import type { Brew } from '../data/mockBrews'
import './BrewCard.css'

function RatingPills({ rating }: { rating: number }) {
  const full = Math.floor(rating)
  const half = rating % 1 >= 0.5
  return (
    <div className="brew-rating" aria-label={`${rating} out of 5`}>
      {[1, 2, 3, 4, 5].map((i) => (
        <span
          key={i}
          className={`brew-rating-pill ${i <= full ? 'full' : i === full + 1 && half ? 'half' : ''}`}
        />
      ))}
      <span className="brew-rating-value">{rating}</span>
    </div>
  )
}

export default function BrewCard({ brew, index = 0 }: { brew: Brew; index?: number }) {
  const location = brew.placeName
    ? `${brew.placeName}${brew.placeNeighborhood ? ` · ${brew.placeNeighborhood}` : ''}${brew.placeCity ? `, ${brew.placeCity}` : ''}`
    : 'At home'

  return (
    <article
      className="brew-card"
      style={{ animationDelay: `${index * 0.05}s` }}
    >
      <div className="brew-card-header">
        <div className="brew-card-user">
          <img
            src={brew.userAvatar || `https://i.pravatar.cc/80?u=${brew.userName}`}
            alt=""
            className="brew-card-avatar"
          />
          <div>
            <span className="brew-card-name">{brew.userName}</span>
            <span className="brew-card-time">{brew.timestamp}</span>
          </div>
        </div>
        {brew.userName === 'You' && <span className="brew-card-badge">You</span>}
      </div>

      <div className="brew-card-photo-wrap">
        <img
          src={brew.photo || 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600'}
          alt=""
          className="brew-card-photo"
        />
      </div>

      <div className="brew-card-body">
        <RatingPills rating={brew.rating} />
        <h3 className="brew-card-place">{brew.placeName || 'Home brew'}</h3>
        <p className="brew-card-location">{location}</p>
        <span className="brew-card-type">{brew.coffeeType}</span>
        {brew.tastingNotes.length > 0 && (
          <div className="brew-card-notes">
            {brew.tastingNotes.map((n) => (
              <span key={n} className="brew-card-note">{n}</span>
            ))}
          </div>
        )}
        {brew.caption && <p className="brew-card-caption">{brew.caption}</p>}
      </div>
    </article>
  )
}
