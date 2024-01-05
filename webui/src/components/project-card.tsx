import { ProjectMetadata } from '@/gen_client'

export function ProjectCard(project: ProjectMetadata) {
  return (
    <div className="ModelCard border-1 relative h-72 w-96 gap-2 overflow-hidden rounded-lg border shadow">
      <div className="BottomCard absolute inset-x-0 bottom-0 flex h-auto flex-col items-center justify-end gap-1 self-stretch rounded-lg bg-neutral-600/80 px-3.5 py-1">
        <div className="ModelName self-stretch text-base font-semibold text-white">
          {project.name}
        </div>
        <div className="Badges inline-flex items-start justify-start gap-1.5 self-stretch text-white">
          {project.update_time}
        </div>
      </div>
    </div>
  )
}
