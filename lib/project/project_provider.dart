import 'dart:ui';

import 'package:bladecreate/data/remote_data.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
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
    remote.updateProject(
      projectUUID,
      ProjectUpdate(data: projectData),
    );
    super.dispose();
  }

  final remote = RemoteDataStore();

  final String projectUUID;
  late Future<void> loadFuture;

  // Saved state
  late Timer timer;
  int updatesAfterSaved = 0;
  DateTime lastSaved = DateTime.now();
  bool get unSaved => updatesAfterSaved > 0;

  // Cached data
  late Project project;
  List<String> layersOrder = [];
  Map<String, Layer> layers = {};
  List<Generation> generations = [];
  Map<String, Uint8List> imageData = {};
  ProjectData get projectData =>
      ProjectData(layersOrder: layersOrder, layers: layers);
  Iterable<Layer> get orderedLayers => layersOrder.map((e) => layers[e]!);
  Uint8List? imageOf(String imageUuid) => imageData[imageUuid];

  // Board states
  final defaultHeight = 200.0;
  String? selectedLayerUUID;

  Future<void> load() async {
    notifyListeners();
    loadFuture = () async {
      project = await remote.fetchProject(projectUUID);
      layersOrder = project.data.layersOrder!;
      layers = project.data.layers!
          .map((k, v) => MapEntry<String, Layer>(k, Layer.fromJson(v)));
      generations = await remote.fetchGenerations(layers.values
          .expand<String>((e) => e.generationUuids ?? [])
          .toList());
      imageData = await remote.fetchImages([
        ...layers.values
            .expand<String>((e) => e.imageUuid == null ? [] : [e.imageUuid]),
        ...generations.expand((e) => e.imageUuids)
      ]);
      notifyListeners();
    }();
    return loadFuture;
  }

  Future updateProject({bool modfied = true}) async {
    final now = DateTime.now();
    if (modfied) updatesAfterSaved++;
    notifyListeners();
    if (unSaved &&
        (now.difference(lastSaved).inSeconds > 30 || updatesAfterSaved >= 5)) {
      lastSaved = now;
      updatesAfterSaved = 0;
      notifyListeners();
      return remote.updateProject(
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
    final ratio = oriWidth / oriHeight;
    return Size(defaultHeight * ratio, defaultHeight);
  }

  Future addLayerFromBytes(String name, Uint8List bytes) async {
    final layerUuid = uuid.v4();
    imageData[layerUuid] = bytes;

    await remote.uploadImageData({layerUuid: bytes});
    decodeImageFromList(bytes, (res) async {
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
    });
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
    layersOrder.add(removed);

    notifyListeners();
    return updateProject();
  }

  Future setLayer({
    required String layerUuid,
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
    update = false,
  }) async {
    final l = layers[layerUuid];
    if (l == null) return;
    layers[layerUuid] = Layer(
      name: l.name,
      uuid: l.uuid,
      x: x ?? l.x,
      y: y ?? l.y,
      rotation: rotation ?? l.rotation,
      width: width ?? l.width,
      height: height ?? l.height,
      imageUuid: l.imageUuid,
      generationUuids: l.generationUuids,
    );

    notifyListeners();
    if (update) return updateProject();
  }

  Future setSelectedLayer({
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
  }) async {
    if (selectedLayerUUID == null) return;
    return setLayer(
      layerUuid: selectedLayerUUID!,
      x: x,
      y: y,
      width: width,
      height: height,
      rotation: rotation,
    );
  }

  Future removeSelectedLayer() async {
    if (selectedLayerUUID == null) return;
    return removeLayer(selectedLayerUUID!);
  }

  void select(String uuid) {
    if (selectedLayerUUID != uuid) {
      selectedLayerUUID = uuid;
      notifyListeners();
    }
  }

  void unSelect() {
    if (selectedLayerUUID != null) {
      selectedLayerUUID = null;
      notifyListeners();
    }
  }
}
