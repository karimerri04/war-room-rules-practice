package com.karimerri.warroom.javaincident.infrastructure.persistence;

import com.karimerri.warroom.javaincident.domain.model.Incident;
import com.karimerri.warroom.javaincident.domain.model.IncidentSeverity;
import com.karimerri.warroom.javaincident.domain.model.IncidentStatus;
import com.karimerri.warroom.javaincident.domain.value.IncidentId;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;

class InMemoryIncidentRepositoryTest {

    @Test
    void shouldReturnInitialIncidents() {
        InMemoryIncidentRepository repository = new InMemoryIncidentRepository();

        List<Incident> incidents = repository.findAll();

        assertThat(incidents).isNotEmpty();
        assertThat(incidents)
                .extracting(incident -> incident.getId().value())
                .contains("JAVA-INC-001", "JAVA-INC-002", "JAVA-INC-003");
    }

    @Test
    void shouldReturnIncidentById() {
        InMemoryIncidentRepository repository = new InMemoryIncidentRepository();

        Optional<Incident> incident = repository.findById(IncidentId.of("JAVA-INC-001"));

        assertThat(incident).isPresent();
        assertThat(incident.get().getTitle())
                .isEqualTo("NullPointerException when finding an unknown incident");
    }

    @Test
    void shouldReturnOptionalEmptyWhenIncidentDoesNotExist() {
        InMemoryIncidentRepository repository = new InMemoryIncidentRepository();

        Optional<Incident> incident = repository.findById(IncidentId.of("UNKNOWN"));

        assertThat(incident).isEmpty();
    }

    @Test
    void shouldSaveNewIncident() {
        InMemoryIncidentRepository repository = new InMemoryIncidentRepository();

        Incident incident = Incident.open(
                IncidentId.of("JAVA-INC-999"),
                "New incident",
                "New incident description",
                IncidentSeverity.CRITICAL,
                List.of("Symptom")
        );

        Incident saved = repository.save(incident);

        assertThat(saved).isEqualTo(incident);
        assertThat(repository.findById(IncidentId.of("JAVA-INC-999"))).contains(incident);
    }

    @Test
    void shouldReplaceExistingIncidentOnSave() {
        InMemoryIncidentRepository repository = new InMemoryIncidentRepository();

        Incident original = repository.findById(IncidentId.of("JAVA-INC-001")).orElseThrow();

        Incident resolved = original.resolve(
                "Missing Optional handling",
                "Use Optional.empty and translate absence to 404"
        );

        repository.save(resolved);

        Incident stored = repository.findById(IncidentId.of("JAVA-INC-001")).orElseThrow();

        assertThat(stored.getStatus()).isEqualTo(IncidentStatus.RESOLVED);
        assertThat(stored.getRootCause()).isEqualTo("Missing Optional handling");
        assertThat(stored.getResolution()).isEqualTo("Use Optional.empty and translate absence to 404");
    }

    @Test
    void shouldProtectInternalIncidentList() {
        InMemoryIncidentRepository repository = new InMemoryIncidentRepository();

        List<Incident> incidents = repository.findAll();

        assertThatThrownBy(() -> incidents.clear())
                .isInstanceOf(UnsupportedOperationException.class);

        assertThat(repository.findAll()).isNotEmpty();
    }
}