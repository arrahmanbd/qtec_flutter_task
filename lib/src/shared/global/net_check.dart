import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider.autoDispose<bool>((ref) {
  return Connectivity()
      .onConnectivityChanged
      .map((result) => result != ConnectivityResult.none)
      .distinct();
});

void listenToConnection(BuildContext context, WidgetRef ref) {
  ref.listen<AsyncValue<bool>>(connectivityProvider, (previous, next) {
    final wasConnected = previous?.value ?? true;
    final isConnected = next.value ?? true;

    if (wasConnected && !isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No Internet Connection'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  });
}
