package com.karimerri.warroom.javaincident.api.dto;

import io.swagger.v3.oas.annotations.media.Schema;

import java.time.Instant;

@Schema(description = "Investigation note attached to an incident")
public record InvestigationNoteResponse(
        @Schema(example = "Karim")
        String author,

        @Schema(example = "Checked repository contract and found missing Optional handling.")
        String message,

        Instant createdAt
) {
}