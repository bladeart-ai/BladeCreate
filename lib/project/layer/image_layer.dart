import 'package:bladecreate/project/layer/layer_model.dart';
import 'package:flutter/widgets.dart';

class ImageLayerModel extends LayerModel {
  ImageLayerModel(this.url);

  final String url;
}

class ImageLayerContent extends StatelessWidget {
  const ImageLayerContent({super.key, required this.m});

  final ImageLayerModel m;

  @override
  Widget build(BuildContext context) {
    return Image.network(m.url);
  }
}
