import 'package:bladecreate/canvas/canvas.dart';
import 'package:bladecreate/projects/project_card.dart';
import 'package:bladecreate/projects/projects_provider.dart';
import 'package:bladecreate/widgets/error_banner.dart';
import 'package:flutter/material.dart';
import 'package:bladecreate/style.dart';
import 'package:provider/provider.dart';

class ProjectCardList extends StatelessWidget {
  const ProjectCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) {
      final p = ProjectsProvider();
      wrapFutureWithShowingErrorBanner(context, () => p.fetchProjects(),
          text: "Fetching Projects Error", dismissable: false);
      return p;
    }, child: Consumer<ProjectsProvider>(
      builder: (_, p, child) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Text(
                  "All Server Projects",
                  style: AppStyle.heading,
                ),
                const Spacer(flex: 1),
                IconButton(
                    onPressed: () => wrapFutureWithShowingErrorBanner(
                        context,
                        () => p.createProject().then((projectUUID) {
                              Navigator.pushNamed(context, "project",
                                  arguments: CanvasPageArguments(projectUUID));
                            }),
                        text: "Creating Project Error"),
                    icon: const Icon(Icons.add))
              ]),
              const SizedBox(
                height: 15,
              ),
              FutureBuilder(
                  future: p.fetchProjectsFuture,
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
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
            ]);
      },
    ));
  }
}
