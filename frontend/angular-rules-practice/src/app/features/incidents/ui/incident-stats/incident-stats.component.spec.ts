import { ComponentFixture, TestBed } from '@angular/core/testing'
import { IncidentStatsComponent } from './incident-stats.component'
import type { IncidentStats } from '../../models/incident.model'
import type { StatFilter } from '../../models/incident-filter.model'

const stats: IncidentStats = {
  total: 8,
  open: 2,
  investigating: 1,
  resolved: 3,
  critical: 1,
  high: 2,
  medium: 3,
  low: 2,
}

describe('IncidentStatsComponent', () => {
  let fixture: ComponentFixture<IncidentStatsComponent>
  let component: IncidentStatsComponent

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [IncidentStatsComponent],
    }).compileComponents()

    fixture = TestBed.createComponent(IncidentStatsComponent)
    component = fixture.componentInstance
    fixture.componentRef.setInput('stats', stats)
    fixture.detectChanges()
  })

  it('should render incident statistics', () => {
    const element: HTMLElement = fixture.nativeElement

    expect(element.textContent).toContain('Total')
    expect(element.textContent).toContain('Open')
    expect(element.textContent).toContain('Investigating')
    expect(element.textContent).toContain('Resolved')
    expect(element.textContent).toContain('Critical')
  })

  it('should emit status filter when Open is clicked', () => {
    let emittedFilter: StatFilter | null = null
    component.statClick.subscribe((filter) => {
      emittedFilter = filter
    })

    const button = findButtonByText('Open')
    button.click()

    expect(emittedFilter).toEqual({
      type: 'STATUS',
      value: 'OPEN',
    })
  })

  it('should emit severity filter when Critical is clicked', () => {
    let emittedFilter: StatFilter | null = null
    component.statClick.subscribe((filter) => {
      emittedFilter = filter
    })

    const button = findButtonByText('Critical')
    button.click()

    expect(emittedFilter).toEqual({
      type: 'SEVERITY',
      value: 'CRITICAL',
    })
  })

  it('should emit all filter when Total is clicked', () => {
    let emittedFilter: StatFilter | null = null
    component.statClick.subscribe((filter) => {
      emittedFilter = filter
    })

    const button = findButtonByText('Total')
    button.click()

    expect(emittedFilter).toEqual({
      type: 'ALL',
    })
  })

  function findButtonByText(text: string): HTMLButtonElement {
    const buttons = Array.from(
      fixture.nativeElement.querySelectorAll('button'),
    ) as HTMLButtonElement[]

    const button = buttons.find((candidate) => candidate.textContent?.includes(text))

    if (!button) {
      throw new Error(`Button with text "${text}" not found`)
    }

    return button
  }
})