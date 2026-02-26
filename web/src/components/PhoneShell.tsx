import type { ReactNode } from 'react'
import './PhoneShell.css'

type PhoneShellProps = {
  children: ReactNode
}

export default function PhoneShell({ children }: PhoneShellProps) {
  return (
    <div className="phone-shell">
      <div className="phone-frame">{children}</div>
    </div>
  )
}
