// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:convert';

import 'package:chopper/chopper.dart';

import 'client_mapping.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show MultipartFile;
import 'package:chopper/chopper.dart' as chopper;

part 'openapi.swagger.chopper.dart';
part 'openapi.swagger.g.dart';

// **************************************************************************
// SwaggerChopperGenerator
// **************************************************************************

@ChopperApi()
abstract class Openapi extends ChopperService {
  static Openapi create({
    ChopperClient? client,
    http.Client? httpClient,
    Authenticator? authenticator,
    ErrorConverter? errorConverter,
    Converter? converter,
    Uri? baseUrl,
    Iterable<dynamic>? interceptors,
  }) {
    if (client != null) {
      return _$Openapi(client);
    }

    final newClient = ChopperClient(
        services: [_$Openapi()],
        converter: converter ?? $JsonSerializableConverter(),
        interceptors: interceptors ?? [],
        client: httpClient,
        authenticator: authenticator,
        errorConverter: errorConverter,
        baseUrl: baseUrl ?? Uri.parse('http://'));
    return _$Openapi(newClient);
  }

  ///Get Image Data Or Url
  ///@param user_id
  ///@param image_uuids
  Future<chopper.Response<ImagesURLOrData>> imagesUserIdGet({
    required String? userId,
    List<String>? imageUuids,
  }) {
    generatedMapping.putIfAbsent(
        ImagesURLOrData, () => ImagesURLOrData.fromJsonFactory);

    return _imagesUserIdGet(userId: userId, imageUuids: imageUuids);
  }

  ///Get Image Data Or Url
  ///@param user_id
  ///@param image_uuids
  @Get(path: '/images/{user_id}')
  Future<chopper.Response<ImagesURLOrData>> _imagesUserIdGet({
    @Path('user_id') required String? userId,
    @Query('image_uuids') List<String>? imageUuids,
  });

  ///Upload Images
  ///@param user_id
  Future<chopper.Response> imagesUserIdPost({
    required String? userId,
    required ImagesData? body,
  }) {
    return _imagesUserIdPost(userId: userId, body: body);
  }

  ///Upload Images
  ///@param user_id
  @Post(
    path: '/images/{user_id}',
    optionalBody: true,
  )
  Future<chopper.Response> _imagesUserIdPost({
    @Path('user_id') required String? userId,
    @Body() required ImagesData? body,
  });

  ///Get Projects
  ///@param user_id
  ///@param uuids
  Future<chopper.Response<List<Project>>> projectsUserIdGet({
    required String? userId,
    List<String>? uuids,
  }) {
    generatedMapping.putIfAbsent(Project, () => Project.fromJsonFactory);

    return _projectsUserIdGet(userId: userId, uuids: uuids);
  }

  ///Get Projects
  ///@param user_id
  ///@param uuids
  @Get(path: '/projects/{user_id}')
  Future<chopper.Response<List<Project>>> _projectsUserIdGet({
    @Path('user_id') required String? userId,
    @Query('uuids') List<String>? uuids,
  });

  ///Create Project
  ///@param user_id
  Future<chopper.Response<Project>> projectsUserIdPost({
    required String? userId,
    required ProjectCreate? body,
  }) {
    generatedMapping.putIfAbsent(Project, () => Project.fromJsonFactory);

    return _projectsUserIdPost(userId: userId, body: body);
  }

  ///Create Project
  ///@param user_id
  @Post(
    path: '/projects/{user_id}',
    optionalBody: true,
  )
  Future<chopper.Response<Project>> _projectsUserIdPost({
    @Path('user_id') required String? userId,
    @Body() required ProjectCreate? body,
  });

  ///Get Project
  ///@param user_id
  ///@param project_uuid
  Future<chopper.Response<Project>> projectsUserIdProjectUuidGet({
    required String? userId,
    required String? projectUuid,
  }) {
    generatedMapping.putIfAbsent(Project, () => Project.fromJsonFactory);

    return _projectsUserIdProjectUuidGet(
        userId: userId, projectUuid: projectUuid);
  }

  ///Get Project
  ///@param user_id
  ///@param project_uuid
  @Get(path: '/projects/{user_id}/{project_uuid}')
  Future<chopper.Response<Project>> _projectsUserIdProjectUuidGet({
    @Path('user_id') required String? userId,
    @Path('project_uuid') required String? projectUuid,
  });

  ///Update Project
  ///@param user_id
  ///@param project_uuid
  Future<chopper.Response<Project>> projectsUserIdProjectUuidPut({
    required String? userId,
    required String? projectUuid,
    required ProjectUpdate? body,
  }) {
    generatedMapping.putIfAbsent(Project, () => Project.fromJsonFactory);

    return _projectsUserIdProjectUuidPut(
        userId: userId, projectUuid: projectUuid, body: body);
  }

  ///Update Project
  ///@param user_id
  ///@param project_uuid
  @Put(
    path: '/projects/{user_id}/{project_uuid}',
    optionalBody: true,
  )
  Future<chopper.Response<Project>> _projectsUserIdProjectUuidPut({
    @Path('user_id') required String? userId,
    @Path('project_uuid') required String? projectUuid,
    @Body() required ProjectUpdate? body,
  });

  ///Get Generations
  ///@param user_id
  ///@param generation_uuids
  ///@param active_only
  Future<chopper.Response<List<Generation>>> generationsUserIdGet({
    required String? userId,
    List<String>? generationUuids,
    bool? activeOnly,
  }) {
    generatedMapping.putIfAbsent(Generation, () => Generation.fromJsonFactory);

    return _generationsUserIdGet(
        userId: userId,
        generationUuids: generationUuids,
        activeOnly: activeOnly);
  }

  ///Get Generations
  ///@param user_id
  ///@param generation_uuids
  ///@param active_only
  @Get(path: '/generations/{user_id}')
  Future<chopper.Response<List<Generation>>> _generationsUserIdGet({
    @Path('user_id') required String? userId,
    @Query('generation_uuids') List<String>? generationUuids,
    @Query('active_only') bool? activeOnly,
  });

  ///Create Generation
  ///@param user_id
  Future<chopper.Response<Generation>> generationsUserIdPost({
    required String? userId,
    required GenerationCreate? body,
  }) {
    generatedMapping.putIfAbsent(Generation, () => Generation.fromJsonFactory);

    return _generationsUserIdPost(userId: userId, body: body);
  }

