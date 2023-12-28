import { Layout } from '@/components/layout'

interface UseCaseCardProps {
  label: string
}
function UseCaseCard(props: UseCaseCardProps) {
  return (
    <div className="Frame51 flex-col justify-center items-center gap-1 inline-flex">
      <div className="w-72 h-60 bg-zinc-300" />
      <div className="w-72 h-6 text-center text-black text-lg font-semibold leading-7">
        {props.label}
      </div>
    </div>
  )
}
function WelcomePage() {
  return (
    <Layout>
      <h1 className="self-stretch text-black text-3xl font-extrabold leading-10">
        欢迎使用BladeCreate创作平台
      </h1>
      <div className="self-stretch text-black text-xl font-normal leading-7">
        BladeCreate是针对创意美术工作流的AI创作工具。
      </div>
      <div className="text-black text-xl font-semibold leading-9">使用范例</div>
      <div className="self-stretch flex-wrap justify-start items-start gap-5 inline-flex">
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
