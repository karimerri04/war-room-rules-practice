import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { describe, expect, it, vi } from 'vitest'
import { IncidentStats } from './IncidentStats'
import type { IncidentStats as IncidentStatsType } from '../types/incidentTypes'

const stats: IncidentStatsType = {
  total: 8,
  open: 2,
  investigating: 1,
  resolved: 3,
  critical: 1,
  high: 2,
  medium: 3,
  low: 2,
}

describe('IncidentStats', () => {
  it('renders incident statistics', () => {
    render(<IncidentStats stats={stats} onStatClick={vi.fn()} />)

    expect(screen.getByText('Total')).toBeInTheDocument()
    expect(screen.getByText('Open')).toBeInTheDocument()
    expect(screen.getByText('Investigating')).toBeInTheDocument()
    expect(screen.getByText('Resolved')).toBeInTheDocument()
    expect(screen.getByText('Critical')).toBeInTheDocument()
  })

  it('calls onStatClick with status filter when Open is clicked', async () => {
    const user = userEvent.setup()
    const onStatClick = vi.fn()

    render(<IncidentStats stats={stats} onStatClick={onStatClick} />)

    await user.click(screen.getByRole('button', { name: /open/i }))

    expect(onStatClick).toHaveBeenCalledWith({
      type: 'STATUS',
      value: 'OPEN',
    })
  })

  it('calls onStatClick with severity filter when Critical is clicked', async () => {
    const user = userEvent.setup()
    const onStatClick = vi.fn()

    render(<IncidentStats stats={stats} onStatClick={onStatClick} />)

    await user.click(screen.getByRole('button', { name: /critical/i }))

    expect(onStatClick).toHaveBeenCalledWith({
      type: 'SEVERITY',
      value: 'CRITICAL',
    })
  })

  it('calls onStatClick with ALL filter when Total is clicked', async () => {
    const user = userEvent.setup()
    const onStatClick = vi.fn()

    render(<IncidentStats stats={stats} onStatClick={onStatClick} />)

    await user.click(screen.getByRole('button', { name: /total/i }))

    expect(onStatClick).toHaveBeenCalledWith({
      type: 'ALL',
    })
  })

  it('renders nothing when stats is null', () => {
    const { container } = render(<IncidentStats stats={null} onStatClick={vi.fn()} />)

    expect(container).toBeEmptyDOMElement()
  })
})