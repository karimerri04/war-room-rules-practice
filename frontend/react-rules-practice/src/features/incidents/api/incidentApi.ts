import { API_BASE_URL } from '../../../shared/config/apiConfig'
import type {
  AddIncidentNoteRequest,
  Incident,
  IncidentStats,
  ResolveIncidentRequest,
} from '../types/incidentTypes'

async function requestJson<T>(url: string, options?: RequestInit): Promise<T> {
  const response = await fetch(url, {
    headers: {
      'Content-Type': 'application/json',
      ...(options?.headers ?? {}),
    },
    ...options,
  })

  if (!response.ok) {
    const message = await response.text()
    throw new Error(message || `Request failed with status ${response.status}`)
  }

  return response.json() as Promise<T>
}

export async function findAllIncidents(): Promise<Incident[]> {
  return requestJson<Incident[]>(`${API_BASE_URL}/api/java-incidents`)
}

export async function findIncidentStats(): Promise<IncidentStats> {
  return requestJson<IncidentStats>(`${API_BASE_URL}/api/java-incidents/stats`)
}

export async function findIncidentById(id: string): Promise<Incident> {
  return requestJson<Incident>(`${API_BASE_URL}/api/java-incidents/${id}`)
}

export async function startInvestigation(id: string): Promise<Incident> {
  return requestJson<Incident>(`${API_BASE_URL}/api/java-incidents/${id}/start-investigation`, {
    method: 'PATCH',
  })
}

export async function addIncidentNote(
  id: string,
  request: AddIncidentNoteRequest,
): Promise<Incident> {
  return requestJson<Incident>(`${API_BASE_URL}/api/java-incidents/${id}/notes`, {
    method: 'POST',
    body: JSON.stringify(request),
  })
}

export async function resolveIncident(
  id: string,
  request: ResolveIncidentRequest,
): Promise<Incident> {
  return requestJson<Incident>(`${API_BASE_URL}/api/java-incidents/${id}/resolve`, {
    method: 'PATCH',
    body: JSON.stringify(request),
  })
}