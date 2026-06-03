package com.karimerri.warroom.javaincident.infrastructure.persistence;

import com.karimerri.warroom.javaincident.application.port.IncidentRepository;
import com.karimerri.warroom.javaincident.domain.model.Incident;
import com.karimerri.warroom.javaincident.domain.model.IncidentSeverity;
import com.karimerri.warroom.javaincident.domain.value.IncidentId;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Implémentation en mémoire du repository d’incidents.
 *
 * <p>Elle permet de lancer l’application sans base de données, ce qui facilite
 * la démonstration, les tests locaux et l’évaluation technique.</p>
 */
@Repository
public class InMemoryIncidentRepository implements IncidentRepository {

    private final List<Incident> incidents = new ArrayList<>();

    public InMemoryIncidentRepository() {
        incidents.addAll(List.of(
                Incident.open(
                        IncidentId.of("JAVA-INC-001"),
                        "NullPointerException when finding an unknown incident",
                        "The API fails with a NullPointerException when an unknown incident id is requested.",
                        IncidentSeverity.HIGH,
                        List.of(
                                "HTTP 500 returned instead of 404",
                                "Stack trace shows null access",
                                "Repository did not represent absence explicitly"
                        )
                ),
                Incident.open(
                        IncidentId.of("JAVA-INC-002"),
                        "Mutable incident state causes inconsistent resolution",
                        "An incident is modified directly by several layers, making its lifecycle difficult to reason about.",
                        IncidentSeverity.MEDIUM,
                        List.of(
                                "Status changes without use case orchestration",
                                "Resolution date sometimes missing",
                                "Tests depend on execution order"
                        )
                ),
                Incident.open(
                        IncidentId.of("JAVA-INC-003"),
                        "Controller contains business logic",
                        "The REST controller validates and resolves incidents directly instead of delegating to use cases.",
                        IncidentSeverity.MEDIUM,
                        List.of(
                                "Controller methods are too long",
                                "Business rules are hard to unit test",
                                "HTTP layer knows too much about the domain"
                        )
                )
        ));
    }

    @Override
    public List<Incident> findAll() {
        return List.copyOf(incidents);
    }

    @Override
    public Optional<Incident> findById(IncidentId id) {
        return incidents.stream()
                .filter(incident -> incident.getId().equals(id))
                .findFirst();
    }

    @Override
    public Incident save(Incident incident) {
        incidents.removeIf(existing -> existing.getId().equals(incident.getId()));
        incidents.add(incident);
        return incident;
    }
}