package com.karimerri.warroom.javaincident.api.dto;

import io.swagger.v3.oas.annotations.media.Schema;

import java.time.Instant;
import java.util.List;

@Schema(description = "Incident returned by the Java Incident Service")
public record IncidentResponse(
        @Schema(example = "JAVA-INC-001")
        String id,

        @Schema(example = "NullPointerException when finding an unknown incident")
        String title,

        @Schema(example = "The API fails with a NullPointerException when an unknown incident id is requested.")
        String description,

        @Schema(example = "HIGH")
        String severity,

        @Schema(example = "OPEN")
        String status,

        @Schema(example = "[\"HTTP 500 returned instead of 404\"]")
        List<String> symptoms,

        @Schema(example = "The repository returned null instead of Optional.empty().")
        String rootCause,

        @Schema(example = "Use Optional and translate absence to a 404 response.")
        String resolution,

        Instant createdAt,

        Instant resolvedAt
) {
}