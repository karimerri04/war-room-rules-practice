import { ComponentFixture, TestBed } from '@angular/core/testing'
import { IncidentFiltersComponent } from './incident-filters.component'
import type { SeverityFilter, StatusFilter } from '../../models/incident-filter.model'

describe('IncidentFiltersComponent', () => {
  let fixture: ComponentFixture<IncidentFiltersComponent>
  let component: IncidentFiltersComponent

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [IncidentFiltersComponent],
    }).compileComponents()

    fixture = TestBed.createComponent(IncidentFiltersComponent)
    component = fixture.componentInstance
    fixture.componentRef.setInput('selectedStatus', 'ALL')
    fixture.componentRef.setInput('selectedSeverity', 'ALL')
    fixture.detectChanges()
  })

  it('should render selected filters', () => {
    const statusSelect = fixture.nativeElement.querySelector('#status-filter') as HTMLSelectElement
    const severitySelect = fixture.nativeElement.querySelector('#severity-filter') as HTMLSelectElement

    expect(statusSelect.value).toBe('ALL')
    expect(severitySelect.value).toBe('ALL')
  })

  it('should emit status change', () => {
    let emittedStatus: StatusFilter | null = null
    component.statusChange.subscribe((status) => {
      emittedStatus = status
    })

    const statusSelect = fixture.nativeElement.querySelector('#status-filter') as HTMLSelectElement
    statusSelect.value = 'INVESTIGATING'
    statusSelect.dispatchEvent(new Event('change'))

    expect(emittedStatus).toBe('INVESTIGATING')
  })

  it('should emit severity change', () => {
    let emittedSeverity: SeverityFilter | null = null
    component.severityChange.subscribe((severity) => {
      emittedSeverity = severity
    })

    const severitySelect = fixture.nativeElement.querySelector('#severity-filter') as HTMLSelectElement
    severitySelect.value = 'HIGH'
    severitySelect.dispatchEvent(new Event('change'))

    expect(emittedSeverity).toBe('HIGH')
  })
})