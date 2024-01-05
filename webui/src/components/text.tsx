import { cn } from '@/lib/utils'

export function TextSpan({
  className = '',
  text
}: {
  readonly className?: string
  readonly text: string
}) {
  return (
    <p className={cn('truncate text-black text-sm font-medium leading-tight', className)}>{text}</p>
  )
}
