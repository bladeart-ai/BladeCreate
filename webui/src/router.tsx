/* eslint-disable @typescript-eslint/no-explicit-any */
import { createBrowserRouter } from 'react-router-dom'
import ErrorPage from './pages/error'
import { AuthenticationPage } from './pages/auth'
import { CallbackPage } from './pages/callback-page'
import { Auth0ProviderWithNavigate } from './auth0-provoder-with-navigate'
import { ProtectedRoute } from './components/protected-router'

export const router = createBrowserRouter([
  {
    element: <Auth0ProviderWithNavigate />,
    errorElement: <ErrorPage />,
    children: [
      { path: '/login', element: <AuthenticationPage /> },
      { path: '/callback', element: <CallbackPage /> },
      {
        element: <ProtectedRoute />,
        children: [
          {
            index: true,
            lazy: () => import('./pages/welcome')
          },
          {
            path: 'models',
            lazy: () => import('./pages/models')
          },
          {
            path: 'models/:modelUID',
            lazy: () => import('./pages/model-detail')
          },
          {
            path: 'models/:modelUID/:versionUID',
            lazy: () => import('./pages/model-detail')
          },
          {
            path: 'projects',
            lazy: () => import('./pages/projects')
          },
          {
            path: 'projects/:projectUUID',
            lazy: () => import('./pages/project')
          }
        ]
      }
    ]
  }
])