  ///Create Generation
  ///@param user_id
  @Post(
    path: '/generations/{user_id}',
    optionalBody: true,
  )
  Future<chopper.Response<Generation>> _generationsUserIdPost({
    @Path('user_id') required String? userId,
    @Body() required GenerationCreate? body,
  });

  ///Pop Generation Task
  ///@param worker_uuid
  Future<chopper.Response> workersWorkerUuidPopGenerationTaskPost(
      {required String? workerUuid}) {
    return _workersWorkerUuidPopGenerationTaskPost(workerUuid: workerUuid);
  }

  ///Pop Generation Task
  ///@param worker_uuid
  @Post(
    path: '/workers/{worker_uuid}/pop_generation_task',
    optionalBody: true,
  )
  Future<chopper.Response> _workersWorkerUuidPopGenerationTaskPost(
      {@Path('worker_uuid') required String? workerUuid});

  ///Update Generation
  ///@param generation_uuid
  Future<chopper.Response> generationsGenerationUuidPut({
    required String? generationUuid,
    required GenerationTaskUpdate? body,
  }) {
    return _generationsGenerationUuidPut(
        generationUuid: generationUuid, body: body);
  }

  ///Update Generation
  ///@param generation_uuid
  @Put(
    path: '/generations/{generation_uuid}',
    optionalBody: true,
  )
  Future<chopper.Response> _generationsGenerationUuidPut({
    @Path('generation_uuid') required String? generationUuid,
    @Body() required GenerationTaskUpdate? body,
  });

  ///Upsert Worker
  ///@param worker_uuid
  Future<chopper.Response> workersWorkerUuidPut({
    required String? workerUuid,
    required Worker? body,
  }) {
    return _workersWorkerUuidPut(workerUuid: workerUuid, body: body);
  }

  ///Upsert Worker
  ///@param worker_uuid
  @Put(
    path: '/workers/{worker_uuid}',
    optionalBody: true,
  )
  Future<chopper.Response> _workersWorkerUuidPut({
    @Path('worker_uuid') required String? workerUuid,
    @Body() required Worker? body,
  });

  ///Get Cluster Snapshot
  Future<chopper.Response<ClusterEvent>> clusterGet() {
    generatedMapping.putIfAbsent(
        ClusterEvent, () => ClusterEvent.fromJsonFactory);

    return _clusterGet();
  }

  ///Get Cluster Snapshot
  @Get(path: '/cluster')
  Future<chopper.Response<ClusterEvent>> _clusterGet();

  ///Health Check
  Future<chopper.Response> healthGet() {
    return _healthGet();
  }

  ///Health Check
  @Get(path: '/health')
  Future<chopper.Response> _healthGet();
}

@JsonSerializable(explicitToJson: true)
class ClusterEvent {
  const ClusterEvent({
    this.screenshot,
    this.workerUpdate,
    this.generationUpdate,
  });

  factory ClusterEvent.fromJson(Map<String, dynamic> json) =>
      _$ClusterEventFromJson(json);

  static const toJsonFactory = _$ClusterEventToJson;
  Map<String, dynamic> toJson() => _$ClusterEventToJson(this);

  @JsonKey(name: 'screenshot')
  final dynamic screenshot;
  @JsonKey(name: 'workerUpdate')
  final dynamic workerUpdate;
  @JsonKey(name: 'generationUpdate')
  final dynamic generationUpdate;
  static const fromJsonFactory = _$ClusterEventFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ClusterEvent &&
            (identical(other.screenshot, screenshot) ||
                const DeepCollectionEquality()
                    .equals(other.screenshot, screenshot)) &&
            (identical(other.workerUpdate, workerUpdate) ||
                const DeepCollectionEquality()
                    .equals(other.workerUpdate, workerUpdate)) &&
            (identical(other.generationUpdate, generationUpdate) ||
                const DeepCollectionEquality()
                    .equals(other.generationUpdate, generationUpdate)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(screenshot) ^
      const DeepCollectionEquality().hash(workerUpdate) ^
      const DeepCollectionEquality().hash(generationUpdate) ^
      runtimeType.hashCode;
}

extension $ClusterEventExtension on ClusterEvent {
  ClusterEvent copyWith(
      {dynamic screenshot, dynamic workerUpdate, dynamic generationUpdate}) {
    return ClusterEvent(
        screenshot: screenshot ?? this.screenshot,
        workerUpdate: workerUpdate ?? this.workerUpdate,
        generationUpdate: generationUpdate ?? this.generationUpdate);
  }

  ClusterEvent copyWithWrapped(
      {Wrapped<dynamic>? screenshot,
      Wrapped<dynamic>? workerUpdate,
      Wrapped<dynamic>? generationUpdate}) {
    return ClusterEvent(
        screenshot: (screenshot != null ? screenshot.value : this.screenshot),
        workerUpdate:
            (workerUpdate != null ? workerUpdate.value : this.workerUpdate),
        generationUpdate: (generationUpdate != null
            ? generationUpdate.value
            : this.generationUpdate));
  }
}

@JsonSerializable(explicitToJson: true)
class ClusterSnapshot {
  const ClusterSnapshot({
    required this.workers,
    required this.activeJobs,
  });

  factory ClusterSnapshot.fromJson(Map<String, dynamic> json) =>
      _$ClusterSnapshotFromJson(json);

  static const toJsonFactory = _$ClusterSnapshotToJson;
  Map<String, dynamic> toJson() => _$ClusterSnapshotToJson(this);

  @JsonKey(name: 'workers', defaultValue: <Worker>[])
  final List<Worker> workers;
  @JsonKey(name: 'active_jobs', defaultValue: <Generation>[])
  final List<Generation> activeJobs;
  static const fromJsonFactory = _$ClusterSnapshotFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ClusterSnapshot &&
            (identical(other.workers, workers) ||
                const DeepCollectionEquality()
                    .equals(other.workers, workers)) &&
            (identical(other.activeJobs, activeJobs) ||
                const DeepCollectionEquality()
                    .equals(other.activeJobs, activeJobs)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(workers) ^
      const DeepCollectionEquality().hash(activeJobs) ^
      runtimeType.hashCode;
}

extension $ClusterSnapshotExtension on ClusterSnapshot {
  ClusterSnapshot copyWith(
      {List<Worker>? workers, List<Generation>? activeJobs}) {
    return ClusterSnapshot(
        workers: workers ?? this.workers,
        activeJobs: activeJobs ?? this.activeJobs);
  }

