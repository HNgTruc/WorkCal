<a id="top"></a>

# Sơ đồ quan hệ (ERD)

[← database](README.md) · [Mục lục tài liệu](../README.md)

Sơ đồ chia theo nhóm để dễ đọc. Mọi bảng nghiệp vụ có `TenantId`; các bảng đồng bộ có thêm `Version`, `UpdatedAt`, `IsDeleted` (không vẽ lại ở mỗi bảng).

## Mục lục

- [Nhóm 1 · Tài khoản và tenant](#nhom-1)
- [Nhóm 2 · Lịch, sự kiện, task](#nhom-2)
- [Nhóm 3 · Nghỉ phép, ca, chấm công](#nhom-3)
- [Nhóm 4 · Nền tảng và tích hợp](#nhom-4)

<a id="nhom-1"></a>
## Nhóm 1 · Tài khoản và tenant

```mermaid
erDiagram
    PLANS ||--o{ TENANTS : "ap dung"
    TENANTS ||--o{ MEMBERSHIPS : "co"
    USERS ||--o{ MEMBERSHIPS : "tham gia"
    DEPARTMENTS |o--o{ MEMBERSHIPS : "chua"
    TENANTS ||--o{ DEPARTMENTS : "gom"
    TENANTS ||--o{ INVITATIONS : "gui"
    USERS ||--o{ DEVICES : "dang ky"
    USERS ||--o{ REFRESH_TOKENS : "co"
    TENANTS {
        guid Id PK
        string Name
        string Type
        guid PlanId FK
        string TimeZoneId
        bool IsLocked
    }
    USERS {
        guid Id PK
        string Email UK
        string FullName
        bool IsPlatformAdmin
        bool IsLocked
    }
    MEMBERSHIPS {
        guid Id PK
        guid TenantId FK
        guid UserId FK
        guid DepartmentId FK
        string Role
    }
    DEPARTMENTS {
        guid Id PK
        guid TenantId FK
        guid ParentId FK
        guid ManagerId FK
        string Name
    }
```

<a id="nhom-2"></a>
## Nhóm 2 · Lịch, sự kiện, task

```mermaid
erDiagram
    CALENDARS ||--o{ CALENDAR_SHARES : "chia se"
    CALENDARS ||--o{ EVENTS : "chua"
    CALENDARS ||--o{ TASKS : "chua"
    EVENTS ||--o{ EVENT_EXCEPTIONS : "ngoai le"
    EVENTS ||--o{ EVENT_ATTENDEES : "moi"
    EVENTS ||--o{ REMINDERS : "nhac"
    TASKS ||--o{ REMINDERS : "nhac"
    RESOURCES |o--o{ EVENTS : "dat"
    CALENDARS {
        guid Id PK
        guid TenantId FK
        guid OwnerId FK
        string Name
        string Kind
        string Color
    }
    EVENTS {
        guid Id PK
        guid TenantId FK
        guid CalendarId FK
        string Title
        datetime StartUtc
        datetime EndUtc
        string TimeZoneId
        bool IsAllDay
        string RRule
        guid ResourceId FK
    }
    EVENT_EXCEPTIONS {
        guid Id PK
        guid EventId FK
        datetime OriginalStartUtc
        bool IsCancelled
    }
    TASKS {
        guid Id PK
        guid CalendarId FK
        guid AssigneeId FK
        string Title
        datetime DueUtc
        string Status
    }
```

<a id="nhom-3"></a>
## Nhóm 3 · Nghỉ phép, ca, chấm công

```mermaid
erDiagram
    LEAVE_TYPES ||--o{ LEAVE_BALANCES : "so du"
    LEAVE_TYPES ||--o{ LEAVE_REQUESTS : "loai"
    LEAVE_REQUESTS ||--o{ APPROVAL_STEPS : "duyet"
    SHIFT_SWAP_REQUESTS ||--o{ APPROVAL_STEPS : "duyet"
    SHIFT_TEMPLATES ||--o{ SHIFT_ASSIGNMENTS : "mau"
    SHIFT_ASSIGNMENTS ||--o{ SHIFT_SWAP_REQUESTS : "doi"
    OFFICE_LOCATIONS ||--o{ ATTENDANCE_RECORDS : "tai"
    LEAVE_REQUESTS {
        guid Id PK
        guid UserId FK
        guid LeaveTypeId FK
        date FromDate
        date ToDate
        string Status
    }
    APPROVAL_STEPS {
        guid Id PK
        string SubjectType
        guid SubjectId
        int Level
        guid ApproverId FK
        string Decision
    }
    SHIFT_ASSIGNMENTS {
        guid Id PK
        guid UserId FK
        guid ShiftTemplateId FK
        date Date
    }
    ATTENDANCE_RECORDS {
        guid Id PK
        guid UserId FK
        datetime CheckInUtc
        datetime CheckOutUtc
        string Method
    }
```

<a id="nhom-4"></a>
## Nhóm 4 · Nền tảng và tích hợp

```mermaid
erDiagram
    PLANS ||--o{ FEATURE_FLAGS : "bat"
    TENANTS ||--o{ AUDIT_LOGS : "ghi"
    TENANTS ||--o{ WEBHOOKS : "dang ky"
    TENANTS ||--o{ API_KEYS : "cap"
    TENANTS ||--o{ HOLIDAYS : "co"
    TENANTS ||--o{ ANNOUNCEMENTS : "dang"
    USERS ||--o{ BOOKING_PAGES : "tao"
    AUDIT_LOGS {
        guid Id PK
        guid TenantId FK
        guid ActorId FK
        string Action
        string Source
        string DataJson
    }
```

File gốc nhóm 2: [architecture/diagrams/erd.mmd](../architecture/diagrams/erd.mmd). Chi tiết cột: [data-dictionary.md](data-dictionary.md).

[↑ Về đầu trang](#top)
