package com.karimerri.warroom.javaincident.api.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

@Schema(description = "Request used to add an investigation note")
public record AddIncidentNoteRequest(
        @Schema(example = "Karim")
        @NotBlank(message = "Author must not be blank")
        String author,

        @Schema(example = "Checked repository contract and found missing Optional handling.")
        @NotBlank(message = "Message must not be blank")
        String message
) {
}