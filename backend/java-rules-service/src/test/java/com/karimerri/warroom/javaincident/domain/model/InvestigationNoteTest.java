package com.karimerri.warroom.javaincident.domain.model;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

class InvestigationNoteTest {

    @Test
    void shouldCreateInvestigationNote() {
        InvestigationNote note = InvestigationNote.of(
                "Karim",
                "Checked repository contract and found missing Optional handling."
        );

        assertThat(note.getAuthor()).isEqualTo("Karim");
        assertThat(note.getMessage()).isEqualTo("Checked repository contract and found missing Optional handling.");
        assertThat(note.getCreatedAt()).isNotNull();
    }

    @Test
    void shouldRejectBlankAuthor() {
        assertThatThrownBy(() -> InvestigationNote.of(" ", "Message"))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("author must not be blank");
    }

    @Test
    void shouldRejectBlankMessage() {
        assertThatThrownBy(() -> InvestigationNote.of("Karim", " "))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("message must not be blank");
    }
}