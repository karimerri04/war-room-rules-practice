package com.karimerri.warroom.javaincident.domain.model;

import com.karimerri.warroom.javaincident.domain.value.IncidentId;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.ToString;

import java.time.Instant;
import java.util.List;
import java.util.Objects;

/**
 * Représente un incident technique à diagnostiquer dans la War Room.
 *
 * <p>Cette classe est volontairement immuable : chaque transition métier retourne
 * une nouvelle instance. Cela rend le comportement plus prévisible, plus facile à tester
 * et évite les mutations cachées.</p>
 */
@Getter
@ToString
@EqualsAndHashCode(of = "id")
public final class Incident {

    private final IncidentId id;
    private final String title;
    private final String description;
    private final IncidentSeverity severity;
    private final IncidentStatus status;
    private final List<String> symptoms;
    private final String rootCause;
    private final String resolution;
    private final Instant createdAt;
    private final Instant resolvedAt;

    @Builder(access = AccessLevel.PRIVATE)
    private Incident(
            IncidentId id,
            String title,
            String description,
            IncidentSeverity severity,
            IncidentStatus status,
            List<String> symptoms,
            String rootCause,
            String resolution,
            Instant createdAt,
            Instant resolvedAt
    ) {
        this.id = Objects.requireNonNull(id, "id must not be null");
        this.title = requireText(title, "title");
        this.description = requireText(description, "description");
        this.severity = Objects.requireNonNull(severity, "severity must not be null");
        this.status = Objects.requireNonNull(status, "status must not be null");
        this.symptoms = List.copyOf(Objects.requireNonNull(symptoms, "symptoms must not be null"));
        this.rootCause = rootCause == null ? "" : rootCause.trim();
        this.resolution = resolution == null ? "" : resolution.trim();
        this.createdAt = Objects.requireNonNull(createdAt, "createdAt must not be null");
        this.resolvedAt = resolvedAt;
    }

    /**
     * Crée un nouvel incident ouvert.
     *
     * @param id identifiant métier de l’incident
     * @param title titre court de l’incident
     * @param description description fonctionnelle ou technique du problème
     * @param severity niveau de sévérité de l’incident
     * @param symptoms symptômes observés
     * @return un incident ouvert prêt à être investigué
     */
    public static Incident open(
            IncidentId id,
            String title,
            String description,
            IncidentSeverity severity,
            List<String> symptoms
    ) {
        return Incident.builder()
                .id(id)
                .title(title)
                .description(description)
                .severity(severity)
                .status(IncidentStatus.OPEN)
                .symptoms(symptoms)
                .rootCause("")
                .resolution("")
                .createdAt(Instant.now())
                .resolvedAt(null)
                .build();
    }

    /**
     * Résout l’incident avec une cause racine et une description de résolution.
     *
     * @param rootCause cause réelle ou probable de l’incident
     * @param resolution action appliquée pour résoudre l’incident
     * @return une nouvelle instance résolue de l’incident
     * @throws IllegalStateException si l’incident est déjà résolu
     */
    public Incident resolve(String rootCause, String resolution) {
        if (status == IncidentStatus.RESOLVED) {
            throw new IllegalStateException("Incident is already resolved");
        }

        return Incident.builder()
                .id(id)
                .title(title)
                .description(description)
                .severity(severity)
                .status(IncidentStatus.RESOLVED)
                .symptoms(symptoms)
                .rootCause(requireText(rootCause, "rootCause"))
                .resolution(requireText(resolution, "resolution"))
                .createdAt(createdAt)
                .resolvedAt(Instant.now())
                .build();
    }

    private static String requireText(String value, String fieldName) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(fieldName + " must not be blank");
        }

        return value.trim();
    }
}