import { createRef } from 'react'
import Konva from 'konva'
import { action, makeAutoObservable } from 'mobx'
import { User } from '@auth0/auth0-react'
import { v4 as uuidv4 } from 'uuid'
import {
  DefaultService,
  Generation,
  GenerationParams,
  Layer,
  Project,
  ProjectData
} from '@/gen_client'

interface CanvasProps {
  width: number
  height: number
  xPadding: number
  yPadding: number
  scaleStep: number
  maxScale: number
  minScale: number
}

interface StageProps {
  width: number
  height: number
  workAreaWidth: number
  workAreaHeight: number
  workAreaX: number
  workAreaY: number
  scaleStep: number
  maxScale: number
  minScale: number
}

class ProjectStore {
  fetching: boolean = true
  fetchingGenerations: boolean = false
  fetchingImages: boolean = false
  userLock: boolean = false

  user: User | null = null
  userID: string = ''
  projectUUID: string = ''

  project: Project | null = null
  layersOrder: Array<string> = []
  layers: Record<string, Layer> = {}
  generations: Record<string, Generation> = {}
  imageData: Record<string, string> = {}

  constructor() {
    makeAutoObservable(this)
  }

  get toLayersDisplay() {
    return this.layersOrder.map((layerUUID) => this.layers[layerUUID])
  }

  get toLayersDisplayReversed() {
    return this.layersOrder
      .map((_, index, array) => array[array.length - 1 - index])
      .map((layerUUID) => this.layers[layerUUID])
  }

  get loading() {
    return this.fetching
  }

  lockUI() {
    this.userLock = true
  }
  unlockUI() {
    this.userLock = false
  }

  generationSucceeded(g: Generation) {
    this.generations[g.uuid] = g

    // Select image if the layer has not selected any image
    const layer = Object.values(this.layers).find(
      (l) => !l.image_uuid && l.generation_uuids && l.generation_uuids?.includes(g.uuid)
    )
    if (layer) {
      layer.image_uuid = g.image_uuids[0]
    }
    this.sendUpdateProject()
    this.fetchImages(g.image_uuids)
  }

  fetchGenerations(generationUUIDs: string[]) {
    if (generationUUIDs.length === 0) return
    this.fetchingGenerations = true
    return DefaultService.getGenerations(this.userID, generationUUIDs, false)
      .then(
        action((res) => {
          res.forEach((g) => (this.generations[g.uuid] = g))
        })
      )
      .then(
        action(() => {
          this.fetchingGenerations = false
        })
      )
  }

  fetchImages(imageUUIDs: string[]) {
    if (imageUUIDs.length === 0) return
    this.fetchingImages = true
    return DefaultService.getImageDataOrUrl(this.userID, imageUUIDs)
      .then(
        action((res) => {
          this.imageData = { ...this.imageData, ...res.data }
          return res.urls
        })
      )
      .then(
        action((urls) => {
          Promise.allSettled(
            Object.keys(urls).map((image_uuid) => {
              const url = urls[image_uuid] || ''
              return fetch(url)
                .then((val) => val.text())
                .then(
                  action((val) => {
                    this.imageData[image_uuid] = val
                  })
                )
            })
          )
        })
      )
      .then(
        action(() => {
          this.fetchingImages = false
        })
      )
  }

  fetch(user: User, projectUUID: string) {
    this.fetching = true
    this.userID = user.sub || ''
    this.projectUUID = projectUUID

    return DefaultService.getProject(this.userID, projectUUID)
      .then(
        action((project) => {
          document.title = project.name
          this.project = project
          this.layersOrder = project.data.layers_order || []
          this.layers = project.data.layers || {}
        })
      )
      .then(
        action(() => {
          const generationUUIDs = Object.values(this.layers).flatMap((layer) =>
            Object.values(layer.generation_uuids || [])
          )
          return this.fetchGenerations(generationUUIDs)
        })
      )
      .then(
        action(() => {
          const imageUUIDs = Object.values(this.layers).flatMap((layer) => {
            const layerImageUUIDs = Object.values(this.generations).flatMap((g) => g.image_uuids)
            if (layer.image_uuid) {
              layerImageUUIDs.unshift(layer.image_uuid)
            }
            return layerImageUUIDs
          })
          return this.fetchImages(imageUUIDs)
        })
      )
      .then(
        action(() => {
          this.fetching = false
        })
      )
  }

