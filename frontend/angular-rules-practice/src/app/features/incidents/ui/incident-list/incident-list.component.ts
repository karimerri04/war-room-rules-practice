import { Component, input } from '@angular/core'
import type { Incident } from '../../models/incident.model'
import { IncidentCardComponent } from '../incident-card/incident-card.component'

@Component({
  selector: 'app-incident-list',
  imports: [IncidentCardComponent],
  templateUrl: './incident-list.component.html',
  styleUrl: './incident-list.component.css',
})
export class IncidentListComponent {
  readonly incidents = input.required<Incident[]>()
}