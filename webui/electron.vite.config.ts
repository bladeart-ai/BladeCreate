import { resolve } from 'path'
import { defineConfig, externalizeDepsPlugin } from 'electron-vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  main: {
    root: 'main',
    build: {
      lib: {
        entry: 'index.ts'
      }
    },
    plugins: [externalizeDepsPlugin()]
  },
  preload: {
    root: 'preload',
    build: {
      lib: {
        entry: 'index.ts'
      }
    },
    plugins: [externalizeDepsPlugin()]
  },
  renderer: {
    root: '.',
    build: {
      rollupOptions: {
        input: 'index.html'
      }
    },
    envPrefix: 'VITE_',
    resolve: {
      alias: {
        '@': resolve('src')
      }
    },
    plugins: [react()]
  }
})
