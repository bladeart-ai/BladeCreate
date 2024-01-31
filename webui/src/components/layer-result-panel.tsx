import { Generation, Layer } from '@/gen_client'
import { borderColor } from '@/lib/color-utils'
import { cn } from '@/lib/utils'
import { cs } from '@/store/project-store'
import { observer } from 'mobx-react-lite'
import loadingGif from '@/public/loading.gif?asset'
import { action } from 'mobx'
import { TextSpan } from './text'
import { useTranslation } from 'react-i18next'

function GenerationImageCard({
  imageUUID,
  imageSrc,
  selected,
  onClick
}: {
  readonly imageUUID: string | undefined
  readonly imageSrc: string
  readonly selected: boolean
  readonly onClick: React.MouseEventHandler<HTMLDivElement>
}) {
  return (
    <img
      alt={'generation-image-card-' + imageUUID}
      className={cn(
        'relative h-fit w-full rounded-lg shadow object-contain hover:scale-110 border-4 ',
        selected ? borderColor(true) : borderColor(false)
      )}
      key={'generation-image-card-' + imageUUID}
      src={imageSrc}
      onClick={onClick}
    />
  )
}

export const LayerResultPanel = observer(() => {
  const { t } = useTranslation()

  const GenerateResult = observer(({ layer, g }: { layer: Layer; g: Generation }) => {
    const imageUUIDs = g.image_uuids.filter((uuid) => cs.ps.imageData[uuid] !== undefined)
    if (imageUUIDs.length === 0) {
      return (
        <div className="relative inline-flex h-fit w-full flex-wrap items-start justify-center gap-1 rounded p-1 shadow">
          <GenerationImageCard
            imageSrc={loadingGif}
            imageUUID={undefined}
            selected={layer.image_uuid === undefined}
            key={'generation-image-undefined'}
            onClick={() => cs.ps.updateLayerImageUUID(layer.uuid, null)}
          />
          {g.elapsed_secs && (
            <TextSpan text={t('Elapsed') + ': ' + Math.round(g.elapsed_secs) + 's'} />
          )}
          {g.percentage && (
            <TextSpan text={t('Percentage') + ': ' + Math.floor(g.percentage * 100) + '%'} />
          )}
        </div>
      )
    }

    return (
      <div className="relative inline-flex h-fit w-full flex-wrap items-start justify-center gap-1 rounded p-1 shadow">
        {imageUUIDs.map((uuid) => (
          <GenerationImageCard
            imageSrc={cs.ps.imageData[uuid]}
            imageUUID={uuid}
            selected={layer.image_uuid === uuid}
            key={'generation-image-' + uuid}
            onClick={action(() => cs.ps.updateLayerImageUUID(layer.uuid, uuid))}
          />
        ))}
      </div>
    )
  })

  return (
    <div className="inline-flex h-full w-full flex-col overflow-y-scroll pl-0 pr-1">
      {cs.selectedLayers.length === 1 &&
        cs.selectedLayers[0].generation_uuids &&
        cs.selectedLayers[0].generation_uuids.map(
          (gUUID) =>
            cs.ps.generations[gUUID] && (
              <GenerateResult
                key={'GenerateResult-' + gUUID}
                layer={cs.selectedLayers[0]}
                g={cs.ps.generations[gUUID]}
              />
            )
        )}
    </div>
  )
})
