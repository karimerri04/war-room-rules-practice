import { useMemo, useState } from 'react'
import { IncidentFilters } from '../components/IncidentFilters'
import { IncidentList } from '../components/IncidentList'
import { IncidentStats } from '../components/IncidentStats'
import { useIncidents } from '../hooks/useIncidents'
import type { Incident } from '../types/incidentTypes'
import { Loading } from '../../../shared/components/Loading'
import type { SeverityFilter, StatusFilter } from '../components/IncidentFilters'
import './IncidentDashboardPage.css'

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
        <IncidentStats stats={stats} />

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