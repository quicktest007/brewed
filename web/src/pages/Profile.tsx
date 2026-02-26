import { Link } from 'react-router-dom'
import { useBrewStore } from '../context/BrewStore'
import AppHeader from '../components/AppHeader'
import './Profile.css'

const BADGES = [
  { id: 'first', label: 'First Brew', earned: true, icon: '☕' },
  { id: '10shops', label: '10 Shops', earned: true, icon: '📍' },
  { id: 'traveler', label: 'World Traveler', earned: false, icon: '✈️' },
  { id: 'roast', label: 'Roast Master', earned: false, icon: '🔥' },
]

export default function Profile() {
  const { brews } = useBrewStore()
  const userBrews = brews.filter((b) => b.userName === 'You')
  const cities = [...new Set(brews.map((b) => b.placeCity).filter(Boolean))] as string[]
  const favoriteRoast = 'Latte' // could derive from data

  return (
    <div className="profile-page">
      <AppHeader />
      <main className="profile-main">
        <div className="profile-hero">
          <img
            src="https://i.pravatar.cc/120?img=1"
            alt=""
            className="profile-avatar"
          />
          <h1 className="profile-name">You</h1>
          <p className="profile-handle">@brewed_user</p>
        </div>

        <section className="profile-stats">
          <div className="profile-stat">
            <span className="profile-stat-value">{userBrews.length}</span>
            <span className="profile-stat-label">Brews</span>
          </div>
          <div className="profile-stat">
            <span className="profile-stat-value">{cities.length || 1}</span>
            <span className="profile-stat-label">Cities</span>
          </div>
          <div className="profile-stat">
            <span className="profile-stat-value">{favoriteRoast}</span>
            <span className="profile-stat-label">Favorite</span>
          </div>
        </section>

        <section className="profile-progress">
          <h2>Weekly Goal</h2>
          <div className="profile-progress-ring">
            <svg viewBox="0 0 36 36">
              <path
                className="profile-progress-bg"
                d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"
              />
              <path
                className="profile-progress-fill"
                strokeDasharray={`${Math.min(userBrews.length * 20, 100)}, 100`}
                d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"
              />
            </svg>
            <span className="profile-progress-value">{Math.min(userBrews.length * 2, 10)}/10</span>
          </div>
        </section>

        <section className="profile-badges">
          <h2>Badges</h2>
          <div className="profile-badge-grid">
            {BADGES.map((b) => (
              <div
                key={b.id}
                className={`profile-badge ${b.earned ? 'earned' : ''}`}
              >
                <span className="profile-badge-icon">{b.icon}</span>
                <span className="profile-badge-label">{b.label}</span>
              </div>
            ))}
          </div>
        </section>

        <div className="profile-actions">
          <Link to="/" className="btn btn-primary">Back to Feed</Link>
        </div>
      </main>
    </div>
  )
}
