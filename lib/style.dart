import 'package:flutter/material.dart';

final class AppStyle {
  // Colors
  static const primary = Color(0xFFEC407A);
  static const primaryLighter = Color(0xFFF48FB1); // pink 200
  static const primaryLightest = Color(0xFFF8BBD0); // pink 200
  static final primaryWithOpacity = primary.withOpacity(0.5);
  static const highlight = Colors.white;
  static const background = Colors.white;
  static final backgroundWithOpacity = Colors.white.withOpacity(0.7);
  static const shadow = Colors.black;
  // Boarder
  static final borderColor = const Color(0xFFF48FB1).withOpacity(0.7);
  static const borderWidth = 1.0;
  // Button
  static const smallIconSize = 20.0;
  // Text
  static const text = TextStyle(color: Colors.black, fontSize: 18);
  static const smallText = TextStyle(color: Colors.black, fontSize: 12);
  static const heading =
      TextStyle(color: Colors.black, fontSize: 36, fontWeight: FontWeight.w800);
  static const backgroundedText = TextStyle(color: highlight, fontSize: 18);
}
