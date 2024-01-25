import { LogoutButton } from './auth/logout'
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
import { Link } from 'react-router-dom'
import React, { useContext } from 'react'
import { IconProps } from '@radix-ui/react-icons/dist/types'
import { BackpackIcon, HobbyKnifeIcon } from '@radix-ui/react-icons'
import { IconButton } from './buttons'
import { LogoButton } from './buttons'

export function UserDropdown() {
  const authCtx = useContext(AuthContext) as AuthContextType
  const { i18n } = useTranslation()
  return (
    <DropdownMenu>
      <DropdownMenuTrigger>
        <Auth0Avatar />
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
            <span>Languages</span>
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
        {authCtx.authed && (
          <DropdownMenuItem>
            <LogoutButton />
          </DropdownMenuItem>
        )}
      </DropdownMenuContent>
    </DropdownMenu>
  )
}

export function TopBar({ children }: { readonly children?: React.ReactNode }) {
  return (
    <nav className="fixed top-0 z-50 inline-flex h-12 w-full items-center justify-start gap-1 border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <LogoButton />
      {children}
    </nav>
  )
}

export function ShrinkDiv() {
  return <div className="flex shrink grow basis-0 items-center justify-end self-stretch" />
}

export function NavButton({
  icon,
  path,
  label
}: {
  readonly icon: React.ForwardRefExoticComponent<
    IconProps & React.RefAttributes<SVGSVGElement>
  > | null
  readonly path: string
  readonly label: string
}) {
  return (
    <Link to={path}>
      <IconButton icon={icon} label={label} />
    </Link>
  )
}

export function NavBar({ userDropDown = true }: { userDropDown?: boolean }) {
  const { t } = useTranslation()

  return (
    <TopBar>
      <NavButton icon={BackpackIcon} label={t('Models')} path="/models" />
      <NavButton icon={HobbyKnifeIcon} label={t('Projects')} path="/projects" />
      <ShrinkDiv />
      {userDropDown && <UserDropdown />}
    </TopBar>
  )
}
