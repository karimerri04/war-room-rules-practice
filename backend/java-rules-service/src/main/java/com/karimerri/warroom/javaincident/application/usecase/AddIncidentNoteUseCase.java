package com.karimerri.warroom.javaincident.application.usecase;

import com.karimerri.warroom.javaincident.application.port.IncidentRepository;
import com.karimerri.warroom.javaincident.domain.exception.IncidentNotFoundException;
import com.karimerri.warroom.javaincident.domain.model.Incident;
import com.karimerri.warroom.javaincident.domain.value.IncidentId;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

/**
 * Cas d’usage responsable d’ajouter une note d’investigation à un incident.
 */
@Service
@RequiredArgsConstructor
public class AddIncidentNoteUseCase {

    private final IncidentRepository repository;

    public Incident execute(String rawId, String author, String message) {
        IncidentId id = IncidentId.of(rawId);

        Incident incident = repository.findById(id)
                .orElseThrow(() -> new IncidentNotFoundException(id));

        Incident updatedIncident = incident.addNote(author, message);

        return repository.save(updatedIncident);
    }
}