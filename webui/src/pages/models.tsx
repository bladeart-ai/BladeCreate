import { ModelDataLoaderInst, ModelSnapshot } from '../context/model'
import { ModelFilterPopover, ModelCard } from '../components/model'
import {
  AddModelFromCivitaiModal,
  AddModelFromFilesModal,
} from '@/components/add-model-modal'
import { Link } from 'react-router-dom'
import { Layout } from '@/components/layout'
import { useEffect, useState } from 'react'
import { LoaderDiv } from '@/components/page-loader'

function ModelsPage() {
  const [modelSnapshots, setModelSnapshots] = useState<ModelSnapshot[] | null>(
    null
  )

  useEffect(() => {
    setModelSnapshots(ModelDataLoaderInst.getModelSnapshots())
  }, [])

  if (!modelSnapshots) {
    return <LoaderDiv />
  }

  return (
    <Layout>
      <div className="w-full h-auto justify-start items-start inline-flex">
        <h1 className="w-full self-stretch text-black text-3xl font-extrabold leading-10">
          所有模型
        </h1>
        <div className="w-1/3 h-auto justify-start items-start inline-flex gap-2">
          <AddModelFromCivitaiModal />
          <AddModelFromFilesModal />
        </div>
      </div>
      <div className="w-full h-auto justify-start items-start inline-flex">
        <p className="self-stretch text-black text-base leading-10"></p>
        <ModelFilterPopover />
      </div>
      <div className="w-full h-full justify-start items-start gap-5 inline-flex flex-wrap">
        {modelSnapshots.map(val => (
          <Link key={val.modelUID} to={'/models/' + val.modelUID}>
            <ModelCard {...val}></ModelCard>
          </Link>
        ))}
      </div>
    </Layout>
  )
}

export const Component = ModelsPage

export default ModelsPage
