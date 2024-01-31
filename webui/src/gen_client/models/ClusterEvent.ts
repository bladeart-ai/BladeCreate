/* generated using openapi-typescript-codegen -- do no edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */

import type { ClusterSnapshot } from './ClusterSnapshot'
import type { GenerationTaskUpdate } from './GenerationTaskUpdate'
import type { Worker } from './Worker'

export type ClusterEvent = {
  screenshot?: ClusterSnapshot | null
  worker_update?: Worker | null
  generation_update?: GenerationTaskUpdate | null
}
