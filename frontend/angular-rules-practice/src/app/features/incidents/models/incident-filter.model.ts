import type { IncidentSeverity, IncidentStatus } from './incident.model'

export type StatusFilter = 'ALL' | IncidentStatus

export type SeverityFilter = 'ALL' | IncidentSeverity

export type StatFilter =
  | { type: 'ALL' }
  | { type: 'STATUS'; value: IncidentStatus }
  | { type: 'SEVERITY'; value: IncidentSeverity }