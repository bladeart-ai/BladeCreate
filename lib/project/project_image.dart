import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProjectImage extends StatelessWidget {
  const ProjectImage({
    super.key,
    required this.w,
    required this.h,
    this.percentage,
    this.bytes,
  });

  final Uint8List? bytes;
  final double w;
  final double h;
  final double? percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
          image: DecorationImage(
        fit: BoxFit.fill,
        image: bytes == null
            ? const AssetImage("assets/loading.gif")
            : MemoryImage(bytes!) as ImageProvider,
      )),
      child: percentage == 1
          ? const SizedBox.shrink()
          : Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 3,
                width: w,
                child: LinearProgressIndicator(value: percentage),
              ),
            ),
    );
  }
}
