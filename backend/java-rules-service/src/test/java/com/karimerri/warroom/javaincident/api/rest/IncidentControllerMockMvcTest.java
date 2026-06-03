package com.karimerri.warroom.javaincident.api.rest;

import com.karimerri.warroom.javaincident.api.error.GlobalExceptionHandler;
import com.karimerri.warroom.javaincident.api.mapper.IncidentMapper;
import com.karimerri.warroom.javaincident.application.usecase.FindAllIncidentsUseCase;
import com.karimerri.warroom.javaincident.application.usecase.FindIncidentByIdUseCase;
import com.karimerri.warroom.javaincident.application.usecase.ResolveIncidentUseCase;
import com.karimerri.warroom.javaincident.infrastructure.persistence.InMemoryIncidentRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.test.web.servlet.MockMvc;

import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.notNullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(controllers = IncidentController.class)
@Import({
        IncidentMapper.class,
        GlobalExceptionHandler.class,
        FindAllIncidentsUseCase.class,
        FindIncidentByIdUseCase.class,
        ResolveIncidentUseCase.class,
        InMemoryIncidentRepository.class
})
@DirtiesContext(classMode = DirtiesContext.ClassMode.BEFORE_EACH_TEST_METHOD)
class IncidentControllerMockMvcTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    @DisplayName("GET /api/java-incidents should return all incidents")
    void shouldReturnAllIncidents() throws Exception {
        mockMvc.perform(get("/api/java-incidents"))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$", hasSize(3)))
                .andExpect(jsonPath("$[0].id").exists())
                .andExpect(jsonPath("$[0].title").exists())
                .andExpect(jsonPath("$[0].severity").exists())
                .andExpect(jsonPath("$[0].status").exists());
    }

    @Test
    @DisplayName("GET /api/java-incidents/{id} should return one incident")
    void shouldReturnIncidentById() throws Exception {
        mockMvc.perform(get("/api/java-incidents/JAVA-INC-001"))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value("JAVA-INC-001"))
                .andExpect(jsonPath("$.title").value("NullPointerException when finding an unknown incident"))
                .andExpect(jsonPath("$.severity").value("HIGH"))
                .andExpect(jsonPath("$.status").value("OPEN"))
                .andExpect(jsonPath("$.symptoms", hasSize(3)))
                .andExpect(jsonPath("$.rootCause").value(""))
                .andExpect(jsonPath("$.resolution").value(""))
                .andExpect(jsonPath("$.createdAt", notNullValue()))
                .andExpect(jsonPath("$.resolvedAt").isEmpty());
    }

    @Test
    @DisplayName("GET /api/java-incidents/{id} should return 404 when incident does not exist")
    void shouldReturnNotFoundWhenIncidentDoesNotExist() throws Exception {
        mockMvc.perform(get("/api/java-incidents/UNKNOWN"))
                .andExpect(status().isNotFound())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.status").value(404))
                .andExpect(jsonPath("$.error").value("Not Found"))
                .andExpect(jsonPath("$.messages[0]").value("Incident not found: UNKNOWN"))
                .andExpect(jsonPath("$.path").value("/api/java-incidents/UNKNOWN"));
    }

    @Test
    @DisplayName("PATCH /api/java-incidents/{id}/resolve should resolve an incident")
    void shouldResolveIncident() throws Exception {
        String requestBody = """
                {
                  "rootCause": "The repository did not represent absence explicitly.",
                  "resolution": "Use Optional in the repository contract and translate missing incidents to a 404 response."
                }
                """;

        mockMvc.perform(patch("/api/java-incidents/JAVA-INC-001/resolve")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value("JAVA-INC-001"))
                .andExpect(jsonPath("$.status").value("RESOLVED"))
                .andExpect(jsonPath("$.rootCause").value("The repository did not represent absence explicitly."))
                .andExpect(jsonPath("$.resolution").value("Use Optional in the repository contract and translate missing incidents to a 404 response."))
                .andExpect(jsonPath("$.resolvedAt", notNullValue()));
    }

    @Test
    @DisplayName("PATCH /api/java-incidents/{id}/resolve should return 400 when body is invalid")
    void shouldReturnBadRequestWhenResolveRequestIsInvalid() throws Exception {
        String requestBody = """
                {
                  "rootCause": "",
                  "resolution": ""
                }
                """;

        mockMvc.perform(patch("/api/java-incidents/JAVA-INC-001/resolve")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isBadRequest())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.status").value(400))
                .andExpect(jsonPath("$.error").value("Validation Error"))
                .andExpect(jsonPath("$.messages", hasSize(2)))
                .andExpect(jsonPath("$.path").value("/api/java-incidents/JAVA-INC-001/resolve"));
    }

    @Test
    @DisplayName("PATCH /api/java-incidents/{id}/resolve should return 400 when incident is already resolved")
    void shouldReturnBadRequestWhenIncidentIsAlreadyResolved() throws Exception {
        String firstRequestBody = """
                {
                  "rootCause": "First root cause",
                  "resolution": "First resolution"
                }
                """;

        String secondRequestBody = """
                {
                  "rootCause": "Second root cause",
                  "resolution": "Second resolution"
                }
                """;

        mockMvc.perform(patch("/api/java-incidents/JAVA-INC-001/resolve")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(firstRequestBody))
                .andExpect(status().isOk());

        mockMvc.perform(patch("/api/java-incidents/JAVA-INC-001/resolve")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(secondRequestBody))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.status").value(400))
                .andExpect(jsonPath("$.error").value("Bad Request"))
                .andExpect(jsonPath("$.messages[0]").value("Incident is already resolved"));
    }
}