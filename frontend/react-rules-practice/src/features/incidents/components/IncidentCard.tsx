import { memo } from 'react'
import { Link } from 'react-router-dom'
import './IncidentCard.css'
import type { Incident } from '../types/incidentTypes'

type IncidentCardProps = {
  incident: Incident
}

function getStatusClass(status: Incident['status']): string {
  return `incident-badge incident-badge-status-${status.toLowerCase()}`
}

function getSeverityClass(severity: Incident['severity']): string {
  return `incident-badge incident-badge-severity-${severity.toLowerCase()}`
}

function IncidentCardComponent({ incident }: IncidentCardProps) {
  return (
    <article className="incident-card">
      <div className="incident-card-header">
        <div>
          <h3 className="incident-card-title">{incident.title}</h3>

          <p className="incident-card-id">
            <strong>ID:</strong> {incident.id}
          </p>
        </div>

        <Link className="incident-card-link" to={`/incidents/${incident.id}`}>
          View details
        </Link>
      </div>

      <div className="incident-badges">
        <span className={getStatusClass(incident.status)}>{incident.status}</span>
        <span className={getSeverityClass(incident.severity)}>{incident.severity}</span>
      </div>

      <p className="incident-card-description">{incident.description}</p>

      <details>
        <summary>Symptoms</summary>
        <ul>
          {incident.symptoms.map((symptom) => (
            <li key={symptom}>{symptom}</li>
          ))}
        </ul>
      </details>

      <p className="incident-card-notes">
        <strong>Notes:</strong> {incident.notes.length}
      </p>
    </article>
  )
}

export const IncidentCard = memo(IncidentCardComponent)