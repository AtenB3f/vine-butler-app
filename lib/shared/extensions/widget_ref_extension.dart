import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;

extension WidgetRefEventExtension on WidgetRef {
  void handleEvent<T>(
    ProviderListenable<T?> event, {
    required VoidCallback consume,
    required void Function(T event) onEvent,
  }) {
    void handle(T? value) {
      if (value == null) { return; }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted || read(event) != value) { return; }

        consume();
        onEvent(value);
      });
    }

    listen(event, (_, next) => handle(next));
    handle(read(event));
  }
}
