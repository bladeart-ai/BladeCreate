import 'package:bladecreate/project/layer/image_layer.dart';
import 'package:bladecreate/project/layer/transform_box_provider.dart';
import 'package:bladecreate/project/project_provider.dart';
import 'package:bladecreate/style.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/helpers.dart';
import 'package:provider/provider.dart';

import 'layer/transform_box.dart';

// Ideal class hierachy:
// Board: contains list of EditableLayer
// EditableLayer: contains (LayerContentGroup -> LayerContent) or LayerContent
// LayerContent - build(): if editing -> Widget
//                         if not editing -> Widget
class Board extends StatefulWidget {
  const Board({
    super.key,
  });

  @override
  BoardState createState() => BoardState();
}

class BoardState extends State<Board> with SafeState<Board> {
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
                      x: x, y: y, width: width, height: height),
                ),
              ],
            ));
      },
    );
  }

  Widget _buildLayer(ProjectProvider p, TransformBoxProvider tp, Layer l) {
    return Positioned(
      top: l.y ?? 0.0,
      left: l.x ?? 0.0,
      height: l.height ?? 0.0,
      width: l.width ?? 0.0,
      child: Transform.rotate(
        angle: l.rotation ?? 0.0,
        child: GestureDetector(
          onTap: () {
            p.select(l.uuid);
            tp.selectLayer(l);
          },
          child: ImageLayerContent(
            m: ImageLayerModel(
                'https://avatars.githubusercontent.com/u/47586449?s=200&v=4'),
          ),
        ),
      ),
    );
  }
}
