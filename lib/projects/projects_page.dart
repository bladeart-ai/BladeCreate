import 'package:bladecreate/generate_backend/generate_backend_provider.dart';
import 'package:bladecreate/generate_backend/generate_backend_status_menu.dart';
import 'package:bladecreate/projects/project_card_list.dart';
import 'package:flutter/material.dart';
import 'package:bladecreate/style.dart';
import 'package:provider/provider.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const Image(
              image: AssetImage("assets/logo.png"), fit: BoxFit.contain),
          leadingWidth: 120,
          actions: [
            ChangeNotifierProvider(
                create: (context) {
                  final cp = GenerateBackendProvider();
                  cp.connect();
                  return cp;
                },
                child: const ClusterStatusMenu())
          ],
        ),
        body: const SafeArea(
            child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(15),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome to BladeCreate!",
                  style: AppStyle.heading,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "BladeCreate is a creative tool for everyone.",
                  style: AppStyle.text,
                ),
                SizedBox(
                  height: 15,
                ),
                ProjectCardList(),
              ]),
        )));
  }
}
