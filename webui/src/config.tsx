import { OpenAPI } from '@/gen_client'

export const MODE = import.meta.env.MODE
export const IS_DEV = MODE === 'development'
export const DISABLE_AUTH = import.meta.env.VITE_DISABLE_AUTH === 'true'
export const DISABLE_GUEST = import.meta.env.VITE_GUEST_DISABLED === 'true'
export const AUTH0_DOMAIN = import.meta.env.VITE_AUTH0_DOMAIN
export const AUTH0_CLIENT = import.meta.env.VITE_AUTH0_CLIENT_ID
export const GUEST_USER = {
  sub: 'guest',
  name: 'Guest'
}

function isElectron() {
  // https://ourcodeworld.com/articles/read/525/how-to-check-if-your-code-is-being-executed-in-electron-or-in-the-browser
  // Renderer process
  if (
    typeof window !== 'undefined' &&
    typeof window.process === 'object' &&
    window.process.type === 'renderer'
  ) {
    return true
  }

  // Main process
  if (
    typeof process !== 'undefined' &&
    typeof process.versions === 'object' &&
    !!process.versions.electron
  ) {
    return true
  }

  // Detect the user agent when the `nodeIntegration` option is set to true
  if (
    typeof navigator === 'object' &&
    typeof navigator.userAgent === 'string' &&
    navigator.userAgent.indexOf('Electron') >= 0
  ) {
    return true
  }

  return false
}
export const ELECTRON = isElectron()

console.info('Running environments:', {
  MODE: MODE,
  ELECTRON: ELECTRON,
  DISABLE_AUTH: DISABLE_AUTH,
  DISABLE_GUEST: DISABLE_GUEST
})

const API_SERVICE_URL = import.meta.env.VITE_API_SERVICE_URL
if (!API_SERVICE_URL) {
  throw new Error('Empty API Service URL, please check env variables')
}
OpenAPI.BASE = API_SERVICE_URL
