package com.karimerri.warroom.javaincident.api.rest;

import com.karimerri.warroom.javaincident.api.dto.IncidentResponse;
import com.karimerri.warroom.javaincident.api.dto.ResolveIncidentRequest;
import com.karimerri.warroom.javaincident.api.mapper.IncidentMapper;
import com.karimerri.warroom.javaincident.application.usecase.FindAllIncidentsUseCase;
import com.karimerri.warroom.javaincident.application.usecase.FindIncidentByIdUseCase;
import com.karimerri.warroom.javaincident.application.usecase.ResolveIncidentUseCase;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/java-incidents")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class IncidentController {

    private final FindAllIncidentsUseCase findAllIncidentsUseCase;
    private final FindIncidentByIdUseCase findIncidentByIdUseCase;
    private final ResolveIncidentUseCase resolveIncidentUseCase;
    private final IncidentMapper mapper;

    @GetMapping
    public List<IncidentResponse> findAll() {
        return findAllIncidentsUseCase.execute()
                .stream()
                .map(mapper::toResponse)
                .toList();
    }

    @GetMapping("/{id}")
    public IncidentResponse findById(@PathVariable String id) {
        return mapper.toResponse(findIncidentByIdUseCase.execute(id));
    }

    @PatchMapping("/{id}/resolve")
    public IncidentResponse resolve(
            @PathVariable String id,
            @Valid @RequestBody ResolveIncidentRequest request
    ) {
        return mapper.toResponse(
                resolveIncidentUseCase.execute(
                        id,
                        request.rootCause(),
                        request.resolution()
                )
        );
    }
}