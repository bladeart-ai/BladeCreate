library stack_board;

import 'package:bladecreate/project/project_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/helpers.dart';
import 'package:provider/provider.dart';
import 'operat_state.dart';

import 'layer/adaptive_text_case.dart';
import 'layer/layer_case.dart';
import 'case_style.dart';
import 'layer/adaptive_text.dart';
import 'layer/layer.dart';

// TODO:
// Ideal class hierachy:
// Board: contains list of Transformable
// Transformable: contains (LayerGroup -> Layer) or Layer
// Layer - build(): if editing -> Widget
//                  if not editing -> Widget
class Board extends StatefulWidget {
  Board({
    super.key,
  });

  @override
  BoardState createState() => BoardState();

  final Widget? background = ColoredBox(color: Colors.grey[100]!);

  final CaseStyle? caseStyle = const CaseStyle(
    borderColor: Colors.grey,
    iconColor: Colors.white,
  );

  final bool tapToCancelAllItem = false;
}

class BoardState extends State<Board> with SafeState<Board> {
  /// 所有item的操作状态
  OperatState? _operatState;

  /// 生成唯一Key
  Key _getKey(int? id) => Key('StackBoardItem$id');

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, model, child) {
        if (widget.background == null) {
          return Stack(
            fit: StackFit.expand,
            children: model.layers
                .map((LayerModel box) => _buildItem(model, box))
                .toList(),
          );
        } else {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              widget.background!,
              ...model.layers.map((LayerModel box) => _buildItem(model, box)),
            ],
          );
        }

        // if (widget.tapToCancelAllItem) {
        //   return GestureDetector(
        //     onTap: _unFocus,
        //     child: child,
        //   );
        // }
      },
    );
  }

  /// 构建项
  Widget _buildItem(ProjectProvider model, LayerModel item) {
    Widget child;

    if (item is AdaptiveText) {
      child = AdaptiveTextCase(
        key: _getKey(item.id),
        adaptiveText: item,
        onDel: () => model.removeLayer(item.id),
        onTap: () => model.moveLayerToTop(item.id),
        operatState: _operatState,
      );
    } else {
      child = ItemCase(
        key: _getKey(item.id),
        onDel: () => model.removeLayer(item.id),
        onTap: () => model.moveLayerToTop(item.id),
        caseStyle: item.caseStyle,
        operatState: _operatState,
        child: item.child,
      );
    }

    return child;
  }
}
