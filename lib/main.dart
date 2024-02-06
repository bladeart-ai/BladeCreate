import 'package:bladecreate/canvas/canvas.dart';
import 'package:bladecreate/style.dart';
import 'package:bladecreate/projects/projects_page.dart';
import 'package:flutter/material.dart';

void main() {
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
