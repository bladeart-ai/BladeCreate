import { Layout } from '@/components/layout'

interface UseCaseCardProps {
  readonly label: string
}
function UseCaseCard(props: UseCaseCardProps) {
  return (
    <div className="inline-flex flex-col items-center justify-center gap-1">
      <div className="h-60 w-72 bg-zinc-300" />
      <div className="h-6 w-72 text-center text-lg font-semibold leading-7 text-black">
        {props.label}
      </div>
    </div>
  )
}
function WelcomePage() {
  return (
    <Layout>
      <h1 className="self-stretch text-3xl font-extrabold leading-10 text-black">
        欢迎使用BladeCreate创作平台
      </h1>
      <div className="self-stretch text-xl font-normal leading-7 text-black">
        BladeCreate是针对创意美术工作流的AI创作工具。
      </div>
      <div className="text-xl font-semibold leading-9 text-black">使用范例</div>
      <div className="inline-flex flex-wrap items-start justify-start gap-5 self-stretch">
        <UseCaseCard label="复杂、创意性构图的制作" />
        <UseCaseCard label="AI辅助的素材生成和拼接" />
        <UseCaseCard label="寻找最优的模型和生成参数" />
        <UseCaseCard label="强大高效的模型训练" />
      </div>
    </Layout>
  )
}

export const Component = WelcomePage

export default WelcomePage
