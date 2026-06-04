import { ComponentFixture, TestBed } from '@angular/core/testing'
import { provideRouter } from '@angular/router'
import { IncidentCardComponent } from './incident-card.component'
import type { Incident } from '../../models/incident.model'

const incident: Incident = {
  id: 'INC-001',
  title: 'Kafka consumer lag is increasing',
  description: 'The payment consumer group is not processing messages fast enough.',
  severity: 'HIGH',
  status: 'OPEN',
  symptoms: ['Consumer lag above threshold', 'Delayed payment confirmation'],
  rootCause: '',
  resolution: '',
  createdAt: '2026-06-04T10:00:00Z',
  resolvedAt: null,
  notes: [
    {
      author: 'Karim',
      message: 'Initial investigation started.',
      createdAt: '2026-06-04T10:15:00Z',
    },
  ],
}

describe('IncidentCardComponent', () => {
  let fixture: ComponentFixture<IncidentCardComponent>

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [IncidentCardComponent],
      providers: [provideRouter([])],
    }).compileComponents()

    fixture = TestBed.createComponent(IncidentCardComponent)
    fixture.componentRef.setInput('incident', incident)
    fixture.detectChanges()
  })

  it('should render incident summary', () => {
    const element: HTMLElement = fixture.nativeElement

    expect(element.textContent).toContain('Kafka consumer lag is increasing')
    expect(element.textContent).toContain(
      'The payment consumer group is not processing messages fast enough.',
    )
    expect(element.textContent).toContain('INC-001')
    expect(element.textContent).toContain('Notes: 1')
  })

  it('should render status and severity labels', () => {
    const element: HTMLElement = fixture.nativeElement

    expect(element.textContent).toContain('Open')
    expect(element.textContent).toContain('High')
  })

  it('should render a link to incident details', () => {
    const link = fixture.nativeElement.querySelector('a') as HTMLAnchorElement

    expect(link.getAttribute('href')).toBe('/incidents/INC-001')
  })
})