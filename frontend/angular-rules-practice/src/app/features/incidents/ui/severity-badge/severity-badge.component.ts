import { Component, input } from '@angular/core'
import type { IncidentSeverity } from '../../models/incident.model'

@Component({
  selector: 'app-severity-badge',
  templateUrl: './severity-badge.component.html',
  styleUrl: './severity-badge.component.css',
})
export class SeverityBadgeComponent {
  readonly severity = input.required<IncidentSeverity>()

  readonly labels: Record<IncidentSeverity, string> = {
    LOW: 'Low',
    MEDIUM: 'Medium',
    HIGH: 'High',
    CRITICAL: 'Critical',
  }

  get cssClass(): string {
    return `badge badge--severity-${this.severity().toLowerCase()}`
  }

  get label(): string {
    return this.labels[this.severity()]
  }
}