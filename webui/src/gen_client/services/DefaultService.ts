/* generated using openapi-typescript-codegen -- do no edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { Generation } from '../models/Generation'
import type { GenerationCreate } from '../models/GenerationCreate'
import type { GenerationDone } from '../models/GenerationDone'
import type { ImagesURLOrData } from '../models/ImagesURLOrData'
import type { Layer } from '../models/Layer'
import type { LayerCreate } from '../models/LayerCreate'
import type { LayerUpdate } from '../models/LayerUpdate'
import type { Project } from '../models/Project'
import type { ProjectCreate } from '../models/ProjectCreate'
import type { ProjectMetadata } from '../models/ProjectMetadata'
import type { ProjectUpdate } from '../models/ProjectUpdate'

import type { CancelablePromise } from '../core/CancelablePromise'
import { OpenAPI } from '../core/OpenAPI'
import { request as __request } from '../core/request'

export class DefaultService {
  /**
   * Get Image Data Or Url
   * @param userId
   * @param projectUuid
   * @param imageUuids
   * @returns ImagesURLOrData Successful Response
   * @throws ApiError
   */
  public static getImageDataOrUrl(
    userId: string,
    projectUuid: string,
    imageUuids?: Array<string>
  ): CancelablePromise<ImagesURLOrData> {
    return __request(OpenAPI, {
      method: 'GET',
      url: '/api/projects/{user_id}/images',
      path: {
        user_id: userId,
      },
      query: {
        project_uuid: projectUuid,
        image_uuids: imageUuids,
      },
      errors: {
        422: `Validation Error`,
      },
    })
  }

  /**
   * Get Projects Metadata
   * @param userId
   * @param uuids
   * @returns ProjectMetadata Successful Response
   * @throws ApiError
   */
  public static getProjectsMetadata(
    userId: string,
    uuids?: Array<string>
  ): CancelablePromise<Array<ProjectMetadata>> {
    return __request(OpenAPI, {
      method: 'GET',
      url: '/api/projects/{user_id}',
      path: {
        user_id: userId,
      },
      query: {
        uuids: uuids,
      },
      errors: {
        422: `Validation Error`,
      },
    })
  }

  /**
   * Create Project
   * @param userId
   * @param requestBody
   * @returns ProjectMetadata Successful Response
   * @throws ApiError
   */
  public static createProject(
    userId: string,
    requestBody: ProjectCreate
  ): CancelablePromise<ProjectMetadata> {
    return __request(OpenAPI, {
      method: 'POST',
      url: '/api/projects/{user_id}',
      path: {
        user_id: userId,
      },
      body: requestBody,
      mediaType: 'application/json',
      errors: {
        422: `Validation Error`,
      },
    })
  }

  /**
   * Update Project
   * @param userId
   * @param projectUuid
   * @param requestBody
   * @returns Project Successful Response
   * @throws ApiError
   */
  public static updateProject(
    userId: string,
    projectUuid: string,
    requestBody: ProjectUpdate
  ): CancelablePromise<Project> {
    return __request(OpenAPI, {
      method: 'PUT',
      url: '/api/projects/{user_id}/{project_uuid}',
      path: {
        user_id: userId,
        project_uuid: projectUuid,
      },
      body: requestBody,
      mediaType: 'application/json',
      errors: {
        422: `Validation Error`,
      },
    })
  }

  /**
   * Get Project
   * @param userId
   * @param projectUuid
   * @returns Project Successful Response
   * @throws ApiError
   */
  public static getProject(
    userId: string,
    projectUuid: string
  ): CancelablePromise<Project> {
    return __request(OpenAPI, {
      method: 'GET',
      url: '/api/projects/{user_id}/{project_uuid}',
      path: {
        user_id: userId,
        project_uuid: projectUuid,
      },
      errors: {
        422: `Validation Error`,
      },
    })
  }

  /**
   * Create Project Layer
   * @param userId
   * @param projectUuid
   * @param requestBody
   * @returns Layer Successful Response
   * @throws ApiError
   */
  public static createProjectLayer(
    userId: string,
    projectUuid: string,
    requestBody: LayerCreate
  ): CancelablePromise<Layer> {
    return __request(OpenAPI, {
      method: 'POST',
      url: '/api/projects/{user_id}/{project_uuid}/layers',
      path: {
        user_id: userId,
        project_uuid: projectUuid,
      },
      body: requestBody,
      mediaType: 'application/json',
      errors: {
        422: `Validation Error`,
      },
    })
  }

  /**
   * Update Project Layer
   * @param userId
   * @param projectUuid
   * @param layerUuid
   * @param requestBody
   * @returns Layer Successful Response
   * @throws ApiError
   */
  public static updateProjectLayer(
    userId: string,
    projectUuid: string,
    layerUuid: string,
    requestBody: LayerUpdate
  ): CancelablePromise<Layer> {
    return __request(OpenAPI, {
      method: 'PUT',
      url: '/api/projects/{user_id}/{project_uuid}/layers/{layer_uuid}',
      path: {
        user_id: userId,
        project_uuid: projectUuid,
        layer_uuid: layerUuid,
      },
      body: requestBody,
      mediaType: 'application/json',
      errors: {
        422: `Validation Error`,
      },
    })
  }

  /**
   * Delete Layer
   * @param userId
   * @param projectUuid
   * @param layerUuid
   * @returns string Successful Response
   * @throws ApiError
   */
  public static deleteLayer(
    userId: string,
    projectUuid: string,
    layerUuid: string
  ): CancelablePromise<string> {
    return __request(OpenAPI, {
      method: 'DELETE',
      url: '/api/projects/{user_id}/{project_uuid}/layers/{layer_uuid}',
      path: {
        user_id: userId,
        project_uuid: projectUuid,
        layer_uuid: layerUuid,
      },
      errors: {
        422: `Validation Error`,
      },
    })
  }

  /**
   * Get Generation
   * @param userId
   * @param projectUuid
   * @param generationUuid
   * @returns Generation Successful Response
   * @throws ApiError
   */
  public static getGeneration(
    userId: string,
    projectUuid: string,
    generationUuid: string
  ): CancelablePromise<Generation> {
    return __request(OpenAPI, {
      method: 'GET',
      url: '/api/projects/{user_id}/{project_uuid}/generations/{generation_uuid}',
      path: {
        user_id: userId,
        project_uuid: projectUuid,
        generation_uuid: generationUuid,
      },
      errors: {
        422: `Validation Error`,
      },
    })
  }

  /**
   * Generate
   * @param userId
   * @param projectUuid
   * @param requestBody
   * @returns GenerationDone Successful Response
   * @throws ApiError
   */
  public static generate(
    userId: string,
    projectUuid: string,
    requestBody: GenerationCreate
  ): CancelablePromise<GenerationDone> {
    return __request(OpenAPI, {
      method: 'POST',
      url: '/api/projects/{user_id}/{project_uuid}/generate',
      path: {
        user_id: userId,
        project_uuid: projectUuid,
      },
      body: requestBody,
      mediaType: 'application/json',
      errors: {
        422: `Validation Error`,
      },
    })
  }

  /**
   * Health Check
   * @returns any Successful Response
   * @throws ApiError
   */
  public static healthCheck(): CancelablePromise<any> {
    return __request(OpenAPI, {
      method: 'GET',
      url: '/health',
    })
  }
}
