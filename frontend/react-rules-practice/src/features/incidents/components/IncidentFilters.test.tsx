import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { describe, expect, it, vi } from 'vitest'
import { IncidentFilters } from './IncidentFilters'
import type { SeverityFilter, StatusFilter } from './IncidentFilters'

describe('IncidentFilters', () => {
  it('renders status and severity filters with selected values', () => {
    render(
      <IncidentFilters
        selectedStatus="OPEN"
        selectedSeverity="CRITICAL"
        onStatusChange={vi.fn()}
        onSeverityChange={vi.fn()}
      />,
    )

    expect(screen.getByLabelText(/status/i)).toHaveValue('OPEN')
    expect(screen.getByLabelText(/severity/i)).toHaveValue('CRITICAL')
  })

  it('calls onStatusChange when status filter changes', async () => {
    const user = userEvent.setup()
    const onStatusChange = vi.fn()
    const onSeverityChange = vi.fn()

    render(
      <IncidentFilters
        selectedStatus="ALL"
        selectedSeverity="ALL"
        onStatusChange={onStatusChange}
        onSeverityChange={onSeverityChange}
      />,
    )

    await user.selectOptions(screen.getByLabelText(/status/i), 'INVESTIGATING')

    expect(onStatusChange).toHaveBeenCalledWith('INVESTIGATING' satisfies StatusFilter)
    expect(onSeverityChange).not.toHaveBeenCalled()
  })

  it('calls onSeverityChange when severity filter changes', async () => {
    const user = userEvent.setup()
    const onStatusChange = vi.fn()
    const onSeverityChange = vi.fn()

    render(
      <IncidentFilters
        selectedStatus="ALL"
        selectedSeverity="ALL"
        onStatusChange={onStatusChange}
        onSeverityChange={onSeverityChange}
      />,
    )

    await user.selectOptions(screen.getByLabelText(/severity/i), 'HIGH')

    expect(onSeverityChange).toHaveBeenCalledWith('HIGH' satisfies SeverityFilter)
    expect(onStatusChange).not.toHaveBeenCalled()
  })

  it('allows resetting status and severity to ALL', async () => {
    const user = userEvent.setup()
    const onStatusChange = vi.fn()
    const onSeverityChange = vi.fn()

    render(
      <IncidentFilters
        selectedStatus="OPEN"
        selectedSeverity="HIGH"
        onStatusChange={onStatusChange}
        onSeverityChange={onSeverityChange}
      />,
    )

    await user.selectOptions(screen.getByLabelText(/status/i), 'ALL')
    await user.selectOptions(screen.getByLabelText(/severity/i), 'ALL')

    expect(onStatusChange).toHaveBeenCalledWith('ALL' satisfies StatusFilter)
    expect(onSeverityChange).toHaveBeenCalledWith('ALL' satisfies SeverityFilter)
  })
})