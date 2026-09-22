# RaceDay API Endpoint Plan

## 1. Introduction

The RaceDay API will provide the backend services required by the RaceDay event management system. The API will support two main user roles: **Organiser** and **Participant**. Organisers will be able to create and manage events, categories, enrolments and participant results. Participants will be able to register for an account, browse events, enter event categories, view their enrolments and track their personal results.

The API will follow RESTful principles and use HTTP methods such as GET, POST, PUT and DELETE. Protected endpoints will require authentication, while role-specific endpoints will restrict access according to the user's role.

The planned API is designed to support the database structure created for Part 1 and will be implemented in C# during Part 2.

---

# 2. User Roles

| Role                   | Description                                                                                                             |
| ---------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| Public                 | A visitor who has not authenticated.                                                                                    |
| Participant            | A registered user who can browse events, enter event categories and view their own enrolments and results.              |
| Organiser              | A registered user who can create and manage events, manage categories, view enrolments and capture participant results. |
| Any Authenticated User | Either an Organiser or Participant who has successfully logged in.                                                      |

---

# 3. Authentication Endpoints

| HTTP Method | Route                | Description                                                          | Role Required | Request Body                                                  | Expected Response                                                                                                    |
| ----------- | -------------------- | -------------------------------------------------------------------- | ------------- | ------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| POST        | `/api/auth/register` | Creates a new RaceDay user account.                                  | Public        | `{ FirstName, LastName, Email, Password, PhoneNumber, Role }` | **201 Created** - user account created. **400 Bad Request** - invalid data. **409 Conflict** - email already exists. |
| POST        | `/api/auth/login`    | Authenticates a registered user and returns an authentication token. | Public        | `{ Email, Password }`                                         | **200 OK** - login successful and token returned. **401 Unauthorized** - invalid credentials.                        |

---

# 4. User Profile Endpoints

| HTTP Method | Route           | Description                                                          | Role Required          | Request Body                                  | Expected Response                                                                                                          |
| ----------- | --------------- | -------------------------------------------------------------------- | ---------------------- | --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| GET         | `/api/users/me` | Returns the profile information of the currently authenticated user. | Any Authenticated User | None                                          | **200 OK** - user profile returned. **401 Unauthorized** - authentication required.                                        |
| PUT         | `/api/users/me` | Updates the profile information of the currently authenticated user. | Any Authenticated User | `{ FirstName, LastName, Email, PhoneNumber }` | **200 OK** - updated profile returned. **400 Bad Request** - invalid data. **401 Unauthorized** - authentication required. |

---

# 5. Event Endpoints

| HTTP Method | Route              | Description                                                                           | Role Required | Request Body                                                         | Expected Response                                                                                                                                                  |
| ----------- | ------------------ | ------------------------------------------------------------------------------------- | ------------- | -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| GET         | `/api/events`      | Returns a list of available RaceDay events.                                           | Public        | None                                                                 | **200 OK** - list of events returned.                                                                                                                              |
| GET         | `/api/events/{id}` | Returns detailed information about a specific event.                                  | Public        | None                                                                 | **200 OK** - event returned. **404 Not Found** - event does not exist.                                                                                             |
| POST        | `/api/events`      | Creates a new RaceDay event. The authenticated organiser becomes the event organiser. | Organiser     | `{ EventName, Description, EventDate, StartTime, Location, Status }` | **201 Created** - event created. **400 Bad Request** - invalid data. **401 Unauthorized** - authentication required. **403 Forbidden** - user is not an organiser. |
| PUT         | `/api/events/{id}` | Updates an existing event managed by the authenticated organiser.                     | Organiser     | `{ EventName, Description, EventDate, StartTime, Location, Status }` | **200 OK** - event updated. **404 Not Found** - event does not exist. **403 Forbidden** - organiser does not own the event.                                        |
| DELETE      | `/api/events/{id}` | Deletes an event managed by the authenticated organiser.                              | Organiser     | None                                                                 | **204 No Content** - event deleted. **404 Not Found** - event does not exist. **403 Forbidden** - organiser does not own the event.                                |

---

