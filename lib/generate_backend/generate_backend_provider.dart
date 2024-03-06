import 'dart:async';

import 'package:bladecreate/store/generate_remote_store.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:flutter/foundation.dart';

enum GenerateBackendStatus { unready, busy, idle }

class GenerateBackendProvider extends ChangeNotifier {
  final generateStore = GenerateRemoteAPI();

  WSStatus wsStatus = WSStatus.disconnected;
  ClusterEvent? wsLastEvent;
  List<Worker> workers = [];
  List<Generation> tasks = [];
  Map<String, Generation> generations = {};
  Map<String, Uint8List> imageData = {};
  Uint8List? imageOf(String imageUuid) => imageData[imageUuid];

  GenerateBackendStatus get status {
    if (wsStatus == WSStatus.disconnected) {
      return GenerateBackendStatus.unready;
    } else {
      if (activeWorkers.isEmpty) {
        return GenerateBackendStatus.unready;
      } else if (idleWorkers.isEmpty) {
        return GenerateBackendStatus.busy;
      } else {
        return GenerateBackendStatus.idle;
      }
    }
  }

  Iterable<Worker> get activeWorkers =>
      workers.where((w) => w.status == "STARTING" || w.status == "INITIALIZED");
  Iterable<Worker> get idleWorkers =>
      activeWorkers.where((w) => w.currentJob == null);
  Iterable<Generation> get activeTasks =>
      tasks.where((t) => t.status == "CREATED" || t.status == "STARTED");

  double? generationPercentage(Generation g) {
    if (g.imageUuids.isNotEmpty) return 1;
    return g.percentage;
  }

  Future<void> load(List<String> generationUuids) async {
    generations.addEntries(
        (await generateStore.fetchGenerations(generationUuids))
            .map((e) => MapEntry(e.uuid, e)));
    imageData.addAll(await generateStore
        .fetchImages(generations.values.expand((e) => e.imageUuids).toList()));
    notifyListeners();
  }

  Future<void> connect() async {
    onConnectionUpdate(WSStatus e) {
      wsStatus = e;
      notifyListeners();
    }

    onScreenshot(ClusterSnapshot e) {
      workers = e.workers;
      tasks = e.activeJobs;
      notifyListeners();
    }

    onWorkerUpdate(Worker newW) {
      final foundIx = workers.indexWhere((w) => w.uuid == newW.uuid);
      if (foundIx != -1) {
        workers[foundIx] = newW;
      } else {
        workers.insert(0, newW);
      }
      notifyListeners();
    }

    onGenerationUpdate(Generation newG) async {
      final foundIx = tasks.indexWhere((g) => g.uuid == newG.uuid);
      if (foundIx != -1) {
        tasks[foundIx] = newG;
      } else {
        tasks.insert(0, newG);
      }

      if (!generations.containsKey(newG.uuid) ||
          generations[newG.uuid]!.imageUuids.isEmpty) {
        imageData.addAll(await generateStore.fetchImages(newG.imageUuids));
      }
      generations[newG.uuid] = newG;

      notifyListeners();
    }

    generateStore.connect(
      onConnectionUpdate,
      onScreenshot,
      onWorkerUpdate,
      onGenerationUpdate,
    );
  }

  Future<Generation> createGeneration(GenerationParams params) async {
    final g = await generateStore.createGeneration(params);
    generations[g.uuid] = g;
    notifyListeners();
    return g;
  }
}
