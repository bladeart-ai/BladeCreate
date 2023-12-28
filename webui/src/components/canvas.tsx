import { useContext, useEffect, useRef, useState } from 'react'
import { cs, ps } from '@/store/project-store'
import {
  Layer as LayerComp,
  Rect,
  Stage,
  Transformer,
  Image,
} from 'react-konva'
import Konva from 'konva'
import useImage from 'use-image'
import { Vector2d } from 'konva/lib/types'
import { action, reaction } from 'mobx'
import { observer } from 'mobx-react-lite'
import { ProjectContext, ProjectContextType } from '@/context/project-context'
import { Layer } from '@/gen_client'

const TransformableImage = observer(({ layer }: { layer: Layer }) => {
  const imageURL = ps.image_data[layer.image_uuid || ''] || ''
  const [image, status] = useImage(imageURL)

  if (status !== 'loaded') {
    return <></>
  }

  let x = layer.x
  let y = layer.y
  let width = layer.width
  let height = layer.height

  // Initialize x and y
  if (!layer.x) {
    x = cs.stageProps.workAreaX
  }
  if (!layer.y) {
    y = cs.stageProps.workAreaY
  }

  // Initialize the image size
  if (
    !layer.width &&
    !layer.height &&
    image?.naturalWidth &&
    image?.naturalHeight
  ) {
    width = image?.naturalWidth
    height = image?.naturalHeight

    // Need resize natural size to fit within the stage
    let resizeScale = 1
    if (image.naturalWidth > cs.stageProps.workAreaWidth) {
      resizeScale = cs.stageProps.workAreaWidth / image.naturalWidth
    }
    if (image.naturalHeight > cs.stageProps.workAreaHeight) {
      resizeScale = Math.min(
        resizeScale,
        cs.stageProps.workAreaHeight / image.naturalHeight
      )
    }

    width = width * resizeScale
    height = height * resizeScale
  }

  return (
    <Image
      id={'image_' + layer.uuid}
      image={image}
      x={x || undefined}
      y={y || undefined}
      width={width || undefined}
      height={height || undefined}
      rotation={layer.rotation || undefined}
      draggable
      onDragEnd={action(e => {
        ps.transformLayers([
          {
            layerUUID: layer.uuid,
            x: e.target.x(),
            y: e.target.y(),
            width: null,
            height: null,
            rotation: null,
          },
        ])
      })}
    />
  )
})

