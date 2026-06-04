import { useCallback, useMemo, useState } from 'react'
import { IncidentFilters } from '../components/IncidentFilters'
import { IncidentList } from '../components/IncidentList'
import { IncidentStats } from '../components/IncidentStats'
import { useIncidents } from '../hooks/useIncidents'
import type { Incident, IncidentSeverity, IncidentStatus } from '../types/incidentTypes'
import { Loading } from '../../../shared/components/Loading'
import type { SeverityFilter, StatusFilter } from '../components/IncidentFilters'
import './IncidentDashboardPage.css'

type StatFilter =
  | { type: 'ALL' }
  | { type: 'STATUS'; value: IncidentStatus }
  | { type: 'SEVERITY'; value: IncidentSeverity }

/**
* Keeps filtering logic outside the component body to make it easy to test,
* read and reuse. The dashboard owns the filter state and derives the visible
* incidents from the full incident list.
*/
function filterIncidents(
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

export function IncidentDashboardPage() {
  const { incidents, stats, loading, error, reload } = useIncidents()

  const [selectedStatus, setSelectedStatus] = useState<StatusFilter>('ALL')
  const [selectedSeverity, setSelectedSeverity] = useState<SeverityFilter>('ALL')

  /**
 * Statistic cards act as shortcuts for dashboard filters.
 * Clicking a status resets the severity filter, and clicking a severity resets
 * the status filter, so the resulting view stays explicit and predictable.
 */
  const handleStatClick = useCallback((filter: StatFilter) => {
    if (filter.type === 'ALL') {
      setSelectedStatus('ALL')
      setSelectedSeverity('ALL')
      return
    }

    if (filter.type === 'STATUS') {
      setSelectedStatus(filter.value)
      setSelectedSeverity('ALL')
      return
    }

    setSelectedSeverity(filter.value)
    setSelectedStatus('ALL')
  }, [])

  const filteredIncidents = useMemo(
    () => filterIncidents(incidents, selectedStatus, selectedSeverity),
    [incidents, selectedStatus, selectedSeverity],
  )

  if (loading) {
    return <Loading />
  }

  if (error) {
    return (
      <section className="dashboard-error" role="alert">
        <h2>Unable to load incidents</h2>
        <p>{error}</p>
        <button type="button" onClick={() => void reload()}>
          Retry
        </button>
      </section>
    )
  }

  return (
    <main className="dashboard-page">
      <header className="dashboard-header">
        <h1 className="dashboard-title">War Room Incident Dashboard</h1>
        <p className="dashboard-subtitle">
          Diagnose, investigate and resolve technical incidents.
        </p>
      </header>

      <div className="dashboard-content">
        <IncidentStats stats={stats} onStatClick={handleStatClick} />

        <IncidentFilters
          selectedStatus={selectedStatus}
          selectedSeverity={selectedSeverity}
          onStatusChange={setSelectedStatus}
          onSeverityChange={setSelectedSeverity}
        />

        <p className="dashboard-count">
          Showing {filteredIncidents.length} of {incidents.length} incidents.
        </p>

        <IncidentList incidents={filteredIncidents} />
      </div>
    </main>
  )
}