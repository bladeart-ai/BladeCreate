/* generated using openapi-typescript-codegen -- do no edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { Generation } from '../models/Generation'
import type { GenerationCreate } from '../models/GenerationCreate'
import type { ImagesData } from '../models/ImagesData'
import type { ImagesURLOrData } from '../models/ImagesURLOrData'
import type { Project } from '../models/Project'
import type { ProjectCreate } from '../models/ProjectCreate'
import type { ProjectUpdate } from '../models/ProjectUpdate'

import type { CancelablePromise } from '../core/CancelablePromise'
import { OpenAPI } from '../core/OpenAPI'
import { request as __request } from '../core/request'

export class DefaultService {
  /**
   * Get Image Data Or Url
   * @param userId
   * @param imageUuids
   * @returns ImagesURLOrData Successful Response
   * @throws ApiError
   */
  public static getImageDataOrUrl(
    userId: string,
    imageUuids?: Array<string>
  ): CancelablePromise<ImagesURLOrData> {
    return __request(OpenAPI, {
      method: 'GET',
      url: '/api/images/{user_id}',
      path: {
        user_id: userId
      },
      query: {
        image_uuids: imageUuids
      },
      errors: {
        422: `Validation Error`
      }
    })
  }

  /**
   * Upload Images
   * @param userId
   * @param requestBody
   * @returns any Successful Response
   * @throws ApiError
   */
  public static uploadImages(userId: string, requestBody: ImagesData): CancelablePromise<any> {
    return __request(OpenAPI, {
      method: 'POST',
      url: '/api/images/{user_id}',
      path: {
        user_id: userId
      },
      body: requestBody,
      mediaType: 'application/json',
      errors: {
        422: `Validation Error`
      }
    })
  }

  /**
   * Get Projects
   * @param userId
   * @param uuids
   * @returns Project Successful Response
   * @throws ApiError
   */
  public static getProjects(
    userId: string,
    uuids?: Array<string>
  ): CancelablePromise<Array<Project>> {
    return __request(OpenAPI, {
      method: 'GET',
      url: '/api/projects/{user_id}',
      path: {
        user_id: userId
      },
      query: {
        uuids: uuids
      },
      errors: {
        422: `Validation Error`
      }
    })
  }

  /**
   * Create Project
   * @param userId
   * @param requestBody
   * @returns Project Successful Response
   * @throws ApiError
   */
  public static createProject(
    userId: string,
    requestBody: ProjectCreate
  ): CancelablePromise<Project> {
    return __request(OpenAPI, {
      method: 'POST',
      url: '/api/projects/{user_id}',
      path: {
        user_id: userId
      },
      body: requestBody,
      mediaType: 'application/json',
      errors: {
        422: `Validation Error`
      }
    })
  }

  /**
   * Get Project
   * @param userId
   * @param projectUuid
   * @returns Project Successful Response
   * @throws ApiError
   */
  public static getProject(userId: string, projectUuid: string): CancelablePromise<Project> {
    return __request(OpenAPI, {
      method: 'GET',
      url: '/api/projects/{user_id}/{project_uuid}',
      path: {
        user_id: userId,
        project_uuid: projectUuid
      },
      errors: {
        422: `Validation Error`
      }
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
        project_uuid: projectUuid
      },
      body: requestBody,
      mediaType: 'application/json',
      errors: {
        422: `Validation Error`
      }
    })
  }

  /**
   * Get Generations
   * @param userId
   * @param generationUuids
   * @returns Generation Successful Response
   * @throws ApiError
   */
  public static getGenerations(
    userId: string,
    generationUuids?: Array<string>
  ): CancelablePromise<Array<Generation>> {
    return __request(OpenAPI, {
      method: 'GET',
      url: '/api/generations/{user_id}/{generation_uuid}',
      path: {
        user_id: userId
      },
      query: {
        generation_uuids: generationUuids
      },
      errors: {
        422: `Validation Error`
      }
    })
  }

  /**
   * Create Generation
   * @param userId
   * @param requestBody
   * @returns Generation Successful Response
   * @throws ApiError
   */
  public static createGeneration(
    userId: string,
    requestBody: GenerationCreate
  ): CancelablePromise<Generation> {
    return __request(OpenAPI, {
      method: 'POST',
      url: '/api/generations/{user_id}',
      path: {
        user_id: userId
      },
      body: requestBody,
      mediaType: 'application/json',
      errors: {
        422: `Validation Error`
      }
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
      url: '/health'
    })
  }
}
