import { NavLink, useNavigate, useLocation } from 'react-router-dom'
import './BottomNav.css'

const navItems = [
  { to: '/', label: 'Home', icon: 'home' },
  { to: '/feed', label: 'Feed', icon: 'feed' },
  { to: '/add', label: 'Add Brew', icon: 'add', elevated: true },
  { to: '/map', label: 'Map', icon: 'map' },
]

const icons: Record<string, React.ReactNode> = {
  home: (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
      <polyline points="9 22 9 12 15 12 15 22" />
    </svg>
  ),
  feed: (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9" />
      <path d="M13.73 21a2 2 0 0 1-3.46 0" />
    </svg>
  ),
  add: (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
      <line x1="12" y1="5" x2="12" y2="19" />
      <line x1="5" y1="12" x2="19" y2="12" />
    </svg>
  ),
  map: (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <polygon points="1 6 1 22 8 18 16 22 23 18 23 2 16 6 8 2 1 6" />
      <line x1="8" y1="2" x2="8" y2="18" />
      <line x1="16" y1="6" x2="16" y2="22" />
    </svg>
  ),
}

export default function BottomNav() {
  const navigate = useNavigate()
  const location = useLocation()
  const isAddActive = location.pathname === '/add'
  return (
    <nav className="bottom-nav" aria-label="Main navigation">
      {navItems.map(({ to, label, icon, elevated }) => {
        if (elevated) {
          return (
            <button
              key={to}
              type="button"
              className={`bottom-nav-add ${isAddActive ? 'active' : ''}`}
              onClick={() => navigate(to)}
              aria-label={label}
            >
              <span className="bottom-nav-add-icon">{icons[icon]}</span>
            </button>
          )
        }
        return (
          <NavLink
            key={to}
            to={to}
            className={({ isActive }) => `bottom-nav-link ${isActive ? 'active' : ''}`}
            end={to === '/'}
          >
            <span className="bottom-nav-icon">{icons[icon]}</span>
            <span className="bottom-nav-label">{label}</span>
          </NavLink>
        )
      })}
    </nav>
  )
}
