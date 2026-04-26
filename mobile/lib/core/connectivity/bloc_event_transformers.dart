/// Bloc event transformers for debouncing user input (search, filters).
///
/// Use with `on<Event>(handler, transformer: debounce(Duration(milliseconds: 300)))`
/// to coalesce rapid user input into a single event.
library bloc_event_transformers;

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

/// Debounces an event stream — only the last event in a quiet period fires.
/// Standard for search-as-you-type to avoid excessive API calls.
EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) {
    return events.debounceTime(duration).flatMap(mapper);
  };
}

/// Throttles an event stream — only the first event in each interval fires.
/// Useful for rate-limiting button presses (refresh, retry).
EventTransformer<E> throttle<E>(Duration duration) {
  return (events, mapper) {
    return events.throttleTime(duration).flatMap(mapper);
  };
}

/// Drops new events while the current handler is still running.
/// Useful for "load more" pagination to prevent duplicate fetches.
EventTransformer<E> droppable<E>() {
  return (events, mapper) {
    return events.exhaustMap(mapper);
  };
}

/// Cancels the previous handler and starts a new one (latest wins).
/// Useful for search where only the most recent query matters.
EventTransformer<E> restartable<E>() {
  return (events, mapper) {
    return events.switchMap(mapper);
  };
}
