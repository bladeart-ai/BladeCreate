import { User } from '@auth0/auth0-react'
import { createContext } from 'react'

export interface AuthContextType {
  authed: boolean
  user: User
  userUID: string
}

export const AuthContext = createContext<AuthContextType | null>(null)
