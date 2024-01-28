import { cs } from '@/store/project-store'
import { LayersIcon, LightningBoltIcon } from '@radix-ui/react-icons'
import { action } from 'mobx'
import { observer } from 'mobx-react-lite'
import { IconButton } from './buttons'

export const SidePanelSwitch = observer(() => {
  return (
    <div className="z-50 inline-flex h-full w-fit flex-col items-center justify-start border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <IconButton
        icon={LayersIcon}
        selected={cs.sidePanelSwitch == 'layers'}
        onClick={action(() =>
          cs.sidePanelSwitch === 'layers' ? cs.switchSidePanel('') : cs.switchSidePanel('layers')
        )}
      />
      <IconButton
        icon={LightningBoltIcon}
        selected={cs.sidePanelSwitch == 'generate'}
        onClick={action(() =>
          cs.sidePanelSwitch === 'generate'
            ? cs.switchSidePanel('')
            : cs.switchSidePanel('generate')
        )}
      />
    </div>
  )
})
