package com.karimerri.warroom.javaincident.domain.value;

import org.junit.jupiter.api.Test;

import com.karimerri.warroom.javaincident.domain.model.Incident;
import com.karimerri.warroom.javaincident.domain.model.IncidentSeverity;
import com.karimerri.warroom.javaincident.domain.model.IncidentStatus;

import static org.assertj.core.api.Assertions.*;

import java.util.List;

class IncidentIdTest {

	@Test
	void shouldCreateIncidentId() {
		IncidentId id = IncidentId.of("JAVA-INC-001");

		assertThat(id.value()).isEqualTo("JAVA-INC-001");
		assertThat(id.toString()).isEqualTo("JAVA-INC-001");
	}

	@Test
	void shouldRejectNullValue() {
		assertThatThrownBy(() -> IncidentId.of(null)).isInstanceOf(IllegalArgumentException.class)
				.hasMessage("Incident id must not be blank");
	}

	@Test
	void shouldRejectBlankValue() {
		assertThatThrownBy(() -> IncidentId.of(" ")).isInstanceOf(IllegalArgumentException.class)
				.hasMessage("Incident id must not be blank");
	}

	@Test
	void shouldStartInvestigationByReturningNewInstance() {
		Incident incident = Incident.open(IncidentId.of("JAVA-INC-TEST-008"), "Incident", "Description",
				IncidentSeverity.HIGH, List.of("Symptom"));

		Incident investigating = incident.startInvestigation();

		assertThat(investigating).isNotSameAs(incident);
		assertThat(investigating.getId()).isEqualTo(incident.getId());
		assertThat(investigating.getStatus()).isEqualTo(IncidentStatus.INVESTIGATING);
		assertThat(investigating.getCreatedAt()).isEqualTo(incident.getCreatedAt());
		assertThat(investigating.getResolvedAt()).isNull();

		assertThat(incident.getStatus()).isEqualTo(IncidentStatus.OPEN);
	}

	@Test
	void shouldRejectStartingInvestigationWhenIncidentIsAlreadyResolved() {
		Incident incident = Incident.open(IncidentId.of("JAVA-INC-TEST-009"), "Incident", "Description",
				IncidentSeverity.HIGH, List.of("Symptom"));

		Incident resolved = incident.resolve("Root cause", "Resolution");

		assertThatThrownBy(resolved::startInvestigation).isInstanceOf(IllegalStateException.class)
				.hasMessage("Only an open incident can move to investigation");
	}

	@Test
	void shouldRejectStartingInvestigationWhenIncidentIsAlreadyInvestigating() {
		Incident incident = Incident.open(IncidentId.of("JAVA-INC-TEST-010"), "Incident", "Description",
				IncidentSeverity.HIGH, List.of("Symptom"));

		Incident investigating = incident.startInvestigation();

		assertThatThrownBy(investigating::startInvestigation).isInstanceOf(IllegalStateException.class)
				.hasMessage("Only an open incident can move to investigation");
	}
}