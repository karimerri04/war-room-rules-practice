import type { Incident } from '../models/incident.model'
import type { SeverityFilter, StatusFilter } from '../models/incident-filter.model'

/**
 * Derives the visible incident list from the full incident collection and the selected filters.
 */
export function filterIncidents(
  incidents: Incident[],
  selectedStatus: StatusFilter,
  selectedSeverity: SeverityFilter,
): Incident[] {
  return incidents.filter((incident) => {
    const matchesStatus = selectedStatus === 'ALL' || incident.status === selectedStatus
    const matchesSeverity = selectedSeverity === 'ALL' || incident.severity === selectedSeverity

    return matchesStatus && matchesSeverity
  })
}