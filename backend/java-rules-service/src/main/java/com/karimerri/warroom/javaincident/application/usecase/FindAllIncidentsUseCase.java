package com.karimerri.warroom.javaincident.application.usecase;

import com.karimerri.warroom.javaincident.application.port.IncidentRepository;
import com.karimerri.warroom.javaincident.domain.model.Incident;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;

/**
 * Cas d’usage responsable de retourner les incidents disponibles dans la War Room.
 */
@Service
@RequiredArgsConstructor
public class FindAllIncidentsUseCase {

    private final IncidentRepository repository;

    public List<Incident> execute() {
        return repository.findAll()
                .stream()
                .sorted(Comparator.comparing(incident -> incident.getCreatedAt()))
                .toList();
    }
}