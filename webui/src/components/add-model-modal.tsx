import { Button } from '@/components/ui/button'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger
} from '@/components/ui/dialog'
import { Label } from '@/components/ui/label'
import { Textarea } from '@/components/ui/textarea'
import { ImportedModelDetails } from './model'
import { ModelDetail } from '../context/model'

const fakeModelDetail = {
  modelSnapshot: {
    modelUID: 'NewModel',
    versionUID: '8',
    modelName: 'Model Name',
    modelIntro: 'This is an intro',
    createTime: '',
    modelType: 'LoRA',
    baseModel: 'SD 1.5',
    source: 'Civitai',
    imageURLs: [],
    civitaiURL: 'http://umm',
    trainingID: null
  },
  modelVersionUIDs: ['8', '7', '8-inpainting', '7-inpainting'],
  modelPresets: []
} as ModelDetail

export function AddModelFromCivitaiModal() {
  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button>从Civitai导入</Button>
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>从Civitai导入</DialogTitle>
          <DialogDescription>
            设定Civitai模型的地址，点击检查可用按钮，最后点击确认提交。
          </DialogDescription>
        </DialogHeader>
        <div className="w-1000 grid gap-4 py-4">
          <div className="grid w-full gap-4">
            <Label htmlFor="civitaiURL">复制浏览器地址</Label>
            <Textarea
              id="civitaiURL"
              placeholder="https://civitai.com/models/4384?modelVersionId=128713"
            />
          </div>
          <ImportedModelDetails {...fakeModelDetail} />
        </div>
        <DialogFooter>
          <Button type="submit">导入</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}

export function AddModelFromFilesModal() {
  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button>上传模型文件</Button>
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>上传模型文件</DialogTitle>
          <DialogDescription>上传模型文件，点击检查可用按钮，最后点击确认提交。</DialogDescription>
        </DialogHeader>
        <div className="w-1000 grid gap-4 py-4">
          <div className="grid w-full gap-4">[占位：文件上传器]</div>
          <ImportedModelDetails {...fakeModelDetail} />
        </div>
        <DialogFooter>
          <Button type="submit">导入</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
