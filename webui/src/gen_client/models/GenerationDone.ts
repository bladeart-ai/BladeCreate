/* generated using openapi-typescript-codegen -- do no edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */

import type { GenerationParams } from './GenerationParams'
import type { ImagesURLOrData } from './ImagesURLOrData'

export type GenerationDone = {
  params: GenerationParams
  uuid: string
  create_time: string
  update_time: string
  status: string
  image_uuids: Array<string>
  images?: ImagesURLOrData | null
}
