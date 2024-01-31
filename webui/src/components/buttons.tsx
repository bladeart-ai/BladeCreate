import { Button, buttonVariants } from '@/components/ui/button'
import { IconProps } from '@radix-ui/react-icons/dist/types'
import logoPng from '@/public/logo.png?asset'
import React from 'react'
import { Link } from 'react-router-dom'
import { VariantProps } from 'class-variance-authority'
import { cn } from '@/lib/utils'

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  readonly icon?: React.ForwardRefExoticComponent<
    IconProps & React.RefAttributes<SVGSVGElement>
  > | null
  readonly label?: string
  readonly selected?: boolean
  readonly asChild?: boolean
}

export const IconButton = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ icon = null, label = '', selected = false, ...props }: ButtonProps, ref) => {
    return (
      <Button
        className={cn(
          'inline-flex h-12 w-fit items-center justify-center gap-1 p-2.5',
          props.className
        )}
        key={label}
        ref={ref}
        variant={selected ? 'secondary' : 'ghost'}
        {...props}
      >
        {icon ? React.createElement(icon, { className: 'w-4 h-4 relative' }) : null}
        {label && <span className="text-xl font-normal leading-7 text-black">{label}</span>}
        {props.children}
      </Button>
    )
  }
)
IconButton.displayName = 'Button'

export function LogoButton() {
  return (
    <Link className="h-fit w-fit" to="/">
      <Button
        className="Logo inline-flex h-12 w-24 flex-col items-start justify-start gap-1 p-2.5"
        key=""
        variant="ghost"
      >
        <img className="shrink grow basis-0 self-stretch" src={logoPng} />
      </Button>
    </Link>
  )
}
