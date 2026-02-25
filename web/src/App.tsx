import { Routes, Route } from 'react-router-dom'
import Landing from './pages/Landing'
import Feed from './pages/Feed'
import Map from './pages/Map'
import AddBrew from './pages/AddBrew'
import './App.css'

function App() {
  return (
    <div className="app">
      <Routes>
        <Route path="/" element={<Landing />} />
        <Route path="/feed" element={<Feed />} />
        <Route path="/map" element={<Map />} />
        <Route path="/add" element={<AddBrew />} />
      </Routes>
    </div>
  )
}

export default App
