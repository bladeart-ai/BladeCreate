import 'package:bladecreate/canvas/canvas_stack_provider.dart';
import 'package:bladecreate/canvas/mask_layer.dart';
import 'package:bladecreate/project/project_image.dart';
import 'package:bladecreate/project/project_provider.dart';
import 'package:bladecreate/style.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'transform_box.dart';

class CanvasStack extends StatelessWidget {
  const CanvasStack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildContentLayerStack(context),
        _buildTransformBox(context),
        _buildMaskLayer(context),
      ],
    );
  }

  Widget _buildContentLayerStack(BuildContext context) {
    final cp = Provider.of<CanvasStackProvider>(context);
    final pp = Provider.of<ProjectProvider>(context);
    return GestureDetector(
      onTap: () {
        if (cp.opMode == CanvasOpMode.layerSelecting) {
          cp.unSelect();
        }
      },
      child: RepaintBoundary(
        key: cp.contentLayerStackKey,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: AppStyle.background),
            ...pp.orderedLayersForRendering
                .map((layer) => _buildContentLayer(context, layer)),
          ],
        ),
      ),
    );
  }

  Widget _buildContentLayer(BuildContext context, Layer l) {
    final cp = Provider.of<CanvasStackProvider>(context);
    return Positioned(
      top: l.y,
      left: l.x,
      height: l.height,
      width: l.width,
      child: Transform.rotate(
        angle: l.rotation,
        child: GestureDetector(
          onTap: () {
            if (cp.opMode == CanvasOpMode.layerSelecting) {
              cp.select(l);
            }
          },
          child: ProjectImage(
            bytes: cp.layerImage(l),
            h: l.height,
            w: l.width,
            percentage: cp.layerPercentage(l),
          ),
        ),
      ),
    );
  }

  Widget _buildTransformBox(BuildContext context) {
    final cp = Provider.of<CanvasStackProvider>(context);
    return TransformBox(
      onMove: (x, y) => cp.setSelectedLayer(x: x, y: y),
      onRotate: (angle) => cp.setSelectedLayer(rotation: angle),
      onScale: (x, y, width, height) => cp.setSelectedLayer(
        x: x,
        y: y,
        width: width,
        height: height,
      ),
      onDelete: () => cp.removeSelectedLayer(),
      onChangeDone: () => cp.setSelectedLayer(update: true),
    );
  }

  Widget _buildMaskLayer(BuildContext context) {
    final cp = Provider.of<CanvasStackProvider>(context);
    return MaskLayer(
      paintKey: cp.maskLayerKey,
    );
  }
}
