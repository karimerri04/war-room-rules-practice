package com.karimerri.warroom.javaincident.domain.value;

/**
 * Identifiant métier d’un incident.
 *
 * <p>Ce value object évite de manipuler un simple {@link String} dans le domaine.
 * Il centralise aussi la validation minimale de l’identifiant.</p>
 */
public record IncidentId(String value) {

    public IncidentId {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("Incident id must not be blank");
        }
    }

    public static IncidentId of(String value) {
        return new IncidentId(value);
    }

    @Override
    public String toString() {
        return value;
    }
}