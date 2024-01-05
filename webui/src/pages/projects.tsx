import { Button } from '@/components/ui/button'
import { Link } from 'react-router-dom'
import { ProjectCard } from '@/components/project-card'
import { Layout } from '@/components/layout'
import { useContext, useEffect } from 'react'
import { LoaderDiv } from '@/components/page-loader'
import { AuthContext, AuthContextType } from '@/context/auth-context'
import { projectsStore } from '@/store/projects-store'
import { observer } from 'mobx-react-lite'
import { action } from 'mobx'

export const ProjectsPage = observer(() => {
  const authCtx = useContext(AuthContext) as AuthContextType

  useEffect(() => {
    projectsStore.fetch(authCtx.user)
  }, [authCtx.user])

  if (projectsStore.fetching) {
    return <LoaderDiv />
  }

  return (
    <Layout>
      <div className="inline-flex h-auto w-full items-start justify-start">
        <h1 className="w-full self-stretch text-3xl font-extrabold leading-10 text-black">
          所有创作
        </h1>
        <div className="inline-flex h-auto w-1/3 items-start justify-start gap-2">
          <Button
            onClick={action(() => {
              projectsStore.createProject()
            })}
          >
            新的创作
          </Button>
        </div>
      </div>

      <div className="inline-flex h-full w-full flex-wrap items-start justify-start gap-3.5">
        {projectsStore.toDisplay.map((p) => (
          <Link key={p.uuid} to={'/projects/' + p.uuid}>
            <ProjectCard {...p} />
          </Link>
        ))}
      </div>
    </Layout>
  )
})

export const Component = ProjectsPage
