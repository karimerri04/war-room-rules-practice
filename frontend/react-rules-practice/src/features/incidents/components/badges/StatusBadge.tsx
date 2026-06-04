import type { IncidentStatus } from '../../types/incidentTypes';
import './Badge.css';

type StatusBadgeProps = {
  status: IncidentStatus;
};

const STATUS_LABELS: Record<IncidentStatus, string> = {
  OPEN: 'Open',
  INVESTIGATING: 'Investigating',
  RESOLVED: 'Resolved',
};

export function StatusBadge({ status }: StatusBadgeProps) {
  return (
    <span className={`badge badge--status badge--status-${status.toLowerCase()}`}>
      {STATUS_LABELS[status]}
    </span>
  );
}