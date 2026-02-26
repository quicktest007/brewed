import './BottomSheet.css'

type BottomSheetProps = {
  title?: string
  subtitle?: string
  children: React.ReactNode
}

export default function BottomSheet({ title, subtitle, children }: BottomSheetProps) {
  return (
    <div className="bottom-sheet">
      {(title || subtitle) && (
        <div className="bottom-sheet-header">
          {title && <h2 className="bottom-sheet-title">{title}</h2>}
          {subtitle && <span className="bottom-sheet-subtitle">{subtitle}</span>}
        </div>
      )}
      <div className="bottom-sheet-content">{children}</div>
    </div>
  )
}