  sendUploadImages(imageUUID: string, imageData: string) {
    const data = {}
    data[imageUUID] = imageData
    return DefaultService.uploadImages(this.userID, { data: data })
  }

  sendUpdateProject() {
    return DefaultService.updateProject(this.userID, this.projectUUID, {
      data: {
        layers_order: this.layersOrder,
        layers: this.layers
      } as ProjectData
    }).catch(
      action(() => {
        // TODO: handle error
        this.lockUI()
      })
    )
  }

  createLayer(
    layerUUID: string | undefined = undefined,
    name: string = '',
    imageData: string | undefined = undefined
  ) {
    this.lockUI()
    if (!layerUUID) layerUUID = uuidv4()
    const newLayer = {
      uuid: layerUUID,
      name: name,
      x: cs.props.xPadding,
      y: cs.props.yPadding,
      rotation: 0,
      image_uuid: layerUUID,
      image_data: imageData
    } as Layer
    this.layersOrder.unshift(newLayer.uuid)
    this.layers[newLayer.uuid] = newLayer

    return this.sendUpdateProject()
      .then(
        action(() => {
          if (imageData) {
            this.imageData[newLayer.uuid] = imageData
            this.sendUploadImages(newLayer.uuid, imageData)
          }
        })
      )
      .finally(action(() => this.unlockUI()))
  }

  updateLayerImageUUID(layerUUID: string, imageUUID: string | null) {
    this.lockUI()
    this.layers[layerUUID].image_uuid = imageUUID
    this.sendUpdateProject().finally(action(() => this.unlockUI()))
  }

  transformLayers(
    transformProps: {
      layerUUID: string
      x: number | null
      y: number | null
      width: number | null
      height: number | null
      rotation: number | null
    }[]
  ) {
    this.lockUI()

    transformProps.map((l) => {
      const newLayer = { ...this.layers[l.layerUUID] }
      if (l.x) newLayer.x = l.x
      if (l.y) newLayer.y = l.y
      if (l.width) newLayer.width = l.width
      if (l.height) newLayer.height = l.height
      if (l.rotation) newLayer.rotation = l.rotation
      if (this.layers[l.layerUUID] === newLayer) {
        return
      }
      this.layers[l.layerUUID] = newLayer
    })

    return this.sendUpdateProject().finally(action(() => this.unlockUI()))
  }

  moveLayer(startIndex: number, endIndex: number) {
    if (startIndex === endIndex) {
      return
    }

    this.lockUI()

    const newLayerOrder = this.layersOrder.slice()
    const [removed] = newLayerOrder.splice(startIndex, 1)
    newLayerOrder.splice(endIndex, 0, removed)
    this.layersOrder = newLayerOrder

    this.sendUpdateProject().finally(action(() => this.unlockUI()))
  }

  deleteLayer(layerUUID: string) {
    const found = this.layersOrder.findIndex((uuid) => uuid == layerUUID)
    if (found == -1) return

    this.lockUI()

    this.layersOrder.splice(found, 1)
    delete this.layers[layerUUID]
    cs.setSelectedIDs(cs.selectedIDs.filter((uuid) => uuid !== layerUUID))

    this.sendUpdateProject().finally(action(() => this.unlockUI()))
  }

