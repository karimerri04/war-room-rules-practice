import './IncidentStats.css'
import type { IncidentStats as IncidentStatsType } from '../types/incidentTypes'

type IncidentStatsProps = {
  stats: IncidentStatsType | null
}

export function IncidentStats({ stats }: IncidentStatsProps) {
  if (!stats) {
    return null
  }

  const items = [
    ['Total', stats.total],
    ['Open', stats.open],
    ['Investigating', stats.investigating],
    ['Resolved', stats.resolved],
    ['Critical', stats.critical],
    ['High', stats.high],
    ['Medium', stats.medium],
    ['Low', stats.low],
  ]

  return (
    <section className="incident-stats" aria-label="Incident statistics">
      {items.map(([label, value]) => (
        <article className="incident-stat-card" key={label}>
          <p className="incident-stat-label">{label}</p>
          <p className="incident-stat-value">{value}</p>
        </article>
      ))}
    </section>
  )
}