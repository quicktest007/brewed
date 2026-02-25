import { NavLink } from 'react-router-dom'
import './BottomNav.css'

const navItems = [
  { to: '/', label: 'Home', icon: '🏠' },
  { to: '/feed', label: 'Feed', icon: '☕' },
  { to: '/map', label: 'Map', icon: '🗺️' },
  { to: '/add', label: 'Add Brew', icon: '➕' },
]

export default function BottomNav() {
  return (
    <nav className="bottom-nav" aria-label="Main navigation">
      {navItems.map(({ to, label, icon }) => (
        <NavLink
          key={to}
          to={to}
          className={({ isActive }) => `bottom-nav-link ${isActive ? 'active' : ''}`}
          end={to === '/'}
        >
          <span className="bottom-nav-icon">{icon}</span>
          <span className="bottom-nav-label">{label}</span>
        </NavLink>
      ))}
    </nav>
  )
}
