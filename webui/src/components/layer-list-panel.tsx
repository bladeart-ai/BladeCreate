import { Button } from '@/components/ui/button'
import { cn } from '@/lib/utils'
import { DragDropContext, Droppable, Draggable } from '@hello-pangea/dnd'
import { DotsVerticalIcon, TrashIcon } from '@radix-ui/react-icons'
import { TextSpan } from './text'
import {
  DropdownMenu,
  DropdownMenuItem,
  DropdownMenuContent,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { cs, ps } from '@/store/project-store'
import { observer, Observer } from 'mobx-react-lite'
import { action } from 'mobx'
import { Layer } from '@/gen_client'
import { color } from './color-utils'

export const LayerListPanel = () => {
  // References:
  // 1. Drag-and-drop list source code: https://github.com/hello-pangea/dnd
  // 1. Drag-and-drop list doc: https://github.com/atlassian/react-beautiful-dnd

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  function onDragEnd(result: any) {
    // dropped outside the list
    if (!result.destination) {
      return
    }

    ps.moveLayer(result.source.index, result.destination.index)
  }

  const LayerItemDropdownMenu = ({ layer }: { layer: Layer }) => {
    return (
      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button variant="ghost" size="icon">
            <DotsVerticalIcon className="m-2.5" />
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent className="w-28">
          <DropdownMenuItem
            onClick={action(() => {
              ps.deleteLayer(layer.uuid)
            })}
            className="py-0"
          >
            <TrashIcon className="m-2.5" />
            <TextSpan text="删除" />
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    )
  }

  const LayerItem = observer(
    ({ layer, dragging }: { layer: Layer; dragging: boolean }) => {
      const bgcolor = color(cs.selectedIDs.includes(layer.uuid), dragging)

      return (
        <div
          className={cn(
            'w-full h-auto pl-2 flex items-center rounded-lg border transition-colors',
            bgcolor
          )}
          onClick={action(evt => {
            const metaPressed = evt.shiftKey || evt.ctrlKey || evt.metaKey
            cs.selectLayer(layer.uuid, metaPressed)
          })}
        >
          <TextSpan text={layer.name || ''} />
          <div className="grow shrink self-stretch" />
          <LayerItemDropdownMenu layer={layer} />
        </div>
      )
    }
  )

  const DraggableLayerItem = observer(
    ({ layer, index }: { layer: Layer; index: number }) => (
      <Draggable
        key={'layer_' + layer.uuid}
        draggableId={'layer_' + layer.uuid}
        index={index}
      >
        {(provided, snapshot) => (
          <div
            ref={provided.innerRef}
            {...provided.draggableProps}
            {...provided.dragHandleProps}
            style={{
              // This is to fix the position of a draggable when it is being dragged because of the side panel is "fixed" positioned
              marginTop: snapshot.isDragging ? 0 : 0,
              ...provided.draggableProps.style,
            }}
          >
            <LayerItem layer={layer} dragging={snapshot.isDragging} />
          </div>
        )}
      </Draggable>
    )
  )

  return (
    <div className="w-full h-full inline-flex flex-col">
      <div className="w-full h-12 pl-2 self-stretch justify start items-center inline-flex">
        <TextSpan text="所有图层" />
        <div className="grow shrink basis-0 self-stretch"></div>
      </div>

      <div className="relative overflow-y-scroll">
        <DragDropContext onDragEnd={onDragEnd}>
          <Droppable droppableId="droppable">
            {(provided, snapshot) => (
              <Observer>
                {() => (
                  <div
                    {...provided.droppableProps}
                    ref={provided.innerRef}
                    className={snapshot.isDraggingOver ? 'bg-pink-100/90' : ''}
                  >
                    {ps.toDisplay.map((layerSnapshot, index) => (
                      <DraggableLayerItem
                        key={'DraggableLayerItem-' + layerSnapshot.uuid}
                        layer={layerSnapshot}
                        index={index}
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
