import { ReactNode } from 'react'
import { NavigationBar } from '@/components/nav'

export function Layout({ children }: { children: ReactNode }) {
  return (
    <div>
      <NavigationBar />
      <main className="MainFrame w-full h-full pt-20 pb-10 px-3.5 flex-col justify-start items-start gap-3.5 inline-flex">
        {children}
      </main>
    </div>
  )
}
