import { Layout } from '@/components/layout'
import { isRouteErrorResponse, useRouteError } from 'react-router-dom'

export default function ErrorPage() {
  const error = useRouteError()

  let errorMessage: string

  if (isRouteErrorResponse(error)) {
    // error is type `ErrorResponse`
    errorMessage = error.error?.message || error.statusText
  } else if (error instanceof Error) {
    errorMessage = error.message
  } else if (typeof error === 'string') {
    errorMessage = error
  } else {
    console.error(error)
    errorMessage = 'Unknown error'
  }
  console.error(error)

  return (
    <Layout>
      <h1 className="self-stretch text-black text-5xl font-extrabold leading-10">
        错误！🙅
      </h1>
      <p>抱歉，预料之外的错误发生了！</p>
      <p>
        <i>{errorMessage}</i>
      </p>
    </Layout>
  )
}
