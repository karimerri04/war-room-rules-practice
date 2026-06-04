import type { IncidentSeverity } from '../../types/incidentTypes';
import './Badge.css';

type SeverityBadgeProps = {
  severity: IncidentSeverity;
};

const SEVERITY_LABELS: Record<IncidentSeverity, string> = {
  LOW: 'Low',
  MEDIUM: 'Medium',
  HIGH: 'High',
  CRITICAL: 'Critical',
};

export function SeverityBadge({ severity }: SeverityBadgeProps) {
  return (
    <span className={`badge badge--severity badge--severity-${severity.toLowerCase()}`}>
      {SEVERITY_LABELS[severity]}
    </span>
  );
}