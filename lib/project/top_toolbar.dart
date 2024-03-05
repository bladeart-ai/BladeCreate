import 'dart:io';

import 'package:bladecreate/project/layer_list_menu.dart';
import 'package:bladecreate/project/project_provider.dart';
import 'package:bladecreate/cluster/cluster_status_menu.dart';
import 'package:bladecreate/style.dart';
import 'package:bladecreate/widgets/error_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class TopToolbar extends StatelessWidget {
  const TopToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, p, child) => Container(
        decoration: BoxDecoration(color: AppStyle.backgroundWithOpacity),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                  Text(p.project.name),
                  const SizedBox(width: 20),
                  p.unSaved
                      ? const Icon(
                          Icons.save,
                          size: AppStyle.smallIconSize,
                          color: Colors.yellow,
                        )
                      : const Icon(
                          Icons.check_box_outlined,
                          size: AppStyle.smallIconSize,
                          color: Colors.green,
                        ),
                  IconButton(
                    onPressed: () => takeScreenShot(p),
                    icon: const Icon(Icons.save_alt),
                  ),
                ],
              ),
            ),
            Expanded(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const LayerListMenu(),
              IconButton(
                onPressed: () => addLayer(context, p),
                icon: const Icon(Icons.image_outlined),
              ),
            ])),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const ClusterStatusMenu(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.manage_accounts),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  addLayer(BuildContext context, ProjectProvider p) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imageData = await image.readAsBytes();
      if (context.mounted) {
        wrapFutureWithShowingErrorBanner(
            context, () => p.addLayerFromBytes(image.name, imageData),
            text: "Add Layer Error");
      }
    }
  }

  takeScreenShot(ProjectProvider p) async {
    // Picking file saving path
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: '${p.project.name}.png',
    );

    if (outputFile != null) {
      final bytes = await p.takeScreenShotAsPNG();
      final file = File(outputFile);
      file.writeAsBytesSync(bytes);
    }
  }
}
