import { useAuth0 } from '@auth0/auth0-react'
import React from 'react'
import { Button } from '@/components/ui/button'
import { useTranslation } from 'react-i18next'

export const LoginButton: React.FC = () => {
  const { t } = useTranslation()
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
      <div className="relative top-[1px]">{t('Log In')}</div>
    </Button>
  )
}
