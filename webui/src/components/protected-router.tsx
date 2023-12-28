import { Navigate, Outlet, useLocation } from 'react-router-dom'
import { useAuth0 } from '@auth0/auth0-react'
import { LoaderDiv } from './page-loader'
import { DISABLE_AUTH } from '@/config'
import { AuthContextProvider } from '@/context/auth-context'

export const ProtectedRoute = () => {
  const location = useLocation()
  const { isAuthenticated, isLoading } = useAuth0()

  if (DISABLE_AUTH) {
    return (
      <AuthContextProvider>
        <Outlet />
      </AuthContextProvider>
    )
  }

  if (isLoading) {
    return <LoaderDiv />
  }

  if (!isAuthenticated) {
    return <Navigate to="/login" replace state={{ from: location }} />
  }

  return (
    <AuthContextProvider>
      <Outlet />
    </AuthContextProvider>
  )
}
