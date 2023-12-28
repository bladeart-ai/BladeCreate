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
      {layer.generations?.map(g => {
        if (g.status !== 'SUCCEEDED') {
          return (
            <div key={'generation_progress' + g.uuid}>
              <p>生成中...</p>
            </div>
          )
        }
        return <div key={'generation_progress' + g.uuid}></div>
      })}
    </div>
  )
})

const GenerationImageCard = ({
  imageUUID,
  imageSrc,
  onClick,
}: {
  imageUUID: string
  imageSrc: string
  onClick: React.MouseEventHandler<HTMLDivElement>
}) => {
  return (
    <div
      className="w-full h-96 rounded-lg shadow border border-1 gap-2 relative overflow-hidden"
      onClick={onClick}
    >
      <img
        className="w-full h-full object-contain hover:scale-110 absolute inset-x-0 top-0"
        key={'generation-image-card-' + imageUUID}
        alt={'generation-image-card-' + imageUUID}
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
      <div className="w-full h-full p-1 rounded shadow justify-center items-start gap-1 inline-flex flex-wrap overflow-y-scroll relative">
        {g.image_uuids.flatMap(uuid => {
          if (ps.image_data[uuid]) {
            return (
              <GenerationImageCard
                key={'generation-image-' + uuid}
                imageUUID={uuid}
                imageSrc={ps.image_data[uuid]}
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
        ?.filter(g => g.status === 'SUCCEEDED')
        .map(g => <GenerateResult key={'GenerateResult-' + g.uuid} g={g} />)}
    </div>
  )
})

export const LayerResultPanel = observer(() => {
  return (
    <div className="w-full h-full pl-0 pr-1">
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
