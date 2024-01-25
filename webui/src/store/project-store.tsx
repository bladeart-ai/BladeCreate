import { createRef } from 'react'
import Konva from 'konva'
import { action, makeAutoObservable } from 'mobx'
import { User } from '@auth0/auth0-react'
import { v4 as uuidv4 } from 'uuid'
import { DefaultService, GenerationParams, Layer, Project, ProjectData } from '@/gen_client'

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
  fetchingMetadata: boolean = true
  fetchingImages: boolean = true
  userLock: boolean = false

  user: User | null = null
  userID: string = ''
  projectUUID: string = ''

  project: Project | null = null
  layersOrder: Array<string> = []
  layers: Record<string, Layer> = {}
  image_data: Record<string, string> = {}

  constructor() {
    makeAutoObservable(this)
  }

  get toDisplay() {
    return this.layersOrder.map((layerUUID) => this.layers[layerUUID])
  }

  get toDisplayReversed() {
    return this.layersOrder
      .map((_, index, array) => array[array.length - 1 - index])
      .map((layerUUID) => this.layers[layerUUID])
  }

  get fetching() {
    return this.fetchingMetadata || this.fetchingImages
  }

  lockUI() {
    this.userLock = true
  }
  unlockUI() {
    this.userLock = false
  }

  fetchImages(imageUUIDs) {
    if (imageUUIDs.length > 0) {
      DefaultService.getImageDataOrUrl(this.userID, imageUUIDs)
        .then(
          action((res) => {
            this.image_data = { ...this.image_data, ...res.data }
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
                      this.image_data[image_uuid] = val
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
    } else {
      this.fetchingImages = false
    }
  }

  fetch(user: User, projectUUID: string) {
    this.fetchingMetadata = true
    this.fetchingImages = true
    this.userID = user.sub || ''
    this.projectUUID = projectUUID

    DefaultService.getProject(this.userID, projectUUID).then(
      action((project) => {
        document.title = project.name
        this.project = project
        this.layersOrder = project.data.layers_order || []
        this.layers = project.data.layers || {}
        this.fetchingMetadata = false

        const imageUUIDs = Object.values(this.layers).flatMap((layer) => [
          layer.image_uuid,
          ...Object.values(layer.generations || []).flatMap((g) => g.image_uuids)
        ])

        this.fetchImages(imageUUIDs)
      })
    )
  }

  sendUploadImages(imageUUID: string, imageData: string) {
    const data = {}
    data[imageUUID] = imageData
    return DefaultService.uploadImages(this.userID, { data: data })
  }

  sendUpdateProject(data: ProjectData) {
    return DefaultService.updateProject(this.userID, this.projectUUID, { data: data }).then(
      action((res) => {
        this.layers = res.data.layers || {}
        this.layersOrder = res.data.layers_order || []
      })
    )
  }

  createLayerFromLocalImage(name: string, imageData: string) {
    this.lockUI()
    const layerUUID = uuidv4()
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
    this.image_data[newLayer.uuid] = imageData
    this.sendUploadImages(newLayer.uuid, imageData).then(
      action(() =>
        this.sendUpdateProject({
          layers_order: this.layersOrder,
          layers: this.layers
        } as ProjectData).finally(action(() => this.unlockUI()))
      )
    )
  }

  updateLayerImageUUID(layerUUID: string, imageUUID: string) {
    this.lockUI()
    const newLayer: Layer = { ...this.layers[layerUUID], image_uuid: imageUUID }
    this.layers[layerUUID] = newLayer
    this.sendUpdateProject({
      layers_order: this.layersOrder,
      layers: this.layers
    } as ProjectData).finally(action(() => this.unlockUI()))
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

    return this.sendUpdateProject({
      layers_order: this.layersOrder,
      layers: this.layers
    } as ProjectData).finally(action(() => this.unlockUI()))
  }

  moveLayer(startIndex: number, endIndex: number) {
    if (startIndex === endIndex) {
      return
    }

    this.lockUI()

    const newLayerOrder = this.layersOrder.slice()
    const [removed] = newLayerOrder.splice(startIndex, 1)
    newLayerOrder.splice(endIndex, 0, removed)

    this.sendUpdateProject({
      layers_order: newLayerOrder,
      layers: this.layers
    } as ProjectData).finally(action(() => this.unlockUI()))
  }

  deleteLayer(layerUUID: string) {
    const found = this.layersOrder.findIndex((uuid) => uuid == layerUUID)
    if (found == -1) return

    this.lockUI()

    this.layersOrder.splice(found, 1)
    delete this.layers[layerUUID]
    cs.setSelectedIDs(cs.selectedIDs.filter((uuid) => uuid !== layerUUID))

    this.sendUpdateProject({
      layers_order: this.layersOrder,
      layers: this.layers
    } as ProjectData).finally(action(() => this.unlockUI()))
  }

  generate(outputLayerUUID: string | null, params: GenerationParams) {
    this.lockUI()

    const callGenerate = action((outputLayerUUID: string) => {
      return DefaultService.generate(this.userID, this.projectUUID, {
        output_layer_uuid: outputLayerUUID,
        params: params
      }).then(
        action((val) => {
          if (val.images) {
            this.image_data = { ...this.image_data, ...val.images.data }
          }

          const g: Generation = { ...val }
          if (outputLayerUUID) {
            if (!this.layers[outputLayerUUID].generations) {
              this.layers[outputLayerUUID].generations = []
            }
            this.layers[outputLayerUUID].generations?.unshift(g)
            this.layers[outputLayerUUID].image_uuid = val.image_uuids[0]
          }
        })
      )
    })

    if (!outputLayerUUID) {
      outputLayerUUID = uuidv4()
      const newLayer = {
        uuid: outputLayerUUID,
        name: 'Generation'
      }
      DefaultService.createProjectLayer(this.userID, this.projectUUID, newLayer)
        .then(
          action((val) => {
            this.layers[val.uuid] = newLayer
            this.layersOrder.unshift(val.uuid)
          })
        )
        .then(
          action(() => {
            callGenerate(newLayer.uuid)
          })
        )
        .finally(action(() => this.unlockUI()))
    } else {
      callGenerate(outputLayerUUID).finally(action(() => this.unlockUI()))
    }
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

class CanvasStore {
  props: CanvasProps
  ref: React.RefObject<Konva.Layer>
  trRef: React.RefObject<Konva.Transformer>
  scale: number
  selectedIDs: string[]

  sidePanelSwitch: string

  projectStore: ProjectStore

  constructor(ps: ProjectStore) {
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
    this.projectStore = ps
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

  get selectedNum() {
    return this.selectedLayers.length
  }
  get selectedLayers() {
    return Object.values(ps.layers).filter((l) => this.selectedIDs.includes(l.uuid))
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
}

export const ps = new ProjectStore()
export const cs = new CanvasStore(ps)
