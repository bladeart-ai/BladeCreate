// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openapi.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClusterEvent _$ClusterEventFromJson(Map<String, dynamic> json) => ClusterEvent(
      screenshot: json['screenshot'],
      workerUpdate: json['workerUpdate'],
      generationUpdate: json['generationUpdate'],
    );

Map<String, dynamic> _$ClusterEventToJson(ClusterEvent instance) =>
    <String, dynamic>{
      'screenshot': instance.screenshot,
      'workerUpdate': instance.workerUpdate,
      'generationUpdate': instance.generationUpdate,
    };

ClusterSnapshot _$ClusterSnapshotFromJson(Map<String, dynamic> json) =>
    ClusterSnapshot(
      workers: (json['workers'] as List<dynamic>?)
              ?.map((e) => Worker.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      activeJobs: (json['active_jobs'] as List<dynamic>?)
              ?.map((e) => Generation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ClusterSnapshotToJson(ClusterSnapshot instance) =>
    <String, dynamic>{
      'workers': instance.workers.map((e) => e.toJson()).toList(),
      'active_jobs': instance.activeJobs.map((e) => e.toJson()).toList(),
    };

Generation _$GenerationFromJson(Map<String, dynamic> json) => Generation(
      params: GenerationParams.fromJson(json['params'] as Map<String, dynamic>),
      uuid: json['uuid'] as String,
      createTime: DateTime.parse(json['create_time'] as String),
      updateTime: DateTime.parse(json['update_time'] as String),
      status: json['status'] as String,
      elapsedSecs: json['elapsedSecs'],
      percentage: json['percentage'],
      imageUuids: (json['image_uuids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$GenerationToJson(Generation instance) =>
    <String, dynamic>{
      'params': instance.params.toJson(),
      'uuid': instance.uuid,
      'create_time': instance.createTime.toIso8601String(),
      'update_time': instance.updateTime.toIso8601String(),
      'status': instance.status,
      'elapsedSecs': instance.elapsedSecs,
      'percentage': instance.percentage,
      'image_uuids': instance.imageUuids,
    };

GenerationCreate _$GenerationCreateFromJson(Map<String, dynamic> json) =>
    GenerationCreate(
      params: GenerationParams.fromJson(json['params'] as Map<String, dynamic>),
      uuid: json['uuid'],
    );

Map<String, dynamic> _$GenerationCreateToJson(GenerationCreate instance) =>
    <String, dynamic>{
      'params': instance.params.toJson(),
      'uuid': instance.uuid,
    };

GenerationParams _$GenerationParamsFromJson(Map<String, dynamic> json) =>
    GenerationParams(
      prompt: json['prompt'] as String,
      negativePrompt: json['negative_prompt'] as String?,
      width: json['width'] as int,
      height: json['height'] as int,
      outputNumber: json['output_number'] as int?,
      inferenceSteps: json['inference_steps'] as int?,
      seeds: json['seeds'],
    );

Map<String, dynamic> _$GenerationParamsToJson(GenerationParams instance) =>
    <String, dynamic>{
      'prompt': instance.prompt,
      'negative_prompt': instance.negativePrompt,
      'width': instance.width,
      'height': instance.height,
      'output_number': instance.outputNumber,
      'inference_steps': instance.inferenceSteps,
      'seeds': instance.seeds,
    };

GenerationTask _$GenerationTaskFromJson(Map<String, dynamic> json) =>
    GenerationTask(
      params: GenerationParams.fromJson(json['params'] as Map<String, dynamic>),
      uuid: json['uuid'] as String,
      createTime: DateTime.parse(json['create_time'] as String),
      updateTime: DateTime.parse(json['update_time'] as String),
      status: json['status'] as String,
      elapsedSecs: json['elapsedSecs'],
      percentage: json['percentage'],
      imageUuids: (json['image_uuids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$GenerationTaskToJson(GenerationTask instance) =>
    <String, dynamic>{
      'params': instance.params.toJson(),
      'uuid': instance.uuid,
      'create_time': instance.createTime.toIso8601String(),
      'update_time': instance.updateTime.toIso8601String(),
      'status': instance.status,
      'elapsedSecs': instance.elapsedSecs,
      'percentage': instance.percentage,
      'image_uuids': instance.imageUuids,
      'user_id': instance.userId,
    };

GenerationTaskUpdate _$GenerationTaskUpdateFromJson(
        Map<String, dynamic> json) =>
    GenerationTaskUpdate(
      params: GenerationParams.fromJson(json['params'] as Map<String, dynamic>),
      uuid: json['uuid'] as String,
      createTime: DateTime.parse(json['create_time'] as String),
      updateTime: DateTime.parse(json['update_time'] as String),
      status: json['status'] as String,
      elapsedSecs: json['elapsedSecs'],
      percentage: json['percentage'],
      imageUuids: (json['image_uuids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$GenerationTaskUpdateToJson(
        GenerationTaskUpdate instance) =>
    <String, dynamic>{
      'params': instance.params.toJson(),
      'uuid': instance.uuid,
      'create_time': instance.createTime.toIso8601String(),
      'update_time': instance.updateTime.toIso8601String(),
      'status': instance.status,
      'elapsedSecs': instance.elapsedSecs,
      'percentage': instance.percentage,
      'image_uuids': instance.imageUuids,
    };

HTTPValidationError _$HTTPValidationErrorFromJson(Map<String, dynamic> json) =>
    HTTPValidationError(
      detail: (json['detail'] as List<dynamic>?)
              ?.map((e) => ValidationError.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$HTTPValidationErrorToJson(
        HTTPValidationError instance) =>
    <String, dynamic>{
      'detail': instance.detail?.map((e) => e.toJson()).toList(),
    };

ImagesData _$ImagesDataFromJson(Map<String, dynamic> json) => ImagesData(
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$ImagesDataToJson(ImagesData instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

ImagesURLOrData _$ImagesURLOrDataFromJson(Map<String, dynamic> json) =>
    ImagesURLOrData(
      urls: json['urls'] as Map<String, dynamic>,
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$ImagesURLOrDataToJson(ImagesURLOrData instance) =>
    <String, dynamic>{
      'urls': instance.urls,
      'data': instance.data,
    };

Layer _$LayerFromJson(Map<String, dynamic> json) => Layer(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      x: json['x'],
      y: json['y'],
      width: json['width'],
      height: json['height'],
      rotation: json['rotation'],
      imageUuid: json['imageUuid'],
      generationUuids: (json['generation_uuids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$LayerToJson(Layer instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'x': instance.x,
      'y': instance.y,
      'width': instance.width,
      'height': instance.height,
      'rotation': instance.rotation,
      'imageUuid': instance.imageUuid,
      'generation_uuids': instance.generationUuids,
    };

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      uuid: json['uuid'] as String,
      createTime: DateTime.parse(json['create_time'] as String),
      updateTime: DateTime.parse(json['update_time'] as String),
      name: json['name'] as String,
      data: ProjectData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'create_time': instance.createTime.toIso8601String(),
      'update_time': instance.updateTime.toIso8601String(),
      'name': instance.name,
      'data': instance.data.toJson(),
    };

ProjectCreate _$ProjectCreateFromJson(Map<String, dynamic> json) =>
    ProjectCreate(
      uuid: json['uuid'],
      name: json['name'] as String,
      data: json['data'],
    );

Map<String, dynamic> _$ProjectCreateToJson(ProjectCreate instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'data': instance.data,
    };

ProjectData _$ProjectDataFromJson(Map<String, dynamic> json) => ProjectData(
      layersOrder: (json['layers_order'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      layers: json['layers'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ProjectDataToJson(ProjectData instance) =>
    <String, dynamic>{
      'layers_order': instance.layersOrder,
      'layers': instance.layers,
    };

ProjectUpdate _$ProjectUpdateFromJson(Map<String, dynamic> json) =>
    ProjectUpdate(
      name: json['name'],
      data: json['data'],
    );

Map<String, dynamic> _$ProjectUpdateToJson(ProjectUpdate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'data': instance.data,
    };

ValidationError _$ValidationErrorFromJson(Map<String, dynamic> json) =>
    ValidationError(
      loc: (json['loc'] as List<dynamic>?)?.map((e) => e as Object).toList() ??
          [],
      msg: json['msg'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$ValidationErrorToJson(ValidationError instance) =>
    <String, dynamic>{
      'loc': instance.loc,
      'msg': instance.msg,
      'type': instance.type,
    };

Worker _$WorkerFromJson(Map<String, dynamic> json) => Worker(
      uuid: json['uuid'] as String,
      createTime: DateTime.parse(json['create_time'] as String),
      updateTime: DateTime.parse(json['update_time'] as String),
      status: json['status'] as String,
      currentJob: json['currentJob'],
    );

Map<String, dynamic> _$WorkerToJson(Worker instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'create_time': instance.createTime.toIso8601String(),
      'update_time': instance.updateTime.toIso8601String(),
      'status': instance.status,
      'currentJob': instance.currentJob,
    };
