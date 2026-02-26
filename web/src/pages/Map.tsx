import { useState, useCallback } from 'react'
import PageTitle from '../components/PageTitle'
import Chip from '../components/Chip'
import BottomSheet from '../components/BottomSheet'
import BrewMap from '../components/BrewMap'
import { mockPlaces } from '../data/mockBrews'
import type { Place } from '../data/mockBrews'
import './Map.css'

const mapFilters = ['Open now', 'Espresso', 'Pour over']

export default function Map() {
  const [activeFilter, setActiveFilter] = useState<string | null>(null)
  const [selected, setSelected] = useState<Place | null>(null)

  const handleSelectPlace = useCallback((place: Place) => {
    setSelected((prev) => (prev?.id === place.id ? null : place))
  }, [])

  return (
    <div className="map-page">
      <PageTitle>Map</PageTitle>
      <div className="map-content">
        <div className="map-area">
          <div className="map-search-wrap">
            <input
              type="text"
              className="map-search"
              placeholder="Search coffee shops"
            />
          </div>
          <div className="map-map-wrap">
            <BrewMap
              places={mockPlaces}
              selectedPlace={selected}
              onSelectPlace={handleSelectPlace}
              flyToPlace={selected}
            />
          </div>
        </div>
        <BottomSheet title="Nearby" subtitle={`${mockPlaces.length} places`}>
          <div className="map-filters">
            {mapFilters.map((f) => (
              <Chip
                key={f}
                selected={activeFilter === f}
                onClick={() => setActiveFilter(activeFilter === f ? null : f)}
              >
                {f}
              </Chip>
            ))}
          </div>
          <div className="map-place-list">
            {mockPlaces.map((p) => (
              <button
                key={p.id}
                type="button"
                className={`map-place-card ${selected?.id === p.id ? 'active' : ''}`}
                onClick={() => handleSelectPlace(p)}
              >
                <div className="map-place-main">
                  <span className="map-place-name">{p.name}</span>
                  <span className="map-place-neighborhood">{p.neighborhood}</span>
                </div>
                <div className="map-place-meta">
                  <span>{p.rating ?? '—'}</span>
                  <span>{p.priceRange ?? '—'}</span>
                  <span>{p.brewsCount ?? 0} brews</span>
                </div>
                <span className="map-place-chevron">›</span>
              </button>
            ))}
          </div>
        </BottomSheet>
      </div>
    </div>
  )
}
