import './IncidentFilters.css'
import type { IncidentSeverity, IncidentStatus } from '../types/incidentTypes'

export type StatusFilter = 'ALL' | IncidentStatus
export type SeverityFilter = 'ALL' | IncidentSeverity

type IncidentFiltersProps = {
  selectedStatus: StatusFilter
  selectedSeverity: SeverityFilter
  onStatusChange: (status: StatusFilter) => void
  onSeverityChange: (severity: SeverityFilter) => void
}

export function IncidentFilters({
  selectedStatus,
  selectedSeverity,
  onStatusChange,
  onSeverityChange,
}: IncidentFiltersProps) {
  return (
    <section className="incident-filters" aria-label="Incident filters">
      <div className="incident-filter-field">
        <label htmlFor="status-filter">Status</label>
        <select
          id="status-filter"
          value={selectedStatus}
          onChange={(event) => onStatusChange(event.target.value as StatusFilter)}
        >
          <option value="ALL">All</option>
          <option value="OPEN">Open</option>
          <option value="INVESTIGATING">Investigating</option>
          <option value="RESOLVED">Resolved</option>
        </select>
      </div>

      <div className="incident-filter-field">
        <label htmlFor="severity-filter">Severity</label>
        <select
          id="severity-filter"
          value={selectedSeverity}
          onChange={(event) => onSeverityChange(event.target.value as SeverityFilter)}
        >
          <option value="ALL">All</option>
          <option value="LOW">Low</option>
          <option value="MEDIUM">Medium</option>
          <option value="HIGH">High</option>
          <option value="CRITICAL">Critical</option>
        </select>
      </div>
    </section>
  )
}