import 'package:bladecreate/project/project_menu.dart';
import 'package:bladecreate/project/project_page.dart';
import 'package:bladecreate/style.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard(
      {super.key,
      required this.project,
      required this.renameFunc,
      required this.deleteFunc});

  final Project project;
  final Function(String newName) renameFunc;
  final Function deleteFunc;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
          maxHeight: 100, minHeight: 50, maxWidth: 400, minWidth: 200),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, "project",
              arguments: ProjectPageArguments(project.uuid));
        },
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
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Spacer(flex: 1),
              Expanded(
                  flex: 10,
                  child: Text(
                    project.name,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyle.backgroundedText,
                  )),
              const Spacer(flex: 1),
              ProjectMenu(
                project: project,
                renameFunc: renameFunc,
                deleteFunc: deleteFunc,
              ),
            ])),
      ),
    );
  }
}
