/// Offline write queue backed by Hive.
///
/// Mutations issued while the device is offline (or while a request fails
/// with a transient network error) are persisted to a Hive box and replayed
/// in FIFO order once connectivity is restored. The queue survives app
/// restarts so users never lose work captured in the field.
///
/// Each entry records the operation kind, target entity, payload, attempt
/// count, and last error so the UI can surface "pending sync" indicators
/// and conflict resolution prompts.
library write_queue;

import 'dart:async';
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

/// Status of a queued mutation.
enum QueueEntryStatus { pending, retrying, failed, completed }

/// A single queued mutation awaiting replay against the backend.
class QueueEntry {
  final String id;
  final String operation;
  final String entity;
  final Map<String, dynamic> payload;
  final DateTime queuedAt;
  int attempts;
  String? lastError;
  QueueEntryStatus status;

  QueueEntry({
    required this.id,
    required this.operation,
    required this.entity,
    required this.payload,
    required this.queuedAt,
    this.attempts = 0,
    this.lastError,
    this.status = QueueEntryStatus.pending,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'operation': operation,
        'entity': entity,
        'payload': payload,
        'queuedAt': queuedAt.toIso8601String(),
        'attempts': attempts,
        'lastError': lastError,
        'status': status.name,
      };

  static QueueEntry fromJson(Map<String, dynamic> j) => QueueEntry(
        id: j['id'] as String,
        operation: j['operation'] as String,
        entity: j['entity'] as String,
        payload: Map<String, dynamic>.from(j['payload'] as Map),
        queuedAt: DateTime.parse(j['queuedAt'] as String),
        attempts: (j['attempts'] as num?)?.toInt() ?? 0,
        lastError: j['lastError'] as String?,
        status: QueueEntryStatus.values.firstWhere(
          (s) => s.name == j['status'],
          orElse: () => QueueEntryStatus.pending,
        ),
      );
}

/// Result returned by a replay handler. `retry: true` keeps the entry in the
/// queue for a later flush; `retry: false` removes it (success or fatal).
class ReplayResult {
  final bool retry;
  final String? error;
  const ReplayResult.success() : retry = false, error = null;
  const ReplayResult.fatal(this.error) : retry = false;
  const ReplayResult.transient(this.error) : retry = true;
}

/// Signature for handlers that know how to replay a specific operation.
typedef ReplayHandler = Future<ReplayResult> Function(QueueEntry entry);

/// Coordinates persistence and replay of offline mutations.
class WriteQueue {
  static const String _boxName = 'solar3d.write_queue';
  static const int _maxAttempts = 5;

  final Box<String> _box;
  final Map<String, ReplayHandler> _handlers = {};
  final _uuid = const Uuid();
  final StreamController<List<QueueEntry>> _stream = StreamController.broadcast();
  bool _flushing = false;

  WriteQueue._(this._box);

  /// Open the queue. Call once at app startup after `Hive.initFlutter()`.
  static Future<WriteQueue> open() async {
    final box = await Hive.openBox<String>(_boxName);
    return WriteQueue._(box);
  }

  /// Stream of the current queue contents — UI can subscribe to show
  /// "N pending sync" badges or expose a conflict-resolution screen.
  Stream<List<QueueEntry>> watch() => _stream.stream;

  /// Snapshot of all queued entries in insertion order.
  List<QueueEntry> entries() {
    final out = <QueueEntry>[];
    for (final raw in _box.values) {
      try {
        out.add(QueueEntry.fromJson(jsonDecode(raw) as Map<String, dynamic>));
      } catch (_) {
        // Skip corrupt entries rather than block the whole queue.
      }
    }
    out.sort((a, b) => a.queuedAt.compareTo(b.queuedAt));
    return out;
  }

  /// Register a replay handler for an operation key (e.g. `project.create`).
  void registerHandler(String operation, ReplayHandler handler) {
    _handlers[operation] = handler;
  }

  /// Enqueue a new mutation. Returns the generated id.
  Future<String> enqueue({
    required String operation,
    required String entity,
    required Map<String, dynamic> payload,
  }) async {
    final entry = QueueEntry(
      id: _uuid.v4(),
      operation: operation,
      entity: entity,
      payload: payload,
      queuedAt: DateTime.now().toUtc(),
    );
    await _box.put(entry.id, jsonEncode(entry.toJson()));
    _emit();
    return entry.id;
  }

  /// Remove an entry without replaying — used by UI when the user explicitly
  /// discards a pending change.
  Future<void> discard(String id) async {
    await _box.delete(id);
    _emit();
  }

  /// Attempt to replay all pending entries. Safe to call concurrently — only
  /// one flush runs at a time.
  Future<void> flush() async {
    if (_flushing) return;
    _flushing = true;
    try {
      for (final entry in entries()) {
        if (entry.status == QueueEntryStatus.completed) continue;
        final handler = _handlers[entry.operation];
        if (handler == null) {
          entry.lastError = 'No replay handler registered for ${entry.operation}';
          entry.status = QueueEntryStatus.failed;
          await _box.put(entry.id, jsonEncode(entry.toJson()));
          continue;
        }
        entry.attempts += 1;
        entry.status = QueueEntryStatus.retrying;
        await _box.put(entry.id, jsonEncode(entry.toJson()));
        final result = await handler(entry);
        if (!result.retry) {
          await _box.delete(entry.id);
        } else if (entry.attempts >= _maxAttempts) {
          entry.status = QueueEntryStatus.failed;
          entry.lastError = result.error;
          await _box.put(entry.id, jsonEncode(entry.toJson()));
        } else {
          entry.status = QueueEntryStatus.pending;
          entry.lastError = result.error;
          await _box.put(entry.id, jsonEncode(entry.toJson()));
        }
      }
    } finally {
      _flushing = false;
      _emit();
    }
  }

  /// Drop all entries — typically only used by tests or by an explicit
  /// "clear pending sync" admin action.
  Future<void> clear() async {
    await _box.clear();
    _emit();
  }

  Future<void> close() async {
    await _stream.close();
    await _box.close();
  }

  void _emit() {
    if (_stream.isClosed) return;
    _stream.add(entries());
  }
}
