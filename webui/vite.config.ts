import { resolve } from 'path'
import react from '@vitejs/plugin-react-swc'
import { defineConfig } from 'vite'

export default defineConfig({
  root: '.',
  publicDir: 'resources',
  plugins: [react()],
  resolve: {
    alias: {
      '@': resolve('src')
    }
  }
})
