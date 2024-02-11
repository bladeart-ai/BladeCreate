import 'package:bladecreate/canvas/canvas.dart';
import 'package:bladecreate/style.dart';
import 'package:bladecreate/projects/projects_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:serious_python/serious_python.dart';

void main() {
  if (!kDebugMode) {
    SeriousPython.run("assets/backend.zip", appFileName: "main.pyc");
  }

  runApp(const BladeCreateApp());
}

class BladeCreateApp extends StatelessWidget {
  const BladeCreateApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BladeCreate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppStyle.primary),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "project": (context) => const CanvasPage(),
        "/": (context) => const ProjectsPage(),
      },
    );
  }
}
