import React from 'react'
import { Loader } from 'lucide-react'

export const LoaderDiv: React.FC = () => {
  return (
    <div className="flex justify-center items-center h-full">
      <Loader className="animate-spin h-24 w-24" />
    </div>
  )
}
