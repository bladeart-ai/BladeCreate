import { ProjectMetadata, DefaultService } from '@/gen_client'
import { action, makeAutoObservable } from 'mobx'
import { User } from '@auth0/auth0-react'
import { v4 as uuidv4 } from 'uuid'

class ProjectsStore {
  fetching: boolean = true
  user: User | null = null
  userID: string = ''
  projects: ProjectMetadata[] = []

  constructor() {
    makeAutoObservable(this)
  }

  get toDisplay() {
    return this.projects.slice().sort((p1, p2) => {
      if (p1.update_time > p2.update_time) return -1
      if (p1.update_time < p2.update_time) return 1
      return 0
    })
  }

  fetch(user: User) {
    this.fetching = true
    this.userID = user.sub || ''

    DefaultService.getProjectsMetadata(this.userID).then(
      action('fetchProjectsSuccess', projects => {
        this.projects = projects
        this.fetching = false
      }),
      action('fetchProjectsError', error => {
        console.error('fetchProjectsError', error)
      })
    )
  }

  createProject() {
    const newProject = { uuid: uuidv4(), name: 'New Project' }
    this.projects.unshift({
      ...newProject,

      create_time: '',
      update_time: '',
    })
    DefaultService.createProject(this.userID, newProject).then(
      action('createProjectSuccess', res => {
        this.projects.map(project => {
          if (project.uuid == res.uuid) {
            project.create_time = res.create_time
            project.update_time = res.update_time
            return project
          }
          return project
        })
      }),
      action('createProjectError', error => {
        console.error('createProjectError', error)
      })
    )
  }
}

export const projectsStore = new ProjectsStore()
