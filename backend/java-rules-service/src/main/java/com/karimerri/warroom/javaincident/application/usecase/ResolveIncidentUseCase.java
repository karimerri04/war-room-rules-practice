package com.karimerri.warroom.javaincident.application.usecase;

import com.karimerri.warroom.javaincident.application.port.IncidentRepository;
import com.karimerri.warroom.javaincident.domain.exception.IncidentNotFoundException;
import com.karimerri.warroom.javaincident.domain.model.Incident;
import com.karimerri.warroom.javaincident.domain.value.IncidentId;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

/**
 * Cas d’usage responsable de résoudre un incident.
 *
 * <p>Il orchestre la récupération, la transition métier et la sauvegarde,
 * sans connaître le détail de persistance.</p>
 */
@Service
@RequiredArgsConstructor
public class ResolveIncidentUseCase {

    private final IncidentRepository repository;

    public Incident execute(String rawId, String rootCause, String resolution) {
        IncidentId id = IncidentId.of(rawId);

        Incident incident = repository.findById(id)
                .orElseThrow(() -> new IncidentNotFoundException(id));

        Incident resolvedIncident = incident.resolve(rootCause, resolution);

        return repository.save(resolvedIncident);
    }
}