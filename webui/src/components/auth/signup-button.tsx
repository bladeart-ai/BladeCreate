import { useAuth0 } from '@auth0/auth0-react'
import React from 'react'
import { Button } from '@/components/ui/button'
import { useTranslation } from 'react-i18next'

export const SignupButton: React.FC = () => {
  const { t } = useTranslation()
  const { loginWithRedirect } = useAuth0()

  const handleSignUp = async () => {
    await loginWithRedirect({
      appState: {
        returnTo: '/'
      },
      authorizationParams: {
        prompt: 'login',
        screen_hint: 'signup'
      }
    })
  }

  return (
    <Button className="h-12 text-base" onClick={handleSignUp} variant="secondary">
      <div className="relative top-[1px]">{t('Sign Up')}</div>
    </Button>
  )
}
