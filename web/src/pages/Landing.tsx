import { Link } from 'react-router-dom'
import './Landing.css'

export default function Landing() {
  return (
    <div className="landing">
      <div className="landing-hero">
        <h1 className="landing-logo">Brewed</h1>
        <p className="landing-tagline">Taste. Rate. Discover.</p>
        <p className="landing-desc">
          The social app for coffee lovers. Share your brews, discover new spots, and build your coffee passport.
        </p>
        <div className="landing-actions">
          <Link to="/feed" className="btn btn-primary">Explore Feed</Link>
          <Link to="/add" className="btn btn-secondary">Post a Brew</Link>
        </div>
      </div>
      <nav className="landing-nav">
        <Link to="/feed">Feed</Link>
        <Link to="/map">Map</Link>
        <Link to="/add">Add Brew</Link>
      </nav>
    </div>
  )
}
