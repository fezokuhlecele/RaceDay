# RaceDay API Endpoint Plan

## 1. Authentication

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | `/api/auth/register` | Register a new RaceDay user | Public | User registration details | 201 Created; 400 Bad Request; 409 Conflict |
| POST | `/api/auth/login` | Authenticate a user | Public | Email and password | 200 OK; 401 Unauthorized |

## 2. User Profile

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | `/api/users/profile` | View the logged-in user's profile | Any | None | 200 OK; 401 Unauthorized |
