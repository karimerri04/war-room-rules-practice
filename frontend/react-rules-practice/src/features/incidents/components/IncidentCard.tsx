import { memo } from 'react';
import { Link } from 'react-router-dom';
import type { Incident  } from '../types/incidentTypes';
import { SeverityBadge } from './badges/SeverityBadge';
import { StatusBadge } from './badges/StatusBadge';
import './IncidentCard.css';

type IncidentCardProps = {
  incident: Incident ;
};

export const IncidentCard = memo(function IncidentCard({ incident }: IncidentCardProps) {
  return (
    <article className="incident-card">
      <div className="incident-card__header">
        <div>
          <h3>{incident.title}</h3>
          <p className="incident-card__id">{incident.id}</p>
        </div>

        <div className="incident-card__badges">
          <SeverityBadge severity={incident.severity} />
          <StatusBadge status={incident.status} />
        </div>
      </div>

      <p className="incident-card__description">{incident.description}</p>

      <div className="incident-card__footer">
        <span>Notes: {incident.notes.length}</span>

        <Link to={`/incidents/${incident.id}`} className="incident-card__link">
          Open incident
        </Link>
      </div>
    </article>
  );
});