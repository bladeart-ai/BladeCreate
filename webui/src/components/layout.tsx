import { ReactNode } from 'react'
import { NavBar } from '@/components/layout-top'

export function Layout({ children }: { readonly children: ReactNode }) {
  return (
    <div>
      <NavBar />
      <main className="MainFrame inline-flex h-full w-full flex-col items-start justify-start gap-3.5 px-3.5 pb-10 pt-20">
        {children}
      </main>
    </div>
  )
}
