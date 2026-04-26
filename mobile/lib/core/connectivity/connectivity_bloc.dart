/// Connectivity monitoring Bloc using `connectivity_plus`.
///
/// Emits [ConnectivityState.online] / [ConnectivityState.offline] events
/// when the device's network status changes. Consumed by the global
/// `ConnectivityIndicator` widget and by service clients to short-circuit
/// requests when offline (queueing them for later sync via Hive).
library connectivity_bloc;

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

// ── Events ─────────────────────────────────────────────────────────────

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();
  @override
  List<Object?> get props => [];
}

class ConnectivityStarted extends ConnectivityEvent {
  const ConnectivityStarted();
}

class ConnectivityChanged extends ConnectivityEvent {
  final List<ConnectivityResult> results;
  const ConnectivityChanged(this.results);
  @override
  List<Object?> get props => [results];
}

// ── States ─────────────────────────────────────────────────────────────

abstract class ConnectivityState extends Equatable {
  const ConnectivityState();
  @override
  List<Object?> get props => [];
}

class ConnectivityInitial extends ConnectivityState {
  const ConnectivityInitial();
}

class ConnectivityOnline extends ConnectivityState {
  /// The active connection type (wifi, mobile, ethernet, etc.).
  final ConnectivityResult connectionType;
  const ConnectivityOnline(this.connectionType);
  @override
  List<Object?> get props => [connectionType];
}

class ConnectivityOffline extends ConnectivityState {
  const ConnectivityOffline();
}

// ── Bloc ───────────────────────────────────────────────────────────────

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityBloc({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        super(const ConnectivityInitial()) {
    on<ConnectivityStarted>(_onStarted);
    on<ConnectivityChanged>(_onChanged);
  }

  Future<void> _onStarted(
    ConnectivityStarted event,
    Emitter<ConnectivityState> emit,
  ) async {
    final initial = await _connectivity.checkConnectivity();
    emit(_resolve(initial));

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      add(ConnectivityChanged(results));
    });
  }

  void _onChanged(ConnectivityChanged event, Emitter<ConnectivityState> emit) {
    emit(_resolve(event.results));
  }

  ConnectivityState _resolve(List<ConnectivityResult> results) {
    // None or only ConnectivityResult.none means offline.
    if (results.isEmpty || results.every((r) => r == ConnectivityResult.none)) {
      return const ConnectivityOffline();
    }
    // Pick the highest-priority connection: wifi > ethernet > mobile > others.
    final priority = [
      ConnectivityResult.wifi,
      ConnectivityResult.ethernet,
      ConnectivityResult.mobile,
      ConnectivityResult.vpn,
      ConnectivityResult.bluetooth,
      ConnectivityResult.other,
    ];
    for (final p in priority) {
      if (results.contains(p)) return ConnectivityOnline(p);
    }
    return ConnectivityOnline(results.first);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
