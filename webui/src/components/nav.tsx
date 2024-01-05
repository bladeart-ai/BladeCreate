import { Link } from 'react-router-dom'
import { Button } from '@/components/ui/button'
import React from 'react'
import { IconProps } from '@radix-ui/react-icons/dist/types'
import { BackpackIcon, HobbyKnifeIcon } from '@radix-ui/react-icons'
import { LogoutButton } from './auth/logout'
import { Auth0Avatar } from './auth/auth0-avatar'
import { DISABLE_AUTH } from '@/config'
import logoPng from '../../resources/logo.png?asset'

interface NavItem {
  readonly icon: React.ForwardRefExoticComponent<
    IconProps & React.RefAttributes<SVGSVGElement>
  > | null
  readonly path: string
  readonly label: string
}

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
function NavBarItem(props: NavItem) {
  return (
    <div className="h-full w-fit">
      <Link to={props.path}>
        <Button
          className="inline-flex h-full w-fit items-center justify-center gap-1 p-2.5"
          key={props.label}
          variant="ghost"
        >
          {props.icon ? React.createElement(props.icon, { className: 'w-4 h-4 relative' }) : null}
          <span className="text-xl font-normal leading-7 text-black">{props.label}</span>
        </Button>
      </Link>
    </div>
  )
}

const navItems: NavItem[] = [
  {
    icon: BackpackIcon,
    label: '模型',
    path: '/models'
  },
  {
    icon: HobbyKnifeIcon,
    label: '创作',
    path: '/projects'
  }
]

export function NavBar({ children }: { readonly children?: React.ReactNode }) {
  return (
    <nav className="NavigationBar fixed top-0 z-50 inline-flex h-12 w-full items-center justify-start gap-1 border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <NavBarLogo />
      {navItems.map((item) => (
        <NavBarItem key={item.path} {...item} />
      ))}
      {children}
    </nav>
  )
}

export function NavigationBar() {
  if (DISABLE_AUTH) {
    return <NavBar />
  }
  return (
    <NavBar>
      <div className="flex shrink grow basis-0 items-center justify-end self-stretch px-3">
        {' '}
        <LogoutButton />
        <Auth0Avatar />
      </div>
    </NavBar>
  )
}
