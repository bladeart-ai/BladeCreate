import { useAuth0 } from '@auth0/auth0-react'
import React from 'react'
import { NavBar } from '@/components/nav'
import { Layout } from '@/components/layout'

export const CallbackPage: React.FC = () => {
  const { error } = useAuth0()

  if (error) {
    return (
      <Layout>
        <div>
          <h1 id="page-title">Error</h1>
          <div>
            <p id="page-description">
              <span>{error.message}</span>
            </p>
          </div>
        </div>
      </Layout>
    )
  }

  return (
    <NavBar>
      <div />
    </NavBar>
  )
}
