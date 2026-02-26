import { NavLink, useNavigate, useLocation } from 'react-router-dom'
import './TabBar.css'

const tabs = [
  { to: '/map', label: 'Map', icon: MapIcon },
  { to: '/feed', label: 'Feed', icon: FeedIcon },
  { to: '/add', label: 'Add', icon: AddIcon, elevated: true },
  { to: '/passport', label: 'Passport', icon: PassportIcon },
  { to: '/profile', label: 'Profile', icon: ProfileIcon },
]

function MapIcon() {
  return (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <polygon points="1 6 1 22 8 18 16 22 23 18 23 2 16 6 8 2 1 6" />
    </svg>
  )
}

function FeedIcon() {
  return (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9" />
      <path d="M13.73 21a2 2 0 0 1-3.46 0" />
    </svg>
  )
}

function AddIcon() {
  return (
    <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
      <line x1="12" y1="5" x2="12" y2="19" />
      <line x1="5" y1="12" x2="19" y2="12" />
    </svg>
  )
}

function PassportIcon() {
  return (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <path d="M4 4h16a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2z" />
      <polyline points="22,6 12,13 2,6" />
    </svg>
  )
}

function ProfileIcon() {
  return (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
      <circle cx="12" cy="7" r="4" />
    </svg>
  )
}

export default function TabBar() {
  const navigate = useNavigate()
  const location = useLocation()

  return (
    <nav className="tab-bar" aria-label="Main navigation">
      {tabs.map(({ to, label, icon: Icon, elevated }) => {
        if (elevated) {
          return (
            <button
              key={to}
              type="button"
              className={`tab-bar-add ${location.pathname === to ? 'active' : ''}`}
              onClick={() => navigate(to)}
              aria-label="Add Brew"
            >
              <Icon />
            </button>
          )
        }
        return (
          <NavLink
            key={to}
            to={to}
            className={({ isActive }) => `tab-bar-link ${isActive ? 'active' : ''}`}
          >
            <Icon />
            <span>{label}</span>
          </NavLink>
        )
      })}
    </nav>
  )
}
