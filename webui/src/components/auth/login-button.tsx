import { useAuth0 } from '@auth0/auth0-react'
import React from 'react'
import { Button } from '../ui/button'

export const LoginButton: React.FC = () => {
  const { loginWithRedirect } = useAuth0()

  const handleLogin = async () => {
    await loginWithRedirect({
      appState: {
        returnTo: '/'
      },
      authorizationParams: {
        prompt: 'login'
      }
    })
  }

  return (
    <Button className="h-12 text-base" onClick={handleLogin}>
      <div className="relative top-[1px]">登陆</div>
    </Button>
  )
}
