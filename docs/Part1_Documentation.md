# RaceDay Part 1 Documentation

## Overview

Part 1 of the RaceDay project focuses on planning and designing the system before implementation of the REST API and MVC web application.

The planning process establishes the database structure, API requirements and relationships between the different components of the system.

## Part 1 Deliverables

The following documents form part of the RaceDay Part 1 submission:

### Entity Relationship Diagram

The Entity Relationship Diagram (ERD) represents the database entities, attributes, primary keys, foreign keys and relationships required by the RaceDay system.

The ERD is available in:

`RaceDay_ERD.png`

### API Endpoint Plan

The API Endpoint Plan defines the REST API endpoints that will be implemented in Part 2.

It specifies the HTTP method, route, purpose, user role, request body and expected response for each endpoint.

The endpoint plan is available in:

`API_Endpoint_Plan.md`

### SQL Database Script

The SQL database script contains the database creation statements, constraints and sample seed data required for the RaceDay database.

The SQL script is available in:

`RaceDay_Database.sql`

## Database Entities

The RaceDay database contains the following entities:

- Users
- Events
- Categories
- EventCategories
- Enrolments
- Results
- Routes
- WeatherInformation

## User Roles

### Organiser

Organisers can create, edit and delete events, manage event categories, capture participant results and view event enrolments.

### Participant

Participants can create accounts, browse events, select categories and enrol for events. They can also view their own enrolments and personal results.

## Development Approach

The project is divided into three parts:

- **Part 1:** System planning, ERD, API endpoint plan and SQL database design.
- **Part 2:** C# REST API, database integration, unit testing and CI/CD.
- **Part 3:** MVC web application, API consumption, Azure Blob Storage and Docker.

## Part 1 Status

The ERD, API endpoint plan and SQL database script have been prepared for the Part 1 submission.
