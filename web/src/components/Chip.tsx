import './Chip.css'

type ChipProps = {
  children: React.ReactNode
  selected?: boolean
  onClick?: () => void
  as?: 'button' | 'span'
}

export default function Chip({ children, selected, onClick, as = 'button' }: ChipProps) {
  const className = `chip ${selected ? 'selected' : ''}`
  if (as === 'span') {
    return <span className={className}>{children}</span>
  }
  return (
    <button type="button" className={className} onClick={onClick}>
      {children}
    </button>
  )
}
