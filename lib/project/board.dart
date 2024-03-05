import 'package:bladecreate/project/layer/transform_box_provider.dart';
import 'package:bladecreate/project/project_image.dart';
import 'package:bladecreate/project/project_provider.dart';
import 'package:bladecreate/style.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'layer/transform_box.dart';

class Board extends StatelessWidget {
  const Board({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProjectProvider, TransformBoxProvider>(
      builder: (context, p, tp, child) {
        return GestureDetector(
          onTap: () {
            p.unSelect();
            tp.unselectLayer();
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              RepaintBoundary(
                key: p.boardKey,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: AppStyle.background),
                    ...p.orderedLayersForRendering
                        .map((layer) => _buildLayer(p, tp, layer)),
                  ],
                ),
              ),
              TransformBox(
                onMove: (x, y) => p.setSelectedLayer(x: x, y: y),
                onRotate: (angle) => p.setSelectedLayer(rotation: angle),
                onScale: (x, y, width, height) => p.setSelectedLayer(
                  x: x,
                  y: y,
                  width: width,
                  height: height,
                ),
                onDelete: () => p.removeSelectedLayer(),
                onChangeDone: () => p.updateProject(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLayer(ProjectProvider p, TransformBoxProvider tp, Layer l) {
    return Positioned(
      top: l.y,
      left: l.x,
      height: l.height,
      width: l.width,
      child: Transform.rotate(
        angle: l.rotation,
        child: GestureDetector(
          onTap: () {
            p.select(l.uuid);
            tp.selectLayer(l);
          },
          child: ProjectImage(
            bytes: p.layerImage(l),
            h: l.height,
            w: l.width,
            percentage: p.layerPercentage(l),
          ),
        ),
      ),
    );
  }
}
