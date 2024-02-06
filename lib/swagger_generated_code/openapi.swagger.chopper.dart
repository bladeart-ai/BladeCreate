//Generated code

part of 'openapi.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$Openapi extends Openapi {
  _$Openapi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = Openapi;

  @override
  Future<Response<ImagesURLOrData>> _imagesUserIdGet({
    required String? userId,
    List<String>? imageUuids,
  }) {
    final Uri $url = Uri.parse('/images/${userId}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'image_uuids': imageUuids
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<ImagesURLOrData, ImagesURLOrData>($request);
  }

  @override
  Future<Response<dynamic>> _imagesUserIdPost({
    required String? userId,
    required ImagesData? body,
  }) {
    final Uri $url = Uri.parse('/images/${userId}');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Project>>> _projectsUserIdGet({
    required String? userId,
    List<String>? uuids,
  }) {
    final Uri $url = Uri.parse('/projects/${userId}');
    final Map<String, dynamic> $params = <String, dynamic>{'uuids': uuids};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<Project>, Project>($request);
  }

  @override
  Future<Response<Project>> _projectsUserIdPost({
    required String? userId,
    required ProjectCreate? body,
  }) {
    final Uri $url = Uri.parse('/projects/${userId}');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Project, Project>($request);
  }

  @override
  Future<Response<Project>> _projectsUserIdProjectUuidGet({
    required String? userId,
    required String? projectUuid,
  }) {
    final Uri $url = Uri.parse('/projects/${userId}/${projectUuid}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Project, Project>($request);
  }

  @override
  Future<Response<Project>> _projectsUserIdProjectUuidPut({
    required String? userId,
    required String? projectUuid,
    required ProjectUpdate? body,
  }) {
    final Uri $url = Uri.parse('/projects/${userId}/${projectUuid}');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Project, Project>($request);
  }

  @override
  Future<Response<List<Generation>>> _generationsUserIdGet({
    required String? userId,
    List<String>? generationUuids,
    bool? activeOnly,
  }) {
    final Uri $url = Uri.parse('/generations/${userId}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'generation_uuids': generationUuids,
      'active_only': activeOnly,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<Generation>, Generation>($request);
  }

  @override
  Future<Response<Generation>> _generationsUserIdPost({
    required String? userId,
    required GenerationCreate? body,
  }) {
    final Uri $url = Uri.parse('/generations/${userId}');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Generation, Generation>($request);
  }

  @override
  Future<Response<dynamic>> _workersWorkerUuidPopGenerationTaskPost(
      {required String? workerUuid}) {
    final Uri $url = Uri.parse('/workers/${workerUuid}/pop_generation_task');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _generationsGenerationUuidPut({
    required String? generationUuid,
    required GenerationTaskUpdate? body,
  }) {
    final Uri $url = Uri.parse('/generations/${generationUuid}');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _workersWorkerUuidPut({
    required String? workerUuid,
    required Worker? body,
  }) {
    final Uri $url = Uri.parse('/workers/${workerUuid}');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<ClusterEvent>> _clusterGet() {
    final Uri $url = Uri.parse('/cluster');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<ClusterEvent, ClusterEvent>($request);
  }

  @override
  Future<Response<dynamic>> _healthGet() {
    final Uri $url = Uri.parse('/health');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
