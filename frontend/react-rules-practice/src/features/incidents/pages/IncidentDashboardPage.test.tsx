import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { MemoryRouter } from 'react-router-dom'
import { describe, expect, it, vi } from 'vitest'
import { IncidentDashboardPage } from './IncidentDashboardPage'
import type { Incident, IncidentStats } from '../types/incidentTypes'

const incidents: Incident[] = [
  {
    id: 'INC-001',
    title: 'Kafka consumer lag is increasing',
    description: 'The payment consumer group is not processing messages fast enough.',
    severity: 'HIGH',
    status: 'OPEN',
    symptoms: ['Consumer lag above threshold'],
    rootCause: '',
    resolution: '',
    createdAt: '2026-06-04T10:00:00Z',
    resolvedAt: null,
    notes: [],
  },
  {
    id: 'INC-002',
    title: 'S3 upload failure',
    description: 'Formatted weather files are not uploaded to S3.',
    severity: 'CRITICAL',
    status: 'INVESTIGATING',
    symptoms: ['S3 PutObject errors'],
    rootCause: '',
    resolution: '',
    createdAt: '2026-06-04T11:00:00Z',
    resolvedAt: null,
    notes: [],
  },
  {
    id: 'INC-003',
    title: 'Frontend route error',
    description: 'React details page fails when incident id is missing.',
    severity: 'MEDIUM',
    status: 'RESOLVED',
    symptoms: ['Route parameter missing'],
    rootCause: 'Missing route guard',
    resolution: 'Added validation before API call',
    createdAt: '2026-06-04T12:00:00Z',
    resolvedAt: '2026-06-04T13:00:00Z',
    notes: [],
  },
]

const stats: IncidentStats = {
  total: 3,
  open: 1,
  investigating: 1,
  resolved: 1,
  critical: 1,
  high: 1,
  medium: 1,
  low: 0,
}

vi.mock('../hooks/useIncidents', () => ({
  useIncidents: () => ({
    incidents,
    stats,
    loading: false,
    error: null,
    reload: vi.fn(),
  }),
}))

describe('IncidentDashboardPage', () => {
  it('renders all incidents by default', () => {
    render(
      <MemoryRouter>
        <IncidentDashboardPage />
      </MemoryRouter>,
    )

    expect(screen.getByText('Kafka consumer lag is increasing')).toBeInTheDocument()
    expect(screen.getByText('S3 upload failure')).toBeInTheDocument()
    expect(screen.getByText('Frontend route error')).toBeInTheDocument()
    expect(screen.getByText('Showing 3 of 3 incidents.')).toBeInTheDocument()
  })

  it('filters incidents when Open statistic is clicked', async () => {
    const user = userEvent.setup()

    render(
      <MemoryRouter>
        <IncidentDashboardPage />
      </MemoryRouter>,
    )

    await user.click(screen.getByRole('button', { name: /open/i }))

    expect(screen.getByText('Kafka consumer lag is increasing')).toBeInTheDocument()
    expect(screen.queryByText('S3 upload failure')).not.toBeInTheDocument()
    expect(screen.queryByText('Frontend route error')).not.toBeInTheDocument()
    expect(screen.getByText('Showing 1 of 3 incidents.')).toBeInTheDocument()

    expect(screen.getByLabelText(/status/i)).toHaveValue('OPEN')
    expect(screen.getByLabelText(/severity/i)).toHaveValue('ALL')
  })

  it('filters incidents when Critical statistic is clicked', async () => {
    const user = userEvent.setup()

    render(
      <MemoryRouter>
        <IncidentDashboardPage />
      </MemoryRouter>,
    )

    await user.click(screen.getByRole('button', { name: /critical/i }))

    expect(screen.queryByText('Kafka consumer lag is increasing')).not.toBeInTheDocument()
    expect(screen.getByText('S3 upload failure')).toBeInTheDocument()
    expect(screen.queryByText('Frontend route error')).not.toBeInTheDocument()
    expect(screen.getByText('Showing 1 of 3 incidents.')).toBeInTheDocument()

    expect(screen.getByLabelText(/status/i)).toHaveValue('ALL')
    expect(screen.getByLabelText(/severity/i)).toHaveValue('CRITICAL')
  })

  it('resets filters when Total statistic is clicked', async () => {
    const user = userEvent.setup()

    render(
      <MemoryRouter>
        <IncidentDashboardPage />
      </MemoryRouter>,
    )

    await user.click(screen.getByRole('button', { name: /critical/i }))
    await user.click(screen.getByRole('button', { name: /total/i }))

    expect(screen.getByText('Kafka consumer lag is increasing')).toBeInTheDocument()
    expect(screen.getByText('S3 upload failure')).toBeInTheDocument()
    expect(screen.getByText('Frontend route error')).toBeInTheDocument()
    expect(screen.getByText('Showing 3 of 3 incidents.')).toBeInTheDocument()

    expect(screen.getByLabelText(/status/i)).toHaveValue('ALL')
    expect(screen.getByLabelText(/severity/i)).toHaveValue('ALL')
  })
})