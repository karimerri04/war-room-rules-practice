package com.karimerri.warroom.javaincident.api.mapper;

import com.karimerri.warroom.javaincident.api.dto.IncidentResponse;
import com.karimerri.warroom.javaincident.api.dto.IncidentStatsResponse;
import com.karimerri.warroom.javaincident.api.dto.InvestigationNoteResponse;
import com.karimerri.warroom.javaincident.application.usecase.IncidentStats;
import com.karimerri.warroom.javaincident.domain.model.Incident;
import com.karimerri.warroom.javaincident.domain.model.InvestigationNote;

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
                incident.getResolvedAt(),
                incident.getNotes()
                .stream()
                .map(this::toNoteResponse)
                .toList()
        );
    }
    
    public IncidentStatsResponse toStatsResponse(IncidentStats stats) {
        return new IncidentStatsResponse(
                stats.total(),
                stats.open(),
                stats.investigating(),
                stats.resolved(),
                stats.critical(),
                stats.high(),
                stats.medium(),
                stats.low()
        );
    }
    
    private InvestigationNoteResponse toNoteResponse(InvestigationNote note) {
        return new InvestigationNoteResponse(
                note.getAuthor(),
                note.getMessage(),
                note.getCreatedAt()
        );
    }
}