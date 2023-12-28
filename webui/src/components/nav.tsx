import { Link } from 'react-router-dom'
import { Button } from '@/components/ui/button'
import React from 'react'
import { IconProps } from '@radix-ui/react-icons/dist/types'
import { BackpackIcon, HobbyKnifeIcon } from '@radix-ui/react-icons'
import { LogoutButton } from './auth/logout'
import { Auth0Avatar } from './auth/auth0-avatar'
import { DISABLE_AUTH } from '@/config'

interface NavItem {
  icon: React.ForwardRefExoticComponent<
    IconProps & React.RefAttributes<SVGSVGElement>
  > | null
  path: string
  label: string
}

export function NavBarLogo() {
  return (
    <Link className="w-fit h-fit" to="/">
      <Button
        variant="ghost"
        className="Logo w-24 h-full p-2.5 flex-col justify-start items-start gap-2.5 inline-flex"
        key=""
      >
        <img className="self-stretch grow shrink basis-0" src="/logo.png" />
      </Button>
    </Link>
  )
}
function NavBarItem(props: NavItem) {
  return (
    <div className="w-fit h-full">
      <Link to={props.path}>
        <Button
          variant="ghost"
          className="w-fit h-full p-2.5 gap-1 justify-center items-center inline-flex"
          key={props.label}
        >
          {props.icon &&
            React.createElement(props.icon, { className: 'w-4 h-4 relative' })}
          <span className="text-black text-xl font-normal leading-7">
            {props.label}
          </span>
        </Button>
      </Link>
    </div>
  )
}

const navItems: NavItem[] = [
  {
    icon: BackpackIcon,
    label: '模型',
    path: '/models',
  },
  {
    icon: HobbyKnifeIcon,
    label: '创作',
    path: '/projects',
  },
]

export const NavBar = ({ children }: { children?: React.ReactNode }) => {
  return (
    <nav className="NavigationBar fixed top-0 z-50 w-full h-12 gap-1 border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60 justify-start items-center inline-flex">
      <NavBarLogo />
      {navItems.map(item => (
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
      <div className="grow shrink basis-0 self-stretch px-3 justify-end items-center flex">
        {' '}
        <LogoutButton />
        <Auth0Avatar />
      </div>
    </NavBar>
  )
}
