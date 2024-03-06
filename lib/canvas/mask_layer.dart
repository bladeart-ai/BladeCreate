import 'package:bladecreate/canvas/mask_layer_provider.dart';
import 'package:bladecreate/style.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MaskLayerPainter extends CustomPainter {
  MaskLayerPainter(this.p);

  final MaskLayerProvider p;

  BlendMode pathModeToBlendMode(MaskLayerPathMode mode) {
    if (mode == MaskLayerPathMode.eraser) return BlendMode.clear;
    return BlendMode.src;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = AppStyle.primaryWithOpacity
      ..blendMode = BlendMode.srcOver;
    canvas.saveLayer(null, paint);
    for (var path in p.paths) {
      // TODO: improve the performance by only calling drawPath on cursor moving. See the flutter_drawing_board implementation of painter.dart and smooth_line.dart.
      for (int i = 1; i < path.points.length; i++) {
        final p1 = path.points[i - 1];
        final p2 = path.points[i];
        canvas.drawPath(
          Path()
            ..moveTo(p1.dx, p1.dy)
            ..lineTo(p2.dx, p2.dy),
          paint
            ..strokeWidth = path.strokeWidth
            ..blendMode = pathModeToBlendMode(path.mode),
        );
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class MaskLayer extends StatelessWidget {
  const MaskLayer({
    super.key,
    required this.paintKey,
  });

  final Key paintKey;

  @override
  Widget build(BuildContext context) {
    return Consumer<MaskLayerProvider>(builder: (context, p, child) {
      if (!p.display) return const SizedBox.shrink();
      return Listener(
        onPointerDown: (e) => p.startPath(e.localPosition),
        onPointerUp: (e) {},
        onPointerMove: (e) => p.addPointToLastPath(e.localPosition),
        child: RepaintBoundary(
          key: paintKey,
          child: CustomPaint(
            painter: MaskLayerPainter(p),
          ),
        ),
      );
    });
  }
}
