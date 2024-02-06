import 'package:flutter/material.dart';

makeErrorBanner(String text, void Function() dismissFunc) {
  return MaterialBanner(
    // padding: const EdgeInsets.all(20),
    content: Text(text),
    leading: const Icon(Icons.agriculture_outlined),
    backgroundColor: Colors.red,
    actions: <Widget>[
      TextButton(
        onPressed: dismissFunc,
        child: const Text('DISMISS'),
      ),
    ],
  );
}

Future<void> wrapFutureWithShowingErrorBanner(
    BuildContext context, Future<void> f,
    {String text = "Error"}) {
  return f.catchError((error, stack) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      makeErrorBanner("$text: $error",
          () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner()),
    );
  });
}
