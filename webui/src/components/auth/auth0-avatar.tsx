import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { AuthContext, AuthContextType } from '@/context/auth-context'
import React, { useContext } from 'react'

export const Auth0Avatar: React.FC = () => {
  const authCtx = useContext(AuthContext) as AuthContextType

  return (
    <Avatar>
      <AvatarImage src={authCtx.user.picture} />
      <AvatarFallback>{authCtx.user.name}</AvatarFallback>
    </Avatar>
  )
}
