import { useState } from 'react'

function LeafIcon() {
  return (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
      <path d="M12 2C8 8 4 12 4 16c0 3 2 4 8 4s8-1 8-4c0-4-4-8-8-14z" />
    </svg>
  )
}
import { Link, useNavigate } from 'react-router-dom'
import { useBrewStore } from '../context/BrewStore'
import { coffeeTypes, tastingNotes, mockPlaces } from '../data/mockBrews'
import Chip from '../components/Chip'
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
      timestamp: 'Just now',
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
            <Link to="/feed" className="btn btn-primary" onClick={resetForm}>View Feed</Link>
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
          <button type="button" className="add-modal-cancel" onClick={closeModal}>
            Cancel
          </button>
          <h1>Add Brew</h1>
          <span />
        </header>
        <form className="add-modal-form" onSubmit={handleSubmit}>
          <section>
            <label>How was it?</label>
            <div className="add-rating-row">
              {[1, 2, 3, 4, 5].map((r) => (
                <button
                  key={r}
                  type="button"
                  className={`add-rating-btn ${r <= rating ? 'filled' : ''}`}
                  onClick={() => setRating(r)}
                  aria-pressed={r <= rating}
                >
                  <LeafIcon />
                </button>
              ))}
            </div>
          </section>
          <section>
            <label>Where did you brew?</label>
            <div className="add-where-tabs">
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
              <div className="add-place-list">
                {mockPlaces.map((p) => (
                  <button
                    key={p.id}
                    type="button"
                    className={`add-place-btn ${place === p.id ? 'selected' : ''}`}
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
            <div className="add-chips">
              {coffeeTypes.map((c) => (
                <Chip key={c} selected={coffeeType === c} onClick={() => setCoffeeType(c)}>
                  {c}
                </Chip>
              ))}
            </div>
          </section>
          <section>
            <label>Tasting notes</label>
            <div className="add-chips">
              {tastingNotes.map((n) => (
                <Chip key={n} selected={notes.has(n)} onClick={() => toggleNote(n)}>
                  {n}
                </Chip>
              ))}
            </div>
          </section>
          <section>
            <label>Photo (optional)</label>
            <div className="add-photo-btns">
              <button type="button" className="add-photo-btn">Take photo</button>
              <button type="button" className="add-photo-btn">Library</button>
            </div>
          </section>
          <section>
            <label>Additional comments (optional)</label>
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
