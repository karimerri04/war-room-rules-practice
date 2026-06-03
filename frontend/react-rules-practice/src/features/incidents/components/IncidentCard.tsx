import { memo } from 'react'
import './IncidentCard.css'
import type { Incident } from '../types/incidentTypes'

type IncidentCardProps = {
  incident: Incident
}

function IncidentCardComponent({ incident }: IncidentCardProps) {
  return (
    <article className="incident-card">
      <div className="incident-card-header">
        <div>
          <h3 className="incident-card-title">{incident.title}</h3>

          <p>
            <strong>ID:</strong> {incident.id}
          </p>
        </div>
      </div>

      <div className="incident-badges">
        <span className="incident-badge">{incident.status}</span>
        <span className="incident-badge">{incident.severity}</span>
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

      <p>
        <strong>Notes:</strong> {incident.notes.length}
      </p>
    </article>
  )
}

export const IncidentCard = memo(IncidentCardComponent)