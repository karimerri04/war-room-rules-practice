package com.karimerri.warroom.javaincident.application.port;

import com.karimerri.warroom.javaincident.domain.model.Incident;
import com.karimerri.warroom.javaincident.domain.value.IncidentId;

import java.util.List;
import java.util.Optional;

/**
 * Port de persistance des incidents.
 *
 * <p>Le domaine applicatif dépend de cette abstraction, et non d’un mécanisme concret
 * comme une base de données, un fichier ou une collection en mémoire.</p>
 */
public interface IncidentRepository {

    /**
     * Retourne tous les incidents connus.
     *
     * @return une liste éventuellement vide, jamais {@code null}
     */
    List<Incident> findAll();

    /**
     * Recherche un incident par son identifiant métier.
     *
     * @param id identifiant de l’incident
     * @return l’incident s’il existe
     */
    Optional<Incident> findById(IncidentId id);

    /**
     * Sauvegarde l’état courant d’un incident.
     *
     * @param incident incident à sauvegarder
     * @return incident sauvegardé
     */
    Incident save(Incident incident);
}