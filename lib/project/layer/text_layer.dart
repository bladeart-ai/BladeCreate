import 'package:flutter/material.dart';

import 'layer_model.dart';

/// 默认文本样式
const TextStyle _defaultStyle = TextStyle(fontSize: 20);

class TextLayerModel extends LayerModel {
  TextLayerModel(this.text);

  final String text;
}

class TextLayerContent extends StatelessWidget {
  const TextLayerContent({super.key, required this.m});

  final TextLayerModel m;

  @override
  Widget build(BuildContext context) {
    return Text(m.text);
  }
}

/// 自适应文本
class AdaptiveTextLayerModel extends LayerModel {
  AdaptiveTextLayerModel(
    this.data, {
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    super.onDel,
    bool? tapToEdit = false,
  });

  /// 文本内容
  String data;

  /// 文本样式
  final TextStyle? style;

  /// 文本对齐方式
  final TextAlign? textAlign;

  /// textDirection
  final TextDirection? textDirection;

  /// locale
  final Locale? locale;

  /// softWrap
  final bool? softWrap;

  /// overflow
  final TextOverflow? overflow;

  /// textScaleFactor
  final double? textScaleFactor;

  /// maxLines
  final int? maxLines;

  /// semanticsLabel
  final String? semanticsLabel;

  /// 输入框宽度
  double textFieldWidth = 100;

  /// 文本样式
  TextStyle get styleWithDefault => style ?? _defaultStyle;

  /// 计算文本大小
  Size textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}

/// 自适应文本
class AdaptiveTextLayerContent extends StatefulWidget {
  const AdaptiveTextLayerContent(
      {super.key, required this.m, required this.isEditing});

  final AdaptiveTextLayerModel m;

  final bool isEditing;

  @override
  State<AdaptiveTextLayerContent> createState() =>
      _AdaptiveTextLayerContentState();
}

class _AdaptiveTextLayerContentState extends State<AdaptiveTextLayerContent> {
  /// 输入框宽度
  double textFieldWidth = 100;

  /// 文本样式
  TextStyle get styleWithDefault => widget.m.style ?? _defaultStyle;

  /// 计算文本大小
  Size textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  /// 仅文本
  Widget get _buildTextBox {
    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          widget.m.data,
          style: styleWithDefault,
          textAlign: widget.m.textAlign,
          textDirection: widget.m.textDirection,
          locale: widget.m.locale,
          softWrap: widget.m.softWrap,
          overflow: widget.m.overflow,
          textScaler: widget.m.textScaleFactor != null
              ? TextScaler.linear(widget.m.textScaleFactor!)
              : null,
          maxLines: widget.m.maxLines,
          semanticsLabel: widget.m.semanticsLabel,
        ),
      ),
    );
  }

  /// 正在编辑
  Widget get _buildEditingBox {
    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: SizedBox(
          width: textFieldWidth,
          child: TextFormField(
            autofocus: true,
            initialValue: widget.m.data,
            onChanged: (String v) => setState(() {
              widget.m.data = v;
            }),
            style: styleWithDefault,
            textAlign: widget.m.textAlign ?? TextAlign.start,
            textDirection: widget.m.textDirection,
            maxLines: widget.m.maxLines,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isEditing ? _buildEditingBox : _buildTextBox;
  }
}
