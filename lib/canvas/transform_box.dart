import 'package:bladecreate/canvas/transform_box_provider.dart';
import 'package:bladecreate/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransformBox extends StatelessWidget {
  const TransformBox({
    super.key,
    this.onMove,
    this.onScale,
    this.onRotate,
    this.onDelete,
    this.onChangeDone,
  });

  final Function(double x, double y)? onMove;
  final Function(double x, double y, double width, double height)? onScale;
  final Function(double angle)? onRotate;
  final Function()? onDelete;
  final Function()? onChangeDone;

  @override
  Widget build(BuildContext context) {
    return Consumer<TransformBoxProvider>(builder: (context, p, c) {
      if (!p.display) return const SizedBox.shrink();

      return Stack(children: [
        _border(p),
        _deleteButton(p),
        _rotateButton(p),
        _scaleButton(p),
        ...p.sizersPos.map((e) => _sizerButton(p, e)),
        ...p.marks.map((e) => _sizerButton(p, e)),
      ]);
    });
  }

  Widget _border(TransformBoxProvider p) {
    return Positioned(
      top: p.pos.dy,
      left: p.pos.dx,
      width: p.size.width,
      height: p.size.height,
      child: Transform.rotate(
        angle: p.rotation,
        child: GestureDetector(
          onTap: () {},
          onPanUpdate: (dud) {
            p.move(dud.delta);
            if (onMove != null) {
              onMove!(p.pos.dx, p.pos.dy);
            }
          },
          onPanEnd: (_) {
            if (onChangeDone != null) {
              onChangeDone!();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppStyle.borderColor,
                width: AppStyle.borderWidth,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _deleteButton(TransformBoxProvider p) {
    return Positioned(
      left: p.topRight.dx - AppStyle.smallIconSize / 2,
      top: p.topRight.dy - AppStyle.smallIconSize / 2,
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeUpLeftDownRight,
        child: GestureDetector(
          onTap: () {
            if (onDelete != null) {
              onDelete!();
            }
            p.unselectLayer();
          },
          child: _operateButton(
            const RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.clear),
            ),
          ),
        ),
      ),
    );
  }

  Widget _scaleButton(TransformBoxProvider p) {
    return Positioned(
      left: p.bottomRight.dx - AppStyle.smallIconSize / 2,
      top: p.bottomRight.dy - AppStyle.smallIconSize / 2,
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeUpLeftDownRight,
        child: GestureDetector(
          onPanUpdate: (dud) {
            p.scale(dud.globalPosition);
            if (onScale != null) {
              onScale!(p.pos.dx, p.pos.dy, p.size.width, p.size.height);
            }
          },
          onPanEnd: (_) {
            if (onChangeDone != null) {
              onChangeDone!();
            }
          },
          child: _operateButton(
            const RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.open_in_full_outlined),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sizerButton(TransformBoxProvider p, Offset pos) {
    return Positioned(
      left: pos.dx - AppStyle.smallIconSize / 2,
      top: pos.dy - AppStyle.smallIconSize / 2,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onPanUpdate: (dud) {},
          onPanEnd: (_) {
            if (onChangeDone != null) {
              onChangeDone!();
            }
          },
          child: _operateButton(
            const RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.circle),
            ),
          ),
        ),
      ),
    );
  }

  Widget _rotateButton(TransformBoxProvider p) {
    return Positioned(
      left: p.centerRight.dx - AppStyle.smallIconSize / 2,
      top: p.centerRight.dy - AppStyle.smallIconSize / 2,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onPanUpdate: (dud) {
            p.rotate(dud.globalPosition);
            if (onRotate != null) {
              onRotate!(p.rotation);
            }
          },
          onPanEnd: (_) {
            if (onChangeDone != null) {
              onChangeDone!();
            }
          },
          child: _operateButton(
            const RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.refresh),
            ),
          ),
        ),
      ),
    );
  }

  Widget _operateButton(Widget child) {
    return Container(
      width: AppStyle.smallIconSize,
      height: AppStyle.smallIconSize,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppStyle.background,
      ),
      child: IconTheme(
        data: const IconThemeData(
          color: AppStyle.primary,
          size: AppStyle.smallIconSize * 0.6,
        ),
        child: child,
      ),
    );
  }
}
