package com.karimerri.warroom.javaincident.api.dto;

import java.time.Instant;
import java.util.List;

public record IncidentResponse(
        String id,
        String title,
        String description,
        String severity,
        String status,
        List<String> symptoms,
        String rootCause,
        String resolution,
        Instant createdAt,
        Instant resolvedAt
) {
}