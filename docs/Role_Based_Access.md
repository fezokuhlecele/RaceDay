# RaceDay Role-Based Access Design

## Overview

RaceDay supports two user roles: Organiser and Participant.

The roles are designed to provide users with access to functionality appropriate to their responsibilities within the event management system.

## Organiser

Organisers are responsible for managing events and race information.

An Organiser can:

- Create events.
- View events they manage.
- Edit event information.
- Delete events.
- Create and manage event categories.
- View participant enrolments for their events.
- Capture participant race results.
- View results associated with their events.

Organiser-only functionality will be protected at API level in Part 2 and reflected in the MVC interface in Part 3.

## Participant

Participants use RaceDay to discover and enter events and track their own participation.

A Participant can:

- Create an account.
- Log into the system.
- View their profile.
- Browse available events.
- View event categories.
- Enrol in an available event category.
- View their own enrolments.
- View their personal race results.
- View relevant route and weather information.

Participants must not be able to access organiser-only management functionality.

## Public Functionality

Some RaceDay information can be available without authentication, including:

- Browsing upcoming events.
- Viewing event details.
- Viewing available event categories.

Authenticated functionality will require the user to log into the system.

## API-Level Security

In Part 2, role-based access will be enforced at the REST API level. Authentication and authorisation will determine whether a request can access a particular endpoint.

For example, an endpoint that creates an event will require the Organiser role, while an endpoint that retrieves a participant's own enrolments will require an authenticated Participant.

## MVC Consistency

In Part 3, the MVC application will reflect the same role permissions used by the API.

The interface will display functionality appropriate to the authenticated user's role while the API remains responsible for enforcing access control.
