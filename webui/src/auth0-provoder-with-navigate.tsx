import { Auth0Provider, AppState } from '@auth0/auth0-react'
import { Outlet, useNavigate } from 'react-router-dom'
import { AUTH0_DOMAIN, AUTH0_CLIENT, DISABLE_AUTH } from './config'

export const Auth0ProviderWithNavigate = (): JSX.Element | null => {
  const navigate = useNavigate()

  if (DISABLE_AUTH) {
    return <Outlet />
  }

  const domain = AUTH0_DOMAIN
  const clientId = AUTH0_CLIENT

  const onRedirectCallback = (appState?: AppState) => {
    navigate(appState?.returnTo || window.location.pathname)
  }

  if (!(domain && clientId)) {
    return null
  }

  return (
    <Auth0Provider
      domain={domain}
      clientId={clientId}
      authorizationParams={{
        redirect_uri: window.location.origin + '/callback',
      }}
      onRedirectCallback={onRedirectCallback}
      useRefreshTokens
      cacheLocation="localstorage"
    >
      <Outlet />
    </Auth0Provider>
  )
}
