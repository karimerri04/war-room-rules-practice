package com.karimerri.warroom.javaincident.api.dto;

import jakarta.validation.constraints.NotBlank;

public record ResolveIncidentRequest(
        @NotBlank(message = "Root cause must not be blank")
        String rootCause,

        @NotBlank(message = "Resolution must not be blank")
        String resolution
) {
}