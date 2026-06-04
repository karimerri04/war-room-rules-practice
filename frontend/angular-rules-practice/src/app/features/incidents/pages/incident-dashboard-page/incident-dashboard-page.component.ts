import { AsyncPipe } from '@angular/common'
import { Component, inject } from '@angular/core'
import { combineLatest, map } from 'rxjs'
import { IncidentService } from '../../data-access/incident.service'

@Component({
  selector: 'app-incident-dashboard-page',
  imports: [AsyncPipe],
  templateUrl: './incident-dashboard-page.component.html',
  styleUrl: './incident-dashboard-page.component.css',
})
export class IncidentDashboardPageComponent {
  private readonly incidentService = inject(IncidentService)

  readonly incidents$ = this.incidentService.findAll()
  readonly stats$ = this.incidentService.getStats()

  readonly vm$ = combineLatest({
    incidents: this.incidents$,
    stats: this.stats$,
  }).pipe(
    map(({ incidents, stats }) => ({
      incidents,
      stats,
    })),
  )
}