import { useBrewStore } from '../context/BrewStore'
import PageTitle from '../components/PageTitle'
import Card from '../components/Card'
import './Passport.css'

export default function Passport() {
  const { brews } = useBrewStore()
  const userBrews = brews.filter((b) => b.userName === 'You')

  return (
    <div className="passport-page">
      <PageTitle>Passport</PageTitle>
      <div className="passport-content">
        <Card className="passport-summary">
          <div className="passport-ring">
            <span>{userBrews.length}</span>
            <span className="passport-ring-label">brews</span>
          </div>
          <p>Your coffee journey</p>
        </Card>
        <Card>
          <h3>Badges</h3>
          <div className="passport-badges">
            <div className="passport-badge earned">☕ First Brew</div>
            <div className="passport-badge earned">📍 10 Shops</div>
            <div className="passport-badge">✈️ World Traveler</div>
          </div>
        </Card>
      </div>
    </div>
  )
}
