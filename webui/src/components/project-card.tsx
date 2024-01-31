import { Project } from '@/gen_client'

export function ProjectCard(project: Project) {
  return (
    <div className="flex h-fit w-full flex-col items-center justify-end gap-1 rounded-lg bg-neutral-600/80 px-3.5 py-1">
      <div className="self-stretch text-base font-semibold text-white">{project.name}</div>
      <div className="inline-flex items-start justify-start gap-1.5 self-stretch text-white">
        {project.update_time}
      </div>
    </div>
  )
}
