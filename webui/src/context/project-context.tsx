import { createContext, useRef } from 'react'
import Konva from 'konva'

export interface ProjectContextType {
  imagesLayerRef: React.MutableRefObject<Konva.Layer | null>
}

export const ProjectContext = createContext<ProjectContextType | null>(null)

export function ProjectContextProvider({
  children,
}: {
  children: React.ReactNode
}) {
  const imagesLayerRef = useRef<Konva.Layer | null>(null)

  const ctx: ProjectContextType = {
    imagesLayerRef: imagesLayerRef,
  }

  return (
    <ProjectContext.Provider value={ctx}>{children}</ProjectContext.Provider>
  )
}
