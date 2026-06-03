package com.karimerri.warroom.javaincident.api.mapper;

import com.karimerri.warroom.javaincident.api.dto.IncidentResponse;
import com.karimerri.warroom.javaincident.domain.model.Incident;
import org.springframework.stereotype.Component;

@Component
public class IncidentMapper {

    public IncidentResponse toResponse(Incident incident) {
        return new IncidentResponse(
                incident.getId().value(),
                incident.getTitle(),
                incident.getDescription(),
                incident.getSeverity().name(),
                incident.getStatus().name(),
                incident.getSymptoms(),
                incident.getRootCause(),
                incident.getResolution(),
                incident.getCreatedAt(),
                incident.getResolvedAt()
        );
    }
}