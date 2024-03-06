import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';

import 'package:bladecreate/settings.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:retry/retry.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

var uuid = const Uuid();

enum WSStatus { connected, disconnected }

class GenerateRemoteAPI {
  final api = Openapi.create(baseUrl: Uri.parse(Settings.apiURL));

  final userId = Settings.guestUserId;

  Future<T> callAPI<T>(Future<Response<T>> f) async {
    final resp = await RetryOptions(
            maxDelay: Duration(seconds: Settings.reconnectDelaySecs),
            maxAttempts: Settings.maxRetryAttempts)
        .retry(
      () => f.timeout(Duration(seconds: Settings.timeoutSecs)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    if (resp.error != null) {
      throw Exception(resp.error);
    }
    if (resp.statusCode != 200) {
      throw Exception("Fail to call API: $resp");
    }
    return resp.body!;
  }

  Future<Uint8List> fetchImageBytes<T>(String uri) async {
    final resp = await RetryOptions(
            maxDelay: Duration(seconds: Settings.reconnectDelaySecs),
            maxAttempts: Settings.maxRetryAttempts)
        .retry(
      () => http
          .get(Uri.parse(uri))
          .timeout(Duration(seconds: Settings.timeoutSecs)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    if (resp.statusCode != 200) {
      throw Exception("Fail to call API: $resp");
    }
    return base64.decode(resp.body);
  }

  Future<List<Generation>> fetchGenerations(
      List<String> generationUuids) async {
    if (generationUuids.isEmpty) return [];
    return callAPI(api.generationsUserIdGet(
      userId: userId,
      generationUuids: generationUuids,
    ));
  }

  Future<Map<String, Uint8List>> fetchImages(List<String> imageUuids) async {
    if (imageUuids.isEmpty) return {};

    final body = await callAPI(api.imagesUserIdGet(
      userId: userId,
      imageUuids: imageUuids,
    ));
    Map<String, Uint8List> imageData =
        body.data.map((k, v) => MapEntry(k, base64.decode(v)));

    body.urls.forEach((k, v) async {
      imageData[k] = await fetchImageBytes(v);
    });

    return imageData;
  }

  Future<Generation> createGeneration(GenerationParams params) async {
    return callAPI(api.generationsUserIdPost(
        userId: userId, body: GenerationCreate(params: params)));
  }

  WebSocketChannel connect(
    Function(WSStatus) onConnectionUpdate,
    Function(ClusterSnapshot) onScreenshot,
    Function(Worker) onWorkerUpdate,
    Function(Generation) onGenerationUpdate,
  ) {
    void reconnect() async {
      onConnectionUpdate(WSStatus.disconnected);

      await Future.delayed(
        Duration(seconds: Settings.reconnectDelaySecs),
        () => connect(
          onConnectionUpdate,
          onScreenshot,
          onWorkerUpdate,
          onGenerationUpdate,
        ),
      );
    }

    void onMessage(dynamic msg) {
      final e = ClusterEvent.fromJson(json.decode(msg));
      if (e.screenshot != null) {
        final screenshot = ClusterSnapshot.fromJson(e.screenshot);
        onScreenshot(screenshot);
      }
      if (e.workerUpdate != null) {
        final newW = Worker.fromJson(e.workerUpdate);
        onWorkerUpdate(newW);
      }
      if (e.generationUpdate != null) {
        final newG = Generation.fromJson(e.generationUpdate);
        onGenerationUpdate(newG);
      }
    }

    final ws = WebSocketChannel.connect(
      Uri.parse(Settings.apiWSURL),
    );
    onConnectionUpdate(WSStatus.connected);

    ws.stream.listen(
      (msg) => onMessage(msg),
      onError: (e) => reconnect(),
      onDone: () => reconnect(),
      cancelOnError: true,
    );

    return ws;
  }
}
