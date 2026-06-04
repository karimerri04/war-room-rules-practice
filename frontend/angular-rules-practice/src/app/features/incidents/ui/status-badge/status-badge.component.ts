import { Component, input } from '@angular/core'
import type { IncidentStatus } from '../../models/incident.model'

@Component({
  selector: 'app-status-badge',
  templateUrl: './status-badge.component.html',
  styleUrl: './status-badge.component.css',
})
export class StatusBadgeComponent {
  readonly status = input.required<IncidentStatus>()

  readonly labels: Record<IncidentStatus, string> = {
    OPEN: 'Open',
    INVESTIGATING: 'Investigating',
    RESOLVED: 'Resolved',
  }

  get cssClass(): string {
    return `badge badge--status-${this.status().toLowerCase()}`
  }

  get label(): string {
    return this.labels[this.status()]
  }
}