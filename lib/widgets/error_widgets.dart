import 'package:flutter/material.dart';

wrapFutureWithShowingErrorBanner(
    BuildContext context, Future<void> Function() f,
    {String text = "Error", bool dismissable = true}) {
  f().catchError((error, stack) {
    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
      content: Text("$text: $error"),
      leading: const Icon(Icons.agriculture_outlined),
      backgroundColor: Theme.of(context).colorScheme.error,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            wrapFutureWithShowingErrorBanner(context, f, text: text);
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: const Text('Retry'),
        ),
        if (dismissable)
          TextButton(
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
            child: const Text('DISMISS'),
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
      this.returnable = false});

  final Future<void> Function() f;
  final Object error;
  final bool returnable;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Error: $error"),
      Row(children: [
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
      ]),
    ]);
  }
}
