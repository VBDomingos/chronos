## Overview
This document describes the structure of the NoSQL database schema. The system manages companies, employees, time tracking, solicitations for time adjustments, and includes authentication for secure access.

---

## Collections

### 1. **Company Collection**
Represents a company with references to its employees.

| Field         | Type      | Description                                         |
|---------------|-----------|-----------------------------------------------------|
| `_id`         | string    | Unique identifier for the company.                  |
| `name`        | string    | Company name.                                       |
| `address`     | object    | Company address details.                            |
| `employees`   | array     | List of employee objects.                           |

#### Address Sub-object:
| Field         | Type      | Description                                         |
|---------------|-----------|-----------------------------------------------------|
| `street`      | string    | Street name.                                        |
| `city`        | string    | City name.                                          |
| `postalCode`  | string    | Postal code.                                        |

#### Employee Sub-object (Reference):
| Field         | Type      | Description                                         |
|---------------|-----------|-----------------------------------------------------|
| `employeeId`  | string    | Reference to the employee document.                 |
| `name`        | string    | Name of the employee.                               |

---

### 2. **Employee Collection**
Stores personal details of employees, their work schedule, time records, and leave history.

| Field         | Type      | Description                                         |
|---------------|-----------|-----------------------------------------------------|
| `_id`         | string    | Unique identifier for the employee.                 |
| `name`        | string    | Employee's full name.                               |
| `email`       | string    | Employee's email address.                           |
| `position`    | string    | Job title of the employee.                          |
| `companyId`   | string    | Reference to the company the employee belongs to.   |
| `workingHours`| object    | Employee's scheduled working hours by day.          |
| `timeRecords` | array     | Time tracking records for each day.                 |
| `leaves`      | array     | History of leaves taken by the employee.            |

#### Working Hours Sub-object:
| Field         | Type      | Description                                         |
|---------------|-----------|-----------------------------------------------------|
| `monday`      | object    | Object representing Monday's working hours.         |
| `tuesday`     | object    | Object representing Tuesday's working hours.        |
| `wednesday`   | object    | Object representing Wednesday's working hours.      |
| `thursday`    | object    | Object representing Thursday's working hours.       |
| `friday`      | object    | Object representing Friday's working hours.         |

#### Time Record Sub-object:
| Field         | Type      | Description                                         |
|---------------|-----------|-----------------------------------------------------|
| `date`        | string    | Date of the time entry (format: YYYY-MM-DD).        |
| `arrivalTime` | string    | Time the employee arrived at work.                  |
| `breaks`      | array     | List of break periods (start and end times).        |
| `departureTime`| string   | Time the employee left work.                        |

#### Break Sub-object:
| Field         | Type      | Description                                         |
|---------------|-----------|-----------------------------------------------------|
| `start`       | string    | Break start time.                                   |
| `end`         | string    | Break end time.                                     |

#### Leave Sub-object:
| Field         | Type      | Description                                         |
|---------------|-----------|-----------------------------------------------------|
| `leaveType`   | string    | Type of leave (e.g., vacation, sick leave).         |
| `startDate`   | string    | Start date of the leave (format: YYYY-MM-DD).       |
| `endDate`     | string    | End date of the leave (format: YYYY-MM-DD).         |

---

### 3. **Time Tracking Collection**
Stores daily time records for employees, including arrival time, breaks, and departure time.

| Field         | Type      | Description                                         |
|---------------|-----------|-----------------------------------------------------|
| `_id`         | string    | Unique identifier for the time record.              |
| `employeeId`  | string    | Reference to the employee.                          |
| `date`        | string    | Date of the time entry (format: YYYY-MM-DD).        |
| `arrivalTime` | string    | Time the employee arrived at work.                  |
| `breaks`      | array     | List of break periods (start and end times).        |
| `departureTime`| string   | Time the employee left work.                        |
| `solicitations`| array    | List of solicitations requesting changes to times.  |

#### Solicitation Sub-object:
| Field         | Type      | Description                                         |
|---------------|-----------|-----------------------------------------------------|
| `requestId`   | string    | Unique identifier for the solicitation.             |
| `requestedChange` | string| Field being changed (e.g., departureTime).          |
| `previousValue` | string  | Previous value of the field.                        |
| `newValue`    | string    | Requested new value.                                |
| `status`      | string    | Status of the request (e.g., pending, approved).    |

---

### 4. **Solicitation Collection**
Stores employee requests for time or leave adjustments.

| Field         | Type      | Description                                         |
|---------------|-----------|-----------------------------------------------------|
| `_id`         | string    | Unique identifier for the solicitation.             |
| `employeeId`  | string    | Reference to the employee making the request.       |
| `date`        | string    | Date associated with the request (format: YYYY-MM-DD). |
| `type`        | string    | Type of request (e.g., time change).                |
| `requestedField` | string | Field requested to be changed (e.g., departureTime).|
| `previousValue` | string  | Current value of the field.                         |
| `newValue`    | string    | Requested new value.                                |
| `status`      | string    | Status of the request (e.g., pending, approved).    |
| `timestamp`   | string    | Time when the request was made (format: YYYY-MM-DDTHH:MM:SSZ). |

---

### 5. **Authentication Collection**
Manages the authentication details of users (employees).

| Field         | Type      | Description                                         |
|---------------|-----------|-----------------------------------------------------|
| `_id`         | string    | Unique identifier for the user (employeeId).        |
| `email`       | string    | User's email address (also used for login).         |
| `employeeId`  | string    | Unique identifier for the employee.                 |
| `passwordHash`| string    | Hashed password for secure authentication.          |
| `roles`       | array     | List of roles assigned to the user (e.g., ["company", "employee"]). |
| `token`       | string    | Current authentication token (for session management). |
| `tokenExpiration` | string| Expiration time of the token (format: YYYY-MM-DDTHH:MM:SSZ). |

#### Role Definitions:
- **company**: Can manage employees, companies, and time tracking.
- **employee**: Can track personal time and make solicitations for changes.

