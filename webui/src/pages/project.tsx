import { useParams } from 'react-router-dom'
import { Canvas } from '../components/canvas'
import { Toolbar } from '@/components/toolbar'
import { LayerListPanel } from '../components/layer-list-panel'
import { Panel, PanelGroup, PanelResizeHandle } from 'react-resizable-panels'
import { cs, ps } from '@/store/project-store'
import { LoaderDiv } from '@/components/page-loader'
import { useContext, useEffect } from 'react'
import { observer } from 'mobx-react-lite'
import { ProjectContextProvider } from '@/context/project-context'
import { AuthContext, AuthContextType } from '@/context/auth-context'
import { LayerResultPanel } from '@/components/layer-result-panel'
import { SidePanelSwitch } from '@/components/side-panel-switch'
import { GeneratePanel } from '@/components/generate-panel'

function CanvasPanelResizeHandle() {
  return <PanelResizeHandle className="h-full w-1" />
}

export const ProjectPage = observer(() => {
  const authCtx = useContext(AuthContext) as AuthContextType

  const { projectUUID } = useParams()

  useEffect(() => {
    if (!projectUUID) return

    ps.fetch(authCtx.user, projectUUID)
  }, [authCtx.user, projectUUID])

  if (ps.fetching) return <LoaderDiv />

  return (
    <ProjectContextProvider>
      <Toolbar />
      <PanelGroup autoSaveId="bladecreate" className="fixed pt-12" direction="horizontal">
        <SidePanelSwitch />
        {cs.sidePanelSwitch == 'layers' && (
          <>
            <Panel
              collapsible
              defaultSizePixels={300}
              id="layerlistpanel"
              maxSizePixels={400}
              minSizePixels={200}
              order={1}
            >
              <LayerListPanel />
            </Panel>
            <CanvasPanelResizeHandle />
          </>
        )}
        {cs.sidePanelSwitch == 'generate' && (
          <>
            <Panel
              collapsible
              defaultSizePixels={300}
              id="generatepanel"
              maxSizePixels={400}
              minSizePixels={200}
              order={2}
            >
              <GeneratePanel />
            </Panel>
            <CanvasPanelResizeHandle />
          </>
        )}
        <Panel id="canvaspanel" order={3}>
          <Canvas />
        </Panel>
        <CanvasPanelResizeHandle />
        <Panel
          defaultSizePixels={150}
          id="layerresultpanel"
          maxSizePixels={300}
          minSizePixels={150}
          order={4}
        >
          <LayerResultPanel />
        </Panel>
      </PanelGroup>
    </ProjectContextProvider>
  )
})

export const Component = ProjectPage
