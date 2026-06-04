import { useCallback, useEffect, useState } from 'react'
import type { SyntheticEvent } from 'react'
import { Link, useParams } from 'react-router-dom'
import {
  addIncidentNote,
  findIncidentById,
  resolveIncident,
  startInvestigation,
} from '../api/incidentApi'
import type { Incident } from '../types/incidentTypes'
import { Loading } from '../../../shared/components/Loading'
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
    async (event: SyntheticEvent<HTMLFormElement>) => {
      event.preventDefault()

      if (!incident) return

      const formData = new FormData(event.currentTarget)
      const author = String(formData.get('author') ?? '')
      const message = String(formData.get('message') ?? '')

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
    async (event: SyntheticEvent<HTMLFormElement>) => {
      event.preventDefault()

      if (!incident) return

      const formData = new FormData(event.currentTarget)
      const rootCause = String(formData.get('rootCause') ?? '')
      const resolution = String(formData.get('resolution') ?? '')

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

      <section className="details-header">
        <div>
          <h1>{incident.title}</h1>
          <p>{incident.description}</p>
        </div>

        <div className="details-badges">
          <span>{incident.status}</span>
          <span>{incident.severity}</span>
        </div>
      </section>

      <section className="details-section">
        <h2>Symptoms</h2>
        <ul>
          {incident.symptoms.map((symptom) => (
            <li key={symptom}>{symptom}</li>
          ))}
        </ul>
      </section>

      <section className="details-section">
        <h2>Actions</h2>

        <button
          type="button"
          disabled={!canStartInvestigation || actionLoading}
          onClick={() => void handleStartInvestigation()}
        >
          Start investigation
        </button>
      </section>

      <section className="details-section">
        <h2>Investigation notes</h2>

        {incident.notes.length === 0 ? (
          <p>No notes yet.</p>
        ) : (
          <ul className="notes-list">
            {incident.notes.map((note) => (
              <li key={`${note.author}-${note.createdAt}`}>
                <strong>{note.author}</strong>
                <p>{note.message}</p>
                <small>{note.createdAt}</small>
              </li>
            ))}
          </ul>
        )}

        <form className="details-form" onSubmit={(event) => void handleAddNote(event)}>
          <label htmlFor="note-author">Author</label>
          <input id="note-author" name="author" defaultValue="Karim" />

          <label htmlFor="note-message">Message</label>
          <textarea id="note-message" name="message" rows={3} />

          <button type="submit" disabled={actionLoading}>
            Add note
          </button>
        </form>
      </section>

      <section className="details-section">
        <h2>Resolution</h2>

        {incident.status === 'RESOLVED' ? (
          <div>
            <p>
              <strong>Root cause:</strong> {incident.rootCause}
            </p>
            <p>
              <strong>Resolution:</strong> {incident.resolution}
            </p>
            <p>
              <strong>Resolved at:</strong> {incident.resolvedAt}
            </p>
          </div>
        ) : (
          <form className="details-form" onSubmit={(event) => void handleResolve(event)}>
            <label htmlFor="root-cause">Root cause</label>
            <textarea id="root-cause" name="rootCause" rows={3} />

            <label htmlFor="resolution">Resolution</label>
            <textarea id="resolution" name="resolution" rows={3} />

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