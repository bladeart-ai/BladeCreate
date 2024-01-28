import { TextSpan } from '@/components/text'
import { DownloadIcon, UploadIcon } from '@radix-ui/react-icons'
import { cs } from '@/store/project-store'
import { observer } from 'mobx-react-lite'
import { ProjectContext, ProjectContextType } from '@/context/project-context'
import { useContext, useState } from 'react'
import { action } from 'mobx'
import { ImageListType } from 'react-images-uploading'
import ImageUploading from 'react-images-uploading'
import { ClusterStatusDropdown, ShrinkDiv, TopBar, UserDropdown } from './layout-top'
import { IconButton } from './buttons'

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
        cs.ps.createLayer(undefined, name, imageList[i].data_url)
      })
      setUploadImageBuffer([])
    }
  )

  const handleExport = action(() => {
    const url = cs.exportLayersToDataURL(ctx.imagesLayerRef)
    const link = document.createElement('a')
    link.download = cs.ps.project?.name + '.png'
    link.href = url
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
  })

  return (
    <TopBar>
      <ShrinkDiv />
      <ImageUploading
        dataURLKey="data_url"
        maxNumber={10}
        multiple
        onChange={onUploadingChange}
        value={uploadImageBuffer}
      >
        {({ onImageUpload }) => (
          <div className="upload__image-wrapper">
            <IconButton icon={UploadIcon} onClick={onImageUpload} />
          </div>
        )}
      </ImageUploading>
      <ShrinkDiv />
      <IconButton icon={DownloadIcon} onClick={handleExport} />
      <TextSpan className="p-2" text={Math.floor(cs.scale * 100) + '%'} />
      <ClusterStatusDropdown />
      <UserDropdown />
    </TopBar>
  )
})
