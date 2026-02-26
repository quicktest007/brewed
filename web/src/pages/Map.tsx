import { useState } from 'react'
import AppHeader from '../components/AppHeader'
import { mockPlaces } from '../data/mockBrews'
import './Map.css'

type Place = typeof mockPlaces[0]

export default function Map() {
  const [selected, setSelected] = useState<Place | null>(null)

  return (
    <div className="map-page">
      <AppHeader />
      <main className="map-main">
        <div className="map-container">
          <div className="map-canvas">
            {/* Simulated map background with grid */}
            <div className="map-grid" />
            {mockPlaces.map((place, i) => {
              const positions = [
                { left: '22%', top: '30%' },
                { left: '72%', top: '28%' },
                { left: '18%', top: '68%' },
                { left: '68%', top: '65%' },
              ]
              const pos = positions[i] || positions[0]
              return (
              <button
                key={place.id}
                type="button"
                className={`map-pin ${selected?.id === place.id ? 'active' : ''}`}
                style={{ left: pos.left, top: pos.top }}
                onClick={() => setSelected(selected?.id === place.id ? null : place)}
                aria-label={`${place.name}, ${place.neighborhood}`}
              >
                <span className="map-pin-dot" />
              </button>
              )
            })}
          </div>
        </div>
        {selected && (
          <div className="map-card" role="dialog" aria-label={`${selected.name} details`}>
            <button
              type="button"
              className="map-card-close"
              onClick={() => setSelected(null)}
              aria-label="Close"
            >
              ×
            </button>
            <div className="map-card-photo" />
            <div className="map-card-body">
              <h2>{selected.name}</h2>
              <p>{selected.neighborhood}, {selected.city}</p>
              <button type="button" className="btn btn-primary btn-sm">View details</button>
            </div>
          </div>
        )}
        <div className="map-list">
          <h3>Nearby</h3>
          {mockPlaces.map((p) => (
            <button
              key={p.id}
              type="button"
              className={`map-list-item ${selected?.id === p.id ? 'active' : ''}`}
              onClick={() => setSelected(p)}
            >
              <span className="map-list-name">{p.name}</span>
              <span className="map-list-loc">{p.neighborhood}, {p.city}</span>
            </button>
          ))}
        </div>
      </main>
    </div>
  )
}
