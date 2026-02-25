import { useState } from 'react'
import { Link } from 'react-router-dom'
import { coffeeTypes, tastingNotes, mockPlaces } from '../data/mockBrews'
import './AddBrew.css'

export default function AddBrew() {
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
    setSubmitted(true)
  }

  const canSubmit = coffeeType && (atHome || place)

  if (submitted) {
    return (
      <div className="add-page">
        <div className="add-success">
          <h2>☕ Brew posted!</h2>
          <p>Thanks for sharing. Check your feed.</p>
          <Link to="/feed" className="btn btn-primary">View Feed</Link>
          <button type="button" className="btn btn-secondary" onClick={() => setSubmitted(false)}>Post another</button>
        </div>
      </div>
    )
  }

  return (
    <div className="add-page">
      <header className="add-header">
        <h1>Add Brew</h1>
        <Link to="/">Cancel</Link>
      </header>
      <form className="add-form" onSubmit={handleSubmit}>
        <section>
          <label>Rating (beans)</label>
          <div className="bean-selector">
            {[1, 2, 3, 4, 5].map((r) => (
              <button key={r} type="button" className={`bean-btn ${r <= rating ? 'filled' : ''}`} onClick={() => setRating(r)} aria-pressed={r <= rating}>☕</button>
            ))}
          </div>
        </section>
        <section>
          <label>Where did you brew?</label>
          <div className="where-tabs">
            <button type="button" className={atHome ? 'active' : ''} onClick={() => { setAtHome(true); setPlace(null) }}>At home</button>
            <button type="button" className={!atHome ? 'active' : ''} onClick={() => setAtHome(false)}>Coffee shop</button>
          </div>
          {!atHome && (
            <div className="place-picker">
              {mockPlaces.map((p) => (
                <button key={p.id} type="button" className={`place-option ${place === p.id ? 'selected' : ''}`} onClick={() => setPlace(p.id)}>{p.name} · {p.neighborhood}</button>
              ))}
            </div>
          )}
        </section>
        <section>
          <label>What did you have?</label>
          <div className="chip-grid">
            {coffeeTypes.map((c) => (
              <button key={c} type="button" className={`chip ${coffeeType === c ? 'selected' : ''}`} onClick={() => setCoffeeType(c)}>{c}</button>
            ))}
          </div>
        </section>
        <section>
          <label>Tasting notes</label>
          <div className="chip-grid">
            {tastingNotes.map((n) => (
              <button key={n} type="button" className={`chip ${notes.has(n) ? 'selected' : ''}`} onClick={() => toggleNote(n)}>{n}</button>
            ))}
          </div>
        </section>
        <section>
          <label>Additional comments</label>
          <textarea placeholder="Notes, vibe, anything else..." value={comments} onChange={(e) => setComments(e.target.value)} rows={3} />
        </section>
        <button type="submit" className="btn btn-primary btn-block" disabled={!canSubmit}>Publish brew</button>
      </form>
    </div>
  )
}
