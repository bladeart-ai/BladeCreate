import { Button } from '@/components/ui/button'
import { Label } from '@/components/ui/label'
import { CheckCircle2Icon, FilterIcon } from 'lucide-react'
import { Input } from '@/components/ui/input'
import { Toggle } from '@/components/ui/toggle'
import { ModelDetail, ModelPreset, ModelSnapshot } from '../context/model'
import { Badge } from '@/components/ui/badge'
import { IconJarLogoIcon } from '@radix-ui/react-icons'
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from '@/components/ui/popover'

export function ModelBadge(text: string) {
  return <Badge className="w-fit h-6 gap-1 text-base">{text}</Badge>
}

export function ModelSourceBadge(source: string, trainingUID: string | null) {
  {
    if (source == 'training') {
      return (
        <Badge className="w-fit h-6 gap-1 text-base">
          <IconJarLogoIcon className="h-4" />
          <div className="text-base">
            {trainingUID == null ? '训练' : '训练 ' + trainingUID}
          </div>
        </Badge>
      )
    } else if (source == 'civitai') {
      return (
        <Badge className="w-fit h-6 gap-1 text-base">
          <img className="CivitaiIcon h-4" src="/civitai_icon.png" />
          <div className="text-base">Civitai</div>
        </Badge>
      )
    } else {
      return (
        <Badge className="w-fit h-6 gap-1 text-base">
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
        <CheckCircle2Icon></CheckCircle2Icon>
      </div>
      <div className="grid grid-cols-4 items-center gap-4">
        <Label htmlFor="modelName">模型名称</Label>
        <Input id="modelName" value="" className="col-span-3" />
      </div>
      <div className="grid grid-cols-4 items-center gap-4">
        <Label htmlFor="modelVersion">模型版本</Label>

        <div className="col-span-3 gap-2 inline-flex flex-wrap">
          {modelDetail.modelVersionUIDs.map(versionUID =>
            modelDetail.modelSnapshot.versionUID == versionUID ? (
              <Toggle
                variant="outline"
                aria-label="Toggle italic"
                key={'importedModelDetails_' + versionUID}
                defaultPressed={true}
              >
                {versionUID}
              </Toggle>
            ) : (
              <Toggle
                variant="outline"
                aria-label="Toggle italic"
                key={'importedModelDetails_' + versionUID}
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
      <h3 className="self-stretch text-black text-xl font-bold leading-10">
        模型介绍
      </h3>
      <p>{modelSnapshot.modelIntro}</p>
      <h3 className="self-stretch text-black text-xl font-bold leading-10">
        模型详情
      </h3>
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
    <div className="ModelCard w-72 h-96 rounded-lg shadow border border-1 gap-2 relative overflow-hidden">
      <img
        className="ProfileImg w-full h-full object-contain object-top hover:scale-110 absolute inset-x-0 top-0"
        key={'modelCard-' + modelSnapshot.imageURLs[0]}
        alt={modelSnapshot.modelName}
        src={modelSnapshot.imageURLs[0]}
      />
      <div className="BottomCard bg-neutral-600/80 self-stretch h-auto px-3.5 py-1 rounded-lg flex-col justify-end items-center gap-1 flex absolute inset-x-0 bottom-0">
        <div className="ModelName self-stretch text-white text-base font-semibold">
          {modelSnapshot.modelName}
        </div>
        <div className="Badges self-stretch justify-start items-start gap-1.5 inline-flex">
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
    <div className="ModelCoverCard w-72 h-96 rounded-lg shadown border border-1 gap-2 relative overflow-hidden">
      <img
        className="ProfileImg w-auto h-auto object-contain absolute inset-x-0 top-0"
        key={'modelCoverCard-' + imageURL}
        src={imageURL}
      />
    </div>
  )
}
export function ModelPresetCard(modelPreset: ModelPreset) {
  return (
    <div className="ModelPresetCard w-72 h-96 rounded-lg shadow border border-1 gap-2 relative overflow-hidden">
      <img
        className="ProfileImg w-auto h-auto object-contain absolute inset-x-0 top-0"
        key={'modelPresetCard-' + modelPreset.imageURL}
        src={modelPreset.imageURL}
      />
      <div className="BottomCard bg-neutral-600/80 self-stretch h-auto px-3.5 py-1 rounded-lg flex-col justify-end items-center gap-1 flex absolute inset-x-0 bottom-0">
        <div className="ModelName self-stretch text-white text-base font-semibold">
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
          <FilterIcon></FilterIcon>
        </Button>
      </PopoverTrigger>
      <PopoverContent className="w-auto">
        <div className="grid gap-4">
          <div className="grid gap-2">
            <Label htmlFor="modelType">模型类型</Label>
            <div className="grid grid-cols-2 items-center gap-2">
              <Toggle
                variant="outline"
                aria-label="Toggle italic h-4 text-base"
              >
                LoRA
              </Toggle>
              <Toggle
                variant="outline"
                aria-label="Toggle italic h-4 text-base"
              >
                大模型
              </Toggle>
            </div>
            <Label htmlFor="baseModel">基础模型</Label>
            <div className="grid grid-cols-2 items-center gap-2">
              <Toggle
                variant="outline"
                aria-label="Toggle italic h-4 text-base"
              >
                SD 1.5
              </Toggle>
              <Toggle
                variant="outline"
                aria-label="Toggle italic h-4 w-auto text-base"
              >
                SDXL 1.0
              </Toggle>
            </div>
            <Label htmlFor="modelSource">模型来源</Label>
            <div className="grid grid-cols-2 items-center gap-2">
              <Toggle
                variant="outline"
                aria-label="Toggle italic h-4 text-base"
              >
                <img className="CivitaiIcon h-4" src="/civitai_icon.png" />
                Civitai
              </Toggle>
              <Toggle
                variant="outline"
                aria-label="Toggle italic h-4 text-base"
              >
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
