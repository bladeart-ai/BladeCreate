import 'package:flutter/material.dart';

wrapFutureWithShowingErrorBanner(
    BuildContext context, Future<void> Function() f,
    {String text = "Error", bool dismissable = true}) {
  f().catchError((error, stack) {
    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
      content: Text("$text: $error"),
      leading: const Icon(Icons.agriculture_outlined),
      backgroundColor: Colors.red,
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