  ClusterSnapshot copyWithWrapped(
      {Wrapped<List<Worker>>? workers, Wrapped<List<Generation>>? activeJobs}) {
    return ClusterSnapshot(
        workers: (workers != null ? workers.value : this.workers),
        activeJobs: (activeJobs != null ? activeJobs.value : this.activeJobs));
  }
}

@JsonSerializable(explicitToJson: true)
class Generation {
  const Generation({
    required this.params,
    required this.uuid,
    required this.createTime,
    required this.updateTime,
    required this.status,
    this.elapsedSecs,
    this.percentage,
    required this.imageUuids,
  });

  factory Generation.fromJson(Map<String, dynamic> json) =>
      _$GenerationFromJson(json);

  static const toJsonFactory = _$GenerationToJson;
  Map<String, dynamic> toJson() => _$GenerationToJson(this);

  @JsonKey(name: 'params')
  final GenerationParams params;
  @JsonKey(name: 'uuid')
  final String uuid;
  @JsonKey(name: 'create_time')
  final DateTime createTime;
  @JsonKey(name: 'update_time')
  final DateTime updateTime;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'elapsedSecs')
  final dynamic elapsedSecs;
  @JsonKey(name: 'percentage')
  final dynamic percentage;
  @JsonKey(name: 'image_uuids', defaultValue: <String>[])
  final List<String> imageUuids;
  static const fromJsonFactory = _$GenerationFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Generation &&
            (identical(other.params, params) ||
                const DeepCollectionEquality().equals(other.params, params)) &&
            (identical(other.uuid, uuid) ||
                const DeepCollectionEquality().equals(other.uuid, uuid)) &&
            (identical(other.createTime, createTime) ||
                const DeepCollectionEquality()
                    .equals(other.createTime, createTime)) &&
            (identical(other.updateTime, updateTime) ||
                const DeepCollectionEquality()
                    .equals(other.updateTime, updateTime)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.elapsedSecs, elapsedSecs) ||
                const DeepCollectionEquality()
                    .equals(other.elapsedSecs, elapsedSecs)) &&
            (identical(other.percentage, percentage) ||
                const DeepCollectionEquality()
                    .equals(other.percentage, percentage)) &&
            (identical(other.imageUuids, imageUuids) ||
                const DeepCollectionEquality()
                    .equals(other.imageUuids, imageUuids)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(params) ^
      const DeepCollectionEquality().hash(uuid) ^
      const DeepCollectionEquality().hash(createTime) ^
      const DeepCollectionEquality().hash(updateTime) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(elapsedSecs) ^
      const DeepCollectionEquality().hash(percentage) ^
      const DeepCollectionEquality().hash(imageUuids) ^
      runtimeType.hashCode;
}

extension $GenerationExtension on Generation {
  Generation copyWith(
      {GenerationParams? params,
      String? uuid,
      DateTime? createTime,
      DateTime? updateTime,
      String? status,
      dynamic elapsedSecs,
      dynamic percentage,
      List<String>? imageUuids}) {
    return Generation(
        params: params ?? this.params,
        uuid: uuid ?? this.uuid,
        createTime: createTime ?? this.createTime,
        updateTime: updateTime ?? this.updateTime,
        status: status ?? this.status,
        elapsedSecs: elapsedSecs ?? this.elapsedSecs,
        percentage: percentage ?? this.percentage,
        imageUuids: imageUuids ?? this.imageUuids);
  }

  Generation copyWithWrapped(
      {Wrapped<GenerationParams>? params,
      Wrapped<String>? uuid,
      Wrapped<DateTime>? createTime,
      Wrapped<DateTime>? updateTime,
      Wrapped<String>? status,
      Wrapped<dynamic>? elapsedSecs,
      Wrapped<dynamic>? percentage,
      Wrapped<List<String>>? imageUuids}) {
    return Generation(
        params: (params != null ? params.value : this.params),
        uuid: (uuid != null ? uuid.value : this.uuid),
        createTime: (createTime != null ? createTime.value : this.createTime),
        updateTime: (updateTime != null ? updateTime.value : this.updateTime),
        status: (status != null ? status.value : this.status),
        elapsedSecs:
            (elapsedSecs != null ? elapsedSecs.value : this.elapsedSecs),
        percentage: (percentage != null ? percentage.value : this.percentage),
        imageUuids: (imageUuids != null ? imageUuids.value : this.imageUuids));
  }
}

@JsonSerializable(explicitToJson: true)
class GenerationCreate {
  const GenerationCreate({
    required this.params,
    this.uuid,
  });

  factory GenerationCreate.fromJson(Map<String, dynamic> json) =>
      _$GenerationCreateFromJson(json);

  static const toJsonFactory = _$GenerationCreateToJson;
  Map<String, dynamic> toJson() => _$GenerationCreateToJson(this);

  @JsonKey(name: 'params')
  final GenerationParams params;
  @JsonKey(name: 'uuid')
  final dynamic uuid;
  static const fromJsonFactory = _$GenerationCreateFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is GenerationCreate &&
            (identical(other.params, params) ||
                const DeepCollectionEquality().equals(other.params, params)) &&
            (identical(other.uuid, uuid) ||
                const DeepCollectionEquality().equals(other.uuid, uuid)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(params) ^
      const DeepCollectionEquality().hash(uuid) ^
      runtimeType.hashCode;
}

extension $GenerationCreateExtension on GenerationCreate {
  GenerationCreate copyWith({GenerationParams? params, dynamic uuid}) {
    return GenerationCreate(
        params: params ?? this.params, uuid: uuid ?? this.uuid);
  }

  GenerationCreate copyWithWrapped(
      {Wrapped<GenerationParams>? params, Wrapped<dynamic>? uuid}) {
    return GenerationCreate(
        params: (params != null ? params.value : this.params),
        uuid: (uuid != null ? uuid.value : this.uuid));
  }
}

@JsonSerializable(explicitToJson: true)
class GenerationParams {
  const GenerationParams({
    required this.prompt,
    this.negativePrompt,
    required this.width,
    required this.height,
    this.outputNumber,
    this.inferenceSteps,
    this.seeds,
  });

