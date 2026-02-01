import 'dart:async';

/// A utility class that delays the execution of a callback until a specified
/// duration has passed without any new calls.
///
/// This is useful for scenarios like search fields where you want to wait
/// for the user to stop typing before executing an action.
class Debouncer {
  /// Creates a [Debouncer] with the specified [delay].
  Debouncer({required this.delay});

  /// The duration to wait before executing the callback.
  final Duration delay;

  Timer? _timer;

  /// Runs the given [action] after the [delay] has passed.
  ///
  /// If this method is called again before the delay expires, the previous
  /// timer is cancelled and a new one is started.
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancels any pending timer and releases resources.
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
