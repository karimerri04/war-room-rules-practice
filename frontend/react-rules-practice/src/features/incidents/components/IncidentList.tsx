import './IncidentList.css'
import type { Incident } from '../types/incidentTypes'
import { IncidentCard } from './IncidentCard'

type IncidentListProps = {
  incidents: Incident[]
}

export function IncidentList({ incidents }: IncidentListProps) {
  if (incidents.length === 0) {
    return <p className="incident-list-empty">No incidents found.</p>
  }

  return (
    <section>
      <h2 className="incident-list-title">Incidents</h2>

      <div className="incident-list">
        {incidents.map((incident) => (
          <IncidentCard key={incident.id} incident={incident} />
        ))}
      </div>
    </section>
  )
}