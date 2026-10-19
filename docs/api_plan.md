\# RaceDay API Endpoint Plan



| Method | Endpoint | Description | Auth Required | Roles Allowed |

|--------|----------|-------------|---------------|---------------|

| POST | `/api/Auth/register` | Register new user | No | All |

| POST | `/api/Auth/login` | User authentication \& JWT generation | No | All |

| GET | `/api/Events` | Retrieve list of race events | Yes | Organiser, Participant |

| POST | `/api/Events` | Create a new race event | Yes | Organiser |

| POST | `/api/Enrolments` | Enrol participant into race category | Yes | Participant |

