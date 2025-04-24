import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enum for connection states.
enum ConnectivityState { disconnected, connected }

class InternetConnectivityChecker {
  InternetConnectivityChecker() {
    _initialize();
  }

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();

  Stream<bool> get onStatusChange => _connectionStatusController.stream;

  bool _hasConnection = false;

  void _initialize() {
    _connectivity.onConnectivityChanged.listen(
      (_) => _updateConnectionStatus(),
    );
    _updateConnectionStatus(); // Initial check on startup
  }

  Future<void> _updateConnectionStatus() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      _hasConnection = result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      _hasConnection = false;
    }

    debugPrint('[ConnectivityChecker] Internet connected: $_hasConnection');
    _connectionStatusController.add(_hasConnection);
  }

  /// Check the current connection status.
  /// This method can be called to manually check the connection status.
  Future<void> checkNow() async => _updateConnectionStatus();
  void dispose() {
    _connectionStatusController.close();
  }
}

/// Provider for InternetConnectivityChecker with lifecycle disposal.
final internetConnectivityCheckerProvider =
    Provider<InternetConnectivityChecker>((ref) {
      final checker = InternetConnectivityChecker();
      ref.onDispose(checker.dispose);
      return checker;
    });

/// Provider for connection state using StateNotifier.
final connectionStateProvider =
    StateNotifierProvider<InternetConnectionNotifier, ConnectivityState>((ref) {
      final checker = ref.watch(internetConnectivityCheckerProvider);
      return InternetConnectionNotifier(checker);
    });

/// StateNotifier to convert boolean stream into enum state.
class InternetConnectionNotifier extends StateNotifier<ConnectivityState> {
  final InternetConnectivityChecker _checker;
  late final StreamSubscription<bool> _subscription;

  InternetConnectionNotifier(this._checker)
    : super(ConnectivityState.connected) {
    _subscription = _checker.onStatusChange.listen((isConnected) {
      state =
          isConnected
              ? ConnectivityState.connected
              : ConnectivityState.disconnected;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