# 6. Category Endpoints

| HTTP Method | Route                  | Description                                                                  | Role Required | Request Body                                           | Expected Response                                                                                                                                           |
| ----------- | ---------------------- | ---------------------------------------------------------------------------- | ------------- | ------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GET         | `/api/categories`      | Returns all available race categories.                                       | Public        | None                                                   | **200 OK** - list of categories returned.                                                                                                                   |
| GET         | `/api/categories/{id}` | Returns information about a specific race category.                          | Public        | None                                                   | **200 OK** - category returned. **404 Not Found** - category does not exist.                                                                                |
| POST        | `/api/categories`      | Creates a new race category that can be assigned to events.                  | Organiser     | `{ CategoryName, Description, DistanceKm, EventType }` | **201 Created** - category created. **400 Bad Request** - invalid data. **403 Forbidden** - user is not an organiser.                                       |
| PUT         | `/api/categories/{id}` | Updates an existing race category.                                           | Organiser     | `{ CategoryName, Description, DistanceKm, EventType }` | **200 OK** - category updated. **404 Not Found** - category does not exist. **403 Forbidden** - user is not an organiser.                                   |
| DELETE      | `/api/categories/{id}` | Deletes an existing race category if it is not required by existing records. | Organiser     | None                                                   | **204 No Content** - category deleted. **404 Not Found** - category does not exist. **409 Conflict** - category cannot be deleted because it is being used. |

---

# 7. Event Category Endpoints

| HTTP Method | Route                                                | Description                                                                            | Role Required | Request Body                                    | Expected Response                                                                                                                                   |
| ----------- | ---------------------------------------------------- | -------------------------------------------------------------------------------------- | ------------- | ----------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| GET         | `/api/events/{eventId}/categories`                   | Returns all categories available for a specific event.                                 | Public        | None                                            | **200 OK** - event categories returned. **404 Not Found** - event does not exist.                                                                   |
| POST        | `/api/events/{eventId}/categories`                   | Adds an existing category to an event and defines its entry fee and participant limit. | Organiser     | `{ CategoryID, EntryFee, MaximumParticipants }` | **201 Created** - event category created. **404 Not Found** - event/category does not exist. **409 Conflict** - category already assigned to event. |
| PUT         | `/api/events/{eventId}/categories/{eventCategoryId}` | Updates the entry fee or participant limit for a category within an event.             | Organiser     | `{ EntryFee, MaximumParticipants }`             | **200 OK** - event category updated. **404 Not Found** - record does not exist. **403 Forbidden** - organiser does not manage the event.            |
| DELETE      | `/api/events/{eventId}/categories/{eventCategoryId}` | Removes a category from an event if it has no conflicting enrolments.                  | Organiser     | None                                            | **204 No Content** - category removed. **404 Not Found** - record does not exist. **409 Conflict** - category has existing enrolments.              |

---

# 8. Enrolment Endpoints

| HTTP Method | Route                              | Description                                                                         | Role Required | Request Body          | Expected Response                                                                                                                                                      |
| ----------- | ---------------------------------- | ----------------------------------------------------------------------------------- | ------------- | --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| POST        | `/api/enrolments`                  | Enrols the authenticated participant into a selected event category.                | Participant   | `{ EventCategoryID }` | **201 Created** - enrolment created with a race number. **400 Bad Request** - invalid request. **409 Conflict** - participant is already enrolled or category is full. |
| GET         | `/api/enrolments/me`               | Returns all event enrolments belonging to the authenticated participant.            | Participant   | None                  | **200 OK** - participant's enrolments returned.                                                                                                                        |
| GET         | `/api/enrolments/{id}`             | Returns details of a specific enrolment belonging to the authenticated participant. | Participant   | None                  | **200 OK** - enrolment returned. **404 Not Found** - enrolment does not exist. **403 Forbidden** - enrolment does not belong to the participant.                       |
| DELETE      | `/api/enrolments/{id}`             | Cancels the authenticated participant's enrolment.                                  | Participant   | None                  | **204 No Content** - enrolment cancelled. **404 Not Found** - enrolment does not exist. **403 Forbidden** - enrolment does not belong to the participant.              |
| GET         | `/api/events/{eventId}/enrolments` | Returns all participant enrolments for an event.                                    | Organiser     | None                  | **200 OK** - event enrolments returned. **404 Not Found** - event does not exist. **403 Forbidden** - organiser does not manage the event.                             |

