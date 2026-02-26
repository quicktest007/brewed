import { Routes, Route } from 'react-router-dom'
import BottomNav from './components/BottomNav'
import Home from './pages/Home'
import Feed from './pages/Feed'
import Map from './pages/Map'
import AddBrew from './pages/AddBrew'
import Profile from './pages/Profile'
import './App.css'

function App() {
  return (
    <div className="app">
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/feed" element={<Feed />} />
        <Route path="/map" element={<Map />} />
        <Route path="/add" element={<AddBrew />} />
        <Route path="/profile" element={<Profile />} />
      </Routes>
      <BottomNav />
    </div>
  )
}

export default App
