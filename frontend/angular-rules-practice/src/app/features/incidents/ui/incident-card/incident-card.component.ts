import { Component, input } from '@angular/core'
import { RouterLink } from '@angular/router'
import type { Incident } from '../../models/incident.model'
import { SeverityBadgeComponent } from '../severity-badge/severity-badge.component'
import { StatusBadgeComponent } from '../status-badge/status-badge.component'

@Component({
  selector: 'app-incident-card',
  imports: [RouterLink, StatusBadgeComponent, SeverityBadgeComponent],
  templateUrl: './incident-card.component.html',
  styleUrl: './incident-card.component.css',
})
export class IncidentCardComponent {
  readonly incident = input.required<Incident>()
}