  generate(outputLayerUUID: string | undefined, params: GenerationParams) {
    this.lockUI()

    DefaultService.createGeneration(this.userID, { params: params })
      .then(
        action((g) => {
          this.generations[g.uuid] = g
          if (outputLayerUUID) {
            if (!this.layers[outputLayerUUID].generation_uuids) {
              this.layers[outputLayerUUID].generation_uuids = [g.uuid]
            } else {
              this.layers[outputLayerUUID].generation_uuids?.unshift(g.uuid)
            }
            this.layers[outputLayerUUID].image_uuid = null
            if (!this.layers[outputLayerUUID].width)
              this.layers[outputLayerUUID].width = params.width
            if (!this.layers[outputLayerUUID].height)
              this.layers[outputLayerUUID].height = params.height
          } else {
            outputLayerUUID = uuidv4()
            const newLayer = {
              uuid: outputLayerUUID,
              name: 'New Layer for Generation',
              x: cs.props.xPadding,
              y: cs.props.yPadding,
              width: params.width,
              height: params.height,
              generation_uuids: [g.uuid]
            } as Layer
            this.layersOrder.unshift(newLayer.uuid)
            this.layers[newLayer.uuid] = newLayer
          }

          return this.sendUpdateProject()
        })
      )
      .finally(action(() => this.unlockUI()))
  }
}

class CanvasStore {
  props: CanvasProps
  ref: React.RefObject<Konva.Layer>
  trRef: React.RefObject<Konva.Transformer>
  scale: number
  selectedIDs: string[]

  sidePanelSwitch: string

  ps: ProjectStore

  constructor() {
    makeAutoObservable(this)
    this.props = {
      width: 900,
      height: 1200,
      xPadding: 200,
      yPadding: 200,
      scaleStep: 1.04,
      maxScale: 2,
      minScale: 0.5
    }
    this.ref = createRef<Konva.Layer>()
    this.trRef = createRef<Konva.Transformer>()
    this.scale = 0.5
    this.selectedIDs = []
    this.sidePanelSwitch = 'layers'
    this.ps = new ProjectStore()
  }

  switchSidePanel(to: string) {
    this.sidePanelSwitch = to
  }

  get stageProps(): StageProps {
    return {
      width: this.props.width + this.props.xPadding * 2,
      height: this.props.height + this.props.yPadding * 2,
      workAreaWidth: this.props.width,
      workAreaHeight: this.props.height,
      workAreaX: this.props.xPadding,
      workAreaY: this.props.yPadding,
      scaleStep: this.props.scaleStep,
      maxScale: this.props.maxScale,
      minScale: this.props.minScale
    }
  }
  setScale(scale: number) {
    if (this.scale === scale) return
    this.scale = scale
  }

  get selectedLayers() {
    return Object.values(this.ps.layers).filter((l) => this.selectedIDs.includes(l.uuid))
  }
  setSelectedIDs(selectedIDs: string[]) {
    if (
      this.selectedIDs.length === selectedIDs.length &&
      this.selectedIDs
        .slice()
        .sort()
        .every((val, index) => val === selectedIDs.sort()[index])
    ) {
      return
    }
    this.selectedIDs = selectedIDs
  }
  deselect() {
    this.setSelectedIDs([])
  }
  selectLayer(ID: string, metaPressed: boolean) {
    // do we press shift or ctrl?
    const isSelected = this.selectedIDs.includes(ID)
    let newSelectedIDs = this.selectedIDs.slice()

    if (!metaPressed && !isSelected) {
      // if no key pressed and the node is not selected
      // select just one
      newSelectedIDs = [ID]
    } else if (metaPressed && isSelected) {
      // if we pressed keys and node was selected
      // we need to remove it from selection:
      newSelectedIDs = this.selectedIDs.slice() // use slice to have new copy of array
      // remove node from array
      newSelectedIDs.splice(newSelectedIDs.indexOf(ID), 1)
    } else if (metaPressed && !isSelected) {
      // add the node into selection
      newSelectedIDs = this.selectedIDs.concat([ID])
    }

    this.setSelectedIDs(newSelectedIDs)
  }

  exportLayersToDataURL(imageLayerRef: React.MutableRefObject<Konva.Layer | null>) {
    const url = imageLayerRef.current?.toDataURL({
      mimeType: 'image/png',
      x: cs.props.xPadding * cs.scale,
      y: cs.props.yPadding * cs.scale,
      width: cs.stageProps.workAreaWidth * cs.scale,
      height: cs.stageProps.workAreaHeight * cs.scale,
      pixelRatio: 1 / cs.scale
    }) as string
    return url
  }
}

export const cs = new CanvasStore()
