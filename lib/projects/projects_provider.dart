import 'dart:async';
import 'dart:io';

import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:retry/retry.dart';
import 'package:uuid/uuid.dart';

class ProjectsProvider extends ChangeNotifier {
  final api = Openapi.create(baseUrl: Uri.parse("http://localhost:8080"));
  var uuid = Uuid();
  final userId = "guest";

  late Future<void> initFuture;
  List<Project> projects = [];

  init() {
    initFuture = fetchProjects();
  }

  Future<void> fetchProjects() async {
    final resp = await const RetryOptions(maxAttempts: 1).retry(
      () => api
          .projectsUserIdGet(userId: userId)
          .timeout(const Duration(seconds: 5)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    if (resp.error != null) {
      // Handle server rejection or error
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
      // Handle server rejection or error
      throw Exception(resp.error);
    } else {
      projects.add(resp.body!);
      notifyListeners();
      return projectUUID;
    }
  }
}
