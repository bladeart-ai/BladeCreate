import { ProjectMetadata } from '@/gen_client'

export function ProjectCard(project: ProjectMetadata) {
  return (
    <div className="ModelCard w-96 h-72 rounded-lg shadow border border-1 gap-2 relative overflow-hidden">
      <div className="BottomCard bg-neutral-600/80 self-stretch h-auto px-3.5 py-1 rounded-lg flex-col justify-end items-center gap-1 flex absolute inset-x-0 bottom-0">
        <div className="ModelName self-stretch text-white text-base font-semibold">
          {project.name}
        </div>
        <div className="Badges self-stretch text-white justify-start items-start gap-1.5 inline-flex">
          {project.update_time}
        </div>
      </div>
    </div>
  )
}
