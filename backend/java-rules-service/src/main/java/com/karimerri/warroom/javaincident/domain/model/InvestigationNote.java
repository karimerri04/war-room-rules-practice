package com.karimerri.warroom.javaincident.domain.model;

import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.ToString;

import java.time.Instant;

/**
 * Note ajoutée pendant l’investigation d’un incident.
 *
 * <p>Elle permet de conserver les observations, hypothèses et actions réalisées
 * avant la résolution finale.</p>
 */
@Getter
@Builder
@EqualsAndHashCode
@ToString
public final class InvestigationNote {

    private final String author;
    private final String message;
    private final Instant createdAt;

    private InvestigationNote(String author, String message, Instant createdAt) {
        this.author = requireText(author, "author");
        this.message = requireText(message, "message");
        this.createdAt = createdAt == null ? Instant.now() : createdAt;
    }

    public static InvestigationNote of(String author, String message) {
        return InvestigationNote.builder()
                .author(author)
                .message(message)
                .createdAt(Instant.now())
                .build();
    }

    private static String requireText(String value, String fieldName) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(fieldName + " must not be blank");
        }

        return value.trim();
    }
}