package com.karimerri.warroom.javaincident.api.rest;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Simple health endpoint for the Java incident service.
 *
 * This controller is intentionally separate from the main incident controller
 * because it represents a technical availability check, not a business use case.
 */
@RestController
public class JavaIncidentHealthController {

    @GetMapping("/api/java-incidents/health")
    public ResponseEntity<HealthResponse> health() {
        return ResponseEntity.ok(
                new HealthResponse(
                        "UP",
                        "java-incident-service"
                )
        );
    }

    public record HealthResponse(
            String status,
            String service
    ) {
    }
}