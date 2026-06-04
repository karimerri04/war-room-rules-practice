import { AsyncPipe } from '@angular/common'
import { Component, inject, signal } from '@angular/core'
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms'
import { ActivatedRoute, RouterLink } from '@angular/router'
import { catchError, EMPTY, switchMap, tap } from 'rxjs'
import { IncidentService } from '../../data-access/incident.service'
import type { Incident } from '../../models/incident.model'
import { SeverityBadgeComponent } from '../../ui/severity-badge/severity-badge.component'
import { StatusBadgeComponent } from '../../ui/status-badge/status-badge.component'

/**
 * Smart page component for incident investigation workflow.
 *
 * It owns the selected incident state, loads data from the route parameter,
 * and coordinates mutations such as starting investigation, adding notes and resolving.
 */
@Component({
  selector: 'app-incident-details-page',
  imports: [
    AsyncPipe,
    RouterLink,
    ReactiveFormsModule,
    StatusBadgeComponent,
    SeverityBadgeComponent,
  ],
  templateUrl: './incident-details-page.component.html',
  styleUrl: './incident-details-page.component.css',
})
export class IncidentDetailsPageComponent {
  private readonly route = inject(ActivatedRoute)
  private readonly incidentService = inject(IncidentService)
  private readonly formBuilder = inject(FormBuilder)

  readonly incident = signal<Incident | null>(null)
  readonly loading = signal<boolean>(true)
  readonly actionLoading = signal<boolean>(false)
  readonly error = signal<string | null>(null)
  readonly notification = signal<string | null>(null)

  /**
 * Reactive form used for collaboration notes.
 *
 * The form keeps validation explicit and avoids manually reading DOM values.
 */
  readonly noteForm = this.formBuilder.nonNullable.group({
    author: ['Karim', Validators.required],
    message: ['', Validators.required],
  })

  /**
 * Reactive form used to close an incident.
 *
 * Both root cause and resolution are required before calling the backend.
 */
  readonly resolveForm = this.formBuilder.nonNullable.group({
    rootCause: ['', Validators.required],
    resolution: ['', Validators.required],
  })

  /**
 * Route-driven loading stream.
 *
 * The async pipe subscribes to this stream from the template, which triggers the
 * initial incident loading and keeps loading/error state synchronized.
 */
  readonly incident$ = this.route.paramMap.pipe(
    tap(() => {
      this.loading.set(true)
      this.error.set(null)
    }),
    switchMap((params) => {
      const id = params.get('id')

      if (!id) {
        this.loading.set(false)
        this.error.set('Missing incident id')
        return EMPTY
      }

      return this.incidentService.findById(id).pipe(
        tap((incident) => {
          this.incident.set(incident)
          this.loading.set(false)
        }),
        catchError((err: unknown) => {
          this.error.set(err instanceof Error ? err.message : 'Unable to load incident.')
          this.loading.set(false)
          return EMPTY
        }),
      )
    }),
  )

  get canStartInvestigation(): boolean {
    return this.incident()?.status === 'OPEN'
  }

  get canResolve(): boolean {
    return this.incident()?.status !== 'RESOLVED'
  }

  startInvestigation(): void {
    const incident = this.incident()

    if (!incident) {
      return
    }

    this.actionLoading.set(true)
    this.notification.set(null)

    this.incidentService.startInvestigation(incident.id).subscribe({
      next: (updatedIncident) => {
        this.incident.set(updatedIncident)
        this.notification.set('Investigation started successfully.')
        this.actionLoading.set(false)
      },
      error: (err: unknown) => {
        this.notification.set(err instanceof Error ? err.message : 'Unable to start investigation.')
        this.actionLoading.set(false)
      },
    })
  }

  addNote(): void {
    const incident = this.incident()

    if (!incident || this.noteForm.invalid) {
      this.noteForm.markAllAsTouched()
      this.notification.set('Author and message are required.')
      return
    }

    this.actionLoading.set(true)
    this.notification.set(null)

    this.incidentService.addNote(incident.id, this.noteForm.getRawValue()).subscribe({
      next: (updatedIncident) => {
        this.incident.set(updatedIncident)
        this.noteForm.reset({
          author: 'Karim',
          message: '',
        })
        this.notification.set('Investigation note added successfully.')
        this.actionLoading.set(false)
      },
      error: (err: unknown) => {
        this.notification.set(err instanceof Error ? err.message : 'Unable to add note.')
        this.actionLoading.set(false)
      },
    })
  }

  resolveIncident(): void {
    const incident = this.incident()

    if (!incident || this.resolveForm.invalid) {
      this.resolveForm.markAllAsTouched()
      this.notification.set('Root cause and resolution are required.')
      return
    }

    this.actionLoading.set(true)
    this.notification.set(null)

    this.incidentService.resolve(incident.id, this.resolveForm.getRawValue()).subscribe({
      next: (updatedIncident) => {
        this.incident.set(updatedIncident)
        this.resolveForm.reset()
        this.notification.set('Incident resolved successfully.')
        this.actionLoading.set(false)
      },
      error: (err: unknown) => {
        this.notification.set(err instanceof Error ? err.message : 'Unable to resolve incident.')
        this.actionLoading.set(false)
      },
    })
  }
}