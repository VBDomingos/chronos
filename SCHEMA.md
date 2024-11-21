## Collections

### **Companies Collection**
Represents a company with references to its employees.

**Collection**: `companies`

| Field            | Type  | Description                                  |
|------------------|-------|----------------------------------------------|
| `name`           | string | Company name.                               |
| `workingHours`   | map    | Company working hours details (see below).  |

#### WorkingHours Map:
Specifies the working hours for different types of employment.

| Field       | Type    | Description                                |
|-------------|---------|--------------------------------------------|
| `clt`       | map     | Working hours for CLT (hired employees).|
| `estagio`   | map     | Working hours for interns.                 |

#### Clt Map:
Defines the working hours for employees (CLT).

| Field       | Type    | Description                                |
|-------------|---------|--------------------------------------------|
| `weekDays`  | map     | Working hours for weekdays.               |
| `weekEnds`  | map     | Working hours for weekends.               |

#### Estagio Map:
Defines the working hours for interns.

| Field       | Type    | Description                                |
|-------------|---------|--------------------------------------------|
| `weekDays`  | map     | Working hours for weekdays.               |

#### Weekdays and Weekends Map:
Specifies the schedule details for each working period.

| Field            | Type    | Description                                                    |
|------------------|---------|----------------------------------------------------------------|
| `arrivalTime`    | string  | Scheduled time of arrival (format: HH:MM).                     |
| `break`          | string  | Time when the break period starts (format: HH:MM).             |
| `departureTime`  | string  | Scheduled time of departure (format: HH:MM).                   |
| `totalBreakTime` | string  | Total duration of break in hours (e.g., "1", "2").             |

---

### **Employees Collection**
Stores personal details of employees, their time records, and solicitations.

| Field             | Type      | Description                                      |
|-------------------|-----------|--------------------------------------------------|
| `companyId`       | string    | Identifier of the associated company.            |
| `createdAt`       | timestamp | Record creation timestamp.                       |
| `document`        | string    | Employee's identification document.             |
| `email`           | string    | Employee's email address.                       |
| `isWorking`       | bool      | Indicates if the employee is currently working. |
| `name`            | string    | Employee's name.                                |
| `phone`           | string    | Employee's contact number.                      |
| `role`            | string    | Role of the employee (e.g., admin, employee).   |
| `workingPattern`  | string    | Employment type (e.g., CLT, estagio).           |

**Subcollections**:

1. **`timeRecords`**  
   Tracks daily working time details for employees.

   | Field        | Type    | Description                                        |
   |--------------|---------|----------------------------------------------------|
   | `date`       | string  | Date of the time record (format: "DD-MM-YYYY").    |
   | `entrada-x`  | map     | Entry details for a specific time slot.            |
   | `saida-x`    | map     | Exit details for a specific time slot.             |

   #### Entrada and Saida Map:
   Captures location and timing information for employee entries and exits.

   | Field               | Type    | Description                                       |
   |---------------------|---------|---------------------------------------------------|
   | `latitude`          | number  | GPS latitude of the location.                    |
   | `longitude`         | number  | GPS longitude of the location.                   |
   | `solicitationIsOpen`| bool    | Indicates if a solicitation is open for this entry/exit. |
   | `time`              | string  | Time of the entry/exit (format: HH:MM).          |

   #### Break Map:
   Represents a break period during the workday.

   | Field   | Type    | Description                |
   |---------|---------|----------------------------|
   | `start` | string  | Break start time (HH:MM).  |
   | `end`   | string  | Break end time (HH:MM).    |

2. **`solicitations`**  
   Logs requests made by employees for changes to time or leave records.

   | Field               | Type      | Description                                       |
   |---------------------|-----------|---------------------------------------------------|
   | `newValue`          | string    | Requested new value.                              |
   | `previousValue`     | string    | Current value of the field.                      |
   | `reason`            | string    | Reason for opening the solicitation.             |
   | `requestedField`    | string    | Field to be updated (e.g., `saida-1`, `entrada-1`). |
   | `requestedFieldDate`| string    | Date of the field to be updated (format: DD-MM-YYYY). |
   | `status`            | string    | Status of the request (e.g., pending, accepted). |
   | `solicitationIsOpen`| bool      | Indicates if the solicitation is still open.     |
   | `timestamp`         | timestamp | Timestamp of when the request was made (ISO 8601). |

---

#### Type Definition:
- **admin**: Can manage employees, solicitations and time tracking details.
- **employee**: Can track personal time and submit requests for changes.