  factory GenerationParams.fromJson(Map<String, dynamic> json) =>
      _$GenerationParamsFromJson(json);

  static const toJsonFactory = _$GenerationParamsToJson;
  Map<String, dynamic> toJson() => _$GenerationParamsToJson(this);

  @JsonKey(name: 'prompt')
  final String prompt;
  @JsonKey(name: 'negative_prompt')
  final String? negativePrompt;
  @JsonKey(name: 'width')
  final int width;
  @JsonKey(name: 'height')
  final int height;
  @JsonKey(name: 'output_number')
  final int? outputNumber;
  @JsonKey(name: 'inference_steps')
  final int? inferenceSteps;
  @JsonKey(name: 'seeds')
  final dynamic seeds;
  static const fromJsonFactory = _$GenerationParamsFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is GenerationParams &&
            (identical(other.prompt, prompt) ||
                const DeepCollectionEquality().equals(other.prompt, prompt)) &&
            (identical(other.negativePrompt, negativePrompt) ||
                const DeepCollectionEquality()
                    .equals(other.negativePrompt, negativePrompt)) &&
            (identical(other.width, width) ||
                const DeepCollectionEquality().equals(other.width, width)) &&
            (identical(other.height, height) ||
                const DeepCollectionEquality().equals(other.height, height)) &&
            (identical(other.outputNumber, outputNumber) ||
                const DeepCollectionEquality()
                    .equals(other.outputNumber, outputNumber)) &&
            (identical(other.inferenceSteps, inferenceSteps) ||
                const DeepCollectionEquality()
                    .equals(other.inferenceSteps, inferenceSteps)) &&
            (identical(other.seeds, seeds) ||
                const DeepCollectionEquality().equals(other.seeds, seeds)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(prompt) ^
      const DeepCollectionEquality().hash(negativePrompt) ^
      const DeepCollectionEquality().hash(width) ^
      const DeepCollectionEquality().hash(height) ^
      const DeepCollectionEquality().hash(outputNumber) ^
      const DeepCollectionEquality().hash(inferenceSteps) ^
      const DeepCollectionEquality().hash(seeds) ^
      runtimeType.hashCode;
}

extension $GenerationParamsExtension on GenerationParams {
  GenerationParams copyWith(
      {String? prompt,
      String? negativePrompt,
      int? width,
      int? height,
      int? outputNumber,
      int? inferenceSteps,
      dynamic seeds}) {
    return GenerationParams(
        prompt: prompt ?? this.prompt,
        negativePrompt: negativePrompt ?? this.negativePrompt,
        width: width ?? this.width,
        height: height ?? this.height,
        outputNumber: outputNumber ?? this.outputNumber,
        inferenceSteps: inferenceSteps ?? this.inferenceSteps,
        seeds: seeds ?? this.seeds);
  }

  GenerationParams copyWithWrapped(
      {Wrapped<String>? prompt,
      Wrapped<String?>? negativePrompt,
      Wrapped<int>? width,
      Wrapped<int>? height,
      Wrapped<int?>? outputNumber,
      Wrapped<int?>? inferenceSteps,
      Wrapped<dynamic>? seeds}) {
    return GenerationParams(
        prompt: (prompt != null ? prompt.value : this.prompt),
        negativePrompt: (negativePrompt != null
            ? negativePrompt.value
            : this.negativePrompt),
        width: (width != null ? width.value : this.width),
        height: (height != null ? height.value : this.height),
        outputNumber:
            (outputNumber != null ? outputNumber.value : this.outputNumber),
        inferenceSteps: (inferenceSteps != null
            ? inferenceSteps.value
            : this.inferenceSteps),
        seeds: (seeds != null ? seeds.value : this.seeds));
  }
}

@JsonSerializable(explicitToJson: true)
class GenerationTask {
  const GenerationTask({
    required this.params,
    required this.uuid,
    required this.createTime,
    required this.updateTime,
    required this.status,
    this.elapsedSecs,
    this.percentage,
    required this.imageUuids,
    required this.userId,
  });

  factory GenerationTask.fromJson(Map<String, dynamic> json) =>
      _$GenerationTaskFromJson(json);

  static const toJsonFactory = _$GenerationTaskToJson;
  Map<String, dynamic> toJson() => _$GenerationTaskToJson(this);

  @JsonKey(name: 'params')
  final GenerationParams params;
  @JsonKey(name: 'uuid')
  final String uuid;
  @JsonKey(name: 'create_time')
  final DateTime createTime;
  @JsonKey(name: 'update_time')
  final DateTime updateTime;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'elapsedSecs')
  final dynamic elapsedSecs;
  @JsonKey(name: 'percentage')
  final dynamic percentage;
  @JsonKey(name: 'image_uuids', defaultValue: <String>[])
  final List<String> imageUuids;
  @JsonKey(name: 'user_id')
  final String userId;
  static const fromJsonFactory = _$GenerationTaskFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is GenerationTask &&
            (identical(other.params, params) ||
                const DeepCollectionEquality().equals(other.params, params)) &&
            (identical(other.uuid, uuid) ||
                const DeepCollectionEquality().equals(other.uuid, uuid)) &&
            (identical(other.createTime, createTime) ||
                const DeepCollectionEquality()
                    .equals(other.createTime, createTime)) &&
            (identical(other.updateTime, updateTime) ||
                const DeepCollectionEquality()
                    .equals(other.updateTime, updateTime)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.elapsedSecs, elapsedSecs) ||
                const DeepCollectionEquality()
                    .equals(other.elapsedSecs, elapsedSecs)) &&
            (identical(other.percentage, percentage) ||
                const DeepCollectionEquality()
                    .equals(other.percentage, percentage)) &&
            (identical(other.imageUuids, imageUuids) ||
                const DeepCollectionEquality()
                    .equals(other.imageUuids, imageUuids)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(params) ^
      const DeepCollectionEquality().hash(uuid) ^
      const DeepCollectionEquality().hash(createTime) ^
      const DeepCollectionEquality().hash(updateTime) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(elapsedSecs) ^
      const DeepCollectionEquality().hash(percentage) ^
      const DeepCollectionEquality().hash(imageUuids) ^
      const DeepCollectionEquality().hash(userId) ^
      runtimeType.hashCode;
}

extension $GenerationTaskExtension on GenerationTask {
  GenerationTask copyWith(
      {GenerationParams? params,
      String? uuid,
      DateTime? createTime,
      DateTime? updateTime,
      String? status,
      dynamic elapsedSecs,
      dynamic percentage,
      List<String>? imageUuids,
      String? userId}) {
    return GenerationTask(
        params: params ?? this.params,
        uuid: uuid ?? this.uuid,
        createTime: createTime ?? this.createTime,
        updateTime: updateTime ?? this.updateTime,
        status: status ?? this.status,
        elapsedSecs: elapsedSecs ?? this.elapsedSecs,
        percentage: percentage ?? this.percentage,
        imageUuids: imageUuids ?? this.imageUuids,
        userId: userId ?? this.userId);
  }

