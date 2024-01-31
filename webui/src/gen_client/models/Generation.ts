/* generated using openapi-typescript-codegen -- do no edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */

import type { GenerationParams } from './GenerationParams'

export type Generation = {
  params: GenerationParams
  uuid: string
  create_time: string
  update_time: string
  status: string
  elapsed_secs?: number | null
  percentage?: number | null
  image_uuids: Array<string>
}
