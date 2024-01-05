import { Button } from '@/components/ui/button'
import { cs } from '@/store/project-store'
import { LayersIcon, LightningBoltIcon } from '@radix-ui/react-icons'
import { action } from 'mobx'
import { observer } from 'mobx-react-lite'
import { ReactNode } from 'react'

export function SidePanelSwitch() {
  const SelectableButton = observer(
    ({ switchVal, children }: { readonly switchVal: string; readonly children: ReactNode }) => {
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
            className="inline-flex h-12 w-12 items-center justify-center gap-1 p-4"
            onClick={onClick}
            variant="secondary"
          >
            {children}
          </Button>
        )

      return (
        <Button
          className="inline-flex h-12 w-12 items-center justify-center gap-1 p-4"
          onClick={onClick}
          variant="ghost"
        >
          {children}
        </Button>
      )
    }
  )

  return (
    <div className="z-50 inline-flex h-full w-fit flex-col items-center justify-start border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <SelectableButton switchVal="layers">
        <LayersIcon className="h-4 w-4" />
      </SelectableButton>
      <SelectableButton switchVal="generate">
        <LightningBoltIcon className="h-4 w-4" />
      </SelectableButton>
    </div>
  )
}
