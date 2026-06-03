# Java Incident Service

Microservice Spring Boot du projet **War Room Rules Practice**.

Ce service expose une API REST permettant de consulter et résoudre des incidents techniques Java / backend.

L’objectif du service n’est pas d’afficher des règles Java, mais de pratiquer les règles Java, Spring Boot et architecture propre directement dans le code.

## Objectifs techniques

Ce microservice applique volontairement plusieurs principes :

- domaine métier isolé du framework ;
- entités immuables ;
- value objects ;
- repository derrière une interface ;
- persistance in-memory pour faciliter l’exécution locale ;
- DTO séparés du domaine ;
- mapper API ;
- use cases applicatifs ;
- gestion d’erreurs centralisée ;
- tests unitaires et MockMvc ;
- documentation OpenAPI / Swagger.

## Stack

- Java 21
- Spring Boot 4
- Spring Web MVC
- Spring Validation
- Spring Actuator
- Springdoc OpenAPI
- Lombok
- JUnit 5
- MockMvc
- Maven

## Architecture

```txt
src/main/java/com/karimerri/warroom/javaincident/
├── api/
│   ├── dto/
│   ├── error/
│   ├── mapper/
│   └── rest/
├── application/
│   ├── port/
│   └── usecase/
├── domain/
│   ├── exception/
│   ├── model/
│   └── value/
└── infrastructure/
    ├── config/
    └── persistence/