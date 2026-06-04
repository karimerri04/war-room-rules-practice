import { AsyncPipe } from '@angular/common'
import { Component, inject, signal } from '@angular/core'
import { combineLatest, map } from 'rxjs'
import { IncidentService } from '../../data-access/incident.service'
import type {
  SeverityFilter,
  StatFilter,
  StatusFilter,
} from '../../models/incident-filter.model'
import { IncidentFiltersComponent } from '../../ui/incident-filters/incident-filters.component'
import { IncidentListComponent } from '../../ui/incident-list/incident-list.component'
import { IncidentStatsComponent } from '../../ui/incident-stats/incident-stats.component'
import { filterIncidents } from '../../utils/incident-filters.util'

/**
 * Smart page component for the incident dashboard.
 *
 * Responsibilities:
 * - load incidents and statistics through the data-access service
 * - own local dashboard filter state with signals
 * - derive the visible incident list
 * - coordinate child UI components through inputs and outputs
 */
@Component({
  selector: 'app-incident-dashboard-page',
  imports: [AsyncPipe, IncidentStatsComponent, IncidentFiltersComponent, IncidentListComponent],
  templateUrl: './incident-dashboard-page.component.html',
  styleUrl: './incident-dashboard-page.component.css',
})
export class IncidentDashboardPageComponent {
  private readonly incidentService = inject(IncidentService)

  readonly selectedStatus = signal<StatusFilter>('ALL')
  readonly selectedSeverity = signal<SeverityFilter>('ALL')

  readonly incidents$ = this.incidentService.findAll()
  readonly stats$ = this.incidentService.getStats()

  /**
 * View model consumed by the template.
 *
 * It combines backend data with the current signal-based filters to expose a
 * single object to the HTML template.
 */
  readonly vm$ = combineLatest({
    incidents: this.incidents$,
    stats: this.stats$,
  }).pipe(
    map(({ incidents, stats }) => {
      const filteredIncidents = filterIncidents(
        incidents,
        this.selectedStatus(),
        this.selectedSeverity(),
      )

      return {
        incidents,
        filteredIncidents,
        stats,
      }
    }),
  )

  onStatusChange(status: StatusFilter): void {
    this.selectedStatus.set(status)
  }

  onSeverityChange(severity: SeverityFilter): void {
    this.selectedSeverity.set(severity)
  }

/**
 * Statistic cards act as shortcuts for dashboard filters.
 *
 * Selecting one filter dimension resets the other dimension to keep the result explicit.
 */
  onStatClick(filter: StatFilter): void {
    if (filter.type === 'ALL') {
      this.selectedStatus.set('ALL')
      this.selectedSeverity.set('ALL')
      return
    }

    if (filter.type === 'STATUS') {
      this.selectedStatus.set(filter.value)
      this.selectedSeverity.set('ALL')
      return
    }

    this.selectedSeverity.set(filter.value)
    this.selectedStatus.set('ALL')
  }
}