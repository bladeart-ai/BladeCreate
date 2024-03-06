import 'package:bladecreate/canvas/canvas_provider.dart';
import 'package:bladecreate/project/project_image.dart';
import 'package:bladecreate/project/project_provider.dart';
import 'package:bladecreate/style.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'transform_box.dart';

class CanvasBoard extends StatelessWidget {
  const CanvasBoard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<CanvasProvider, ProjectProvider>(
      builder: (context, cp, pp, child) {
        return GestureDetector(
          onTap: () => cp.unSelect(),
          child: Stack(
            fit: StackFit.expand,
            children: [
              RepaintBoundary(
                key: cp.boardKey,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: AppStyle.background),
                    ...pp.orderedLayersForRendering
                        .map((layer) => _buildLayer(cp, layer)),
                  ],
                ),
              ),
              TransformBox(
                onMove: (x, y) => cp.setSelectedLayer(x: x, y: y),
                onRotate: (angle) => cp.setSelectedLayer(rotation: angle),
                onScale: (x, y, width, height) => cp.setSelectedLayer(
                  x: x,
                  y: y,
                  width: width,
                  height: height,
                ),
                onDelete: () => cp.removeSelectedLayer(),
                onChangeDone: () => pp.updateProject(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLayer(CanvasProvider cp, Layer l) {
    return Positioned(
      top: l.y,
      left: l.x,
      height: l.height,
      width: l.width,
      child: Transform.rotate(
        angle: l.rotation,
        child: GestureDetector(
          onTap: () => cp.select(l),
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
}
