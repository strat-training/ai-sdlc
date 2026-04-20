import { Footer, Layout, Navbar } from 'nextra-theme-docs'
import { Head } from 'nextra/components'
import { getPageMap } from 'nextra/page-map'
import 'nextra-theme-docs/style.css'

export const metadata = {
  title: 'Ultimate AI Agents',
  description: 'AI agents and workflows — every platform, every department.',
  icons: {
    icon: '/favicon.svg',
  },
}

const navbar = (
  <Navbar
    logo={
      <span style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
        <svg xmlns="http://www.w3.org/2000/svg" width={22} height={22} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round">
          <path d="M12 8V4H8"/>
          <rect width={16} height={12} x={4} y={8} rx={2}/>
          <path d="M2 14h2"/>
          <path d="M20 14h2"/>
          <path d="M15 13v2"/>
          <path d="M9 13v2"/>
        </svg>
        <strong>Ultimate AI Agents</strong>
      </span>
    }
    projectLink="https://github.com/stratpoint-engineering/ultimate-ai-agents"
  />
)
const footer = <Footer>MIT {new Date().getFullYear()} &copy; Stratpoint. Built with Nextra.</Footer>

export default async function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" dir="ltr" suppressHydrationWarning>
      <Head />
      <body>
        <Layout
          navbar={navbar}
          pageMap={await getPageMap()}
          docsRepositoryBase="https://github.com/stratpoint-engineering/ultimate-ai-agents/tree/main/docs"
          footer={footer}
          sidebar={{ defaultMenuCollapseLevel: 2, toggleButton: true }}
          toc={{ backToTop: true }}
        >
          {children}
        </Layout>
      </body>
    </html>
  )
}
