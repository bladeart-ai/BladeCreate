import { Button } from '@/components/ui/button'
import { cs } from '@/store/project-store'
import { LayersIcon, LightningBoltIcon } from '@radix-ui/react-icons'
import { action } from 'mobx'
import { observer } from 'mobx-react-lite'
import { ReactNode } from 'react'

export const SidePanelSwitch = () => {
  const SelectableButton = observer(
    ({ switchVal, children }: { switchVal: string; children: ReactNode }) => {
      const onClick = action(() => {
        if (cs.sidePanelSwitch == switchVal) {
          cs.switchSidePanel('')
        } else {
          cs.switchSidePanel(switchVal)
        }
      })

      if (cs.sidePanelSwitch == switchVal)
        return (
          <Button
            variant="secondary"
            className="w-12 h-12 p-4 gap-1 justify-center items-center inline-flex"
            onClick={onClick}
          >
            {children}
          </Button>
        )

      return (
        <Button
          variant="ghost"
          className="w-12 h-12 p-4 gap-1 justify-center items-center inline-flex"
          onClick={onClick}
        >
          {children}
        </Button>
      )
    }
  )

  return (
    <div className="z-50 w-fit h-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60 justify-start items-center inline-flex flex-col">
      <SelectableButton switchVal="layers">
        <LayersIcon className="w-4 h-4" />
      </SelectableButton>
      <SelectableButton switchVal="generate">
        <LightningBoltIcon className="w-4 h-4" />
      </SelectableButton>
    </div>
  )
}
