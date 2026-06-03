import { useCallback, useEffect, useState } from 'react'
import { findAllIncidents, findIncidentStats } from '../api/incidentApi'
import type { Incident, IncidentStats } from '../types/incidentTypes'

type UseIncidentsResult = {
  incidents: Incident[]
  stats: IncidentStats | null
  loading: boolean
  error: string | null
  reload: () => Promise<void>
}

export function useIncidents(): UseIncidentsResult {
  const [incidents, setIncidents] = useState<Incident[]>([])
  const [stats, setStats] = useState<IncidentStats | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const reload = useCallback(async () => {
    try {
      setLoading(true)
      setError(null)

      const [incidentsResponse, statsResponse] = await Promise.all([
        findAllIncidents(),
        findIncidentStats(),
      ])

      setIncidents(incidentsResponse)
      setStats(statsResponse)
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error')
    } finally {
      setLoading(false)
    }
  }, [])

  useEffect(() => {
    void reload()
  }, [reload])

  return {
    incidents,
    stats,
    loading,
    error,
    reload,
  }
}