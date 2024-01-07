import { LoginButton } from '@/components/auth/login-button'
import { SignupButton } from '@/components/auth/signup-button'
import { Link } from 'react-router-dom'
import herePng from '@/public/hero.jpg?asset'

export const AuthenticationPage: React.FC = () => {
  return (
    <div className="flex min-h-full w-screen flex-col sm:supports-[min-height:100dvh]:min-h-[100dvh] md:grid md:grid-cols-2">
      <div className="relative hidden h-full flex-col bg-muted p-10 text-white lg:flex dark:border-r">
        <img
          className="absolute inset-0 h-full w-full bg-no-repeat object-cover brightness-50"
          src={herePng}
        />
        <nav className="relative z-20 flex items-center text-lg font-medium">
          <h1 aria-label="bladeart">
            <div className="flex cursor-default items-center text-[20px] font-bold leading-none lg:text-[22px]">
              <svg
                className="mr-2 h-6 w-6"
                fill="none"
                stroke="currentColor"
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                viewBox="0 0 24 24"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path d="M15 6v12a3 3 0 1 0 3-3H6a3 3 0 1 0 3 3V6a3 3 0 1 0-3 3h12a3 3 0 1 0-3-3" />
              </svg>
              BLADEART
            </div>
          </h1>
        </nav>
        {/* <div className="flex flex-col text-[32px] leading-[1.2] md:text-[40px]"> */}
        <div className="relative z-20 mt-auto">
          <blockquote className="space-y-2">
            <p className="text-lg">
              &ldquo;bladeart生成的游戏素材，简直就是游戏制作的宝藏！&rdquo;
            </p>
            <footer className="text-sm">ChatGPT</footer>
          </blockquote>
        </div>
      </div>
      <div className="relative flex grow flex-col items-center justify-between bg-white px-5 py-8 text-black sm:rounded-t-[30px] md:rounded-none md:px-6 dark:bg-black dark:text-white">
        <div className="relative flex w-full grow flex-col items-center justify-center">
          <h2 className="text-center text-[20px] leading-[1.2] md:text-[32px] md:leading-8">
            开始创作
          </h2>
          <div className="mt-5 w-full max-w-[440px]">
            <div className="grid gap-x-3 gap-y-2 sm:grid-cols-2 sm:gap-y-0">
              <LoginButton />
              <SignupButton />
            </div>
          </div>
        </div>
        <div className="mt-10 flex flex-col justify-center">
          <div className="flex justify-center text-[#cdcdcd] md:mb-3">
            <svg
              className="mr-2 h-6 w-6"
              fill="none"
              stroke="currentColor"
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth="2"
              viewBox="0 0 24 24"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path d="M15 6v12a3 3 0 1 0 3-3H6a3 3 0 1 0 3 3V6a3 3 0 1 0-3 3h12a3 3 0 1 0-3-3" />
            </svg>
            BLADEART
          </div>
          <div className="py-3 text-xs">
            <Link className="mx-3 text-gray-500 hover:text-primary" to="/terms">
              服务条款
            </Link>
            <span className="text-gray-600">|</span>
            <Link className="mx-3 text-gray-500 hover:text-primary" to="/privacy">
              隐私政策
            </Link>
          </div>
        </div>
      </div>
    </div>
  )
}
