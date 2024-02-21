import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

wrapFutureWithShowingErrorBanner(
    BuildContext context, Future<void> Function() f,
    {String text = "Error", bool dismissable = true}) {
  f().catchError((error, stack) {
    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
      content: Text(
        kDebugMode ? "$text: $error; $stack" : "$text: $error",
        style: const TextStyle(color: Colors.white),
      ),
      leading: const Icon(Icons.agriculture_outlined),
      backgroundColor: Theme.of(context).colorScheme.error,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            wrapFutureWithShowingErrorBanner(context, f, text: text);
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: const Text(
            'Retry',
            style: TextStyle(color: Colors.white),
          ),
        ),
        if (dismissable)
          TextButton(
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
            child: const Text(
              'DISMISS',
              style: TextStyle(color: Colors.white),
            ),
          ),
      ],
    ));
  });
}

class FutureErrorDialog extends StatelessWidget {
  const FutureErrorDialog(
      {super.key,
      required this.f,
      required this.error,
      required this.stackTrace,
      this.returnable = false});

  final Future<void> Function() f;
  final Object error;
  final Object stackTrace;
  final bool returnable;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Error: $error"),
      if (kDebugMode) Text("Stacktrace: $stackTrace"),
      Row(
        children: [
          TextButton(
            onPressed: () => f(),
            child: const Text('Retry'),
          ),
          returnable
              ? IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                )
              : const Spacer()
        ],
      ),
    ]);
  }
}