---

# 9. Result Endpoints

| HTTP Method | Route                           | Description                                                           | Role Required | Request Body                                                                   | Expected Response                                                                                                                                                |
| ----------- | ------------------------------- | --------------------------------------------------------------------- | ------------- | ------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| POST        | `/api/results`                  | Records the result of a participant who completed an event.           | Organiser     | `{ EnrolmentID, FinishTime, OverallPosition, CategoryPosition, ResultStatus }` | **201 Created** - result recorded. **400 Bad Request** - invalid result. **404 Not Found** - enrolment does not exist. **409 Conflict** - result already exists. |
| PUT         | `/api/results/{id}`             | Updates an existing participant result.                               | Organiser     | `{ FinishTime, OverallPosition, CategoryPosition, ResultStatus }`              | **200 OK** - result updated. **404 Not Found** - result does not exist. **403 Forbidden** - organiser does not manage the relevant event.                        |
| GET         | `/api/results/me`               | Returns all results belonging to the authenticated participant.       | Participant   | None                                                                           | **200 OK** - participant results returned.                                                                                                                       |
| GET         | `/api/results/me/{id}`          | Returns a specific result belonging to the authenticated participant. | Participant   | None                                                                           | **200 OK** - result returned. **404 Not Found** - result does not exist. **403 Forbidden** - result does not belong to participant.                              |
| GET         | `/api/events/{eventId}/results` | Returns the results of participants who entered a specific event.     | Organiser     | None                                                                           | **200 OK** - event results returned. **404 Not Found** - event does not exist. **403 Forbidden** - organiser does not manage the event.                          |

---

# 10. Route Information Endpoints

| HTTP Method | Route                         | Description                                     | Role Required | Request Body                                          | Expected Response                                                                                                                               |
| ----------- | ----------------------------- | ----------------------------------------------- | ------------- | ----------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| GET         | `/api/events/{eventId}/route` | Returns route information for a specific event. | Public        | None                                                  | **200 OK** - route information returned. **404 Not Found** - route information does not exist.                                                  |
| POST        | `/api/events/{eventId}/route` | Creates route information for an event.         | Organiser     | `{ RouteName, DistanceKm, RouteDescription, MapUrl }` | **201 Created** - route information created. **404 Not Found** - event does not exist. **403 Forbidden** - organiser does not manage the event. |
| PUT         | `/api/events/{eventId}/route` | Updates the route information for an event.     | Organiser     | `{ RouteName, DistanceKm, RouteDescription, MapUrl }` | **200 OK** - route information updated. **404 Not Found** - route does not exist. **403 Forbidden** - organiser does not manage the event.      |
| DELETE      | `/api/events/{eventId}/route` | Removes route information from an event.        | Organiser     | None                                                  | **204 No Content** - route information deleted. **404 Not Found** - route does not exist.                                                       |

---

# 11. Weather Information Endpoints

| HTTP Method | Route                           | Description                                                 | Role Required | Request Body                                                    | Expected Response                                                                                                                                |
| ----------- | ------------------------------- | ----------------------------------------------------------- | ------------- | --------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| GET         | `/api/events/{eventId}/weather` | Returns the latest weather information stored for an event. | Public        | None                                                            | **200 OK** - weather information returned. **404 Not Found** - weather information does not exist.                                               |
| POST        | `/api/events/{eventId}/weather` | Stores weather information associated with an event.        | Organiser     | `{ Temperature, WeatherCondition, WindSpeed, RainProbability }` | **201 Created** - weather information stored. **404 Not Found** - event does not exist. **403 Forbidden** - organiser does not manage the event. |
| PUT         | `/api/events/{eventId}/weather` | Updates weather information for an event.                   | Organiser     | `{ Temperature, WeatherCondition, WindSpeed, RainProbability }` | **200 OK** - weather information updated. **404 Not Found** - weather information does not exist.                                                |
| DELETE      | `/api/events/{eventId}/weather` | Removes stored weather information for an event.            | Organiser     | None                                                            | **204 No Content** - weather information deleted. **404 Not Found** - weather information does not exist.                                        |

