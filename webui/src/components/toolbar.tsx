import { TextSpan } from '@/components/text'
import { DownloadIcon, UploadIcon } from '@radix-ui/react-icons'
import { Button } from '@/components/ui/button'
import { cs, ps } from '@/store/project-store'
import { observer } from 'mobx-react-lite'
import { ProjectContext, ProjectContextType } from '@/context/project-context'
import { useContext, useState } from 'react'
import { action } from 'mobx'
import { ImageListType } from 'react-images-uploading'
import ImageUploading from 'react-images-uploading'
import { NavBarLogo } from './nav'

export const Toolbar = observer(() => {
  const ctx = useContext(ProjectContext) as ProjectContextType

  const [uploadImageBuffer, setUploadImageBuffer] = useState([])
  const onUploadingChange = action(
    (imageList: ImageListType, addUpdateIndex: number[] | undefined) => {
      // data for submit
      addUpdateIndex?.forEach(i => {
        let name = imageList[i].file?.name
        if (!name) {
          name = ''
        }
        ps.createLayerFromLocalImage(name, imageList[i].data_url)
      })
      setUploadImageBuffer([])
    }
  )

  const handleExport = () => {
    const url = ps.exportLayersToDataURL(ctx.imagesLayerRef)
    const link = document.createElement('a')
    link.download = ps.project?.name + '.png'
    link.href = url
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
  }

  return (
    <div className="fixed top-0 z-50 w-full h-12 gap-1 border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60 justify-start items-center inline-flex">
      <div className="grow shrink basis-0 self-stretch flex justify-start items-center">
        <NavBarLogo />
      </div>
      <ImageUploading
        multiple
        value={uploadImageBuffer}
        onChange={onUploadingChange}
        maxNumber={10}
        dataURLKey="data_url"
      >
        {({ onImageUpload }) => (
          <div className="upload__image-wrapper">
            <Button variant="ghost" size="icon" onClick={onImageUpload}>
              <UploadIcon className="m-2.5" />
            </Button>
          </div>
        )}
      </ImageUploading>
      <div className="grow shrink basis-0 self-stretch flex justify-end items-center">
        <Button variant="ghost" size="icon" onClick={handleExport}>
          <DownloadIcon className="m-2.5" />
        </Button>
        <TextSpan className="p-2" text={Math.floor(cs.scale * 100) + '%'} />
      </div>
    </div>
  )
})
