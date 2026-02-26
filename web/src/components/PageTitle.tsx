import './PageTitle.css'

export default function PageTitle({ children }: { children: React.ReactNode }) {
  return <h1 className="page-title">{children}</h1>
}
