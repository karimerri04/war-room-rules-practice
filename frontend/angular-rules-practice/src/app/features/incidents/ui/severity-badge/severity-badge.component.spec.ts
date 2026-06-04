import { ComponentFixture, TestBed } from '@angular/core/testing'
import { SeverityBadgeComponent } from './severity-badge.component'

describe('SeverityBadgeComponent', () => {
  let fixture: ComponentFixture<SeverityBadgeComponent>

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [SeverityBadgeComponent],
    }).compileComponents()

    fixture = TestBed.createComponent(SeverityBadgeComponent)
  })

  it('should render low severity label', () => {
    fixture.componentRef.setInput('severity', 'LOW')
    fixture.detectChanges()

    const element: HTMLElement = fixture.nativeElement

    expect(element.textContent).toContain('Low')
    expect(element.querySelector('.badge--severity-low')).toBeTruthy()
  })

  it('should render medium severity label', () => {
    fixture.componentRef.setInput('severity', 'MEDIUM')
    fixture.detectChanges()

    const element: HTMLElement = fixture.nativeElement

    expect(element.textContent).toContain('Medium')
    expect(element.querySelector('.badge--severity-medium')).toBeTruthy()
  })

  it('should render high severity label', () => {
    fixture.componentRef.setInput('severity', 'HIGH')
    fixture.detectChanges()

    const element: HTMLElement = fixture.nativeElement

    expect(element.textContent).toContain('High')
    expect(element.querySelector('.badge--severity-high')).toBeTruthy()
  })

  it('should render critical severity label', () => {
    fixture.componentRef.setInput('severity', 'CRITICAL')
    fixture.detectChanges()

    const element: HTMLElement = fixture.nativeElement

    expect(element.textContent).toContain('Critical')
    expect(element.querySelector('.badge--severity-critical')).toBeTruthy()
  })
})