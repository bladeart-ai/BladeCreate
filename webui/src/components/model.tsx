import { Button } from '@/components/ui/button'
import { Label } from '@/components/ui/label'
import { CheckCircle2Icon, FilterIcon } from 'lucide-react'
import { Input } from '@/components/ui/input'
import { Toggle } from '@/components/ui/toggle'
import { ModelDetail, ModelPreset, ModelSnapshot } from '../context/model'
import { Badge } from '@/components/ui/badge'
import { IconJarLogoIcon } from '@radix-ui/react-icons'
import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover'
import civitaiIcon from '@/public/civitai_icon.png?asset'

export function ModelBadge(text: string) {
  return <Badge className="h-6 w-fit gap-1 text-base">{text}</Badge>
}

export function ModelSourceBadge(source: string, trainingUID: string | null) {
  {
    if (source == 'training') {
      return (
        <Badge className="h-6 w-fit gap-1 text-base">
          <IconJarLogoIcon className="h-4" />
          <div className="text-base">{trainingUID == null ? '训练' : '训练 ' + trainingUID}</div>
        </Badge>
      )
    } else if (source == 'civitai') {
      return (
        <Badge className="h-6 w-fit gap-1 text-base">
          <img className="CivitaiIcon h-4" src={civitaiIcon} />
          <div className="text-base">Civitai</div>
        </Badge>
      )
    } else {
      return (
        <Badge className="h-6 w-fit gap-1 text-base">
          <div className="text-base">Unknown</div>
        </Badge>
      )
    }
  }
}

export function ImportedModelDetails(modelDetail: ModelDetail) {
  return (
    <div className="grid w-full gap-4">
      <div className="grid grid-cols-4 items-center gap-4">
        <p className="col-span-3">模型详情</p>
        <Button>检查可用</Button>
      </div>
      <div className="grid grid-cols-4 items-center gap-4">
        <Label htmlFor="modelUsable">模型可用</Label>
        <CheckCircle2Icon />
      </div>
      <div className="grid grid-cols-4 items-center gap-4">
        <Label htmlFor="modelName">模型名称</Label>
        <Input className="col-span-3" id="modelName" value="" />
      </div>
      <div className="grid grid-cols-4 items-center gap-4">
        <Label htmlFor="modelVersion">模型版本</Label>

        <div className="col-span-3 inline-flex flex-wrap gap-2">
          {modelDetail.modelVersionUIDs.map((versionUID) =>
            modelDetail.modelSnapshot.versionUID == versionUID ? (
              <Toggle
                aria-label="Toggle italic"
                defaultPressed
                key={'importedModelDetails_' + versionUID}
                variant="outline"
              >
                {versionUID}
              </Toggle>
            ) : (
              <Toggle
                aria-label="Toggle italic"
                key={'importedModelDetails_' + versionUID}
                variant="outline"
              >
                {versionUID}
              </Toggle>
            )
          )}
        </div>
      </div>
      <div className="grid grid-cols-4 items-center gap-4">
        <Label htmlFor="modelType">创建时间</Label>
        <p>{modelDetail.modelSnapshot.createTime}</p>
      </div>
      <div className="grid grid-cols-4 items-center gap-4">
        <Label htmlFor="modelType">模型类型</Label>
        {ModelBadge(modelDetail.modelSnapshot.modelType)}
      </div>
      <div className="grid grid-cols-4 items-center gap-4">
        <Label htmlFor="baseModel">基础模型</Label>
        {ModelBadge(modelDetail.modelSnapshot.baseModel)}
      </div>
    </div>
  )
}

export function DisplayModelDetails(modelSnapshot: ModelSnapshot) {
  return (
    <div className="grid w-full gap-4">
      <h3 className="self-stretch text-xl font-bold leading-10 text-black">模型介绍</h3>
      <p>{modelSnapshot.modelIntro}</p>
      <h3 className="self-stretch text-xl font-bold leading-10 text-black">模型详情</h3>
      <div className="grid grid-cols-4 items-center gap-4">
        <Label htmlFor="modelType">创建时间</Label>
        <p>{modelSnapshot.createTime}</p>
      </div>
      <div className="grid grid-cols-4 items-center gap-4">
        <Label htmlFor="modelType">模型类型</Label>
        {ModelBadge(modelSnapshot.modelType)}
      </div>
      <div className="grid grid-cols-4 items-center gap-4">
        <Label htmlFor="baseModel">基础模型</Label>
        {ModelBadge(modelSnapshot.baseModel)}
      </div>
      <div className="grid grid-cols-4 items-center gap-4">
        <Label htmlFor="modelSource">模型来源</Label>
        {ModelSourceBadge(modelSnapshot.source, modelSnapshot.trainingID)}
      </div>
    </div>
  )
}

