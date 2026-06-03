package com.karimerri.warroom.javaincident.application.usecase;

import com.karimerri.warroom.javaincident.application.port.IncidentRepository;
import com.karimerri.warroom.javaincident.domain.exception.IncidentNotFoundException;
import com.karimerri.warroom.javaincident.domain.model.Incident;
import com.karimerri.warroom.javaincident.domain.value.IncidentId;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

/**
 * Cas d’usage responsable de démarrer l’investigation d’un incident.
 *
 * <p>Il orchestre la recherche de l’incident, applique la transition métier,
 * puis sauvegarde le nouvel état sans connaître le détail de persistance.</p>
 */
@Service
@RequiredArgsConstructor
public class StartIncidentInvestigationUseCase {

    private final IncidentRepository repository;

    public Incident execute(String rawId) {
        IncidentId id = IncidentId.of(rawId);

        Incident incident = repository.findById(id)
                .orElseThrow(() -> new IncidentNotFoundException(id));

        Incident investigatingIncident = incident.startInvestigation();

        return repository.save(investigatingIncident);
    }
}