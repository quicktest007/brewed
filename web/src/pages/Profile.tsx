import { Link } from 'react-router-dom'
import { useBrewStore } from '../context/BrewStore'
import PageTitle from '../components/PageTitle'
import Card from '../components/Card'
import Chip from '../components/Chip'
import './Profile.css'

const tasteProfile = ['Latte', 'Pour Over', 'Espresso']

export default function Profile() {
  const { brews } = useBrewStore()
  const userBrews = brews.filter((b) => b.userName === 'You')
  const cities = [...new Set(brews.map((b) => b.placeCity).filter(Boolean))] as string[]
  const avgRating = userBrews.length
    ? userBrews.reduce((s, b) => s + b.rating, 0) / userBrews.length
    : 0
  const topMethod = 'Latte'
  const mostVisited = cities[0] ?? '—'

  return (
    <div className="profile-page">
      <div className="profile-header">
        <PageTitle>Profile</PageTitle>
        <Link to="/settings" className="profile-settings" aria-label="Settings">
          <SettingsIcon />
        </Link>
      </div>
      <div className="profile-content">
        <Card className="profile-card">
          <div className="profile-avatar">A</div>
          <h2 className="profile-name">Alex</h2>
          <p className="profile-handle">@alex_brews</p>
        </Card>
        <Card className="profile-stats-card">
          <div className="profile-stat">
            <span className="profile-stat-value">{avgRating.toFixed(1)}</span>
            <span className="profile-stat-label">Avg rating</span>
          </div>
          <div className="profile-stat">
            <span className="profile-stat-value">{userBrews.length}</span>
            <span className="profile-stat-label">Brews</span>
          </div>
          <div className="profile-stat">
            <span className="profile-stat-value">{mostVisited}</span>
            <span className="profile-stat-label">Most visited</span>
          </div>
          <div className="profile-stat">
            <span className="profile-stat-value">{topMethod}</span>
            <span className="profile-stat-label">Top method</span>
          </div>
        </Card>
        <section className="profile-section">
          <h3>Taste profile</h3>
          <div className="profile-chips">
            {tasteProfile.map((t) => (
              <Chip key={t} as="span" selected>{t}</Chip>
            ))}
          </div>
        </section>
        <section className="profile-section">
          <h3>Where you&apos;ve brewed</h3>
          <div className="profile-mini-map" />
        </section>
      </div>
    </div>
  )
}

function SettingsIcon() {
  return (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <circle cx="12" cy="12" r="3" />
      <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z" />
    </svg>
  )
}
