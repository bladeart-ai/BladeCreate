/* eslint-disable @typescript-eslint/no-explicit-any */
import ErrorPage from './pages/error'
import { Auth0ProviderWithNavigate } from './auth0-provoder-with-navigate'
import { Navigate, Outlet, useLocation } from 'react-router-dom'
import { useAuth0 } from '@auth0/auth0-react'
import { LoaderDiv } from '@/components/page-loader'
import { DISABLE_AUTH, DISABLE_GUEST, GUEST_USER, IS_DEV } from '@/config'
import { AuthContext } from '@/context/auth-context'

function ProtectedRoute() {
  const location = useLocation()
  const { isAuthenticated, isLoading, user } = useAuth0()

  if (IS_DEV) {
    console.log('Current auth0 user is', user)
  }

  // Auth is disabled and guest is disabled, do not initialize auth context
  if (DISABLE_AUTH && DISABLE_GUEST)
    throw new Error('Disabling auth & user at the same time is not supported.')

  // When auth is disabled and guest is enabled, always use guest user
  if (DISABLE_AUTH && !DISABLE_GUEST) {
    return (
      <AuthContext.Provider value={{ authed: false, user: GUEST_USER, userUID: GUEST_USER.sub }}>
        <Outlet />
      </AuthContext.Provider>
    )
  }

  // When auth is enabled and is loading
  if (isLoading) {
    return <LoaderDiv />
  }

  // When auth is enabled and guest is enabled, use guest when not authed.
  if (!DISABLE_GUEST && !isAuthenticated) {
    return (
      <AuthContext.Provider value={{ authed: false, user: GUEST_USER, userUID: GUEST_USER.sub }}>
        <Outlet />
      </AuthContext.Provider>
    )
  }

  // When auth is enabled but client is not authed, navigate to login
  if (!isAuthenticated) {
    return <Navigate replace state={{ from: location }} to="/login" />
  }

  if (!user || !user.sub)
    throw new Error('Client is authed but user is empty. This should not happen.')

  return (
    <AuthContext.Provider value={{ authed: true, user: user, userUID: user.sub }}>
      <Outlet />
    </AuthContext.Provider>
  )
}

export const routes = [
  {
    element: <Auth0ProviderWithNavigate />,
    errorElement: <ErrorPage />,
    children: [
      {
        element: <ProtectedRoute />,
        children: [
          {
            index: true,
            lazy: () => import('./pages/projects')
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
]
