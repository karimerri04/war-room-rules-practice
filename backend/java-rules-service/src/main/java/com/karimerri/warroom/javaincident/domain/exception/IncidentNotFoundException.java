package com.karimerri.warroom.javaincident.domain.exception;

import com.karimerri.warroom.javaincident.domain.value.IncidentId;

public class IncidentNotFoundException extends RuntimeException {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public IncidentNotFoundException(IncidentId id) {
        super("Incident not found: " + id.value());
    }
}