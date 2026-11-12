import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/providers/lists_provider.dart';
import 'package:homies/providers/user_provider.dart';

/// Tracks whether the device has network connectivity.
///
/// `true` = online. When the connection comes back, the core data providers
/// are invalidated so the app refetches without the user pressing retry.
class ConnectivityNotifier extends Notifier<bool> {
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  static bool _isOnline(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  @override
  bool build() {
    // Initial state is resolved asynchronously; assume online so the banner
    // doesn't flash on every normal startup.
    _checkInitialState();

    _subscription = Connectivity().onConnectivityChanged.listen(
      (results) {
        final online = _isOnline(results);
        final wasOffline = !state;
        state = online;
        if (online && wasOffline) {
          ref.invalidate(userProvider);
          ref.invalidate(homeProvider);
          ref.invalidate(todoListProvider);
        }
      },
      // The plugin is unavailable in some environments (e.g. widget tests);
      // a failing stream must not crash the app.
      onError: (_) {},
    );
    ref.onDispose(() => _subscription?.cancel());

    return true;
  }

  Future<void> _checkInitialState() async {
    try {
      state = _isOnline(await Connectivity().checkConnectivity());
    } catch (_) {
      // Platform channel unavailable (e.g. tests): keep the current value.
    }
  }
}

final connectivityProvider =
    NotifierProvider<ConnectivityNotifier, bool>(ConnectivityNotifier.new);
