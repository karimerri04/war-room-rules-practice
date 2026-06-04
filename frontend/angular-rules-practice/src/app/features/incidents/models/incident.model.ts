export type IncidentSeverity = 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL'

export type IncidentStatus = 'OPEN' | 'INVESTIGATING' | 'RESOLVED'

export type InvestigationNote = {
  author: string
  message: string
  createdAt: string
}

export type Incident = {
  id: string
  title: string
  description: string
  severity: IncidentSeverity
  status: IncidentStatus
  symptoms: string[]
  rootCause: string
  resolution: string
  createdAt: string
  resolvedAt: string | null
  notes: InvestigationNote[]
}

export type IncidentStats = {
  total: number
  open: number
  investigating: number
  resolved: number
  critical: number
  high: number
  medium: number
  low: number
}

export type AddIncidentNoteRequest = {
  author: string
  message: string
}

export type ResolveIncidentRequest = {
  rootCause: string
  resolution: string
}