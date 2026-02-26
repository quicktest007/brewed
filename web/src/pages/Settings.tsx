import { Link } from 'react-router-dom'
import PageTitle from '../components/PageTitle'
import './Settings.css'

export default function Settings() {
  return (
    <div className="settings-page">
      <div className="settings-header">
        <Link to="/profile" className="settings-back">← Back</Link>
        <PageTitle>Settings</PageTitle>
      </div>
      <div className="settings-content">
        <p className="settings-placeholder">Settings coming soon.</p>
      </div>
    </div>
  )
}
