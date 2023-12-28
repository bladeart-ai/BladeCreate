import { OpenAPI } from '@/gen_client'

export const DISABLE_AUTH = import.meta.env.VITE_DISABLE_AUTH == 'true'
export const AUTH0_DOMAIN = import.meta.env.VITE_AUTH0_DOMAIN
export const AUTH0_CLIENT = import.meta.env.VITE_AUTH0_CLIENT_ID

export const TEST_USER = {
  sub: 'test_user',
}

const API_SERVICE_URL = import.meta.env.VITE_API_SERVICE_URL

console.info('Running on mode:', import.meta.env.MODE)
if (!API_SERVICE_URL) {
  throw new Error('Empty API Service URL, please check env variables')
}
OpenAPI.BASE = API_SERVICE_URL
