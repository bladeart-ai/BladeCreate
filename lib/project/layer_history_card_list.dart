import 'package:bladecreate/canvas/canvas_provider.dart';
import 'package:bladecreate/generate_backend/generate_backend_provider.dart';
import 'package:bladecreate/project/project_image.dart';
import 'package:bladecreate/style.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class LayerHistoryCardList extends StatelessWidget {
  const LayerHistoryCardList({super.key});

  static double width = 200;
  static double verticalMargin = 40;

  Size initSize(double oriWidth, double oriHeight) {
    final ratio = oriWidth / oriHeight;
    return Size(width, width / ratio);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CanvasProvider>(
        builder: (context, p, child) =>
            LayoutBuilder(builder: (context, constraints) {
              return Align(
                  alignment: Alignment.centerRight,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: width,
                      maxHeight: constraints.maxHeight - verticalMargin * 2,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: p.selectedLayerGenerations.isEmpty
                          ? []
                          : p.selectedLayerGenerations
                              .map((g) => buildGenerationImageGroup(
                                  context, p.selectedLayer!, g))
                              .toList(),
                    ),
                  ));
            }));
  }

  Widget buildGenerationImageGroup(
      BuildContext context, Layer l, Generation g) {
    final size = initSize(l.width, l.height);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(2),
      width: width,
      decoration: BoxDecoration(
        color: AppStyle.borderColor,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: AppStyle.shadow.withOpacity(0.5),
            offset: const Offset(1.0, 1.0),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Wrap(
        direction: Axis.vertical,
        children: g.imageUuids.isEmpty
            ? [
                ProjectImage(
                  w: size.width,
                  h: size.height,
                  percentage: g.percentage,
                )
              ]
            : g.imageUuids
                .map(
                  (e) => buildSelectableImage(context, l, g, size, e),
                )
                .toList(),
      ),
    );
  }

  Widget buildSelectableImage(BuildContext context, Layer l, Generation g,
      Size size, String imageUuid) {
    final p = Provider.of<CanvasProvider>(context);
    final gbp = Provider.of<GenerateBackendProvider>(context);
    return GestureDetector(
        onTap: () => p.setLayerImageFromGeneration(l, imageUuid),
        child: ProjectImage(
          bytes: gbp.imageOf(imageUuid),
          w: size.width,
          h: size.height,
          percentage: gbp.generationPercentage(g),
        ));
  }
}
