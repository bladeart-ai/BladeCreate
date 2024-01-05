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
      addUpdateIndex?.forEach((i) => {
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
    <div className="fixed top-0 z-50 inline-flex h-12 w-full items-center justify-start gap-1 border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div className="flex shrink grow basis-0 items-center justify-start self-stretch">
        <NavBarLogo />
      </div>
      <ImageUploading
        dataURLKey="data_url"
        maxNumber={10}
        multiple
        onChange={onUploadingChange}
        value={uploadImageBuffer}
      >
        {({ onImageUpload }) => (
          <div className="upload__image-wrapper">
            <Button onClick={onImageUpload} size="icon" variant="ghost">
              <UploadIcon className="m-2.5" />
            </Button>
          </div>
        )}
      </ImageUploading>
      <div className="flex shrink grow basis-0 items-center justify-end self-stretch">
        <Button onClick={handleExport} size="icon" variant="ghost">
          <DownloadIcon className="m-2.5" />
        </Button>
        <TextSpan className="p-2" text={Math.floor(cs.scale * 100) + '%'} />
      </div>
    </div>
  )
})
