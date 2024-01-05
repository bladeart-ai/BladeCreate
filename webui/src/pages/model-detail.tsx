import { Link, useParams } from 'react-router-dom'
import { Button } from '@/components/ui/button'
import { ModelCoverCard, ModelPresetCard, DisplayModelDetails } from '@/components/model'
import { ModelDataLoaderInst, ModelDetail, ModelPreset, ModelSnapshot } from '@/context/model'
import { Layout } from '@/components/layout'
import { useEffect, useState } from 'react'
import { LoaderDiv } from '@/components/page-loader'

function ModelVersionNav(modelDetail: ModelDetail) {
  return (
    <div className="inline-flex h-fit w-full flex-wrap items-start justify-start gap-2.5">
      {modelDetail.modelVersionUIDs.map((versionUID) => (
        <Link
          key={'model_version_link_' + versionUID}
          to={'/models/' + modelDetail.modelSnapshot.modelUID + '/' + versionUID}
        >
          {modelDetail.modelSnapshot.versionUID == versionUID ? (
            <Button>{versionUID}</Button>
          ) : (
            <Button variant="secondary">{versionUID}</Button>
          )}
        </Link>
      ))}
    </div>
  )
}
function ModelSnapshot(modelSnapshot: ModelSnapshot) {
  return (
    <div className="grid h-fit w-full grid-cols-5 items-start justify-start gap-3.5">
      <div className="col-span-3 grid gap-2.5 py-2.5">
        <h2 className="self-stretch text-2xl font-semibold leading-10 text-black">样例展示</h2>
        <div className="overflow-y-scroll">
          <div className="inline-flex w-fit flex-row items-start justify-start gap-5">
            {modelSnapshot.imageURLs.map((url) => ModelCoverCard(url))}
          </div>
        </div>
      </div>
      <div className="col-span-2 inline-flex flex-col gap-2.5 py-2.5">
        <div className="inline-flex h-fit w-full flex-wrap items-start justify-end gap-2.5">
          <Button>下载</Button>
          <Button>生成与比较</Button>
          <Button variant="destructive">删除</Button>
        </div>
        <DisplayModelDetails {...modelSnapshot} />
      </div>
    </div>
  )
}

function ModelPresets(modelPresets: ModelPreset[]) {
  return (
    <div className="inline-flex h-fit w-full flex-col items-start justify-start gap-3.5">
      <h2 className="self-stretch text-2xl font-semibold leading-10 text-black">参数预设</h2>
      <div className="inline-flex h-fit w-full flex-wrap items-start justify-start gap-2.5 py-2.5">
        {modelPresets.map((modelPreset) => (
          <ModelPresetCard
            key={'model_preset_card_' + modelPreset.modelUID + '_' + modelPreset.presetUID}
            {...modelPreset}
          />
        ))}
      </div>
    </div>
  )
}

function ModelDetailPage() {
  const { modelUID, versionUID } = useParams()

  const [modelDetail, setModelDetail] = useState<ModelDetail | null>(null)

  useEffect(() => {
    if (!modelUID) {
      return
    }

    setModelDetail(ModelDataLoaderInst.getModelDetail(modelUID, versionUID))
  }, [modelUID, versionUID])

  if (!modelDetail) {
    return <LoaderDiv />
  }

  return (
    <Layout>
      <h1 className="self-stretch text-3xl font-extrabold leading-10 text-black">
        模型详情 - {modelDetail.modelSnapshot.modelName}
      </h1>
      {ModelVersionNav(modelDetail)}
      {ModelSnapshot(modelDetail.modelSnapshot)}
      {ModelPresets(modelDetail.modelPresets)}
    </Layout>
  )
}

export const Component = ModelDetailPage

export default ModelDetailPage
