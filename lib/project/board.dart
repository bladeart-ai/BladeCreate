import 'dart:typed_data';

import 'package:bladecreate/project/layer/transform_box_provider.dart';
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
              Container(color: AppStyle.background),
              ...p.orderedLayers.map((layer) => _buildLayer(p, tp, layer)),
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
    Image image = Image.asset(
      "assets/loading.gif",
      height: l.height,
      width: l.width,
      fit: BoxFit.fill,
    );
    if (l.imageUuid != null) {
      final bytes = p.imageOf(l.imageUuid);
      image = Image.memory(
        bytes ?? Uint8List(0),
        height: l.height,
        width: l.width,
        fit: BoxFit.fill,
      );
    }

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
          child: image,
        ),
      ),
    );
  }
}
