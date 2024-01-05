import { Generation, Layer } from '@/gen_client'
import { cs, ps } from '@/store/project-store'
import { observer } from 'mobx-react-lite'

const GenerationProgress = observer(({ layer }: { layer: Layer }) => {
  // TODO: figure out UX, build it
  // Thoughts：每个任务单独跟踪进度，一个图层可以对应多种任务
  // 任务可以是单次的，也可以是streaming的

  if (!layer.generations) {
    return <></>
  }

  return (
    <div>
      {layer.generations?.map((g) => {
        if (g.status !== 'SUCCEEDED') {
          return (
            <div key={'generation_progress' + g.uuid}>
              <p>生成中...</p>
            </div>
          )
        }
        return <div key={'generation_progress' + g.uuid} />
      })}
    </div>
  )
})

function GenerationImageCard({
  imageUUID,
  imageSrc,
  onClick
}: {
  readonly imageUUID: string
  readonly imageSrc: string
  readonly onClick: React.MouseEventHandler<HTMLDivElement>
}) {
  return (
    <div
      className="border-1 relative h-96 w-full gap-2 overflow-hidden rounded-lg border shadow"
      onClick={onClick}
    >
      <img
        alt={'generation-image-card-' + imageUUID}
        className="absolute inset-x-0 top-0 h-full w-full object-contain hover:scale-110"
        key={'generation-image-card-' + imageUUID}
        src={imageSrc}
      />
    </div>
  )
}

const GenerateResultsArea = observer(({ layer }: { layer: Layer }) => {
  if (!layer.generations) {
    return <p>不存在生成结果</p>
  }

  const GenerateResult = observer(({ g }: { g: Generation }) => {
    return (
      <div className="relative inline-flex h-full w-full flex-wrap items-start justify-center gap-1 overflow-y-scroll rounded p-1 shadow">
        {g.image_uuids.flatMap((uuid) => {
          if (ps.image_data[uuid]) {
            return (
              <GenerationImageCard
                imageSrc={ps.image_data[uuid]}
                imageUUID={uuid}
                key={'generation-image-' + uuid}
                onClick={() => ps.updateLayerImageUUID(layer.uuid, uuid)}
              />
            )
          }
          return
        })}
      </div>
    )
  })

  return (
    <div>
      {layer.generations
        ?.filter((g) => g.status === 'SUCCEEDED')
        .map((g) => <GenerateResult g={g} key={'GenerateResult-' + g.uuid} />)}
    </div>
  )
})

export const LayerResultPanel = observer(() => {
  return (
    <div className="h-full w-full pl-0 pr-1">
      {cs.selectedIDs.length === 1 && ps.layers[cs.selectedIDs[0]] ? (
        <>
          <GenerationProgress layer={ps.layers[cs.selectedIDs[0]]} />
          <GenerateResultsArea layer={ps.layers[cs.selectedIDs[0]]} />
        </>
      ) : (
        <p>选中了{cs.selectedIDs.length}个图层</p>
      )}
    </div>
  )
})
