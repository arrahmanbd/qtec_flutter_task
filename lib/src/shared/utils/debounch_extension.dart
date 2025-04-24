import 'dart:async' show StreamController, StreamSubscription, Timer;

/// Debounce extension for Stream
extension DebounceExtension<T> on Stream<T> {
  Stream<T> debounce(Duration duration) {
    Timer? debounceTimer;
    StreamController<T>? controller;
    StreamSubscription<T>? subscription;

    controller = StreamController<T>(
      onListen: () {
        subscription = listen(
          (event) {
            debounceTimer?.cancel();
            debounceTimer = Timer(duration, () {
              controller?.add(event);
            });
          },
          onError: controller?.addError,
          onDone: controller?.close,
        );
      },
      onPause: () => subscription?.pause(),
      onResume: () => subscription?.resume(),
      onCancel: () {
        debounceTimer?.cancel();
        return subscription?.cancel();
      },
    );

    return controller.stream;
  }
}
