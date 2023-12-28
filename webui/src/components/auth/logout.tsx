import { useAuth0 } from '@auth0/auth0-react'
import { ExitIcon } from '@radix-ui/react-icons'
import React from 'react'
import { Button } from '../ui/button'

export const LogoutButton: React.FC = () => {
  const { logout, isAuthenticated } = useAuth0()

  if (!isAuthenticated) {
    return null
  }

  const handleLogout = () => {
    logout({
      logoutParams: {
        returnTo: window.location.origin,
      },
    })
  }

  return (
    <Button variant="link" size="icon" onClick={handleLogout}>
      <ExitIcon className="h-4 w-4" />
    </Button>
  )
}