## Collections

### **Companies Collection**
Represents a company with references to its employees.

**Collection**: `companies`

| Field      | Type  | Description                                |
|------------|-------|--------------------------------------------|
| `name`     | string | Company name.                             |
| `address`  | map    | Company address details (see below).      |

#### Address Map:
| Field       | Type    | Description                              |
|-------------|---------|------------------------------------------|
| `street`    | string  | Street name.                             |
| `city`      | string  | City name.                               |
| `postalCode`| string  | Postal code.                             |

---

### **Employees Subcollection**
Stores personal details of employees, their work schedule, time records, and leave history.

| Field         | Type  | Description                                     |
|---------------|-------|-------------------------------------------------|
| `name`        | string| Employee's full name.                           |
| `email`       | string| Employee's email address.                       |
| `workingHours`| map   | Employee's scheduled working hours by day (see below). |
| `leaves`      | array | History of leaves taken by the employee.        |

#### Leave Array:
Each entry represents a leave record:

| Field         | Type    | Description                                       |
|---------------|---------|---------------------------------------------------|
| `leaveType`   | string  | Type of leave (e.g., vacation, sick leave).       |
| `startDate`   | string  | Start date of the leave (format: YYYY-MM-DD).     |
| `endDate`     | string  | End date of the leave (format: YYYY-MM-DD).       |

#### Working Hours Map:
| Field         | Type    | Description                                |
|---------------|---------|--------------------------------------------|
| `monday`      | map     | Object representing Monday's working hours.|
| `tuesday`     | map     | Object representing Tuesday's working hours. |
| `wednesday`   | map     | Object representing Wednesday's working hours. |
| `thursday`    | map     | Object representing Thursday's working hours. |
| `friday`      | map     | Object representing Friday's working hours. |

#### Each **Day Map** (e.g., `monday`, `tuesday`) includes:

| Field        | Type   | Description                                        |
|--------------|--------|----------------------------------------------------|
| `startTime`  | string | Start time of the workday (e.g., "09:00").         |
| `endTime`    | string | End time of the workday (e.g., "17:00").           |
| `breaks`     | array  | List of break periods (see below).                 |

#### Breaks Array:
Each entry in the breaks array represents a break period, containing:

| Field   | Type   | Description                        |
|---------|--------|------------------------------------|
| `start` | string | Break start time (e.g., "12:00"). |
| `end`   | string | Break end time (e.g., "12:30").   |

**Subcollections**:

1. **`timeRecords`**  
   Stores time tracking data for each employee on a per-day basis.

   | Field          | Type    | Description                                       |
   |----------------|---------|---------------------------------------------------|
   | `date`         | string  | Date of the time entry (format: YYYY-MM-DD).      |
   | `arrivalTime`  | string  | Time the employee arrived at work.                |
   | `breaks`       | array   | List of break periods (see Break Array below).    |
   | `departureTime`| string  | Time the employee left work.                      |

   #### Break Array:
   Each entry represents a break period.

   | Field         | Type    | Description                                       |
   |---------------|---------|---------------------------------------------------|
   | `start`       | string  | Break start time.                                 |
   | `end`         | string  | Break end time.                                   |

2. **`solicitations`**  
   Stores requests from employees for time or leave adjustments.

   | Field            | Type    | Description                                       |
   |------------------|---------|---------------------------------------------------|
   | `type`           | string  | Type of request (e.g., time change).              |
   | `requestedField` | string  | Field requested to be changed.                    |
   | `previousValue`  | string  | Current value of the field.                       |
   | `newValue`       | string  | Requested new value.                              |
   | `status`         | string  | Status of the request (e.g., pending, approved).  |
   | `timestamp`      | timestamp  | Time when the request was made (format: YYYY-MM-DDTHH:MM:SSZ). |

---

### 3. **Authentication Collection**
Manages the authentication details of users (employees).

**Collection**: `authentication`

| Field            | Type    | Description                                         |
|------------------|---------|-----------------------------------------------------|
| `email`          | string  | User's email address (also used for login).         |
| `_id`     | string  | Unique identifier for the document.                 |
| `passwordHash`   | string  | Hashed password for secure authentication.          |
| `type`           | array   | Type of the account (e.g., company, employee. |
| `token`          | string  | Current authentication token.                       |
| `tokenExpiration`| string  | Expiration time of the token (format: YYYY-MM-DDTHH:MM:SSZ). |

#### Type Definition:
- **company**: Can manage employees, companies, and time tracking.
- **employee**: Can track personal time and make solicitations for changes.