  GenerationTask copyWithWrapped(
      {Wrapped<GenerationParams>? params,
      Wrapped<String>? uuid,
      Wrapped<DateTime>? createTime,
      Wrapped<DateTime>? updateTime,
      Wrapped<String>? status,
      Wrapped<dynamic>? elapsedSecs,
      Wrapped<dynamic>? percentage,
      Wrapped<List<String>>? imageUuids,
      Wrapped<String>? userId}) {
    return GenerationTask(
        params: (params != null ? params.value : this.params),
        uuid: (uuid != null ? uuid.value : this.uuid),
        createTime: (createTime != null ? createTime.value : this.createTime),
        updateTime: (updateTime != null ? updateTime.value : this.updateTime),
        status: (status != null ? status.value : this.status),
        elapsedSecs:
            (elapsedSecs != null ? elapsedSecs.value : this.elapsedSecs),
        percentage: (percentage != null ? percentage.value : this.percentage),
        imageUuids: (imageUuids != null ? imageUuids.value : this.imageUuids),
        userId: (userId != null ? userId.value : this.userId));
  }
}

@JsonSerializable(explicitToJson: true)
class GenerationTaskUpdate {
  const GenerationTaskUpdate({
    required this.params,
    required this.uuid,
    required this.createTime,
    required this.updateTime,
    required this.status,
    this.elapsedSecs,
    this.percentage,
    required this.imageUuids,
  });

  factory GenerationTaskUpdate.fromJson(Map<String, dynamic> json) =>
      _$GenerationTaskUpdateFromJson(json);

  static const toJsonFactory = _$GenerationTaskUpdateToJson;
  Map<String, dynamic> toJson() => _$GenerationTaskUpdateToJson(this);

  @JsonKey(name: 'params')
  final GenerationParams params;
  @JsonKey(name: 'uuid')
  final String uuid;
  @JsonKey(name: 'create_time')
  final DateTime createTime;
  @JsonKey(name: 'update_time')
  final DateTime updateTime;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'elapsedSecs')
  final dynamic elapsedSecs;
  @JsonKey(name: 'percentage')
  final dynamic percentage;
  @JsonKey(name: 'image_uuids', defaultValue: <String>[])
  final List<String> imageUuids;
  static const fromJsonFactory = _$GenerationTaskUpdateFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is GenerationTaskUpdate &&
            (identical(other.params, params) ||
                const DeepCollectionEquality().equals(other.params, params)) &&
            (identical(other.uuid, uuid) ||
                const DeepCollectionEquality().equals(other.uuid, uuid)) &&
            (identical(other.createTime, createTime) ||
                const DeepCollectionEquality()
                    .equals(other.createTime, createTime)) &&
            (identical(other.updateTime, updateTime) ||
                const DeepCollectionEquality()
                    .equals(other.updateTime, updateTime)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.elapsedSecs, elapsedSecs) ||
                const DeepCollectionEquality()
                    .equals(other.elapsedSecs, elapsedSecs)) &&
            (identical(other.percentage, percentage) ||
                const DeepCollectionEquality()
                    .equals(other.percentage, percentage)) &&
            (identical(other.imageUuids, imageUuids) ||
                const DeepCollectionEquality()
                    .equals(other.imageUuids, imageUuids)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(params) ^
      const DeepCollectionEquality().hash(uuid) ^
      const DeepCollectionEquality().hash(createTime) ^
      const DeepCollectionEquality().hash(updateTime) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(elapsedSecs) ^
      const DeepCollectionEquality().hash(percentage) ^
      const DeepCollectionEquality().hash(imageUuids) ^
      runtimeType.hashCode;
}

extension $GenerationTaskUpdateExtension on GenerationTaskUpdate {
  GenerationTaskUpdate copyWith(
      {GenerationParams? params,
      String? uuid,
      DateTime? createTime,
      DateTime? updateTime,
      String? status,
      dynamic elapsedSecs,
      dynamic percentage,
      List<String>? imageUuids}) {
    return GenerationTaskUpdate(
        params: params ?? this.params,
        uuid: uuid ?? this.uuid,
        createTime: createTime ?? this.createTime,
        updateTime: updateTime ?? this.updateTime,
        status: status ?? this.status,
        elapsedSecs: elapsedSecs ?? this.elapsedSecs,
        percentage: percentage ?? this.percentage,
        imageUuids: imageUuids ?? this.imageUuids);
  }

  GenerationTaskUpdate copyWithWrapped(
      {Wrapped<GenerationParams>? params,
      Wrapped<String>? uuid,
      Wrapped<DateTime>? createTime,
      Wrapped<DateTime>? updateTime,
      Wrapped<String>? status,
      Wrapped<dynamic>? elapsedSecs,
      Wrapped<dynamic>? percentage,
      Wrapped<List<String>>? imageUuids}) {
    return GenerationTaskUpdate(
        params: (params != null ? params.value : this.params),
        uuid: (uuid != null ? uuid.value : this.uuid),
        createTime: (createTime != null ? createTime.value : this.createTime),
        updateTime: (updateTime != null ? updateTime.value : this.updateTime),
        status: (status != null ? status.value : this.status),
        elapsedSecs:
            (elapsedSecs != null ? elapsedSecs.value : this.elapsedSecs),
        percentage: (percentage != null ? percentage.value : this.percentage),
        imageUuids: (imageUuids != null ? imageUuids.value : this.imageUuids));
  }
}

@JsonSerializable(explicitToJson: true)
class HTTPValidationError {
  const HTTPValidationError({
    this.detail,
  });

