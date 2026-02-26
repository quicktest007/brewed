import { useBrewStore } from '../context/BrewStore'
import AppHeader from '../components/AppHeader'
import BrewCard from '../components/BrewCard'
import './Home.css'

export default function Home() {
  const { brews } = useBrewStore()
  return (
    <div className="home-page">
      <AppHeader />
      <main className="home-feed">
        <div className="home-feed-list">
          {brews.map((brew, i) => (
            <BrewCard key={brew.id} brew={brew} index={i} />
          ))}
        </div>
      </main>
    </div>
  )
}
