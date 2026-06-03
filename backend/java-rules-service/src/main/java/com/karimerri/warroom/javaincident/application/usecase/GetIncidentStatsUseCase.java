package com.karimerri.warroom.javaincident.application.usecase;

import com.karimerri.warroom.javaincident.application.port.IncidentRepository;
import com.karimerri.warroom.javaincident.domain.model.Incident;
import com.karimerri.warroom.javaincident.domain.model.IncidentSeverity;
import com.karimerri.warroom.javaincident.domain.model.IncidentStatus;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Cas d’usage responsable de calculer les statistiques du dashboard incident.
 */
@Service
@RequiredArgsConstructor
public class GetIncidentStatsUseCase {

    private final IncidentRepository repository;

    public IncidentStats execute() {
        List<Incident> incidents = repository.findAll();

        return new IncidentStats(
                incidents.size(),
                countByStatus(incidents, IncidentStatus.OPEN),
                countByStatus(incidents, IncidentStatus.INVESTIGATING),
                countByStatus(incidents, IncidentStatus.RESOLVED),
                countBySeverity(incidents, IncidentSeverity.CRITICAL),
                countBySeverity(incidents, IncidentSeverity.HIGH),
                countBySeverity(incidents, IncidentSeverity.MEDIUM),
                countBySeverity(incidents, IncidentSeverity.LOW)
        );
    }

    private static long countByStatus(List<Incident> incidents, IncidentStatus status) {
        return incidents.stream()
                .filter(incident -> incident.getStatus() == status)
                .count();
    }

    private static long countBySeverity(List<Incident> incidents, IncidentSeverity severity) {
        return incidents.stream()
                .filter(incident -> incident.getSeverity() == severity)
                .count();
    }
}