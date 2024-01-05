import React from 'react'
import { Loader } from 'lucide-react'

export const LoaderDiv: React.FC = () => {
  return (
    <div className="flex h-full items-center justify-center">
      <Loader className="h-24 w-24 animate-spin" />
    </div>
  )
}
