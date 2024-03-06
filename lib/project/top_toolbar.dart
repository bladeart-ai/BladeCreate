import 'dart:io';

import 'package:bladecreate/canvas/canvas_provider.dart';
import 'package:bladecreate/project/layer_list_menu.dart';
import 'package:bladecreate/project/project_provider.dart';
import 'package:bladecreate/generate_backend/generate_backend_status_menu.dart';
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
    return Consumer<CanvasProvider>(
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
                  Text(p.pp.project.name),
                  const SizedBox(width: 20),
                  p.pp.unSaved
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
                onPressed: () => uploadImageAsLayer(context, p.pp),
                icon: const Icon(Icons.image_outlined),
              ),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.touch_app_outlined)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.picture_in_picture_alt_outlined)),
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

  uploadImageAsLayer(BuildContext context, ProjectProvider p) async {
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

  takeScreenShot(CanvasProvider cp) async {
    // Picking file saving path
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: '${cp.pp.project.name}.png',
    );

    if (outputFile != null) {
      final bytes = await cp.takeScreenShotAsPNG();
      final file = File(outputFile);
      file.writeAsBytesSync(bytes);
    }
  }
}
