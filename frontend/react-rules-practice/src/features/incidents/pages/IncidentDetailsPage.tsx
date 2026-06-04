import { useCallback, useEffect, useState } from 'react'
import type { FormEvent } from 'react'
import { Link, useParams } from 'react-router-dom'
import {
  addIncidentNote,
  findIncidentById,
  resolveIncident,
  startInvestigation,
} from '../api/incidentApi'
import type { Incident } from '../types/incidentTypes'
import { Loading } from '../../../shared/components/Loading'
import { SeverityBadge } from '../components/badges/SeverityBadge'
import { StatusBadge } from '../components/badges/StatusBadge'
import './IncidentDetailsPage.css'

export function IncidentDetailsPage() {
  const { id } = useParams<{ id: string }>()

  const [incident, setIncident] = useState<Incident | null>(null)
  const [loading, setLoading] = useState(true)
  const [actionLoading, setActionLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [notification, setNotification] = useState<string | null>(null)

  const loadIncident = useCallback(async () => {
    if (!id) {
      setError('Missing incident id')
      setLoading(false)
      return
    }

    try {
      setLoading(true)
      setError(null)

      const response = await findIncidentById(id)
      setIncident(response)
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error')
    } finally {
      setLoading(false)
    }
  }, [id])

  useEffect(() => {
    void loadIncident()
  }, [loadIncident])

  const handleStartInvestigation = useCallback(async () => {
    if (!incident) return

    try {
      setActionLoading(true)
      setNotification(null)

      const updatedIncident = await startInvestigation(incident.id)
      setIncident(updatedIncident)
      setNotification('Investigation started successfully.')
    } catch (err) {
      setNotification(err instanceof Error ? err.message : 'Unable to start investigation.')
    } finally {
      setActionLoading(false)
    }
  }, [incident])

  const handleAddNote = useCallback(
    async (event: FormEvent<HTMLFormElement>) => {
      event.preventDefault()

      if (!incident) return

      const formData = new FormData(event.currentTarget)
      const author = String(formData.get('author') ?? '').trim()
      const message = String(formData.get('message') ?? '').trim()

      if (!author || !message) {
        setNotification('Author and message are required.')
        return
      }

      try {
        setActionLoading(true)
        setNotification(null)

        const updatedIncident = await addIncidentNote(incident.id, { author, message })
        setIncident(updatedIncident)
        setNotification('Investigation note added successfully.')
        event.currentTarget.reset()
      } catch (err) {
        setNotification(err instanceof Error ? err.message : 'Unable to add note.')
      } finally {
        setActionLoading(false)
      }
    },
    [incident],
  )

  const handleResolve = useCallback(
    async (event: FormEvent<HTMLFormElement>) => {
      event.preventDefault()

      if (!incident) return

      const formData = new FormData(event.currentTarget)
      const rootCause = String(formData.get('rootCause') ?? '').trim()
      const resolution = String(formData.get('resolution') ?? '').trim()

      if (!rootCause || !resolution) {
        setNotification('Root cause and resolution are required.')
        return
      }

      try {
        setActionLoading(true)
        setNotification(null)

        const updatedIncident = await resolveIncident(incident.id, { rootCause, resolution })
        setIncident(updatedIncident)
        setNotification('Incident resolved successfully.')
        event.currentTarget.reset()
      } catch (err) {
        setNotification(err instanceof Error ? err.message : 'Unable to resolve incident.')
      } finally {
        setActionLoading(false)
      }
    },
    [incident],
  )

  if (loading) {
    return <Loading />
  }

  if (error) {
    return (
      <main className="incident-details-page">
        <Link to="/incidents" className="back-link">
          ← Back to dashboard
        </Link>

        <section className="details-error" role="alert">
          <p className="section-eyebrow">Loading error</p>
          <h1>Unable to load incident</h1>
          <p>{error}</p>
          <button type="button" onClick={() => void loadIncident()}>
            Retry
          </button>
        </section>
      </main>
    )
  }

  if (!incident) {
    return null
  }

  const canStartInvestigation = incident.status === 'OPEN'
  const canResolve = incident.status !== 'RESOLVED'

  return (
    <main className="incident-details-page">
      <Link to="/incidents" className="back-link">
        ← Back to dashboard
      </Link>

      <section className="details-hero">
        <div className="details-hero__content">
          <p className="section-eyebrow">Incident details</p>
          <h1>{incident.title}</h1>
          <p className="details-description">{incident.description}</p>

          <dl className="incident-meta-grid">
            <div>
              <dt>Incident ID</dt>
              <dd>{incident.id}</dd>
            </div>
            <div>
              <dt>Created at</dt>
              <dd>{incident.createdAt}</dd>
            </div>
            <div>
              <dt>Resolved at</dt>
              <dd>{incident.resolvedAt ?? 'Not resolved yet'}</dd>
            </div>
          </dl>
        </div>

        <div className="details-hero__side">
          <StatusBadge status={incident.status} />
          <SeverityBadge severity={incident.severity} />
        </div>
      </section>

      <section className="details-section">
        <div className="details-section__header">
          <div>
            <p className="section-eyebrow">Signals</p>
            <h2>Symptoms</h2>
          </div>
          <span className="section-counter">{incident.symptoms.length}</span>
        </div>

        <ul className="symptoms-list">
          {incident.symptoms.map((symptom) => (
            <li key={symptom}>{symptom}</li>
          ))}
        </ul>
      </section>

      <section className="details-section">
        <div className="details-section__header">
          <div>
            <p className="section-eyebrow">Workflow</p>
            <h2>Actions</h2>
          </div>
        </div>

        <div className="action-panel">
          <div>
            <h3>Start investigation</h3>
            <p>
              Move the incident from open state to investigation state so the team can begin
              diagnosis.
            </p>
          </div>

          <button
            type="button"
            disabled={!canStartInvestigation || actionLoading}
            onClick={() => void handleStartInvestigation()}
          >
            Start investigation
          </button>
        </div>
      </section>

      <section className="details-section">
        <div className="details-section__header">
          <div>
            <p className="section-eyebrow">Collaboration</p>
            <h2>Investigation notes</h2>
          </div>
          <span className="section-counter">{incident.notes.length}</span>
        </div>

        {incident.notes.length === 0 ? (
          <p className="empty-state">No notes yet.</p>
        ) : (
          <ul className="notes-list">
            {incident.notes.map((note) => (
              <li key={`${note.author}-${note.createdAt}`}>
                <div className="note-header">
                  <strong>{note.author}</strong>
                  <small>{note.createdAt}</small>
                </div>
                <p>{note.message}</p>
              </li>
            ))}
          </ul>
        )}

        <form className="details-form" onSubmit={(event) => void handleAddNote(event)}>
          <label htmlFor="note-author">Author</label>
          <input id="note-author" name="author" defaultValue="Karim" />

          <label htmlFor="note-message">Message</label>
          <textarea
            id="note-message"
            name="message"
            rows={3}
            placeholder="Describe the investigation step, hypothesis, or finding..."
          />

          <button type="submit" disabled={actionLoading}>
            Add note
          </button>
        </form>
      </section>

      <section className="details-section">
        <div className="details-section__header">
          <div>
            <p className="section-eyebrow">Closure</p>
            <h2>Resolution</h2>
          </div>
        </div>

        {incident.status === 'RESOLVED' ? (
          <div className="resolution-summary">
            <div>
              <h3>Root cause</h3>
              <p>{incident.rootCause}</p>
            </div>

            <div>
              <h3>Resolution</h3>
              <p>{incident.resolution}</p>
            </div>

            <div>
              <h3>Resolved at</h3>
              <p>{incident.resolvedAt}</p>
            </div>
          </div>
        ) : (
          <form className="details-form" onSubmit={(event) => void handleResolve(event)}>
            <label htmlFor="root-cause">Root cause</label>
            <textarea
              id="root-cause"
              name="rootCause"
              rows={3}
              placeholder="Explain the technical cause of the incident..."
            />

            <label htmlFor="resolution">Resolution</label>
            <textarea
              id="resolution"
              name="resolution"
              rows={3}
              placeholder="Explain what was done to resolve the incident..."
            />

            <button type="submit" disabled={!canResolve || actionLoading}>
              Resolve incident
            </button>
          </form>
        )}
      </section>

      <p className="details-notification" aria-live="polite">
        {notification}
      </p>
    </main>
  )
}