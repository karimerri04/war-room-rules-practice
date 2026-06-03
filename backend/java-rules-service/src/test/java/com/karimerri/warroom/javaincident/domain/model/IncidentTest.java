package com.karimerri.warroom.javaincident.domain.model;

import com.karimerri.warroom.javaincident.domain.value.IncidentId;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.assertj.core.api.Assertions.*;

class IncidentTest {

    @Test
    void shouldCreateOpenIncident() {
        Incident incident = Incident.open(
                IncidentId.of("JAVA-INC-TEST-001"),
                "Test incident",
                "A test incident description",
                IncidentSeverity.HIGH,
                List.of("Symptom 1", "Symptom 2")
        );

        assertThat(incident.getId()).isEqualTo(IncidentId.of("JAVA-INC-TEST-001"));
        assertThat(incident.getTitle()).isEqualTo("Test incident");
        assertThat(incident.getDescription()).isEqualTo("A test incident description");
        assertThat(incident.getSeverity()).isEqualTo(IncidentSeverity.HIGH);
        assertThat(incident.getStatus()).isEqualTo(IncidentStatus.OPEN);
        assertThat(incident.getSymptoms()).containsExactly("Symptom 1", "Symptom 2");
        assertThat(incident.getRootCause()).isEmpty();
        assertThat(incident.getResolution()).isEmpty();
        assertThat(incident.getCreatedAt()).isNotNull();
        assertThat(incident.getResolvedAt()).isNull();
    }

    @Test
    void shouldResolveIncidentByReturningNewResolvedInstance() {
        Incident incident = Incident.open(
                IncidentId.of("JAVA-INC-TEST-002"),
                "Incident to resolve",
                "The incident must be resolved",
                IncidentSeverity.MEDIUM,
                List.of("Unexpected status")
        );

        Incident resolved = incident.resolve(
                "Missing Optional handling",
                "Return Optional.empty and translate absence to 404"
        );

        assertThat(resolved).isNotSameAs(incident);
        assertThat(resolved.getId()).isEqualTo(incident.getId());
        assertThat(resolved.getStatus()).isEqualTo(IncidentStatus.RESOLVED);
        assertThat(resolved.getRootCause()).isEqualTo("Missing Optional handling");
        assertThat(resolved.getResolution()).isEqualTo("Return Optional.empty and translate absence to 404");
        assertThat(resolved.getCreatedAt()).isEqualTo(incident.getCreatedAt());
        assertThat(resolved.getResolvedAt()).isNotNull();

        assertThat(incident.getStatus()).isEqualTo(IncidentStatus.OPEN);
        assertThat(incident.getResolvedAt()).isNull();
    }

    @Test
    void shouldRejectBlankTitle() {
        assertThatThrownBy(() -> Incident.open(
                IncidentId.of("JAVA-INC-TEST-003"),
                " ",
                "Description",
                IncidentSeverity.LOW,
                List.of("Symptom")
        ))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("title must not be blank");
    }

    @Test
    void shouldRejectBlankResolutionWhenResolving() {
        Incident incident = Incident.open(
                IncidentId.of("JAVA-INC-TEST-004"),
                "Incident",
                "Description",
                IncidentSeverity.LOW,
                List.of("Symptom")
        );

        assertThatThrownBy(() -> incident.resolve("Root cause", " "))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("resolution must not be blank");
    }

    @Test
    void shouldRejectResolvingAlreadyResolvedIncident() {
        Incident incident = Incident.open(
                IncidentId.of("JAVA-INC-TEST-005"),
                "Incident",
                "Description",
                IncidentSeverity.LOW,
                List.of("Symptom")
        );

        Incident resolved = incident.resolve("Root cause", "Resolution");

        assertThatThrownBy(() -> resolved.resolve("Another root cause", "Another resolution"))
                .isInstanceOf(IllegalStateException.class)
                .hasMessage("Incident is already resolved");
    }

    @Test
    void shouldProtectSymptomsFromExternalMutation() {
        List<String> symptoms = new java.util.ArrayList<>();
        symptoms.add("Initial symptom");

        Incident incident = Incident.open(
                IncidentId.of("JAVA-INC-TEST-006"),
                "Incident",
                "Description",
                IncidentSeverity.LOW,
                symptoms
        );

        symptoms.add("External mutation");

        assertThat(incident.getSymptoms()).containsExactly("Initial symptom");
    }

    @Test
    void shouldExposeUnmodifiableSymptomsList() {
        Incident incident = Incident.open(
                IncidentId.of("JAVA-INC-TEST-007"),
                "Incident",
                "Description",
                IncidentSeverity.LOW,
                List.of("Symptom")
        );

        assertThatThrownBy(() -> incident.getSymptoms().add("Mutation attempt"))
                .isInstanceOf(UnsupportedOperationException.class);
    }
}