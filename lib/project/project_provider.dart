import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';

import 'package:bladecreate/settings.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:flutter/widgets.dart';
import 'package:retry/retry.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class ProjectProvider extends ChangeNotifier {
  ProjectProvider({required this.projectUUID});

  // Data fetching
  final api = Openapi.create(baseUrl: Uri.parse(Settings.apiURL));

  final userId = Settings.guestUserId;
  final String projectUUID;
  late Future<void> fetchProjectFuture;

  // Cached data
  late Project project;
  List<String> layersOrder = [];
  Map<String, Layer> layers = {};
  String? selectedLayerUUID;

  Iterable<Layer> get orderedLayers => layersOrder.map((e) => layers[e]!);

  Future<void> fetchProject() async {
    notifyListeners();
    fetchProjectFuture = _fetchProject();
    return fetchProjectFuture;
  }

  Future<void> _fetchProject() async {
    final resp = await RetryOptions(
            maxDelay: Duration(seconds: Settings.reconnectDelaySecs),
            maxAttempts: Settings.maxRetryAttempts)
        .retry(
      () => api
          .projectsUserIdProjectUuidGet(
              userId: userId, projectUuid: projectUUID)
          .timeout(Duration(seconds: Settings.timeoutSecs)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    if (resp.error != null) {
      throw Exception(resp.error);
    } else {
      project = resp.body!;
      layersOrder = project.data.layersOrder!;
      layers =
          project.data.layers!.map((k, v) => MapEntry<String, Layer>(k, v));
      notifyListeners();
    }
  }

  void addLayer(Layer l) {
    layersOrder.add(l.uuid);
    layers[l.uuid] = l;
    notifyListeners();
  }

  void removeLayer(String uuid) {
    layersOrder.remove(uuid);
    layers.remove(uuid);
    notifyListeners();
  }

  void moveLayerToTop(String uuid) {
    final ix = layersOrder.indexWhere((String e) => e == uuid);
    if (ix == -1) return;
    final removed = layersOrder.removeAt(ix);
    layersOrder.add(removed);
    notifyListeners();
  }

  void setSelectedLayer({
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
  }) {
    if (selectedLayerUUID == null) return;

    final selectedLayer = layers[selectedLayerUUID!]!;
    layers[selectedLayerUUID!] = Layer(
      name: selectedLayer.name,
      uuid: selectedLayer.uuid,
      x: x ?? selectedLayer.x,
      y: y ?? selectedLayer.y,
      rotation: rotation ?? selectedLayer.rotation,
      width: width ?? selectedLayer.width,
      height: height ?? selectedLayer.height,
    );
    notifyListeners();
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