export const Canvas = observer(() => {
  // Definition for the Canvas React Component
  // References:
  // 1. https://konvajs.org/docs/react/Images.html
  // 2. https://konvajs.org/docs/react/Transformer.html
  // 3. Multi-selection: https://konvajs.org/docs/select_and_transform/Basic_demo.html

  const ctx = useContext(ProjectContext) as ProjectContextType

  const viewportRef = useRef<HTMLDivElement | null>(null)
  const stageRef = useRef<Konva.Stage | null>(null)
  const selectionRectRef = useRef<Konva.Rect | null>(null)
  const trRef = useRef<Konva.Transformer | null>(null)
  const imageLayerRef = ctx.imagesLayerRef

  const [selectionRectState, setSelectionRectState] = useState({
    visible: false,
    clicked: false,
    x1: 0,
    y1: 0,
    x2: 0,
    y2: 0,
  })

  // Initialize scrolling of viewport
  // eslint-disable-next-line react-hooks/exhaustive-deps
  useEffect(
    action(() => {
      viewportRef.current?.scrollTo({
        top: cs.props.yPadding * cs.scale,
        left: cs.props.xPadding * cs.scale,
      })
    }),
    []
  )

  // Redraw layer when an image is selected
  // Put redrawing transformer in the React execution flow
  useEffect(
    () =>
      reaction(
        () => cs.selectedIDs,
        selectedIDs => {
          // we need to attach transformer manually
          const nodes = selectedIDs.flatMap(UID => {
            const node = stageRef.current?.findOne('#image_' + UID)
            if (!node) {
              return []
            }
            return [node]
          })
          trRef.current?.setNodes(nodes)
          trRef.current?.getLayer()?.batchDraw()
        }
      ),
    []
  )

  const handleSelectOrDeselect = action(
    (
      e: Konva.KonvaEventObject<MouseEvent> | Konva.KonvaEventObject<TouchEvent>
    ) => {
      // Multi-selection -> update selected ids

      if (selectionRectState.visible) {
        return
      }

      // if clicked on empty area, remove all selections
      const clickedOnEmpty =
        e.target === e.target.getStage() || e.target.id() === 'workarea_bg'
      if (clickedOnEmpty) {
        cs.deselect()
        return
      }

      // do nothing if clicked NOT on our rectangles
      if (!e.target.id().startsWith('image_')) {
        return
      }
      const UID = e.target.id().substring(6)

      const metaPressed = e.evt.shiftKey || e.evt.ctrlKey || e.evt.metaKey
      cs.selectLayer(UID, metaPressed)
    }
  )

  const handleSelectionRectStart = action(
    (e: Konva.KonvaEventObject<MouseEvent | TouchEvent>) => {
      // Multi-selection -> selection rectangle set visible

      // do nothing if we mousedown on any shape
      const clickedOnEmpty =
        e.target === e.target.getStage() || e.target.id() === 'workarea_bg'
      if (!clickedOnEmpty) {
        return
      }
      e.evt.preventDefault()

      const stage = e.target.getStage() as Konva.Stage
      const relativePt = stage.getRelativePointerPosition() as Vector2d
      setSelectionRectState({
        visible: false,
        clicked: true,
        x1: relativePt.x,
        y1: relativePt.y,
        x2: relativePt.x,
        y2: relativePt.y,
      })
    }
  )

  const handleSelectionRectRelocate = action(
    (e: Konva.KonvaEventObject<MouseEvent | TouchEvent>) => {
      // Multi-selection -> selection rectangle relocate/resize

      // do nothing if we didn't start selection
      if (!selectionRectState.clicked) {
        return
      }
      e.evt.preventDefault()

      const stage = e.target.getStage() as Konva.Stage
      const relativePt = stage.getRelativePointerPosition() as Vector2d
      setSelectionRectState({
        visible: true,
        clicked: true,
        x1: selectionRectState.x1,
        y1: selectionRectState.y1,
        x2: relativePt.x,
        y2: relativePt.y,
      })
    }
  )

  const handleSelectionRectHide = action(
    (e: Konva.KonvaEventObject<MouseEvent | TouchEvent>) => {
      // Multi-selection -> selection rectangle set hidden

      // do nothing if we didn't start selection
      if (!selectionRectState.clicked) {
        return
      }
      e.evt.preventDefault()

      const stage = e.target.getStage() as Konva.Stage
      // update visibility in timeout, so we can check it in click event
      setTimeout(() => {
        setSelectionRectState({
          ...selectionRectState,
          clicked: false,
          visible: false,
        })
      })

      const elements = stage.find('Image')
      const box = (selectionRectRef.current as Konva.Rect).getClientRect()
      const selectedIDs = elements
        .filter(element =>
          Konva.Util.haveIntersection(box, element.getClientRect())
        )
        .map(element => element.id().substring(6))
      cs.setSelectedIDs(selectedIDs)
    }
  )

  const scaleStage = action((e: Konva.KonvaEventObject<WheelEvent>) => {
    // when we zoom on trackpad, e.evt.ctrlKey is true, otherwise using default scrolling.
    if (!e.evt.ctrlKey) {
      return
    }

    // Disable default scrolling
    e.evt.preventDefault()
    const stage = e.target.getStage()
    if (stage === null) {
      return
    }

    const oldScale = cs.scale
    // how to scale? Zoom in? Or zoom out?
    const direction = e.evt.deltaY > 0 ? -1 : 1
    let newScale =
      direction > 0
        ? oldScale * cs.stageProps.scaleStep
        : oldScale / cs.stageProps.scaleStep
    if (newScale > cs.stageProps.maxScale) {
      newScale = cs.stageProps.maxScale
    } else if (newScale < cs.stageProps.minScale) {
      newScale = cs.stageProps.minScale
    }
    const scaleBy = newScale / oldScale

    cs.setScale(newScale)
    // 尽管stage的Component是用context.canvasState.scale渲染的，但是这里手动更新会让效果更顺滑
    stage.scale({ x: newScale, y: newScale })

    stage.height(cs.stageProps.height * newScale)
    stage.width(cs.stageProps.width * newScale)

    // Move scrolling location so that the mouse stays where it was on the viewport
    const pointer = stage.getPointerPosition()
    if (pointer !== null) {
      viewportRef.current?.scrollTo({
        top: pointer.y * (scaleBy - 1) + viewportRef.current?.scrollTop,
        left: pointer.x * (scaleBy - 1) + viewportRef.current?.scrollLeft,
      })
    }
  })

  const handleTransformLayers = action(() => {
    setTimeout(
      action(() => {
        const transforms = cs.selectedIDs
          .map(layerUUID => {
            const node = stageRef.current?.findOne('#image_' + layerUUID)
            if (node === undefined) {
              return
            }

            // transformer is changing scale of the node
            // and NOT its width or height
            // but in the store we have only width and height
            // to match the data better we will reset scale on transform end
            node.setAttrs({
              width: Math.max(node.width() * node.scaleX(), 5),
              height: Math.max(node.height() * node.scaleY(), 5),
              scaleX: 1,
              scaleY: 1,
            })

            return {
              layerUUID: layerUUID,
              x: node.x(),
              y: node.y(),
              width: node.width(),
              height: node.height(),
              rotation: node.rotation(),
            }
          })
          .filter(x => x) as {
          layerUUID: string
          x: number | null
          y: number | null
          width: number | null
          height: number | null
          rotation: number | null
        }[]

        ps.transformLayers(transforms)
      }),
      10
    )
  })

  // TODO: 使用自已做的滚动条，原生滚动条有点问题
  return (
    <div
      id="canvas-viewport"
      className="relative w-full h-full flex justify-center overflow-scroll border border-pink-200"
      ref={viewportRef}
    >
      <div id="canvas-full" className="w-fit h-fit">
        <Stage
          ref={stageRef}
          width={cs.stageProps.width * cs.scale}
          height={cs.stageProps.height * cs.scale}
          scale={{ x: cs.scale, y: cs.scale }}
          style={{ background: 'grey' }}
          onMouseDown={handleSelectionRectStart}
          onTouchStart={handleSelectionRectStart}
          onMouseMove={handleSelectionRectRelocate}
          onTouchMove={handleSelectionRectRelocate}
          onMouseUp={handleSelectionRectHide}
          onTouchEnd={handleSelectionRectHide}
          onClick={handleSelectOrDeselect}
          onTap={handleSelectOrDeselect}
          onWheel={scaleStage}
        >
          <LayerComp ref={imageLayerRef}>
            <Rect
              id="workarea_bg"
              x={cs.stageProps.workAreaX}
              y={cs.stageProps.workAreaY}
              height={cs.stageProps.workAreaHeight}
              width={cs.stageProps.workAreaWidth}
              fill="white"
            />

            {ps.toDisplayReversed.map(layer => (
              <TransformableImage key={'image_' + layer.uuid} layer={layer} />
            ))}
          </LayerComp>

          <LayerComp>
            <Transformer
              ref={trRef}
              style={cs.selectedIDs.length > 0 ? {} : { display: 'none' }}
              flipEnabled={false}
              boundBoxFunc={(oldBox, newBox) => {
                // limit resize
                if (Math.abs(newBox.width) < 5 || Math.abs(newBox.height) < 5) {
                  return oldBox
                }
                return newBox
              }}
              // anchorStroke='rgb(244,114,182)' // Tailwind Pink 400
              // borderStroke='rgb(244,114,182)' // Tailwind Pink 400

              onTransformEnd={handleTransformLayers}
            />

            <Rect
              ref={selectionRectRef}
              fill="rgba(0,0,255,0.5)"
              visible={selectionRectState.visible}
              x={Math.min(selectionRectState.x1, selectionRectState.x2)}
              y={Math.min(selectionRectState.y1, selectionRectState.y2)}
              width={Math.abs(selectionRectState.x2 - selectionRectState.x1)}
              height={Math.abs(selectionRectState.y2 - selectionRectState.y1)}
            />
          </LayerComp>
        </Stage>
      </div>
    </div>
  )
})
