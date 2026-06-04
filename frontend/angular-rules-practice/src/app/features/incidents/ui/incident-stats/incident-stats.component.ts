import { Component, input, output } from '@angular/core'
import type { IncidentStats } from '../../models/incident.model'
import type { StatFilter } from '../../models/incident-filter.model'

type StatItem = {
  label: string
  value: number
  filter: StatFilter
}

@Component({
  selector: 'app-incident-stats',
  templateUrl: './incident-stats.component.html',
  styleUrl: './incident-stats.component.css',
})
export class IncidentStatsComponent {
  readonly stats = input.required<IncidentStats>()
  readonly statClick = output<StatFilter>()

  get items(): StatItem[] {
    const stats = this.stats()

    return [
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
  }

  onStatClick(filter: StatFilter): void {
    this.statClick.emit(filter)
  }
}