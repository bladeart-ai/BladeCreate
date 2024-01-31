import { Auth0Avatar } from './auth/auth0-avatar'
import { Trans, useTranslation } from 'react-i18next'
import { AuthContext, AuthContextType } from '@/context/auth-context'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuPortal,
  DropdownMenuRadioGroup,
  DropdownMenuRadioItem,
  DropdownMenuSeparator,
  DropdownMenuSub,
  DropdownMenuSubContent,
  DropdownMenuSubTrigger,
  DropdownMenuTrigger
} from '@/components/ui/dropdown-menu'
import React, { useContext } from 'react'
import { IconButton, LogoButton } from './buttons'
import { Loader2 } from 'lucide-react'
import { csts } from '@/store/cluster-store'
import { GoDotFill } from 'react-icons/go'
import { observer } from 'mobx-react-lite'

export const ClusterStatusDropdown = observer(() => {
  const { t } = useTranslation()

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <IconButton>
          {csts.status === 'busy' ? (
            <Loader2 className="animate-spin" color="green" />
          ) : csts.status === 'idle' ? (
            <GoDotFill color="green" />
          ) : (
            <GoDotFill color="red" />
          )}
        </IconButton>
      </DropdownMenuTrigger>
      <DropdownMenuContent>
        <DropdownMenuLabel>
          {csts.status === 'busy' ? t('Busy') : csts.status === 'idle' ? t('Idle') : t('Loading')}
        </DropdownMenuLabel>
        <DropdownMenuLabel>
          {t('Active Workers') + ': ' + csts.workersStatus.length}
        </DropdownMenuLabel>
        {csts.workersStatus.length > 0 && <DropdownMenuSeparator />}
        {csts.workersStatus.map((wk) => (
          <DropdownMenuItem key={'worker_dropdown' + wk.uuid}>
            {t('Worker') + ' ' + wk.uuid + ': ' + wk.status}
          </DropdownMenuItem>
        ))}
        {csts.workersStatus.length > 0 && <DropdownMenuSeparator />}
        {csts.activeJobs.length > 0 && <DropdownMenuSeparator />}
        <DropdownMenuLabel>{t('Active Jobs') + ': ' + csts.activeJobs.length}</DropdownMenuLabel>
        {csts.activeJobs.map((j) => (
          <DropdownMenuItem key={'cluster_job_dropdown' + j.uuid}>
            {j.uuid + ': ' + j.status}
          </DropdownMenuItem>
        ))}
      </DropdownMenuContent>
    </DropdownMenu>
  )
})

export function UserDropdown() {
  const authCtx = useContext(AuthContext) as AuthContextType
  const { t, i18n } = useTranslation()
  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <IconButton>
          <Auth0Avatar />
        </IconButton>
      </DropdownMenuTrigger>
      <DropdownMenuContent>
        <DropdownMenuLabel>
          {authCtx.user.sub === 'guest' ? (
            <Trans i18nKey="WelcomeGuestUser" />
          ) : (
            <Trans i18nKey="WelcomeUser" values={{ user: authCtx.user.name }} />
          )}
        </DropdownMenuLabel>
        <DropdownMenuSeparator />
        <DropdownMenuSub>
          <DropdownMenuSubTrigger>
            <span>{t('Languages')}</span>
          </DropdownMenuSubTrigger>
          <DropdownMenuPortal>
            <DropdownMenuSubContent>
              <DropdownMenuRadioGroup
                value={i18n.resolvedLanguage}
                onValueChange={(val) => i18n.changeLanguage(val)}
              >
                <DropdownMenuRadioItem value="en">EN</DropdownMenuRadioItem>
                <DropdownMenuRadioItem value="zh">中文</DropdownMenuRadioItem>
              </DropdownMenuRadioGroup>
            </DropdownMenuSubContent>
          </DropdownMenuPortal>
        </DropdownMenuSub>
      </DropdownMenuContent>
    </DropdownMenu>
  )
}

export function TopBar({ children }: { readonly children?: React.ReactNode }) {
  return (
    <nav className="fixed top-0 z-50 inline-flex h-12 w-full items-center justify-start border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <LogoButton />
      {children}
    </nav>
  )
}

export function ShrinkDiv() {
  return <div className="flex shrink grow basis-0 items-center justify-end self-stretch" />
}
