package com.karimerri.warroom.javarules.api.rest;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;
import java.util.Map;

@RestController
public class HealthController {

    @GetMapping("/api/java-rules/health")
    public Map<String, Object> health() {
        return Map.of(
                "status", "UP",
                "service", "java-rules-service",
                "timestamp", Instant.now().toString()
        );
    }
}