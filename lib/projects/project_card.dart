import 'package:bladecreate/project/project_page.dart';
import 'package:bladecreate/projects/projects_provider.dart';
import 'package:bladecreate/style.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:bladecreate/widgets/error_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({super.key, required this.project});

  final Project project;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  final TextEditingController _pNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _pNameController.dispose();
  }

  _buildRenameConfirmationDialog(BuildContext context, ProjectsProvider p) {
    _pNameController.text = widget.project.name;

    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                    autofocus: true,
                    controller: _pNameController,
                    decoration: const InputDecoration(
                      labelText: "Project Name",
                      hintText: "Project Name",
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Rename"),
              onPressed: () {
                wrapFutureWithShowingErrorBanner(
                    context,
                    () => p.renameProject(
                        widget.project.uuid, _pNameController.text),
                    text: "Renaming Project Error");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _buildDeleteConfirmationDialog(BuildContext context, ProjectsProvider p) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Do you confirm deleting this project?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                wrapFutureWithShowingErrorBanner(
                    context, () => p.deleteProject(widget.project.uuid),
                    text: "Deleting Project Error");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _buildDropdownMenu() {
    return Consumer<ProjectsProvider>(builder: (_, p, child) {
      return MenuAnchor(
        builder:
            (BuildContext context, MenuController controller, Widget? child) {
          return IconButton(
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: const Icon(Icons.menu, color: AppStyle.highlight),
          );
        },
        menuChildren: [
          IconButton(
              onPressed: () => _buildRenameConfirmationDialog(context, p),
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () => _buildDeleteConfirmationDialog(context, p),
              icon: const Icon(Icons.delete))
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
          maxHeight: 100, minHeight: 50, maxWidth: 400, minWidth: 200),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, "project",
              arguments: ProjectPageArguments(widget.project.uuid));
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
                    widget.project.name,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyle.backgroundedText,
                  )),
              const Spacer(flex: 1),
              _buildDropdownMenu(),
            ])),
      ),
    );
  }
}
