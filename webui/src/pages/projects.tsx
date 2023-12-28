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
      <div className="w-full h-auto justify-start items-start inline-flex">
        <h1 className="w-full self-stretch text-black text-3xl font-extrabold leading-10">
          所有创作
        </h1>
        <div className="w-1/3 h-auto justify-start items-start inline-flex gap-2">
          <Button
            onClick={action(() => {
              projectsStore.createProject()
            })}
          >
            新的创作
          </Button>
        </div>
      </div>

      <div className="w-full h-full justify-start items-start inline-flex flex-wrap gap-3.5">
        {projectsStore.toDisplay.map(p => (
          <Link to={'/projects/' + p.uuid} key={p.uuid}>
            <ProjectCard {...p} />
          </Link>
        ))}
      </div>
    </Layout>
  )
})

export const Component = ProjectsPage
