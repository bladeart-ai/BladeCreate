import { Button } from '@/components/ui/button'
import { cn } from '@/lib/utils'
import { DragDropContext, Droppable, Draggable } from '@hello-pangea/dnd'
import { DotsVerticalIcon, TrashIcon } from '@radix-ui/react-icons'
import { TextSpan } from './text'
import {
  DropdownMenu,
  DropdownMenuItem,
  DropdownMenuContent,
  DropdownMenuTrigger
} from '@/components/ui/dropdown-menu'
import { cs } from '@/store/project-store'
import { observer, Observer } from 'mobx-react-lite'
import { action } from 'mobx'
import { Layer } from '@/gen_client'
import { color } from '../lib/color-utils'

export function LayerListPanel() {
  // References:
  // 1. Drag-and-drop list source code: https://github.com/hello-pangea/dnd
  // 1. Drag-and-drop list doc: https://github.com/atlassian/react-beautiful-dnd

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  function onDragEnd(result: any) {
    // dropped outside the list
    if (!result.destination) {
      return
    }

    cs.ps.moveLayer(result.source.index, result.destination.index)
  }

  function LayerItemDropdownMenu({ layer }: { readonly layer: Layer }) {
    return (
      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button size="icon" variant="ghost">
            <DotsVerticalIcon className="m-2.5" />
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent className="w-28">
          <DropdownMenuItem
            className="py-0"
            onClick={action(() => {
              cs.ps.deleteLayer(layer.uuid)
            })}
          >
            <TrashIcon className="m-2.5" />
            <TextSpan text="删除" />
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    )
  }

  const LayerItem = observer(
    ({ layer, dragging }: { layer: Layer; readonly dragging: boolean }) => {
      const bgcolor = color(cs.selectedIDs.includes(layer.uuid), dragging)

      return (
        <div
          className={cn(
            'w-full h-auto pl-2 flex items-center rounded-lg border transition-colors',
            bgcolor
          )}
          onClick={action((evt) => {
            const metaPressed = evt.shiftKey || evt.ctrlKey || evt.metaKey
            cs.selectLayer(layer.uuid, metaPressed)
          })}
        >
          <TextSpan text={layer.name || ''} />
          <div className="shrink grow self-stretch" />
          <LayerItemDropdownMenu layer={layer} />
        </div>
      )
    }
  )

  const DraggableLayerItem = observer(
    ({ layer, index }: { readonly layer: Layer; readonly index: number }) => (
      <Draggable draggableId={'layer_' + layer.uuid} index={index} key={'layer_' + layer.uuid}>
        {(provided, snapshot) => (
          <div
            ref={provided.innerRef}
            {...provided.draggableProps}
            {...provided.dragHandleProps}
            style={{
              // This is to fix the position of a draggable when it is being dragged because of the side panel is "fixed" positioned
              marginTop: snapshot.isDragging ? 0 : 0,
              ...provided.draggableProps.style
            }}
          >
            <LayerItem dragging={snapshot.isDragging} layer={layer} />
          </div>
        )}
      </Draggable>
    )
  )

  return (
    <div className="inline-flex h-full w-full flex-col">
      <div className="justify start inline-flex h-12 w-full items-center self-stretch pl-2">
        <TextSpan text="所有图层" />
        <div className="shrink grow basis-0 self-stretch" />
      </div>

      <div className="relative overflow-y-scroll">
        <DragDropContext onDragEnd={onDragEnd}>
          <Droppable droppableId="droppable">
            {(provided, snapshot) => (
              <Observer>
                {() => (
                  <div
                    {...provided.droppableProps}
                    className={snapshot.isDraggingOver ? 'bg-pink-100/90' : ''}
                    ref={provided.innerRef}
                  >
                    {cs.ps.toLayersDisplay.map((layerSnapshot, index) => (
                      <DraggableLayerItem
                        index={index}
                        key={'DraggableLayerItem-' + layerSnapshot.uuid}
                        layer={layerSnapshot}
                      />
                    ))}
                    {provided.placeholder}
                  </div>
                )}
              </Observer>
            )}
          </Droppable>
        </DragDropContext>
      </div>
    </div>
  )
}
