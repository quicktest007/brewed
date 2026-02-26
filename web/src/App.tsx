import { Routes, Route, Navigate } from 'react-router-dom'
import PhoneShell from './components/PhoneShell'
import TabBar from './components/TabBar'
import Feed from './pages/Feed'
import Map from './pages/Map'
import AddBrew from './pages/AddBrew'
import Passport from './pages/Passport'
import Profile from './pages/Profile'
import Settings from './pages/Settings'
import './App.css'

function App() {
  return (
    <PhoneShell>
      <Routes>
        <Route path="/" element={<Navigate to="/feed" replace />} />
        <Route path="/feed" element={<Feed />} />
        <Route path="/map" element={<Map />} />
        <Route path="/add" element={<AddBrew />} />
        <Route path="/passport" element={<Passport />} />
        <Route path="/profile" element={<Profile />} />
        <Route path="/settings" element={<Settings />} />
      </Routes>
      <TabBar />
    </PhoneShell>
  )
}

export default App
