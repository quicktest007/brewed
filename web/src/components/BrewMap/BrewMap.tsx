import { useEffect, useRef } from 'react'
import maplibregl from 'maplibre-gl'
import 'maplibre-gl/dist/maplibre-gl.css'
import { TILE_URL, DEFAULT_CENTER, DEFAULT_ZOOM } from './config'
import type { Place } from '../../data/mockBrews'
import './BrewMap.css'

type BrewMapProps = {
  places: Place[]
  selectedPlace: Place | null
  onSelectPlace: (place: Place) => void
  flyToPlace: Place | null
}

export default function BrewMap({ places, selectedPlace, onSelectPlace, flyToPlace }: BrewMapProps) {
  const containerRef = useRef<HTMLDivElement>(null)
  const mapRef = useRef<maplibregl.Map | null>(null)
  const markersRef = useRef<maplibregl.Marker[]>([])

  useEffect(() => {
    if (!containerRef.current) return

    const map = new maplibregl.Map({
      container: containerRef.current,
      style: {
        version: 8,
        sources: {
          'osm-tiles': {
            type: 'raster',
            tiles: [TILE_URL],
            tileSize: 256,
            attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
          },
        },
        layers: [
          {
            id: 'osm-tiles-layer',
            type: 'raster',
            source: 'osm-tiles',
            minzoom: 0,
            maxzoom: 19,
          },
        ],
      },
      center: DEFAULT_CENTER,
      zoom: DEFAULT_ZOOM,
    })

    map.addControl(new maplibregl.NavigationControl(), 'top-right')
    mapRef.current = map

    return () => {
      markersRef.current.forEach((m) => m.remove())
      markersRef.current = []
      map.remove()
      mapRef.current = null
    }
  }, [])

  useEffect(() => {
    if (!mapRef.current) return

    markersRef.current.forEach((m) => m.remove())
    markersRef.current = []

    places.forEach((place) => {
      const el = document.createElement('div')
      el.className = 'brew-map-marker'
      el.dataset.placeId = place.id

      const marker = new maplibregl.Marker({ element: el })
        .setLngLat([place.lng, place.lat])
        .addTo(mapRef.current!)

      el.addEventListener('click', () => onSelectPlace(place))
      markersRef.current.push(marker)
    })
  }, [places, onSelectPlace])

  useEffect(() => {
    if (!mapRef.current) return
    markersRef.current.forEach((m) => {
      const el = m.getElement()
      const placeId = el.getAttribute('data-place-id')
      const isSelected = placeId && selectedPlace?.id === placeId
      el.classList.toggle('selected', !!isSelected)
    })
  }, [selectedPlace])

  useEffect(() => {
    if (!mapRef.current || !flyToPlace) return
    mapRef.current.flyTo({
      center: [flyToPlace.lng, flyToPlace.lat],
      zoom: 15,
      duration: 800,
    })
  }, [flyToPlace])

  return <div ref={containerRef} className="brew-map-container" />
}
