import { HttpClient } from '@angular/common/http'
import { inject, Injectable } from '@angular/core'
import { Observable } from 'rxjs'
import { API_BASE_URL } from '../../../core/config/api.config'
import {
  AddIncidentNoteRequest,
  Incident,
  IncidentStats,
  ResolveIncidentRequest,
} from '../models/incident.model'

@Injectable({
  providedIn: 'root',
})
export class IncidentService {
  private readonly http = inject(HttpClient)
  private readonly baseUrl = API_BASE_URL

  findAll(): Observable<Incident[]> {
    return this.http.get<Incident[]>(this.baseUrl)
  }

  findById(id: string): Observable<Incident> {
    return this.http.get<Incident>(`${this.baseUrl}/${id}`)
  }

  getStats(): Observable<IncidentStats> {
    return this.http.get<IncidentStats>(`${this.baseUrl}/stats`)
  }

  startInvestigation(id: string): Observable<Incident> {
    return this.http.patch<Incident>(`${this.baseUrl}/${id}/start-investigation`, {})
  }

  addNote(id: string, request: AddIncidentNoteRequest): Observable<Incident> {
    return this.http.post<Incident>(`${this.baseUrl}/${id}/notes`, request)
  }

  resolve(id: string, request: ResolveIncidentRequest): Observable<Incident> {
    return this.http.patch<Incident>(`${this.baseUrl}/${id}/resolve`, request)
  }
}