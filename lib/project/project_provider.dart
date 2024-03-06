import 'dart:ui' as ui;

import 'package:bladecreate/store/project_remote_store.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class ProjectProvider extends ChangeNotifier {
  ProjectProvider({required this.projectUUID}) {
    timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => updateProject(modfied: false),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    saveProject();
    super.dispose();
  }

  final projectStore = ProjectRemoteAPI();

  final String projectUUID;

  // Saved state
  late Timer timer;
  int updatesAfterSaved = 0;
  DateTime lastSaved = DateTime.now();
  bool get unSaved => updatesAfterSaved > 0;

  // Cached data
  late Project project;
  List<String> layersOrder = [];
  Map<String, Layer> layers = {};
  Map<String, Uint8List> imageData = {};
  ProjectData get projectData =>
      ProjectData(layersOrder: layersOrder, layers: layers);
  Iterable<Layer> get orderedLayers => layersOrder.map((e) => layers[e]!);
  Iterable<Layer> get orderedLayersForRendering =>
      layersOrder.reversed.map((e) => layers[e]!);
  List<String> get allLayersGenerationUuids =>
      layers.values.expand<String>((e) => e.generationUuids ?? []).toList();
  Uint8List? imageOf(String imageUuid) => imageData[imageUuid];

  Future<void> load() async {
    project = await projectStore.fetchProject(projectUUID);
    layersOrder = project.data.layersOrder!;
    layers = project.data.layers!
        .map((k, v) => MapEntry<String, Layer>(k, Layer.fromJson(v)));
    imageData.addAll(await projectStore.fetchImages(layers.values
        .expand<String>((e) => e.imageUuid == null ? [] : [e.imageUuid])
        .toList()));
    notifyListeners();
  }

  Future updateProject({bool modfied = true}) async {
    bool oriUnsaved = unSaved;
    final now = DateTime.now();
    if (modfied) updatesAfterSaved++;
    if (oriUnsaved != unSaved) notifyListeners();
    if (unSaved &&
        (now.difference(lastSaved).inSeconds > 30 || updatesAfterSaved >= 5)) {
      return saveProject();
    }
  }

  Future saveProject() async {
    if (unSaved) {
      lastSaved = DateTime.now();
      updatesAfterSaved = 0;
      notifyListeners();
      return projectStore.updateProject(
        projectUUID,
        ProjectUpdate(data: projectData),
      );
    }
  }

  Future addLayer(Layer l) async {
    layersOrder.add(l.uuid);
    layers[l.uuid] = l;

    notifyListeners();
    return updateProject();
  }

  Size initLayerSize(double oriWidth, double oriHeight) {
    const defaultHeight = 200.0;
    final ratio = oriWidth / oriHeight;
    return Size(defaultHeight * ratio, defaultHeight);
  }

  Future addLayerFromBytes(String name, Uint8List bytes) async {
    final layerUuid = uuid.v4();
    imageData[layerUuid] = bytes;

    await projectStore.uploadImageData({layerUuid: bytes});
    ui.decodeImageFromList(
      bytes,
      (res) async {
        Size size = initLayerSize(res.width.toDouble(), res.height.toDouble());
        await addLayer(
          Layer(
            uuid: layerUuid,
            name: name,
            x: 0.0,
            y: 0.0,
            width: size.width,
            height: size.height,
            rotation: 0.0,
            imageUuid: layerUuid,
            generationUuids: [],
          ),
        );
      },
    );
  }

  Future removeLayer(String uuid) async {
    layersOrder.remove(uuid);
    layers.remove(uuid);

    notifyListeners();
    return updateProject();
  }

  Future moveLayerToTop(String uuid) async {
    final ix = layersOrder.indexWhere((String e) => e == uuid);
    if (ix == -1) return;
    final removed = layersOrder.removeAt(ix);
    layersOrder.insert(0, removed);

    notifyListeners();
    return updateProject();
  }

  Future reorderLayer(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = layersOrder.removeAt(oldIndex);
    layersOrder.insert(newIndex, item);

    notifyListeners();
    return updateProject();
  }

  Future setLayer({
    required String layerUuid,
    String? name,
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
    String? imageUuid,
    Uint8List? imageBytes,
    List<String>? generationUuids,
    update = true,
  }) async {
    final l = layers[layerUuid];
    if (l == null) return;
    layers[layerUuid] = Layer(
      uuid: l.uuid,
      name: name ?? l.name,
      x: x ?? l.x,
      y: y ?? l.y,
      rotation: rotation ?? l.rotation,
      width: width ?? l.width,
      height: height ?? l.height,
      imageUuid: imageUuid ?? l.imageUuid,
      generationUuids: generationUuids ?? l.generationUuids,
    );

    if (imageUuid != null &&
        imageData[imageUuid] == null &&
        imageBytes != null) {
      imageData[imageUuid] = imageBytes;
      await projectStore.uploadImageData({imageUuid: imageBytes});
    }

    notifyListeners();
    if (update) return updateProject();
  }
}
