import { Auth0Provider, AppState } from '@auth0/auth0-react'
import { Outlet, useNavigate } from 'react-router-dom'
import { AUTH0_DOMAIN, AUTH0_CLIENT, DISABLE_AUTH } from './config'

export function Auth0ProviderWithNavigate(): JSX.Element | null {
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
      authorizationParams={{
        redirect_uri: window.location.origin + '/callback'
      }}
      cacheLocation="localstorage"
      clientId={clientId}
      domain={domain}
      onRedirectCallback={onRedirectCallback}
      useRefreshTokens
    >
      <Outlet />
    </Auth0Provider>
  )
}
