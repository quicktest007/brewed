import './PhoneShell.css'

type PhoneShellProps = {
  children: React.ReactNode
}

export default function PhoneShell({ children }: PhoneShellProps) {
  return (
    <div className="phone-shell">
      <div className="phone-frame">{children}</div>
    </div>
  )
}
