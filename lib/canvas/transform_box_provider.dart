import 'dart:math' as math;
import 'package:bladecreate/style.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TransformBoxProvider extends ChangeNotifier {
  TransformBoxProvider(
      {this.size = const Size(0, 0),
      this.pos = Offset.zero,
      this.rotation = 0});

  bool display = false;

  Size size;

  // Left top corner of the edit box in the layout axis (unrotated).
  // When the edit box is rotated, it does not change.
  Offset pos;

  List<Offset> marks = [];

  double rotation;

  // rotateToLayoutAxis rotates a vector by -angle to the layout axis.
  // The reason is that the axis of dud is rotated because GestureDetector is rotated.
  static Offset rotateClockwise(Offset d, double angle) {
    final double sina = math.sin(angle);
    final double cosa = math.cos(angle);
    return Offset(cosa * d.dx - sina * d.dy, sina * d.dx + cosa * d.dy);
  }

  Offset calRotatedPos(Offset pos) {
    return center - rotateClockwise(center - pos, rotation);
  }

  Offset get center => size.center(pos);
  Offset get topLeft => calRotatedPos(size.topLeft(pos));
  Offset get topRight => calRotatedPos(size.topRight(pos));
  Offset get centerRight => calRotatedPos(size.centerRight(pos));
  Offset get bottomLeft => calRotatedPos(size.bottomLeft(pos));
  Offset get bottomRight => calRotatedPos(size.bottomRight(pos));
  List<Offset> get sizersPos => [];

  void selectLayer(Layer l) {
    display = true;
    size = Size(l.width, l.height);
    pos = Offset(l.x, l.y);
    rotation = l.rotation;
    notifyListeners();
  }

  void unselectLayer() {
    if (display) {
      display = false;
      size = const Size(0.0, 0.0);
      pos = const Offset(0.0, 0.0);
      notifyListeners();
    }
  }

  void move(Offset rotatedD) {
    final d = rotateClockwise(rotatedD, rotation);
    pos = pos.translate(d.dx, d.dy);
    notifyListeners();
  }

  void rotate(Offset cursorPos) {
    final double l = (cursorPos - center).distance;
    final double s = (cursorPos.dy - center.dy).abs();

    double angle = math.asin(s / l);

    if (cursorPos.dx < center.dx) {
      if (cursorPos.dy < center.dy) {
        angle = math.pi + angle;
      } else {
        angle = math.pi - angle;
      }
    } else {
      if (cursorPos.dy < center.dy) {
        angle = 2 * math.pi - angle;
      }
    }
    rotation = angle;
    notifyListeners();
  }

  void scale(Offset cursorPos) {
    const double min = AppStyle.smallIconSize * 3;
    // TODO: This calculation is not fully correct but usable to some extent.
    final d = rotateClockwise(cursorPos - topLeft, -rotation);

    double w = d.dx;
    double h = d.dy;
    if (w < min) w = min;
    if (h < min) h = min;

    size = Size(w, h);

    final newCenter = (topLeft + cursorPos) / 2.0;
    pos = newCenter - d / 2.0;

    notifyListeners();
  }
}
