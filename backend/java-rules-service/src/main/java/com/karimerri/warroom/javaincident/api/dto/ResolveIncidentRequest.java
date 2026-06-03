package com.karimerri.warroom.javaincident.api.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

@Schema(description = "Request used to resolve an incident")
public record ResolveIncidentRequest(
        @Schema(
                example = "The repository did not represent absence explicitly.",
                description = "Root cause of the incident"
        )
        @NotBlank(message = "Root cause must not be blank")
        String rootCause,

        @Schema(
                example = "Use Optional in the repository contract and translate missing incidents to a 404 response.",
                description = "Resolution applied to the incident"
        )
        @NotBlank(message = "Resolution must not be blank")
        String resolution
) {
}