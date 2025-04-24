import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qtec_flutter_task/src/shared/utils/debounch_extension.dart';


/// Enum to represent connection state.
enum ConnectivityState { disconnected, connected }

/// A service to check actual internet connectivity.
class InternetConnectivityChecker {
  final Connectivity _connectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();
  late final StreamSubscription _subscription;
  bool _lastStatus = false;

  InternetConnectivityChecker() {
    _subscription = _connectivity.onConnectivityChanged
        .debounce(const Duration(milliseconds: 500))
        .asyncMap((_) => _hasInternetAccess())
        .distinct()
        .listen((status) {
          _lastStatus = status;
          _controller.add(status);
          _debugLog('Emitting connection status: $status');
        });

    // Initial check
    _initialize();
  }

  Stream<bool> get connectionChange => _controller.stream;

  Future<void> _initialize() async {
    final initialStatus = await _hasInternetAccess();
    if (_lastStatus != initialStatus) {
      _controller.add(initialStatus);
    }
  }

  Future<bool> _hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 2));
      final hasConnection = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      _debugLog('Internet reachable: $hasConnection');
      return hasConnection;
    } on SocketException {
      _debugLog('No internet (SocketException)');
      return false;
    } on TimeoutException {
      _debugLog('No internet (Timeout)');
      return false;
    }
  }

  /// Manually trigger a connection check
  Future<void> checkNow() async {
    final status = await _hasInternetAccess();
    _controller.add(status);
  }

  void dispose() {
    _subscription.cancel();
    _controller.close();
  }

  void _debugLog(String msg) {
    if (kDebugMode) debugPrint('[InternetChecker] $msg');
  }
}

/// Notifier that provides internet connectivity state
class InternetConnectionNotifier extends StateNotifier<ConnectivityState> {
  final InternetConnectivityChecker _checker;

  InternetConnectionNotifier(this._checker)
      : super(ConnectivityState.connected) {
    _checker.connectionChange.listen((isConnected) {
      state = isConnected
          ? ConnectivityState.connected
          : ConnectivityState.disconnected;
    });
  }

  void checkNow() => _checker.checkNow();

  @override
  void dispose() {
    _checker.dispose();
    super.dispose();
  }
}

/// Provider for the InternetConnectivityChecker instance
final internetConnectivityCheckerProvider = Provider<InternetConnectivityChecker>((ref) {
  final checker = InternetConnectivityChecker();
  ref.onDispose(() => checker.dispose());
  return checker;
});

/// StateNotifier provider for internet connectivity state
final connectionStateProvider =
    StateNotifierProvider<InternetConnectionNotifier, ConnectivityState>((ref) {
  final checker = ref.watch(internetConnectivityCheckerProvider);
  return InternetConnectionNotifier(checker);
});

