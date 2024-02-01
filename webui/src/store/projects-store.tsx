import { action, makeAutoObservable } from 'mobx'
import { User } from '@auth0/auth0-react'
import { v4 as uuidv4 } from 'uuid'
import { DefaultService, Project } from '@/gen_client'

class ProjectsStore {
  fetching: boolean = true
  user: User | null = null
  userID: string = ''
  projects: Project[] = []

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

    DefaultService.getProjects(this.userID).then(
      action((projects) => {
        this.projects = projects
        this.fetching = false
      }),
      action(() => {
        console.error('Cannot fetch, retrying in 5 seconds')
        setTimeout(
          action(() => projectsStore.fetch(user)),
          5000
        )
      })
    )
  }

  createProject(name: string) {
    const newProject = { uuid: uuidv4(), name: name }
    this.projects.unshift({
      ...newProject,

      data: {},
      create_time: '',
      update_time: ''
    })
    DefaultService.createProject(this.userID, newProject).then(
      action((res) => {
        this.projects.map((project) => {
          if (project.uuid == res.uuid) {
            project.create_time = res.create_time
            project.update_time = res.update_time
            return project
          }
          return project
        })
      })
    )
  }
}

export const projectsStore = new ProjectsStore()
