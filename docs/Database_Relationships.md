# RaceDay Database Relationships

## Overview

The RaceDay database uses relational database principles to connect users, events, categories, enrolments and race results.

The relationships defined below correspond to the entities represented in the RaceDay Entity Relationship Diagram (ERD).

## Users and Events

One Organiser can manage many Events.

**Relationship:**

`Users (Organiser) 1 ──── M Events`

The `Events.OrganiserID` foreign key references `Users.UserID`.

This relationship allows the system to identify which organiser is responsible for each event.

## Events and Categories

An Event can contain multiple Categories, and a Category can be available at multiple Events.

This is a many-to-many relationship resolved through the `EventCategories` entity.

**Relationship:**

`Events 1 ──── M EventCategories M ──── 1 Categories`

The `EventCategories` table stores the relationship between an event and a category.

It also stores event-specific information such as the entry fee and maximum number of participants.

## Participants and Enrolments

One Participant can have many Enrolments.

**Relationship:**

`Users (Participant) 1 ──── M Enrolments`

The `Enrolments.ParticipantID` foreign key identifies the participant who entered the event.

## Event Categories and Enrolments

One EventCategory can have many Enrolments.

**Relationship:**

`EventCategories 1 ──── M Enrolments`

This allows multiple participants to enrol in the same event category.

## Enrolments and Results

One Enrolment can have one Result.

**Relationship:**

`Enrolments 1 ──── 1 Results`

The `Results.EnrolmentID` foreign key identifies the participant's specific race entry.

The relationship allows RaceDay to associate a finishing time and race position with a particular enrolment.

## Events and Routes

Each Event has one Route.

**Relationship:**

`Events 1 ──── 1 Routes`

The `Routes.EventID` foreign key identifies the event associated with the route.

Route information can include the route name, distance, description and map URL.

## Events and Weather Information

Each Event can have one WeatherInformation record in the current database design.

**Relationship:**

`Events 1 ──── 1 WeatherInformation`

The `WeatherInformation.EventID` foreign key identifies the event for which the weather information was recorded.

Weather information includes temperature, weather conditions, wind speed and rain probability.

## Referential Integrity

Foreign key constraints are used to maintain referential integrity.

This prevents records from referencing entities that do not exist and ensures that the relationships represented in the ERD are also enforced by the SQL Server database.
