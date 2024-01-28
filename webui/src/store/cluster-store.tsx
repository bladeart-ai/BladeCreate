import { ClusterEvent, Worker, Generation, GenerationTaskUpdate } from '@/gen_client'
import { action, makeAutoObservable } from 'mobx'

import { API_SERVICE_URL } from '@/config'
import { cs } from './project-store'

class ClusterStore {
  wsStatus: string = 'disconnected'
  wsLastEvent: ClusterEvent | null = null
  workersStatus: Worker[] = []
  generations: Generation[] = []

  constructor() {
    makeAutoObservable(this)
    this.startWS()
  }

  get status() {
    if (this.wsStatus === 'disconnected') {
      return 'disconnected'
    } else if (this.wsStatus === 'connected') {
      if (this.workersStatus.length === 0) return 'loading'
      if (this.workersStatus[0].status !== 'initialized') return 'loading'
      if (this.workersStatus[0].current_job) return 'busy'
      return 'idle'
    }
    return 'loading'
  }

  get activeJobs() {
    return this.generations.filter((g) => g.status === 'CREATED' || g.status === 'STARTED')
  }

  updateWorker(data: Worker) {
    const foundIx = this.workersStatus.findIndex((v) => v.uuid === data.uuid)
    if (foundIx !== -1) {
      this.workersStatus[foundIx] = data
    } else {
      this.workersStatus.unshift(data)
    }
  }
  updateGeneration(data: GenerationTaskUpdate) {
    const foundIx = this.generations.findIndex((v) => v.uuid === data.uuid)
    if (foundIx !== -1) {
      this.generations[foundIx] = data
    } else {
      this.generations.unshift(data)
    }

    if (data.status === 'SUCCEEDED') {
      cs.ps.generationSucceeded(data)
    }
  }
  startWS() {
    this.wsStatus = 'connecting'
    const socket = new WebSocket('ws://' + API_SERVICE_URL + '/ws')
    socket.onopen = () => {
      csts.wsStatus = 'connected'
      console.log('Websocket is open')
    }
    socket.onclose = () => {
      csts.wsStatus = 'disconnected'
      setTimeout(
        action(() => csts.startWS()),
        5000
      )
    }
    socket.onmessage = action((evt) => {
      csts.wsStatus = 'connected'
      const data = JSON.parse(evt.data) as ClusterEvent
      console.log('Received ws message', data)
      if (data.screenshot) {
        csts.workersStatus = data.screenshot.workers
        csts.generations = data.screenshot.active_jobs
      } else if (data.worker_update) {
        csts.updateWorker(data.worker_update)
      } else if (data.generation_update) {
        csts.updateGeneration(data.generation_update)
      }
    })
  }
}

export const csts = new ClusterStore()
