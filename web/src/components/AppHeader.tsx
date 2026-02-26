import { Link } from 'react-router-dom'
import { useTheme } from '../context/ThemeContext'
import './AppHeader.css'

export default function AppHeader() {
  const { theme, toggleTheme } = useTheme()
  return (
    <header className="app-header">
      <Link to="/" className="app-header-logo">Brewed</Link>
      <div className="app-header-actions">
        <button
          type="button"
          className="app-header-icon"
          aria-label="Search"
        >
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <circle cx="11" cy="11" r="8" />
            <path d="m21 21-4.35-4.35" />
          </svg>
        </button>
        <button
          type="button"
          className="app-header-icon"
          onClick={toggleTheme}
          aria-label={`Switch to ${theme === 'light' ? 'dark' : 'light'} mode`}
        >
          {theme === 'light' ? (
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" />
            </svg>
          ) : (
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <circle cx="12" cy="12" r="4" />
              <path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M6.34 17.66l-1.41 1.41M19.07 4.93l-1.41 1.41" />
            </svg>
          )}
        </button>
        <Link to="/profile" className="app-header-avatar">
          <img src="https://i.pravatar.cc/80?img=1" alt="Profile" />
        </Link>
      </div>
    </header>
  )
}
