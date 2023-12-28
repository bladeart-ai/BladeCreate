import { Link, useParams } from 'react-router-dom'
import { Button } from '@/components/ui/button'
import {
  ModelCoverCard,
  ModelPresetCard,
  DisplayModelDetails,
} from '@/components/model'
import {
  ModelDataLoaderInst,
  ModelDetail,
  ModelPreset,
  ModelSnapshot,
} from '@/context/model'
import { Layout } from '@/components/layout'
import { useEffect, useState } from 'react'
import { LoaderDiv } from '@/components/page-loader'

function ModelVersionNav(modelDetail: ModelDetail) {
  return (
    <div className="VersionSelection w-full h-fit justify-start items-start gap-2.5 inline-flex flex-wrap">
      {modelDetail.modelVersionUIDs.map(versionUID => (
        <Link
          to={
            '/models/' + modelDetail.modelSnapshot.modelUID + '/' + versionUID
          }
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
    <div className="MainDisplay w-full h-fit justify-start items-start grid grid-cols-5 gap-3.5">
      <div className="col-span-3 grid py-2.5 gap-2.5">
        <h2 className="self-stretch text-black text-2xl font-semibold leading-10">
          样例展示
        </h2>
        <div className="overflow-y-scroll">
          <div className="w-fit justify-start items-start gap-5 inline-flex flex-row">
            {modelSnapshot.imageURLs.map(url => ModelCoverCard(url))}
          </div>
        </div>
      </div>
      <div className="col-span-2 inline-flex flex-col py-2.5 gap-2.5">
        <div className="ModelOperations w-full h-fit justify-end items-start inline-flex flex-wrap gap-2.5">
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
    <div className="ModelPresets w-full h-fit justify-start items-start inline-flex flex-col gap-3.5">
      <h2 className="self-stretch text-black text-2xl font-semibold leading-10">
        参数预设
      </h2>
      <div className="ModelPresetCards w-full h-fit justify-start items-start py-2.5 gap-2.5 inline-flex flex-wrap">
        {modelPresets.map(modelPreset => (
          <ModelPresetCard {...modelPreset} />
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
      <h1 className="self-stretch text-black text-3xl font-extrabold leading-10">
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