---


# 12. HTTP Status Codes

The RaceDay API will use standard HTTP status codes to communicate the outcome of requests.

| Status Code               | Meaning                                                | Example                                  |
| ------------------------- | ------------------------------------------------------ | ---------------------------------------- |
| 200 OK                    | Request completed successfully.                        | Event or profile successfully retrieved. |
| 201 Created               | A new resource was successfully created.               | New event or enrolment created.          |
| 204 No Content            | Request succeeded but there is no response body.       | Event successfully deleted.              |
| 400 Bad Request           | Request contains invalid or missing information.       | Invalid event data supplied.             |
| 401 Unauthorized          | Authentication is required or credentials are invalid. | User has not logged in.                  |
| 403 Forbidden             | User is authenticated but does not have permission.    | Participant attempts to create an event. |
| 404 Not Found             | Requested resource does not exist.                     | Event ID cannot be found.                |
| 409 Conflict              | Request conflicts with existing data or system rules.  | Participant attempts to enrol twice.     |
| 500 Internal Server Error | Unexpected server-side error.                          | Database or server failure.              |

---

# 13. Authentication and Authorisation

RaceDay will use authentication to identify users and authorisation to control access to protected resources. After successful login, the API will provide an authentication token that can be included in subsequent requests.

Role-based access will be enforced at API level.

Organisers will have permission to:

* Create events.
* Update their events.
* Delete their events.
* Create and manage categories.
* Assign categories to events.
* View enrolments for their events.
* Capture and update participant results.
* Manage route information for their events.
* Manage event weather information.

Participants will have permission to:

* Create an account.
* Log in.
* View and update their profile.
* Browse available events.
* View event categories.
* Enrol in event categories.
* View their own enrolments.
* Cancel their own enrolments.
* View their own results.

Public users will be able to browse events, event details, categories, route information and available weather information without logging in.

---

# 14. API Design Principles

The RaceDay API will follow the following design principles:

1. **RESTful design** - resources will be represented using clear URLs and standard HTTP methods.
2. **Role-based authorisation** - protected resources will only be accessible to users with the appropriate role.
3. **Resource ownership** - organisers will only be able to modify events and related information that they manage.
4. **Participant privacy** - participants will only be able to access their own enrolments and results.
5. **Validation** - invalid requests will return appropriate HTTP error responses.
6. **Consistent status codes** - standard HTTP status codes will communicate successful and unsuccessful requests.
7. **Separation of concerns** - authentication, events, categories, enrolments and results will be handled as separate API resources.
8. **Database consistency** - API operations will follow the relationships and constraints defined in the RaceDay database design.

---

# 15. Planned API Summary

The planned RaceDay API contains endpoints for:

* Authentication
* User profiles
* Events
* Categories
* Event categories
* Enrolments
* Results
* Routes
* Weather information

This endpoint plan will be used as the reference specification when implementing the RaceDay RESTful API in Part 2. Any changes made during implementation will be documented and justified in the project README.

## API Endpoint Grouping

The RaceDay API is organised into functional groups to make the system easier to understand and maintain.

### Authentication

Authentication endpoints allow users to register and log into the RaceDay system. These endpoints establish the identity and role of each user.

### User Profile

User profile endpoints allow authenticated users to retrieve and update their profile information.

### Events

Event endpoints allow organisers to create, view, update and delete events. Participants can use the public event endpoints to browse available events.

### Categories

Category endpoints allow organisers to manage the different running, walking and cycling categories available within the system.

### Event Enrolments

Enrolment endpoints allow participants to enter an event by selecting an available category. Organisers can view enrolments associated with their events.

### Results

Result endpoints allow organisers to capture and manage race results. Participants can retrieve their own results.

### Routes and Weather

Route and weather endpoints provide additional information that can assist participants when preparing for an event.
