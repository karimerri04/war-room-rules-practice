package com.karimerri.warroom.javaincident.domain.value;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

class IncidentIdTest {

    @Test
    void shouldCreateIncidentId() {
        IncidentId id = IncidentId.of("JAVA-INC-001");

        assertThat(id.value()).isEqualTo("JAVA-INC-001");
        assertThat(id.toString()).isEqualTo("JAVA-INC-001");
    }

    @Test
    void shouldRejectNullValue() {
        assertThatThrownBy(() -> IncidentId.of(null))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("Incident id must not be blank");
    }

    @Test
    void shouldRejectBlankValue() {
        assertThatThrownBy(() -> IncidentId.of(" "))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("Incident id must not be blank");
    }
}