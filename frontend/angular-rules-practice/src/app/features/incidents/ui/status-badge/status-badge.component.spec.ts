import { ComponentFixture, TestBed } from '@angular/core/testing'
import { StatusBadgeComponent } from './status-badge.component'

describe('StatusBadgeComponent', () => {
  let fixture: ComponentFixture<StatusBadgeComponent>

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [StatusBadgeComponent],
    }).compileComponents()

    fixture = TestBed.createComponent(StatusBadgeComponent)
  })

  it('should render open status label', () => {
    fixture.componentRef.setInput('status', 'OPEN')
    fixture.detectChanges()

    const element: HTMLElement = fixture.nativeElement

    expect(element.textContent).toContain('Open')
    expect(element.querySelector('.badge--status-open')).toBeTruthy()
  })

  it('should render investigating status label', () => {
    fixture.componentRef.setInput('status', 'INVESTIGATING')
    fixture.detectChanges()

    const element: HTMLElement = fixture.nativeElement

    expect(element.textContent).toContain('Investigating')
    expect(element.querySelector('.badge--status-investigating')).toBeTruthy()
  })

  it('should render resolved status label', () => {
    fixture.componentRef.setInput('status', 'RESOLVED')
    fixture.detectChanges()

    const element: HTMLElement = fixture.nativeElement

    expect(element.textContent).toContain('Resolved')
    expect(element.querySelector('.badge--status-resolved')).toBeTruthy()
  })
})