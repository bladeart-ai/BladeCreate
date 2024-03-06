import 'package:bladecreate/style.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:bladecreate/widgets/error_widgets.dart';
import 'package:flutter/material.dart';

class ProjectMenu extends StatefulWidget {
  const ProjectMenu({
    super.key,
    required this.project,
    required this.renameFunc,
    required this.deleteFunc,
  });

  final Project project;
  final Function(String newName) renameFunc;
  final Function deleteFunc;

  @override
  State<ProjectMenu> createState() => _ProjectMenuState();
}

class _ProjectMenuState extends State<ProjectMenu> {
  final TextEditingController _pNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _pNameController.dispose();
  }

  _buildRenameConfirmationDialog(BuildContext context) {
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
                    context, () => widget.renameFunc(_pNameController.text),
                    text: "Renaming Project Error");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _buildDeleteConfirmationDialog(BuildContext context) {
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
                    context, () => widget.deleteFunc(),
                    text: "Deleting Project Error");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          onPressed: () => setState(() {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          }),
          icon: controller.isOpen
              ? const Icon(Icons.menu_open_outlined, color: AppStyle.highlight)
              : const Icon(Icons.menu_outlined, color: AppStyle.highlight),
        );
      },
      menuChildren: [
        IconButton(
            onPressed: () => _buildRenameConfirmationDialog(context),
            icon: const Icon(Icons.edit)),
        IconButton(
            onPressed: () => _buildDeleteConfirmationDialog(context),
            icon: const Icon(Icons.delete))
      ],
    );
  }
}
