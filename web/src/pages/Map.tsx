import { Link } from 'react-router-dom'
import { mockPlaces } from '../data/mockBrews'
import './Map.css'

export default function Map() {
  return (
    <div className="map-page">
      <header className="map-header">
        <h1>Brewed</h1>
        <nav>
          <Link to="/">Home</Link>
          <Link to="/feed">Feed</Link>
          <Link to="/add">Add Brew</Link>
        </nav>
      </header>
      <main className="map-main">
        <div className="map-placeholder">
          <span className="map-icon">🗺️</span>
          <h2>Map Discovery</h2>
          <p>Discover coffee shops near you. Full map view is available in the iOS app.</p>
          <div className="map-search">
            <input type="text" placeholder="Search area or address..." readOnly />
          </div>
        </div>
        <div className="map-list">
          <h3>Nearby places</h3>
          {mockPlaces.map((p) => (
            <div key={p.id} className="place-row">
              <span className="place-name">{p.name}</span>
              <span className="place-neighborhood">{p.neighborhood}, {p.city}</span>
            </div>
          ))}
        </div>
      </main>
    </div>
  )
}
