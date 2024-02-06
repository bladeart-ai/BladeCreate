import 'package:bladecreate/canvas/canvas.dart';
import 'package:bladecreate/projects/projects_provider.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:bladecreate/widgets/error_banner.dart';
import 'package:flutter/material.dart';
import 'package:bladecreate/style.dart';
import 'package:provider/provider.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project});

  // final ImageProvider? image;
  final Project project;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, "project",
              arguments: CanvasPageArguments(project.uuid));
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(
              maxHeight: 100, minHeight: 50, maxWidth: 400, minWidth: 200),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppStyle.primary,
              gradient:
                  RadialGradient(center: Alignment.topLeft, radius: 5, colors: [
                AppStyle.primary.withOpacity(0.5),
                AppStyle.primary,
              ]),
              boxShadow: [
                BoxShadow(
                  color: AppStyle.shadow.withOpacity(0.5),
                  offset: const Offset(1.0, 1.0),
                  blurRadius: 4.0,
                ),
              ],
              // image: image == null
              //     ? null
              //     : DecorationImage(fit: BoxFit.cover, image: image!),
            ),
            child: Text(
              project.name,
              style: AppStyle.backgroundedText,
            ),
          ),
        ));
  }
}

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          final p = ProjectsProvider();
          p.init();
          return p;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppStyle.highlight,
              leading: const Image(
                  image: AssetImage("assets/logo.png"), fit: BoxFit.contain),
              leadingWidth: 120,
            ),
            body: Consumer<ProjectsProvider>(
              builder: (_, p, child) {
                return SafeArea(
                    child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome to BladeCreate!",
                          style: AppStyle.heading,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "BladeCreate is a creative tool for everyone.",
                          style: AppStyle.text,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(children: [
                          const Text(
                            "All Projects",
                            style: AppStyle.heading,
                          ),
                          const Spacer(flex: 1),
                          IconButton(
                              onPressed: () => wrapFutureWithShowingErrorBanner(
                                  context,
                                  p.createProject().then((projectUUID) {
                                    Navigator.pushNamed(context, "project",
                                        arguments:
                                            CanvasPageArguments(projectUUID));
                                  }),
                                  text: "Creating Project Error"),
                              icon: const Icon(Icons.add))
                        ]),
                        const SizedBox(
                          height: 15,
                        ),
                        FutureBuilder(
                            future: wrapFutureWithShowingErrorBanner(
                                context, p.initFuture,
                                text: "Fetching Projects Error"),
                            builder: (BuildContext context,
                                AsyncSnapshot<void> snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              }
                              return Wrap(
                                direction: Axis.horizontal,
                                spacing: 15,
                                runSpacing: 15,
                                children: (p.projects)
                                    .map<Widget>((p) => ProjectCard(project: p))
                                    .toList(),
                              );
                            }),
                      ]),
                ));
              },
            )));
  }
}
