import { useBrewStore } from '../context/BrewStore'
import PageTitle from '../components/PageTitle'
import Card from '../components/Card'
import Chip from '../components/Chip'
import RatingLeaves from '../components/RatingLeaves'
import type { Brew } from '../data/mockBrews'
import './Feed.css'

function FeedCard({ brew }: { brew: Brew }) {
  const location = brew.placeName
    ? `${brew.placeName}${brew.placeNeighborhood ? ` · ${brew.placeNeighborhood}` : ''}`
    : 'At home'
  return (
    <Card className="feed-card">
      <div className="feed-card-photo">
        <img
          src={brew.photo || 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600'}
          alt=""
        />
      </div>
      <div className="feed-card-body">
        <div className="feed-card-top">
          <RatingLeaves rating={brew.rating} />
          <span className="feed-card-type">{brew.coffeeType}</span>
        </div>
        <h3 className="feed-card-place">{brew.placeName || 'Home brew'}</h3>
        <p className="feed-card-location">{location}</p>
        {brew.tastingNotes.length > 0 && (
          <div className="feed-card-notes">
            {brew.tastingNotes.map((n) => (
              <Chip key={n} as="span" selected>{n}</Chip>
            ))}
          </div>
        )}
        {brew.caption && <p className="feed-card-caption">{brew.caption}</p>}
        <div className="feed-card-actions">
          <button type="button" className="feed-action">Like</button>
          <button type="button" className="feed-action">Comment</button>
          <button type="button" className="feed-action">Bookmark</button>
          <button type="button" className="feed-action feed-action-primary">Brew again</button>
        </div>
      </div>
    </Card>
  )
}

export default function Feed() {
  const { brews } = useBrewStore()
  return (
    <div className="feed-page">
      <PageTitle>Feed</PageTitle>
      <div className="feed-list">
        {brews.map((brew) => (
          <FeedCard key={brew.id} brew={brew} />
        ))}
      </div>
    </div>
  )
}
