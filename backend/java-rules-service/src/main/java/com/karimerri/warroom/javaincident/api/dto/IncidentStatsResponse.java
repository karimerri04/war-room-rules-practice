package com.karimerri.warroom.javaincident.api.dto;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Dashboard statistics for Java incidents")
public record IncidentStatsResponse(
        @Schema(example = "3")
        long total,

        @Schema(example = "2")
        long open,

        @Schema(example = "0")
        long investigating,

        @Schema(example = "1")
        long resolved,

        @Schema(example = "0")
        long critical,

        @Schema(example = "1")
        long high,

        @Schema(example = "2")
        long medium,

        @Schema(example = "0")
        long low
) {
}