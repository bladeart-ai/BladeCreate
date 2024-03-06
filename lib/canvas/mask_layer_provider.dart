import 'package:flutter/widgets.dart';

enum MaskLayerPathMode {
  eraser,
  line;
}

@immutable
class MaskLayerPath {
  const MaskLayerPath(this.mode, this.strokeWidth, {this.points = const []});
  final MaskLayerPathMode mode;
  final double strokeWidth;
  final List<Offset> points;
}

class MaskLayerProvider extends ChangeNotifier {
  bool display = false;
  MaskLayerPathMode pathMode = MaskLayerPathMode.line;
  double strokeWidth = 50.0;

  List<MaskLayerPath> paths = [];
  MaskLayerPath? get lastPath => paths[paths.length - 1];

  setDisplay(bool newVal) {
    if (display == newVal) return;
    display = newVal;
    notifyListeners();
  }

  setPathMode(MaskLayerPathMode mode) {
    if (pathMode == mode) return;
    pathMode = mode;
    notifyListeners();
  }

  setStrokeWidth(double newVal) {
    if (strokeWidth == newVal) return;
    strokeWidth = newVal;
    notifyListeners();
  }

  startPath(Offset startPoint) {
    paths.add(MaskLayerPath(pathMode, strokeWidth, points: [startPoint]));
    notifyListeners();
  }

  addPointToLastPath(Offset point) {
    if (lastPath == null) return;
    lastPath!.points.add(point);
    notifyListeners();
  }
}
