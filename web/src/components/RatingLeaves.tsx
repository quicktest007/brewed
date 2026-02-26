import './RatingLeaves.css'

const LeafIcon = ({ filled }: { filled: boolean }) => (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" className={filled ? 'filled' : ''}>
    <path
      d="M12 2C8 8 4 12 4 16c0 3 2 4 8 4s8-1 8-4c0-4-4-8-8-14z"
      stroke="currentColor"
      strokeWidth="1.5"
      fill={filled ? 'currentColor' : 'none'}
    />
  </svg>
)

export default function RatingLeaves({ rating }: { rating: number }) {
  const full = Math.floor(rating)
  const half = rating % 1 >= 0.5
  return (
    <div className="rating-leaves" aria-label={`${rating} out of 5`}>
      {[1, 2, 3, 4, 5].map((i) => (
        <span
          key={i}
          className={`rating-leaf ${i <= full ? 'full' : i === full + 1 && half ? 'half' : ''}`}
        >
          <LeafIcon filled={i <= full || (i === full + 1 && half)} />
        </span>
      ))}
    </div>
  )
}
