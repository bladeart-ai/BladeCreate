/* generated using openapi-typescript-codegen -- do no edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */

import type { ImagesURLOrData } from './ImagesURLOrData'
import type { Layer } from './Layer'

export type Project = {
  uuid: string
  name: string
  create_time: string
  update_time: string
  layers_order?: Array<string>
  layers?: Record<string, Layer>
  images?: ImagesURLOrData | null
}
