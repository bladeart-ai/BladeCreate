import 'package:bladecreate/project/case_style.dart';
import 'package:bladecreate/project/layer/layer.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';

import 'package:bladecreate/settings.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:flutter/widgets.dart';
import 'package:retry/retry.dart';
import 'package:uuid/uuid.dart';

class ProjectProvider extends ChangeNotifier {
  ProjectProvider({required this.projectUUID});

  // Data fetching
  final api = Openapi.create(baseUrl: Uri.parse(Settings.apiURL));
  var uuid = const Uuid();
  final userId = Settings.guestUserId;
  final String projectUUID;
  late Future<void> fetchProjectFuture;

  // Cached data
  late Project project;
  List<LayerModel> layers = [];
  List<int> selected = [];

  // Temporary Status
  final CaseStyle caseStyle = const CaseStyle();

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
      notifyListeners();
    }
  }

  void addLayer<T extends LayerModel>(LayerModel item) {
    if (layers.contains(item)) throw 'duplicate id';

    layers.add(item.copyWith(
      id: item.id ?? layers.length,
      caseStyle: item.caseStyle ?? caseStyle,
    ));
    notifyListeners();
  }

  void removeLayer(int? id) {
    layers.removeWhere((LayerModel b) => b.id == id);
    notifyListeners();
  }

  void moveLayerToTop(int? id) {
    if (id == null) return;

    final LayerModel item = layers.firstWhere((LayerModel i) => i.id == id);
    layers.removeWhere((LayerModel i) => i.id == id);
    layers.add(item);
    notifyListeners();
  }

  void unSelect() {
    selected.clear();
    notifyListeners();
  }
}
