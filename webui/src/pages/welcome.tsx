import { Layout } from '@/components/layout'
import { useTranslation } from 'react-i18next'

function WelcomePage() {
  const { t } = useTranslation()
  return (
    <Layout>
      <h1 className="self-stretch text-3xl font-extrabold leading-10 text-black">{t('welcome')}</h1>
      <div className="self-stretch text-xl font-normal leading-7 text-black">{t('intro')}</div>
    </Layout>
  )
}

export const Component = WelcomePage

export default WelcomePage
