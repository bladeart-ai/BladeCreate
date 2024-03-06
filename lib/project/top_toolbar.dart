import 'dart:io';

import 'package:bladecreate/canvas/canvas_stack_provider.dart';
import 'package:bladecreate/canvas/mask_layer_provider.dart';
import 'package:bladecreate/project/layer_list_menu.dart';
import 'package:bladecreate/project/project_provider.dart';
import 'package:bladecreate/generate_backend/generate_backend_status_menu.dart';
import 'package:bladecreate/style.dart';
import 'package:bladecreate/user/user_menu.dart';
import 'package:bladecreate/widgets/error_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class TopToolbar extends StatelessWidget {
  const TopToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppStyle.backgroundWithOpacity),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildReturnButton(context),
                buildProjectName(context),
                buildSavedButton(context),
                buildExportButton(context),
                buildMaskExportButton(context),
                const Text("|"),
                const LayerListMenu(),
                buildUploadImageAsLayerButton(context),
                const Text("|"),
                ...buildModeSelector(context),
                const Text("|"),
                ...buildCanvasTools(context),
              ],
            ),
          ),
          const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [ClusterStatusMenu(), UserMenu()],
          )
        ],
      ),
    );
  }

  Widget buildReturnButton(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.close),
    );
  }

  Widget buildProjectName(BuildContext context) {
    final name = context.select((ProjectProvider p) => p.project.name);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        name,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget buildSavedButton(BuildContext context) {
    final pp = Provider.of<ProjectProvider>(context);
    return IconButton(
      onPressed: () => pp.saveProject(),
      icon: pp.unSaved
          ? const Icon(
              Icons.save,
              color: Colors.yellow,
            )
          : const Icon(
              Icons.check_box_outlined,
              color: Colors.green,
            ),
    );
  }

  Widget buildExportButton(BuildContext context) {
    takeScreenShot(BuildContext context) async {
      final cp = Provider.of<CanvasStackProvider>(context, listen: false);
      final pp = Provider.of<ProjectProvider>(context, listen: false);
      // Picking file saving path
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: '${pp.project.name}.png',
      );

      if (outputFile != null) {
        final bytes = await cp.takeContentLayerStackAsPNG();
        final file = File(outputFile);
        file.writeAsBytesSync(bytes);
      }
    }

    return IconButton(
      onPressed: () => takeScreenShot(context),
      icon: const Icon(Icons.save_alt),
    );
  }

  Widget buildMaskExportButton(BuildContext context) {
    takeScreenShot(BuildContext context) async {
      final cp = Provider.of<CanvasStackProvider>(context, listen: false);
      final pp = Provider.of<ProjectProvider>(context, listen: false);
      // Picking file saving path
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: '${pp.project.name}.png',
      );

      if (outputFile != null) {
        final bytes = await cp.takeMaskLayerStackAsPNG();
        final file = File(outputFile);
        file.writeAsBytesSync(bytes);
      }
    }

    return IconButton(
      onPressed: () => takeScreenShot(context),
      icon: const Icon(Icons.save_alt),
    );
  }

  List<Widget> buildCanvasTools(BuildContext context) {
    final opMode = context.select((CanvasStackProvider p) => p.opMode);
    if (opMode == CanvasOpMode.maskDrawing) return buildMaskLayerTools(context);
    return [];
  }

  List<Widget> buildModeSelector(BuildContext context) {
    final p = Provider.of<CanvasStackProvider>(context);
    return [
      IconButton(
        onPressed: () => p.setOpMode(CanvasOpMode.layerSelecting),
        isSelected: p.opMode == CanvasOpMode.layerSelecting,
        style: p.opMode == CanvasOpMode.layerSelecting
            ? const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll<Color>(AppStyle.primaryLightest))
            : null,
        icon: const Icon(Icons.touch_app_outlined),
      ),
      IconButton(
        onPressed: () => p.setOpMode(CanvasOpMode.maskDrawing),
        isSelected: p.opMode == CanvasOpMode.maskDrawing,
        style: p.opMode == CanvasOpMode.maskDrawing
            ? const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll<Color>(AppStyle.primaryLightest))
            : null,
        icon: const Icon(Icons.picture_in_picture_alt_outlined),
      ),
    ];
  }

  Widget buildUploadImageAsLayerButton(BuildContext context) {
    uploadImageAsLayer(BuildContext context) async {
      final pp = Provider.of<ProjectProvider>(context, listen: false);
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final imageData = await image.readAsBytes();
        if (context.mounted) {
          wrapFutureWithShowingErrorBanner(
              context, () => pp.addLayerFromBytes(image.name, imageData),
              text: "Add Layer Error");
        }
      }
    }

    return IconButton(
      onPressed: () => uploadImageAsLayer(context),
      icon: const Icon(Icons.add_photo_alternate_outlined),
    );
  }

  List<Widget> buildMaskLayerTools(BuildContext context) {
    final mp = Provider.of<MaskLayerProvider>(context);
    return [
      IconButton(
        onPressed: () => mp.setPathMode(MaskLayerPathMode.line),
        isSelected: mp.pathMode == MaskLayerPathMode.line,
        style: mp.pathMode == MaskLayerPathMode.line
            ? const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll<Color>(AppStyle.primaryLightest))
            : null,
        icon: const Icon(Icons.format_paint_outlined),
      ),
      IconButton(
        onPressed: () => mp.setPathMode(MaskLayerPathMode.eraser),
        isSelected: mp.pathMode == MaskLayerPathMode.eraser,
        style: mp.pathMode == MaskLayerPathMode.eraser
            ? const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll<Color>(AppStyle.primaryLightest))
            : null,
        icon: const Icon(Icons.cleaning_services_outlined),
      ),
      SizedBox(
        height: 20,
        width: 150,
        child: Slider(
          value: mp.strokeWidth,
          max: 100,
          min: 1,
          divisions: 100,
          onChanged: (newVal) => mp.setStrokeWidth(newVal),
        ),
      ),
      Text(mp.strokeWidth.toInt().toString()),
    ];
  }
}