export function ModelCard(modelSnapshot: ModelSnapshot) {
  return (
    <div className="ModelCard border-1 relative h-96 w-72 gap-2 overflow-hidden rounded-lg border shadow">
      <img
        alt={modelSnapshot.modelName}
        className="ProfileImg absolute inset-x-0 top-0 h-full w-full object-contain object-top hover:scale-110"
        key={'modelCard-' + modelSnapshot.imageURLs[0]}
        src={modelSnapshot.imageURLs[0]}
      />
      <div className="BottomCard absolute inset-x-0 bottom-0 flex h-auto flex-col items-center justify-end gap-1 self-stretch rounded-lg bg-neutral-600/80 px-3.5 py-1">
        <div className="ModelName self-stretch text-base font-semibold text-white">
          {modelSnapshot.modelName}
        </div>
        <div className="Badges inline-flex items-start justify-start gap-1.5 self-stretch">
          {ModelBadge(modelSnapshot.baseModel)}
          {ModelBadge(modelSnapshot.modelType)}
          {ModelSourceBadge(modelSnapshot.source, modelSnapshot.trainingID)}
        </div>
      </div>
    </div>
  )
}

export function ModelCoverCard(imageURL: string) {
  return (
    <div className="ModelCoverCard shadown border-1 relative h-96 w-72 gap-2 overflow-hidden rounded-lg border">
      <img
        className="ProfileImg absolute inset-x-0 top-0 h-auto w-auto object-contain"
        key={'modelCoverCard-' + imageURL}
        src={imageURL}
      />
    </div>
  )
}
export function ModelPresetCard(modelPreset: ModelPreset) {
  return (
    <div className="ModelPresetCard border-1 relative h-96 w-72 gap-2 overflow-hidden rounded-lg border shadow">
      <img
        className="ProfileImg absolute inset-x-0 top-0 h-auto w-auto object-contain"
        key={'modelPresetCard-' + modelPreset.imageURL}
        src={modelPreset.imageURL}
      />
      <div className="BottomCard absolute inset-x-0 bottom-0 flex h-auto flex-col items-center justify-end gap-1 self-stretch rounded-lg bg-neutral-600/80 px-3.5 py-1">
        <div className="ModelName self-stretch text-base font-semibold text-white">
          {modelPreset.presetUID}
        </div>
      </div>
    </div>
  )
}

export function ModelFilterPopover() {
  return (
    <Popover>
      <PopoverTrigger asChild>
        <Button variant="ghost">
          <FilterIcon />
        </Button>
      </PopoverTrigger>
      <PopoverContent className="w-auto">
        <div className="grid gap-4">
          <div className="grid gap-2">
            <Label htmlFor="modelType">模型类型</Label>
            <div className="grid grid-cols-2 items-center gap-2">
              <Toggle aria-label="Toggle italic h-4 text-base" variant="outline">
                LoRA
              </Toggle>
              <Toggle aria-label="Toggle italic h-4 text-base" variant="outline">
                大模型
              </Toggle>
            </div>
            <Label htmlFor="baseModel">基础模型</Label>
            <div className="grid grid-cols-2 items-center gap-2">
              <Toggle aria-label="Toggle italic h-4 text-base" variant="outline">
                SD 1.5
              </Toggle>
              <Toggle aria-label="Toggle italic h-4 w-auto text-base" variant="outline">
                SDXL 1.0
              </Toggle>
            </div>
            <Label htmlFor="modelSource">模型来源</Label>
            <div className="grid grid-cols-2 items-center gap-2">
              <Toggle aria-label="Toggle italic h-4 text-base" variant="outline">
                <img className="CivitaiIcon h-4" src={civitaiIcon} />
                Civitai
              </Toggle>
              <Toggle aria-label="Toggle italic h-4 text-base" variant="outline">
                <IconJarLogoIcon className="h-4" />
                训练
              </Toggle>
            </div>
          </div>
        </div>
      </PopoverContent>
    </Popover>
  )
}
