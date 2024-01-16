import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { RouterProvider, createBrowserRouter, createHashRouter } from 'react-router-dom'
import './tailwind.css'
import './global.css'
import './i18n'
import { routes } from './routes'

import { configure } from 'mobx'
import { ELECTRON } from './config'

configure({
  enforceActions: 'always',
  computedRequiresReaction: true,
  reactionRequiresObservable: true,
  observableRequiresReaction: true,
  disableErrorBoundaries: true
})

let router
if (ELECTRON) {
  router = createHashRouter(routes)
} else {
  router = createBrowserRouter(routes)
}

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <RouterProvider router={router} />
  </StrictMode>
)
