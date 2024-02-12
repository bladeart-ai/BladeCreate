import 'dart:async';
import 'dart:io';

import 'package:bladecreate/settings.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:retry/retry.dart';
import 'package:uuid/uuid.dart';

class ProjectsProvider extends ChangeNotifier {
  final api = Openapi.create(baseUrl: Uri.parse(Settings.apiURL));
  var uuid = const Uuid();
  final userId = Settings.guestUserId;

  late Future<void> fetchProjectsFuture;
  List<Project> projects = [];

  Future<void> fetchProjects() async {
    notifyListeners();
    fetchProjectsFuture = _fetchProjects();
    return fetchProjectsFuture;
  }

  Future<void> _fetchProjects() async {
    final resp = await RetryOptions(
            maxDelay: Duration(seconds: Settings.reconnectDelaySecs),
            maxAttempts: Settings.maxRetryAttempts)
        .retry(
      () => api
          .projectsUserIdGet(userId: userId)
          .timeout(Duration(seconds: Settings.timeoutSecs)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    if (resp.error != null) {
      throw Exception(resp.error);
    } else {
      projects = resp.body!;
      notifyListeners();
    }
  }

  Future<dynamic> createProject() async {
    final projectUUID = uuid.v4();
    final resp = await api.projectsUserIdPost(
        userId: userId,
        body: ProjectCreate(uuid: projectUUID, name: "Untitled", data: {}));
    if (resp.error != null) {
      throw Exception(resp.error);
    } else {
      projects.add(resp.body!);
      notifyListeners();
      return projectUUID;
    }
  }

  Future<dynamic> renameProject(String projectUUID, String newName) async {
    final resp = await api.projectsUserIdProjectUuidPut(
        userId: userId,
        projectUuid: projectUUID,
        body: ProjectUpdate(name: newName));
    if (resp.error != null) {
      throw Exception(resp.error);
    } else {
      projects[projects.indexWhere((p) => resp.body!.uuid == p.uuid)] =
          resp.body!;
      notifyListeners();
    }
  }

  Future<void> deleteProject(String projectUUID) async {
    final resp = await api.projectsUserIdProjectUuidDelete(
        userId: userId, projectUuid: projectUUID);
    if (resp.error != null) {
      throw Exception(resp.error);
    } else {
      projects.removeWhere((p) => resp.body!.uuid == p.uuid);
      notifyListeners();
    }
  }
}
