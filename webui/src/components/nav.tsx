import { Link } from 'react-router-dom'
import { Button } from '@/components/ui/button'
import React, { useContext } from 'react'
import { IconProps } from '@radix-ui/react-icons/dist/types'
import { BackpackIcon, HobbyKnifeIcon } from '@radix-ui/react-icons'
import { LogoutButton } from './auth/logout'
import { Auth0Avatar } from './auth/auth0-avatar'
import logoPng from '@/public/logo.png?asset'
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

export function NavBarLogo() {
  return (
    <Link className="h-fit w-fit" to="/">
      <Button
        className="Logo inline-flex h-full w-24 flex-col items-start justify-start gap-2.5 p-2.5"
        key=""
        variant="ghost"
      >
        <img className="shrink grow basis-0 self-stretch" src={logoPng} />
      </Button>
    </Link>
  )
}

function NavBarItem({
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
    <div className="h-full w-fit">
      <Link to={path}>
        <Button
          className="inline-flex h-full w-fit items-center justify-center gap-1 p-2.5"
          key={label}
          variant="ghost"
        >
          {icon ? React.createElement(icon, { className: 'w-4 h-4 relative' }) : null}
          <span className="text-xl font-normal leading-7 text-black">{label}</span>
        </Button>
      </Link>
    </div>
  )
}

export function NavBar({ children }: { readonly children?: React.ReactNode }) {
  const { t } = useTranslation()

  return (
    <nav className="NavigationBar fixed top-0 z-50 inline-flex h-12 w-full items-center justify-start gap-1 border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <NavBarLogo />
      <NavBarItem icon={BackpackIcon} label={t('Models')} path="/models" />
      <NavBarItem icon={HobbyKnifeIcon} label={t('Projects')} path="/projects" />
      {children}
    </nav>
  )
}

export function NavBarWithUser() {
  const authCtx = useContext(AuthContext) as AuthContextType
  const { i18n } = useTranslation()

  return (
    <NavBar>
      <div className="flex shrink grow basis-0 items-center justify-end self-stretch px-3">
        {' '}
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
      </div>
    </NavBar>
  )
}
