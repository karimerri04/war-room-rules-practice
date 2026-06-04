import './IncidentStats.css'
import type {
  IncidentSeverity,
  IncidentStats as IncidentStatsType,
  IncidentStatus,
} from '../types/incidentTypes'

type StatFilter =
  | { type: 'ALL' }
  | { type: 'STATUS'; value: IncidentStatus }
  | { type: 'SEVERITY'; value: IncidentSeverity }

type IncidentStatsProps = {
  stats: IncidentStatsType | null
  onStatClick: (filter: StatFilter) => void
}

type StatItem = {
  label: string
  value: number
  filter: StatFilter
}

export function IncidentStats({ stats, onStatClick }: IncidentStatsProps) {
  if (!stats) {
    return null
  }

  const items: StatItem[] = [
    { label: 'Total', value: stats.total, filter: { type: 'ALL' } },
    { label: 'Open', value: stats.open, filter: { type: 'STATUS', value: 'OPEN' } },
    {
      label: 'Investigating',
      value: stats.investigating,
      filter: { type: 'STATUS', value: 'INVESTIGATING' },
    },
    { label: 'Resolved', value: stats.resolved, filter: { type: 'STATUS', value: 'RESOLVED' } },
    { label: 'Critical', value: stats.critical, filter: { type: 'SEVERITY', value: 'CRITICAL' } },
    { label: 'High', value: stats.high, filter: { type: 'SEVERITY', value: 'HIGH' } },
    { label: 'Medium', value: stats.medium, filter: { type: 'SEVERITY', value: 'MEDIUM' } },
    { label: 'Low', value: stats.low, filter: { type: 'SEVERITY', value: 'LOW' } },
  ]

  return (
    <section className="incident-stats" aria-label="Incident statistics">
      {items.map((item) => (
        <button
          type="button"
          className="incident-stat-card"
          key={item.label}
          onClick={() => onStatClick(item.filter)}
        >
          <span className="incident-stat-label">{item.label}</span>
          <span className="incident-stat-value">{item.value}</span>
        </button>
      ))}
    </section>
  )
}