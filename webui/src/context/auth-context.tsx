import { DISABLE_AUTH, TEST_USER } from '@/config'
import { User, useAuth0 } from '@auth0/auth0-react'
import { createContext } from 'react'

export interface AuthContextType {
  user: User
  userUID: string
}

export const AuthContext = createContext<AuthContextType | null>(null)

export function AuthContextProvider({
  children,
}: {
  children: React.ReactNode
}) {
  let { user } = useAuth0()

  if (DISABLE_AUTH) {
    user = TEST_USER
  }

  if (!user || !user.sub)
    throw new Error(
      "You are already auth-ed but user is not retrievable. (This shouldn't happen.)"
    )

  const ctx: AuthContextType = {
    user: user,
    userUID: user.sub,
  }

  return <AuthContext.Provider value={ctx}>{children}</AuthContext.Provider>
}
