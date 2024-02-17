/// 自定义对象
class LayerModel {
  LayerModel({
    this.onDel,
    this.uuid = "",
  });

  String uuid;

  /// 移除回调
  final Future<bool> Function()? onDel;
}
