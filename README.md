# \# RaceDay
youtube link: https://www.youtube.com/watch?v=o3KPpheDbSI 

# 

# \## Project Overview

# 

# RaceDay is a full-stack web-based event management system designed for South African road running, walking and cycling events. The system allows organisers to create and manage sporting events, categories, participant enrolments and race results. Participants can create accounts, browse available events, select event categories, view their enrolments and track their personal results.

# 

# The system is planned to use a REST API, SQL Server database and MVC web application. Development will be completed in multiple parts, with Part 1 focusing on system planning and database design.

# 

# \## User Roles

# 

# \### Organiser

# 

# The Organiser is responsible for managing sporting events. An organiser can create, edit and delete events, manage event categories, capture participant results and view all participant enrolments for an event.

# 

# \### Participant

# 

# The Participant can create an account, browse available events, select a category and enrol for an event. Participants can also view their own enrolments and track their personal race results.

# 

# \## Part 1 Documentation

# 

# The following documentation is included in the `docs` folder:

# 

# \- \[RaceDay ERD](docs/RaceDay\_ERD.png)

# \- \[API Endpoint Plan](docs/API\_Endpoint\_Plan.md)

# \- \[SQL Database Script](docs/RaceDay\_Database.sql)

# 

# \## Database

# 

# The RaceDay database is designed using Microsoft SQL Server.

# 

# The database contains the following main entities:

# 

# \- Users

# \- Events

# \- Categories

# \- EventCategories

# \- Enrolments

# \- Results

# \- Routes

# \- WeatherInformation

# 

# The database includes primary keys, foreign keys, unique constraints, check constraints and sample seed data.

# 

# \## API Planning

# 

# The API endpoint plan documents the REST API endpoints required by the RaceDay system. The planned endpoints cover:

# 

# \- Authentication

# \- User profiles

# \- Events

# \- Categories

# \- Event categories

# \- Participant enrolments

# \- Race results

# \- Routes

# \- Weather information

# 

# Each endpoint includes the HTTP method, route, description, user role, request body and expected response.

# 

# \## CI/CD

# 

# GitHub Actions is used to support continuous integration and ensure that the project can be checked automatically when changes are pushed to the repository.

# 

# The workflow files are stored in:

# 

# `.github/workflows/`

# 

# \## Project Development

# 

# RaceDay will be developed in three parts:

# 

# \### Part 1 — Planning

# 

# Part 1 focuses on the system design, including the Entity Relationship Diagram (ERD), REST API endpoint plan and SQL Server database script.

# 

# \### Part 2 — REST API

# 

# Part 2 will involve developing the C# REST API, connecting the API to the SQL Server database, implementing functionality and creating unit tests.

# 

# \### Part 3 — MVC Web Application

# 

# Part 3 will involve developing the MVC web application that consumes the REST API and implementing Azure Blob Storage and Docker.

# 

# \## AI Use Disclosure

# 

# AI tools were used as a learning and development aid during the planning and documentation process. The assistance was used to help understand requirements, structure documentation and troubleshoot development issues. The final project was reviewed and adapted by the student.