  factory HTTPValidationError.fromJson(Map<String, dynamic> json) =>
      _$HTTPValidationErrorFromJson(json);

  static const toJsonFactory = _$HTTPValidationErrorToJson;
  Map<String, dynamic> toJson() => _$HTTPValidationErrorToJson(this);

  @JsonKey(name: 'detail', defaultValue: <ValidationError>[])
  final List<ValidationError>? detail;
  static const fromJsonFactory = _$HTTPValidationErrorFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is HTTPValidationError &&
            (identical(other.detail, detail) ||
                const DeepCollectionEquality().equals(other.detail, detail)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(detail) ^ runtimeType.hashCode;
}

extension $HTTPValidationErrorExtension on HTTPValidationError {
  HTTPValidationError copyWith({List<ValidationError>? detail}) {
    return HTTPValidationError(detail: detail ?? this.detail);
  }

  HTTPValidationError copyWithWrapped(
      {Wrapped<List<ValidationError>?>? detail}) {
    return HTTPValidationError(
        detail: (detail != null ? detail.value : this.detail));
  }
}

@JsonSerializable(explicitToJson: true)
class ImagesData {
  const ImagesData({
    required this.data,
  });

  factory ImagesData.fromJson(Map<String, dynamic> json) =>
      _$ImagesDataFromJson(json);

  static const toJsonFactory = _$ImagesDataToJson;
  Map<String, dynamic> toJson() => _$ImagesDataToJson(this);

  @JsonKey(name: 'data')
  final Map<String, dynamic> data;
  static const fromJsonFactory = _$ImagesDataFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ImagesData &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(data) ^ runtimeType.hashCode;
}

extension $ImagesDataExtension on ImagesData {
  ImagesData copyWith({Map<String, dynamic>? data}) {
    return ImagesData(data: data ?? this.data);
  }

