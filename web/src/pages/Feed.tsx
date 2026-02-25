import { Link } from 'react-router-dom'
import { mockBrews } from '../data/mockBrews'
import './Feed.css'

function RatingBeans({ rating }: { rating: number }) {
  return (
    <span className="rating-beans">
      {[1, 2, 3, 4, 5].map((i) => (
        <span key={i} className={i <= rating ? 'bean filled' : 'bean'} aria-hidden>☕</span>
      ))}
      <span className="rating-text">{rating}</span>
    </span>
  )
}

function BrewCard({ brew }: { brew: typeof mockBrews[0] }) {
  return (
    <article className="brew-card">
      <div className="brew-header">
        <RatingBeans rating={brew.rating} />
        <span className="brew-type">{brew.coffeeType}</span>
      </div>
      <div className="brew-place">
        {brew.placeName ? `${brew.placeName}${brew.placeNeighborhood ? ` · ${brew.placeNeighborhood}` : ''}` : 'At home'}
      </div>
      {brew.tastingNotes.length > 0 && (
        <div className="brew-notes">
          {brew.tastingNotes.map((n) => (
            <span key={n} className="note-tag">{n}</span>
          ))}
        </div>
      )}
      {brew.caption && <p className="brew-caption">{brew.caption}</p>}
    </article>
  )
}

export default function Feed() {
  return (
    <div className="feed-page">
      <header className="feed-header">
        <h1>Brewed</h1>
        <nav>
          <Link to="/">Home</Link>
          <Link to="/map">Map</Link>
          <Link to="/add" className="add-link">+ Add Brew</Link>
        </nav>
      </header>
      <main className="feed-main">
        <h2>Feed</h2>
        <div className="brew-list">
          {mockBrews.map((brew) => (
            <BrewCard key={brew.id} brew={brew} />
          ))}
        </div>
      </main>
    </div>
  )
}
