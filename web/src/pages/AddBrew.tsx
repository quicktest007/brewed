import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { useBrewStore } from '../context/BrewStore'
import { coffeeTypes, tastingNotes, mockPlaces } from '../data/mockBrews'
import './AddBrew.css'

export default function AddBrew() {
  const navigate = useNavigate()
  const { addBrew } = useBrewStore()
  const [rating, setRating] = useState(5)
  const [atHome, setAtHome] = useState(true)
  const [place, setPlace] = useState<string | null>(null)
  const [coffeeType, setCoffeeType] = useState<string | null>(null)
  const [notes, setNotes] = useState<Set<string>>(new Set())
  const [comments, setComments] = useState('')
  const [submitted, setSubmitted] = useState(false)

  const toggleNote = (n: string) => {
    setNotes((prev) => {
      const next = new Set(prev)
      if (next.has(n)) next.delete(n)
      else next.add(n)
      return next
    })
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    if (!coffeeType || (!atHome && !place)) return
    const placeObj = !atHome && place ? mockPlaces.find((p) => p.id === place) : null
    addBrew({
      rating,
      placeName: placeObj?.name ?? null,
      placeNeighborhood: placeObj?.neighborhood,
      placeCity: placeObj?.city,
      coffeeType,
      tastingNotes: Array.from(notes),
      caption: comments.trim(),
    })
    setSubmitted(true)
  }

  const canSubmit = coffeeType && (atHome || place)
  const resetForm = () => {
    setSubmitted(false)
    setRating(5)
    setAtHome(true)
    setPlace(null)
    setCoffeeType(null)
    setNotes(new Set())
    setComments('')
  }

  const closeModal = () => navigate(-1)

  if (submitted) {
    return (
      <div className="add-modal-overlay" role="dialog">
        <div className="add-modal add-modal-success">
          <h2>Brew posted</h2>
          <p>Thanks for sharing. Check your feed.</p>
          <div className="add-modal-actions">
            <Link to="/" className="btn btn-primary" onClick={resetForm}>View Feed</Link>
            <button type="button" className="btn btn-secondary" onClick={resetForm}>
              Post another
            </button>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div
      className="add-modal-overlay"
      role="dialog"
      aria-label="Add a brew"
      onClick={(e) => e.target === e.currentTarget && closeModal()}
    >
      <div className="add-modal" onClick={(e) => e.stopPropagation()}>
        <header className="add-modal-header">
          <h1>New Brew</h1>
          <button
            type="button"
            className="add-modal-close"
            onClick={closeModal}
            aria-label="Close"
          >
            ×
          </button>
        </header>
        <form className="add-modal-form" onSubmit={handleSubmit}>
          <section className="add-photo-section">
            <label>Photo</label>
            <div className="add-photo-upload">
              <span className="add-photo-icon">+</span>
              <span>Tap to add photo</span>
            </div>
          </section>
          <section>
            <label>Rating</label>
            <div className="add-rating-pills">
              {[1, 2, 3, 4, 5].map((r) => (
                <button
                  key={r}
                  type="button"
                  className={`add-rating-pill ${r <= rating ? 'filled' : ''}`}
                  onClick={() => setRating(r)}
                  aria-pressed={r <= rating}
                />
              ))}
            </div>
          </section>
          <section>
            <label>Where</label>
            <div className="where-tabs">
              <button
                type="button"
                className={atHome ? 'active' : ''}
                onClick={() => { setAtHome(true); setPlace(null) }}
              >
                At home
              </button>
              <button
                type="button"
                className={!atHome ? 'active' : ''}
                onClick={() => setAtHome(false)}
              >
                Coffee shop
              </button>
            </div>
            {!atHome && (
              <div className="place-picker">
                {mockPlaces.map((p) => (
                  <button
                    key={p.id}
                    type="button"
                    className={`place-option ${place === p.id ? 'selected' : ''}`}
                    onClick={() => setPlace(p.id)}
                  >
                    {p.name} · {p.neighborhood}
                  </button>
                ))}
              </div>
            )}
          </section>
          <section>
            <label>What did you have?</label>
            <div className="chip-grid">
              {coffeeTypes.map((c) => (
                <button
                  key={c}
                  type="button"
                  className={`chip ${coffeeType === c ? 'selected' : ''}`}
                  onClick={() => setCoffeeType(c)}
                >
                  {c}
                </button>
              ))}
            </div>
          </section>
          <section>
            <label>Tasting notes</label>
            <div className="chip-grid">
              {tastingNotes.map((n) => (
                <button
                  key={n}
                  type="button"
                  className={`chip ${notes.has(n) ? 'selected' : ''}`}
                  onClick={() => toggleNote(n)}
                >
                  {n}
                </button>
              ))}
            </div>
          </section>
          <section>
            <label>Review</label>
            <textarea
              placeholder="Notes, vibe, anything else..."
              value={comments}
              onChange={(e) => setComments(e.target.value)}
              rows={3}
            />
          </section>
          <button type="submit" className="btn btn-primary btn-block" disabled={!canSubmit}>
            Publish brew
          </button>
        </form>
      </div>
    </div>
  )
}
