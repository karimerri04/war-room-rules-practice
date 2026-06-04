import { Component, input, output } from '@angular/core'
import type { SeverityFilter, StatusFilter } from '../../models/incident-filter.model'

@Component({
  selector: 'app-incident-filters',
  templateUrl: './incident-filters.component.html',
  styleUrl: './incident-filters.component.css',
})
export class IncidentFiltersComponent {
  readonly selectedStatus = input.required<StatusFilter>()
  readonly selectedSeverity = input.required<SeverityFilter>()

  readonly statusChange = output<StatusFilter>()
  readonly severityChange = output<SeverityFilter>()

  onStatusChange(value: string): void {
    this.statusChange.emit(value as StatusFilter)
  }

  onSeverityChange(value: string): void {
    this.severityChange.emit(value as SeverityFilter)
  }
}