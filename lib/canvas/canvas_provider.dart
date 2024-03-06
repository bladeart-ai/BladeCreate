import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:bladecreate/canvas/transform_box_provider.dart';
import 'package:bladecreate/generate_backend/generate_backend_provider.dart';
import 'package:bladecreate/project/project_provider.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' as rendering;

enum CanvasOpMode { layer, mask }

class CanvasProvider extends ChangeNotifier {
  CanvasProvider(this.pp, this.gbp, this.tp);

  final ProjectProvider pp;
  final GenerateBackendProvider gbp;
  final TransformBoxProvider tp;

  GlobalKey boardKey = GlobalKey();

  late Future<void> loadFuture;

  CanvasOpMode opMode = CanvasOpMode.layer;

  String? selectedLayerUUID;
  Layer? get selectedLayer => pp.layers[selectedLayerUUID];
  Iterable<Generation> get selectedLayerGenerations =>
      selectedLayer == null || selectedLayer!.generationUuids == null
          ? []
          : selectedLayer!.generationUuids!.map((e) => gbp.generations[e]!);

  Uint8List? layerImage(Layer l) {
    if (l.imageUuid != null) return pp.imageOf(l.imageUuid);
    if (l.generationUuids != null && l.generationUuids!.isNotEmpty) {
      final g = gbp.generations[l.generationUuids![0]]!;
      if (g.imageUuids.isNotEmpty) {
        return gbp.imageOf(g.imageUuids[0]);
      }
    }
    return null;
  }

  double? layerPercentage(Layer l) {
    if (l.generationUuids != null && l.generationUuids!.isNotEmpty) {
      final g = gbp.generations[l.generationUuids![0]]!;
      return gbp.generationPercentage(g);
    }
    return 1;
  }

  Future<void> load() async {
    notifyListeners();
    loadFuture = () async {
      await pp.load();
      await gbp.load(pp.allLayersGenerationUuids);
      await gbp.connect();
      notifyListeners();
    }();
    return loadFuture;
  }

  Future setSelectedLayer({
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
  }) async {
    if (selectedLayerUUID == null) return;
    return pp.setLayer(
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
    return pp.removeLayer(selectedLayerUUID!);
  }

  void select(Layer l) {
    if (selectedLayerUUID != l.uuid) {
      selectedLayerUUID = l.uuid;
      notifyListeners();
    }
    tp.selectLayer(l);
  }

  void unSelect() {
    if (selectedLayerUUID != null) {
      selectedLayerUUID = null;
      notifyListeners();
    }
    tp.unselectLayer();
  }

  Future setLayerImageFromGeneration(Layer l, String imageUuid) async {
    return pp.setLayer(
      layerUuid: l.uuid,
      imageUuid: imageUuid,
      imageBytes: gbp.imageOf(imageUuid),
    );
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
    final g = await gbp.createGeneration(params);
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
      return pp.addLayer(newLayer);
    } else {
      List<String> generationUuids = selectedLayer!.generationUuids ?? [];
      generationUuids = [g.uuid, ...generationUuids];
      return pp.setLayer(
        layerUuid: selectedLayerUUID!,
        generationUuids: generationUuids,
      );
    }
  }
}
