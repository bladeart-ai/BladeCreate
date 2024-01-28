/* generated using openapi-typescript-codegen -- do no edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */

import type { Generation } from './Generation'
import type { Worker } from './Worker'

export type ClusterSnapshot = {
  workers: Array<Worker>
  active_jobs: Array<Generation>
}
