import 'dart:async';
import 'dart:convert';

import 'package:bladecreate/settings.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum WSStatus { connected, disconnected }

enum ClusterStatus { unready, busy, idle }

class ClusterRepo extends ChangeNotifier {
  late WebSocketChannel ws;

  WSStatus wsStatus = WSStatus.disconnected;
  ClusterEvent? wsLastEvent;
  List<Worker> workers = [];
  List<Generation> tasks = [];

  ClusterStatus get status {
    if (wsStatus == WSStatus.disconnected) {
      return ClusterStatus.unready;
    } else {
      if (activeWorkers.isEmpty) {
        return ClusterStatus.unready;
      } else if (idleWorkers.isEmpty) {
        return ClusterStatus.busy;
      } else {
        return ClusterStatus.idle;
      }
    }
  }

  Iterable<Worker> get activeWorkers =>
      workers.where((w) => w.status == "STARTING" || w.status == "INITIALIZED");
  Iterable<Worker> get idleWorkers =>
      activeWorkers.where((w) => w.currentJob == null);
  Iterable<Generation> get activeTasks =>
      tasks.where((t) => t.status == "CREATED" || t.status == "STARTED");

  Future<void> connect() async {
    final ws = WebSocketChannel.connect(
      Uri.parse(Settings.apiWSURL),
    );
    wsStatus = WSStatus.connected;
    notifyListeners();

    ws.stream.listen((msg) {
      final e = ClusterEvent.fromJson(json.decode(msg));
      wsLastEvent = e;
      if (e.screenshot != null) {
        final screenshot = ClusterSnapshot.fromJson(e.screenshot);
        workers = (screenshot).workers;
        tasks = (screenshot).activeJobs;
      }
      if (e.workerUpdate != null) {
        final newW = Worker.fromJson(e.workerUpdate);
        final foundIx = workers.indexWhere((w) => w.uuid == newW.uuid);
        if (foundIx != -1) {
          workers[foundIx] = newW;
        } else {
          workers.insert(0, newW);
        }
      }
      if (e.generationUpdate != null) {
        final newG = Generation.fromJson(e.generationUpdate);
        final foundIx = tasks.indexWhere((g) => g.uuid == newG.uuid);
        if (foundIx != -1) {
          tasks[foundIx] = newG;
        } else {
          tasks.insert(0, newG);
        }
      }
      notifyListeners();
    }, onError: (e) async {
      wsStatus = WSStatus.disconnected;
      notifyListeners();

      await Future.delayed(
          Duration(seconds: Settings.reconnectDelaySecs), () => connect());
    }, onDone: () async {
      wsStatus = WSStatus.disconnected;
      notifyListeners();

      await Future.delayed(
          Duration(seconds: Settings.reconnectDelaySecs), () => connect());
    }, cancelOnError: true);
  }
}
