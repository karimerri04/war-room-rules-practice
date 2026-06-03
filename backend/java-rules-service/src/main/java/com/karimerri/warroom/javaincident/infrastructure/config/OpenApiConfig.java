package com.karimerri.warroom.javaincident.infrastructure.config;

import io.swagger.v3.oas.models.ExternalDocumentation;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration OpenAPI du microservice Java Incident.
 *
 * <p>Elle documente l’API REST exposée par le service afin de faciliter
 * les tests manuels, la démonstration et l’évaluation technique.</p>
 */
@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI javaIncidentOpenApi() {
        return new OpenAPI()
                .info(new Info()
                        .title("War Room - Java Incident Service API")
                        .version("v1")
                        .description("""
                                REST API for managing Java backend incidents in the War Room project.
                                
                                This service intentionally uses an in-memory repository so the project
                                can be started and reviewed without any external database.
                                """))
                .externalDocs(new ExternalDocumentation()
                        .description("War Room Rules Practice Repository")
                        .url("https://github.com/karimerri04/war-room-rules-practice"));
    }
}