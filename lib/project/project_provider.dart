import 'dart:ui' as ui;

import 'package:bladecreate/store/generate_remote_store.dart';
import 'package:bladecreate/store/project_remote_store.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter/rendering.dart' as rendering;
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
    projectStore.updateProject(
      projectUUID,
      ProjectUpdate(data: projectData),
    );
    super.dispose();
  }

  final projectStore = ProjectRemoteAPI();
  final generateStore = GenerateRemoteAPI();

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
  Map<String, Generation> generations = {};
  Map<String, Uint8List> imageData = {};
  ProjectData get projectData =>
      ProjectData(layersOrder: layersOrder, layers: layers);
  Iterable<Layer> get orderedLayers => layersOrder.map((e) => layers[e]!);
  Uint8List? imageOf(String imageUuid) => imageData[imageUuid];
  Uint8List? layerImage(Layer l) {
    if (l.imageUuid != null) return imageData[l.imageUuid];
    if (l.generationUuids != null && l.generationUuids!.isNotEmpty) {
      final g = generations[l.generationUuids![0]]!;
      if (g.imageUuids.isNotEmpty) {
        return imageData[g.imageUuids[0]];
      }
    }
    return null;
  }

  double? generationPercentage(Generation g) {
    if (g.imageUuids.isNotEmpty) return 1;
    return g.percentage;
  }

  double? layerPercentage(Layer l) {
    if (l.generationUuids != null && l.generationUuids!.isNotEmpty) {
      final g = generations[l.generationUuids![0]]!;
      return generationPercentage(g);
    }
    return 1;
  }

  // Board states
  GlobalKey boardKey = GlobalKey();
  final defaultHeight = 200.0;
  String? selectedLayerUUID;
  Layer? get selectedLayer => layers[selectedLayerUUID];
  Iterable<Generation> get selectedLayerGenerations =>
      selectedLayer == null || selectedLayer!.generationUuids == null
          ? []
          : selectedLayer!.generationUuids!.map((e) => generations[e]!);

  Future<void> load() async {
    notifyListeners();
    loadFuture = () async {
      project = await projectStore.fetchProject(projectUUID);
      layersOrder = project.data.layersOrder!;
      layers = project.data.layers!
          .map((k, v) => MapEntry<String, Layer>(k, Layer.fromJson(v)));
      generations.addEntries((await generateStore.fetchGenerations(layers.values
              .expand<String>((e) => e.generationUuids ?? [])
              .toList()))
          .map((e) => MapEntry(e.uuid, e)));
      imageData.addAll(await projectStore.fetchImages(layers.values
          .expand<String>((e) => e.imageUuid == null ? [] : [e.imageUuid])
          .toList()));
      imageData.addAll(await generateStore.fetchImages(
          generations.values.expand((e) => e.imageUuids).toList()));
      notifyListeners();
    }();
    return loadFuture;
  }

  void watchGenerationStream(StreamController<Generation> sc) {
    sc.stream.listen((Generation newG) async {
      if (!generations.containsKey(newG.uuid) ||
          generations[newG.uuid]!.imageUuids.isEmpty) {
        imageData.addAll(await generateStore.fetchImages(newG.imageUuids));
      }
      generations[newG.uuid] = newG;
      notifyListeners();
    });
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
    layersOrder.add(removed);

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
      update: false,
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

  Future<Uint8List> takeScreenShotAsPNG() async {
    rendering.RenderRepaintBoundary boundary = boardKey.currentContext!
        .findRenderObject()! as rendering.RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage();
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();
    return pngBytes;
  }

  Future generate(GenerationParams params) async {
    final g = await generateStore.createGeneration(params);
    generations[g.uuid] = g;
    if (selectedLayerUUID == null) {
      final newLayer = Layer(
        uuid: uuid.v4(),
        name: "New Generation Layer",
        x: 0,
        y: 0,
        width: params.width.toDouble(),
        height: params.height.toDouble(),
        rotation: 0,
        generationUuids: [g.uuid],
      );
      return addLayer(newLayer);
    } else {
      List<String> generationUuids =
          layers[selectedLayerUUID!]!.generationUuids ?? [];
      generationUuids = [g.uuid, ...generationUuids];
      return setLayer(
        layerUuid: selectedLayerUUID!,
        generationUuids: generationUuids,
      );
    }
  }
}