  ImagesData copyWithWrapped({Wrapped<Map<String, dynamic>>? data}) {
    return ImagesData(data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class ImagesURLOrData {
  const ImagesURLOrData({
    required this.urls,
    required this.data,
  });

  factory ImagesURLOrData.fromJson(Map<String, dynamic> json) =>
      _$ImagesURLOrDataFromJson(json);

  static const toJsonFactory = _$ImagesURLOrDataToJson;
  Map<String, dynamic> toJson() => _$ImagesURLOrDataToJson(this);

  @JsonKey(name: 'urls')
  final Map<String, dynamic> urls;
  @JsonKey(name: 'data')
  final Map<String, dynamic> data;
  static const fromJsonFactory = _$ImagesURLOrDataFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ImagesURLOrData &&
            (identical(other.urls, urls) ||
                const DeepCollectionEquality().equals(other.urls, urls)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(urls) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $ImagesURLOrDataExtension on ImagesURLOrData {
  ImagesURLOrData copyWith(
      {Map<String, dynamic>? urls, Map<String, dynamic>? data}) {
    return ImagesURLOrData(urls: urls ?? this.urls, data: data ?? this.data);
  }

  ImagesURLOrData copyWithWrapped(
      {Wrapped<Map<String, dynamic>>? urls,
      Wrapped<Map<String, dynamic>>? data}) {
    return ImagesURLOrData(
        urls: (urls != null ? urls.value : this.urls),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class Layer {
  const Layer({
    required this.uuid,
    required this.name,
    this.x,
    this.y,
    this.width,
    this.height,
    this.rotation,
    this.imageUuid,
    this.generationUuids,
  });

  factory Layer.fromJson(Map<String, dynamic> json) => _$LayerFromJson(json);

  static const toJsonFactory = _$LayerToJson;
  Map<String, dynamic> toJson() => _$LayerToJson(this);

  @JsonKey(name: 'uuid')
  final String uuid;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'x')
  final dynamic x;
  @JsonKey(name: 'y')
  final dynamic y;
  @JsonKey(name: 'width')
  final dynamic width;
  @JsonKey(name: 'height')
  final dynamic height;
  @JsonKey(name: 'rotation')
  final dynamic rotation;
  @JsonKey(name: 'imageUuid')
  final dynamic imageUuid;
  @JsonKey(name: 'generation_uuids', defaultValue: <String>[])
  final List<String>? generationUuids;
  static const fromJsonFactory = _$LayerFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Layer &&
            (identical(other.uuid, uuid) ||
                const DeepCollectionEquality().equals(other.uuid, uuid)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.x, x) ||
                const DeepCollectionEquality().equals(other.x, x)) &&
            (identical(other.y, y) ||
                const DeepCollectionEquality().equals(other.y, y)) &&
            (identical(other.width, width) ||
                const DeepCollectionEquality().equals(other.width, width)) &&
            (identical(other.height, height) ||
                const DeepCollectionEquality().equals(other.height, height)) &&
            (identical(other.rotation, rotation) ||
                const DeepCollectionEquality()
                    .equals(other.rotation, rotation)) &&
            (identical(other.imageUuid, imageUuid) ||
                const DeepCollectionEquality()
                    .equals(other.imageUuid, imageUuid)) &&
            (identical(other.generationUuids, generationUuids) ||
                const DeepCollectionEquality()
                    .equals(other.generationUuids, generationUuids)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(uuid) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(x) ^
      const DeepCollectionEquality().hash(y) ^
      const DeepCollectionEquality().hash(width) ^
      const DeepCollectionEquality().hash(height) ^
      const DeepCollectionEquality().hash(rotation) ^
      const DeepCollectionEquality().hash(imageUuid) ^
      const DeepCollectionEquality().hash(generationUuids) ^
      runtimeType.hashCode;
}

extension $LayerExtension on Layer {
  Layer copyWith(
      {String? uuid,
      String? name,
      dynamic x,
      dynamic y,
      dynamic width,
      dynamic height,
      dynamic rotation,
      dynamic imageUuid,
      List<String>? generationUuids}) {
    return Layer(
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
        x: x ?? this.x,
        y: y ?? this.y,
        width: width ?? this.width,
        height: height ?? this.height,
        rotation: rotation ?? this.rotation,
        imageUuid: imageUuid ?? this.imageUuid,
        generationUuids: generationUuids ?? this.generationUuids);
  }

  Layer copyWithWrapped(
      {Wrapped<String>? uuid,
      Wrapped<String>? name,
      Wrapped<dynamic>? x,
      Wrapped<dynamic>? y,
      Wrapped<dynamic>? width,
      Wrapped<dynamic>? height,
      Wrapped<dynamic>? rotation,
      Wrapped<dynamic>? imageUuid,
      Wrapped<List<String>?>? generationUuids}) {
    return Layer(
        uuid: (uuid != null ? uuid.value : this.uuid),
        name: (name != null ? name.value : this.name),
        x: (x != null ? x.value : this.x),
        y: (y != null ? y.value : this.y),
        width: (width != null ? width.value : this.width),
        height: (height != null ? height.value : this.height),
        rotation: (rotation != null ? rotation.value : this.rotation),
        imageUuid: (imageUuid != null ? imageUuid.value : this.imageUuid),
        generationUuids: (generationUuids != null
            ? generationUuids.value
            : this.generationUuids));
  }
}

@JsonSerializable(explicitToJson: true)
class Project {
  const Project({
    required this.uuid,
    required this.createTime,
    required this.updateTime,
    required this.name,
    required this.data,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  static const toJsonFactory = _$ProjectToJson;
  Map<String, dynamic> toJson() => _$ProjectToJson(this);

  @JsonKey(name: 'uuid')
  final String uuid;
  @JsonKey(name: 'create_time')
  final DateTime createTime;
  @JsonKey(name: 'update_time')
  final DateTime updateTime;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'data')
  final ProjectData data;
  static const fromJsonFactory = _$ProjectFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Project &&
            (identical(other.uuid, uuid) ||
                const DeepCollectionEquality().equals(other.uuid, uuid)) &&
            (identical(other.createTime, createTime) ||
                const DeepCollectionEquality()
                    .equals(other.createTime, createTime)) &&
            (identical(other.updateTime, updateTime) ||
                const DeepCollectionEquality()
                    .equals(other.updateTime, updateTime)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(uuid) ^
      const DeepCollectionEquality().hash(createTime) ^
      const DeepCollectionEquality().hash(updateTime) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $ProjectExtension on Project {
  Project copyWith(
      {String? uuid,
      DateTime? createTime,
      DateTime? updateTime,
      String? name,
      ProjectData? data}) {
    return Project(
        uuid: uuid ?? this.uuid,
        createTime: createTime ?? this.createTime,
        updateTime: updateTime ?? this.updateTime,
        name: name ?? this.name,
        data: data ?? this.data);
  }

  Project copyWithWrapped(
      {Wrapped<String>? uuid,
      Wrapped<DateTime>? createTime,
      Wrapped<DateTime>? updateTime,
      Wrapped<String>? name,
      Wrapped<ProjectData>? data}) {
    return Project(
        uuid: (uuid != null ? uuid.value : this.uuid),
        createTime: (createTime != null ? createTime.value : this.createTime),
        updateTime: (updateTime != null ? updateTime.value : this.updateTime),
        name: (name != null ? name.value : this.name),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class ProjectCreate {
  const ProjectCreate({
    this.uuid,
    required this.name,
    this.data,
  });

  factory ProjectCreate.fromJson(Map<String, dynamic> json) =>
      _$ProjectCreateFromJson(json);

  static const toJsonFactory = _$ProjectCreateToJson;
  Map<String, dynamic> toJson() => _$ProjectCreateToJson(this);

  @JsonKey(name: 'uuid')
  final dynamic uuid;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'data')
  final Object? data;
  static const fromJsonFactory = _$ProjectCreateFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ProjectCreate &&
            (identical(other.uuid, uuid) ||
                const DeepCollectionEquality().equals(other.uuid, uuid)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(uuid) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $ProjectCreateExtension on ProjectCreate {
  ProjectCreate copyWith({dynamic uuid, String? name, Object? data}) {
    return ProjectCreate(
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
        data: data ?? this.data);
  }

  ProjectCreate copyWithWrapped(
      {Wrapped<dynamic>? uuid, Wrapped<String>? name, Wrapped<Object?>? data}) {
    return ProjectCreate(
        uuid: (uuid != null ? uuid.value : this.uuid),
        name: (name != null ? name.value : this.name),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class ProjectData {
  const ProjectData({
    this.layersOrder,
    this.layers,
  });

  factory ProjectData.fromJson(Map<String, dynamic> json) =>
      _$ProjectDataFromJson(json);

  static const toJsonFactory = _$ProjectDataToJson;
  Map<String, dynamic> toJson() => _$ProjectDataToJson(this);

  @JsonKey(name: 'layers_order', defaultValue: <String>[])
  final List<String>? layersOrder;
  @JsonKey(name: 'layers')
  final Map<String, dynamic>? layers;
  static const fromJsonFactory = _$ProjectDataFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ProjectData &&
            (identical(other.layersOrder, layersOrder) ||
                const DeepCollectionEquality()
                    .equals(other.layersOrder, layersOrder)) &&
            (identical(other.layers, layers) ||
                const DeepCollectionEquality().equals(other.layers, layers)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(layersOrder) ^
      const DeepCollectionEquality().hash(layers) ^
      runtimeType.hashCode;
}

extension $ProjectDataExtension on ProjectData {
  ProjectData copyWith(
      {List<String>? layersOrder, Map<String, dynamic>? layers}) {
    return ProjectData(
        layersOrder: layersOrder ?? this.layersOrder,
        layers: layers ?? this.layers);
  }

  ProjectData copyWithWrapped(
      {Wrapped<List<String>?>? layersOrder,
      Wrapped<Map<String, dynamic>?>? layers}) {
    return ProjectData(
        layersOrder:
            (layersOrder != null ? layersOrder.value : this.layersOrder),
        layers: (layers != null ? layers.value : this.layers));
  }
}

@JsonSerializable(explicitToJson: true)
class ProjectUpdate {
  const ProjectUpdate({
    this.name,
    this.data,
  });

  factory ProjectUpdate.fromJson(Map<String, dynamic> json) =>
      _$ProjectUpdateFromJson(json);

  static const toJsonFactory = _$ProjectUpdateToJson;
  Map<String, dynamic> toJson() => _$ProjectUpdateToJson(this);

  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'data')
  final Object? data;
  static const fromJsonFactory = _$ProjectUpdateFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ProjectUpdate &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $ProjectUpdateExtension on ProjectUpdate {
  ProjectUpdate copyWith({String? name, Object? data}) {
    return ProjectUpdate(name: name ?? this.name, data: data ?? this.data);
  }

  ProjectUpdate copyWithWrapped(
      {Wrapped<String?>? name, Wrapped<Object?>? data}) {
    return ProjectUpdate(
        name: (name != null ? name.value : this.name),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class ValidationError {
  const ValidationError({
    required this.loc,
    required this.msg,
    required this.type,
  });

  factory ValidationError.fromJson(Map<String, dynamic> json) =>
      _$ValidationErrorFromJson(json);

  static const toJsonFactory = _$ValidationErrorToJson;
  Map<String, dynamic> toJson() => _$ValidationErrorToJson(this);

  @JsonKey(name: 'loc', defaultValue: <Object>[])
  final List<Object> loc;
  @JsonKey(name: 'msg')
  final String msg;
  @JsonKey(name: 'type')
  final String type;
  static const fromJsonFactory = _$ValidationErrorFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ValidationError &&
            (identical(other.loc, loc) ||
                const DeepCollectionEquality().equals(other.loc, loc)) &&
            (identical(other.msg, msg) ||
                const DeepCollectionEquality().equals(other.msg, msg)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(loc) ^
      const DeepCollectionEquality().hash(msg) ^
      const DeepCollectionEquality().hash(type) ^
      runtimeType.hashCode;
}

extension $ValidationErrorExtension on ValidationError {
  ValidationError copyWith({List<Object>? loc, String? msg, String? type}) {
    return ValidationError(
        loc: loc ?? this.loc, msg: msg ?? this.msg, type: type ?? this.type);
  }

  ValidationError copyWithWrapped(
      {Wrapped<List<Object>>? loc,
      Wrapped<String>? msg,
      Wrapped<String>? type}) {
    return ValidationError(
        loc: (loc != null ? loc.value : this.loc),
        msg: (msg != null ? msg.value : this.msg),
        type: (type != null ? type.value : this.type));
  }
}

@JsonSerializable(explicitToJson: true)
class Worker {
  const Worker({
    required this.uuid,
    required this.createTime,
    required this.updateTime,
    required this.status,
    this.currentJob,
  });

  factory Worker.fromJson(Map<String, dynamic> json) => _$WorkerFromJson(json);

  static const toJsonFactory = _$WorkerToJson;
  Map<String, dynamic> toJson() => _$WorkerToJson(this);

  @JsonKey(name: 'uuid')
  final String uuid;
  @JsonKey(name: 'create_time')
  final DateTime createTime;
  @JsonKey(name: 'update_time')
  final DateTime updateTime;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'currentJob')
  final dynamic currentJob;
  static const fromJsonFactory = _$WorkerFromJson;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Worker &&
            (identical(other.uuid, uuid) ||
                const DeepCollectionEquality().equals(other.uuid, uuid)) &&
            (identical(other.createTime, createTime) ||
                const DeepCollectionEquality()
                    .equals(other.createTime, createTime)) &&
            (identical(other.updateTime, updateTime) ||
                const DeepCollectionEquality()
                    .equals(other.updateTime, updateTime)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.currentJob, currentJob) ||
                const DeepCollectionEquality()
                    .equals(other.currentJob, currentJob)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(uuid) ^
      const DeepCollectionEquality().hash(createTime) ^
      const DeepCollectionEquality().hash(updateTime) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(currentJob) ^
      runtimeType.hashCode;
}

extension $WorkerExtension on Worker {
  Worker copyWith(
      {String? uuid,
      DateTime? createTime,
      DateTime? updateTime,
      String? status,
      dynamic currentJob}) {
    return Worker(
        uuid: uuid ?? this.uuid,
        createTime: createTime ?? this.createTime,
        updateTime: updateTime ?? this.updateTime,
        status: status ?? this.status,
        currentJob: currentJob ?? this.currentJob);
  }

  Worker copyWithWrapped(
      {Wrapped<String>? uuid,
      Wrapped<DateTime>? createTime,
      Wrapped<DateTime>? updateTime,
      Wrapped<String>? status,
      Wrapped<dynamic>? currentJob}) {
    return Worker(
        uuid: (uuid != null ? uuid.value : this.uuid),
        createTime: (createTime != null ? createTime.value : this.createTime),
        updateTime: (updateTime != null ? updateTime.value : this.updateTime),
        status: (status != null ? status.value : this.status),
        currentJob: (currentJob != null ? currentJob.value : this.currentJob));
  }
}

typedef $JsonFactory<T> = T Function(Map<String, dynamic> json);

class $CustomJsonDecoder {
  $CustomJsonDecoder(this.factories);

  final Map<Type, $JsonFactory> factories;

  dynamic decode<T>(dynamic entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity);
    }

    if (entity is T) {
      return entity;
    }

    if (isTypeOf<T, Map>()) {
      return entity;
    }

    if (isTypeOf<T, Iterable>()) {
      return entity;
    }

    if (entity is Map<String, dynamic>) {
      return _decodeMap<T>(entity);
    }

    return entity;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! $JsonFactory<T>) {
      return throw "Could not find factory for type $T. Is '$T: $T.fromJsonFactory' included in the CustomJsonDecoder instance creation in bootstrapper.dart?";
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<T>((v) => decode<T>(v) as T).toList();
}

class $JsonSerializableConverter extends chopper.JsonConverter {
  @override
  FutureOr<chopper.Response<ResultType>> convertResponse<ResultType, Item>(
      chopper.Response response) async {
    if (response.bodyString.isEmpty) {
      // In rare cases, when let's say 204 (no content) is returned -
      // we cannot decode the missing json with the result type specified
      return chopper.Response(response.base, null, error: response.error);
    }

    if (ResultType == String) {
      return response.copyWith();
    }

    if (ResultType == DateTime) {
      return response.copyWith(
          body: DateTime.parse((response.body as String).replaceAll('"', ''))
              as ResultType);
    }

    final jsonRes = await super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
        body: $jsonDecoder.decode<Item>(jsonRes.body) as ResultType);
  }
}

final $jsonDecoder = $CustomJsonDecoder(generatedMapping);

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
