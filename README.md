# RaceDay API - Portfolio of Evidence (Parts 1 & 2)

## Overview & System Architecture
The RaceDay API is an enterprise-grade, secure, and cloud-aware .NET 10 Web API built to manage multi-category race events, participant enrolments, and granular role-based access control. The project spans system planning, explicit relational database mapping, RESTful API implementation, unit testing, and automated GitHub Actions CI/CD pipelines.

The platform distinguishes between two core user roles:
* **Organiser**: Possesses elevated privileges to create, schedule, and manage race events and categories.
* **Participant**: Possesses privileges to browse available race events and register/enrol into specific race categories.

---

## Part 1: System Planning & Artifacts
The foundational architecture and planning artifacts for the RaceDay platform are preserved within the `/docs` directory in this repository:
* **Entity Relationship Diagram (ERD)**: Documents entity structures, relationships, and foreign key mappings (`docs/erd.png` or `docs/erd.txt`).
* **API Endpoint Specification**: Detailed route planning mapping HTTP methods to domain models (`docs/api_plan.md`).
* **SQL DDL Scripts**: Direct database creation and schema definitions (`docs/schema.sql`).

---

## Part 2: Technical Implementation Details

### Technology Stack
* **Framework**: .NET Web API (.NET 10)
* **Database & ORM**: SQL Server (`SQLEXPRESS`) using EF Core Fluent API (Code-First Explicit Mapping)
* **Security & Auth**: JSON Web Token (JWT) Bearer Authentication with Role Claims (`Organiser` and `Participant`)
* **Testing & CI/CD**: xUnit Test Suite (`RaceDay.Tests`) integrated with GitHub Actions Workflows (`.github/workflows/ci.yml`)
* **API Documentation**: Interactive Swagger UI with Bearer Security Definitions

---

## Database Schema (SQL DDL)

To manually initialize or verify the relational database schema in SQL Server (`SQLEXPRESS`), execute the following DDL script:

```sql
CREATE DATABASE RaceDayDb;
GO

USE RaceDayDb;
GO

CREATE TABLE Roles (
    RoleId INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL
);

CREATE TABLE Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    PasswordHash NVARCHAR(MAX) NOT NULL,
    PhoneNumber NVARCHAR(20) NULL,
    RoleId INT NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleId) REFERENCES Roles(RoleId)
);

CREATE TABLE Events (
    EventId INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(150) NOT NULL,
    Description NVARCHAR(1000) NULL,
    Location NVARCHAR(200) NOT NULL,
    EventDate DATETIME2 NOT NULL,
    OrganiserId INT NOT NULL,
    CONSTRAINT FK_Events_Users FOREIGN KEY (OrganiserId) REFERENCES Users(UserId)
);

CREATE TABLE Enrolments (
    EnrolmentId INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantId INT NOT NULL,
    CategoryId INT NOT NULL,
    CONSTRAINT FK_Enrolments_Participants FOREIGN KEY (ParticipantId) REFERENCES Users(UserId),
    CONSTRAINT FK_Enrolments_Events FOREIGN KEY (CategoryId) REFERENCES Events(EventId)
);
