import 'package:bladecreate/project/project_provider.dart';
import 'package:bladecreate/cluster/cluster_status_dropdown.dart';
import 'package:bladecreate/style.dart';
import 'package:bladecreate/widgets/error_widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class TopToolbar extends StatelessWidget {
  const TopToolbar({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, p, child) => Container(
        decoration: BoxDecoration(color: AppStyle.background.withOpacity(0.7)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
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
              ]),
            ),
            Expanded(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.layers),
              ),
              IconButton(
                onPressed: () => addLayer(context, p),
                icon: const Icon(Icons.image_outlined),
              ),
            ])),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const ClusterStatusDropdown(),
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
}
