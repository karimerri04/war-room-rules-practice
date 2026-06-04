import { render, screen } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { describe, expect, it } from 'vitest'
import { IncidentCard } from './IncidentCard'
import type { Incident } from '../types/incidentTypes'

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

describe('IncidentCard', () => {
  it('renders incident summary', () => {
    render(
      <MemoryRouter>
        <IncidentCard incident={incident} />
      </MemoryRouter>,
    )

    expect(screen.getByText('Kafka consumer lag is increasing')).toBeInTheDocument()
    expect(
      screen.getByText('The payment consumer group is not processing messages fast enough.'),
    ).toBeInTheDocument()
    expect(screen.getByText('INC-001')).toBeInTheDocument()
    expect(screen.getByText('Notes: 1')).toBeInTheDocument()
  })

  it('renders status and severity badges', () => {
    render(
      <MemoryRouter>
        <IncidentCard incident={incident} />
      </MemoryRouter>,
    )

    expect(screen.getByText('Open')).toBeInTheDocument()
    expect(screen.getByText('High')).toBeInTheDocument()
  })

  it('renders a link to the incident details page', () => {
    render(
      <MemoryRouter>
        <IncidentCard incident={incident} />
      </MemoryRouter>,
    )

    const link = screen.getByRole('link', { name: /open incident/i })

    expect(link).toHaveAttribute('href', '/incidents/INC-001')
  })
})