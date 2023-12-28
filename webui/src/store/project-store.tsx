import { createRef } from 'react'
import Konva from 'konva'
import {
  ProjectMetadata,
  GenerationParams,
  Generation,
  DefaultService,
  Layer,
  LayerCreate,
} from '@/gen_client'
import { action, makeAutoObservable } from 'mobx'
import { User } from '@auth0/auth0-react'
import { v4 as uuidv4 } from 'uuid'

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
  project: ProjectMetadata | null = null
  layerOrder: Array<string> = []
  layers: Record<string, Layer> = {}
  image_urls: Record<string, string> = {}
  image_data: Record<string, string> = {}

  constructor() {
    makeAutoObservable(this)
  }

  get toDisplay() {
    return this.layerOrder.map(layerUUID => this.layers[layerUUID])
  }

  get toDisplayReversed() {
    return this.layerOrder
      .map((_, index, array) => array[array.length - 1 - index])
      .map(layerUUID => this.layers[layerUUID])
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

  fetch(user: User, projectUUID: string) {
    this.fetchingMetadata = true
    this.fetchingImages = true
    this.userID = user.sub || ''
    this.projectUUID = projectUUID

    DefaultService.getProject(this.userID, projectUUID).then(
      action('fetchProjectSuccess', project => {
        document.title = project.name
        this.project = project
        this.layerOrder = project.layers_order || []
        this.layers = project.layers || {}
        this.image_data = project.images?.data || {}
        this.fetchingMetadata = false

        if (project.images) {
          Promise.allSettled(
            Object.keys(project.images.urls).map(image_uuid => {
              const url = project.images?.urls[image_uuid] || ''
              return fetch(url)
                .then(val => val.text())
                .then(
                  action(val => {
                    this.image_data[url] = val
                  })
                )
            })
          ).then(
            action('fetchImagesSuccess', () => {
              this.fetchingImages = false
            }),
            action('fetchImagesError', error => {
              console.error('fetch error', error)
            })
          )
        }
      }),
      action('fetchProjectError', error => {
        console.error('fetchProjectError', error)
      })
    )
  }
  createLayerFromLocalImage(name: string, imageData: string) {
    this.lockUI()
    DefaultService.createProjectLayer(this.userID, this.projectUUID, {
      uuid: uuidv4(),
      name: name,
      x: cs.props.xPadding,
      y: cs.props.yPadding,
      rotation: 0,
      image_data: imageData,
    } as LayerCreate)
      .then(
        action(res => {
          this.layers[res.uuid] = res
          this.image_data[res.uuid] = imageData
          this.layerOrder.unshift(res.uuid)
        })
      )
      .finally(action(() => this.unlockUI()))
  }

  generate(outputLayerUUID: string | null, params: GenerationParams) {
    this.lockUI()

    const callGenerate = action((outputLayerUUID: string) => {
      return DefaultService.generate(this.userID, this.projectUUID, {
        output_layer_uuid: outputLayerUUID,
        params: params,
      }).then(
        action(val => {
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
        name: 'Generation',
      }
      DefaultService.createProjectLayer(this.userID, this.projectUUID, newLayer)
        .then(
          action(val => {
            this.layers[val.uuid] = newLayer
            this.layerOrder.unshift(val.uuid)
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

  updateLayerImageUUID(layerUUID: string, imageUUID: string) {
    this.lockUI()
    DefaultService.updateProjectLayer(
      this.userID,
      this.projectUUID,
      layerUUID,
      { image_uuid: imageUUID }
    )
      .then(
        action(() => {
          this.layers[layerUUID].image_uuid = imageUUID
        })
      )
      .finally(action(() => this.unlockUI()))
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

    Promise.allSettled(
      transformProps.map(l => {
        const newLayer = { ...this.layers[l.layerUUID] }
        if (l.x) newLayer.x = l.x
        if (l.y) newLayer.y = l.y
        if (l.width) newLayer.width = l.width
        if (l.height) newLayer.height = l.height
        if (l.rotation) newLayer.rotation = l.rotation
        if (this.layers[l.layerUUID] === newLayer) {
          return
        }
        return DefaultService.updateProjectLayer(
          this.userID,
          this.projectUUID,
          l.layerUUID,
          newLayer
        ).then(
          action(val => {
            this.layers[l.layerUUID] = val
          })
        )
      })
    ).finally(action(() => this.unlockUI()))
  }

  moveLayer(startIndex: number, endIndex: number) {
    if (startIndex === endIndex) {
      return
    }

    this.lockUI()

    const newLayerOrder = this.layerOrder.slice()
    const [removed] = newLayerOrder.splice(startIndex, 1)
    newLayerOrder.splice(endIndex, 0, removed)

    DefaultService.updateProject(this.userID, this.projectUUID, {
      layers_order: newLayerOrder,
    })
      .then(() => {
        this.layerOrder = newLayerOrder
      })
      .finally(action(() => this.unlockUI()))
  }

  deleteLayer(layerUUID: string) {
    const found = this.layerOrder.findIndex(uuid => uuid == layerUUID)
    if (found == -1) return

    this.lockUI()

    this.layerOrder.splice(found, 1)
    delete this.layers[layerUUID]
    cs.setSelectedIDs(cs.selectedIDs.filter(uuid => uuid !== layerUUID))

    DefaultService.deleteLayer(
      this.userID,
      this.projectUUID,
      layerUUID
    ).finally(action(() => this.unlockUI()))
  }

  exportLayersToDataURL(
    imageLayerRef: React.MutableRefObject<Konva.Layer | null>
  ) {
    const url = imageLayerRef.current?.toDataURL({
      mimeType: 'image/png',
      x: cs.props.xPadding * cs.scale,
      y: cs.props.yPadding * cs.scale,
      width: cs.stageProps.workAreaWidth * cs.scale,
      height: cs.stageProps.workAreaHeight * cs.scale,
      pixelRatio: 1 / cs.scale,
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
      minScale: 0.5,
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
      minScale: this.props.minScale,
    }
  }
  setScale(scale: number) {
    if (this.scale === scale) return
    this.scale = scale
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
