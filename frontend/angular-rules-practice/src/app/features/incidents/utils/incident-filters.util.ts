import type { Incident } from '../models/incident.model'
import type { SeverityFilter, StatusFilter } from '../models/incident-filter.model'

/**
 * Derives the visible incident list from the complete incident collection.
 *
 * The dashboard owns the selected filters, while this utility keeps the filtering
 * rule pure, reusable and easy to test.
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