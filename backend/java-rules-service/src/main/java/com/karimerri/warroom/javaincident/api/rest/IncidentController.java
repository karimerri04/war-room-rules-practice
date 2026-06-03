package com.karimerri.warroom.javaincident.api.rest;

import com.karimerri.warroom.javaincident.api.dto.IncidentResponse;
import com.karimerri.warroom.javaincident.api.dto.IncidentStatsResponse;
import com.karimerri.warroom.javaincident.api.dto.ResolveIncidentRequest;
import com.karimerri.warroom.javaincident.api.mapper.IncidentMapper;
import com.karimerri.warroom.javaincident.application.usecase.FindAllIncidentsUseCase;
import com.karimerri.warroom.javaincident.application.usecase.FindIncidentByIdUseCase;
import com.karimerri.warroom.javaincident.application.usecase.GetIncidentStatsUseCase;
import com.karimerri.warroom.javaincident.application.usecase.ResolveIncidentUseCase;
import com.karimerri.warroom.javaincident.application.usecase.StartIncidentInvestigationUseCase;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/java-incidents")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
@Tag(name = "Java Incidents", description = "Operations for diagnosing and resolving Java backend incidents")
public class IncidentController {

	private final FindAllIncidentsUseCase findAllIncidentsUseCase;
	private final FindIncidentByIdUseCase findIncidentByIdUseCase;
	private final ResolveIncidentUseCase resolveIncidentUseCase;
	private final GetIncidentStatsUseCase getIncidentStatsUseCase;
	private final StartIncidentInvestigationUseCase startIncidentInvestigationUseCase;
	private final IncidentMapper mapper;

	@GetMapping
	@Operation(summary = "Find all Java incidents")
	public List<IncidentResponse> findAll() {
		return findAllIncidentsUseCase.execute().stream().map(mapper::toResponse).toList();
	}

	@GetMapping("/stats")
	@Operation(summary = "Get Java incidents dashboard statistics")
	public IncidentStatsResponse getStats() {
		return mapper.toStatsResponse(getIncidentStatsUseCase.execute());
	}

	@GetMapping("/{id}")
	@Operation(summary = "Find a Java incident by id")
	public IncidentResponse findById(@PathVariable String id) {
		return mapper.toResponse(findIncidentByIdUseCase.execute(id));
	}
	
	@PatchMapping("/{id}/start-investigation")
	@Operation(summary = "Start investigation for a Java incident")
	public IncidentResponse startInvestigation(@PathVariable String id) {
	    return mapper.toResponse(startIncidentInvestigationUseCase.execute(id));
	}

	@PatchMapping("/{id}/resolve")
	@Operation(summary = "Resolve a Java incident")
	public IncidentResponse resolve(@PathVariable String id, @Valid @RequestBody ResolveIncidentRequest request) {
		return mapper.toResponse(resolveIncidentUseCase.execute(id, request.rootCause(), request.resolution()));
	}
}