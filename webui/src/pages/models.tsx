import { ModelDataLoaderInst, ModelSnapshot } from '../context/model'
import { ModelFilterPopover, ModelCard } from '../components/model'
import { AddModelFromCivitaiModal, AddModelFromFilesModal } from '@/components/add-model-modal'
import { Link } from 'react-router-dom'
import { Layout } from '@/components/layout'
import { useEffect, useState } from 'react'
import { LoaderDiv } from '@/components/page-loader'

function ModelsPage() {
  const [modelSnapshots, setModelSnapshots] = useState<ModelSnapshot[] | null>(null)

  useEffect(() => {
    setModelSnapshots(ModelDataLoaderInst.getModelSnapshots())
  }, [])

  if (!modelSnapshots) {
    return <LoaderDiv />
  }

  return (
    <Layout>
      <div className="inline-flex h-auto w-full items-start justify-start">
        <h1 className="w-full self-stretch text-3xl font-extrabold leading-10 text-black">
          所有模型
        </h1>
        <div className="inline-flex h-auto w-1/3 items-start justify-start gap-2">
          <AddModelFromCivitaiModal />
          <AddModelFromFilesModal />
        </div>
      </div>
      <div className="inline-flex h-auto w-full items-start justify-start">
        <p className="self-stretch text-base leading-10 text-black" />
        <ModelFilterPopover />
      </div>
      <div className="inline-flex h-full w-full flex-wrap items-start justify-start gap-5">
        {modelSnapshots.map((val) => (
          <Link key={val.modelUID} to={'/models/' + val.modelUID}>
            <ModelCard {...val} />
          </Link>
        ))}
      </div>
    </Layout>
  )
}

export const Component = ModelsPage

export default ModelsPage
