package com.karimerri.warroom.javaincident.application.usecase;

/**
 * Résumé statistique des incidents.
 *
 * <p>Ce modèle appartient à la couche application, car il représente une vue calculée
 * utile au dashboard, sans être une entité métier centrale.</p>
 */
public record IncidentStats(
        long total,
        long open,
        long investigating,
        long resolved,
        long critical,
        long high,
        long medium,
        long low
) {
}