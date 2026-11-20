<a id="top"></a>

# Từ điển dữ liệu

[← database](README.md) · [Mục lục tài liệu](../README.md)

Mô tả 33 bảng chính của WorkCal. Cấu hình EF cho từng bảng nằm ở [`Persistence/Configurations/`](../../src/Server/WorkCal.Infrastructure/Persistence/Configurations/), entity ở [`WorkCal.Domain/`](../../src/Server/WorkCal.Domain/).

## Mục lục

- [Quy ước chung](#quy-uoc)
- [Tài khoản và tenant](#tai-khoan) · Plans, Tenants, Users, Memberships, Departments, Invitations, RefreshTokens, Devices
- [Lịch, sự kiện, task](#lich) · Calendars, CalendarShares, Events, EventExceptions, EventAttendees, Tasks, Reminders, Resources
- [Doanh nghiệp](#doanh-nghiep) · Holidays, Announcements, LeaveTypes, LeaveBalances, LeaveRequests, ApprovalSteps
- [Ca và chấm công](#ca) · ShiftTemplates, ShiftAssignments, ShiftSwapRequests, OfficeLocations, AttendanceRecords
- [Nền tảng và tích hợp](#nen-tang) · FeatureFlags, SystemAnnouncements, AuditLogs, BookingPages, Webhooks, ApiKeys

<a id="quy-uoc"></a>
## Quy ước chung

| Quy ước | Chi tiết |
| --- | --- |
| Khóa chính | `Id uniqueidentifier`, GUID v7 sinh ở client hoặc server (`Guid.CreateVersion7()`) |
| Tenant | Cột `TenantId` (FK → Tenants) trên mọi bảng nghiệp vụ; ghi chú "(nền tảng)" là bảng không có TenantId |
| Đồng bộ | `Version rowversion`, `UpdatedAt datetime2`, `IsDeleted bit`, `DeletedAt datetime2 null` trên bảng client đồng bộ (đánh dấu **S**) |
| Thời gian | Lưu UTC, hậu tố `Utc`; ngày thuần dùng kiểu `date` |
| Enum | Lưu dạng chuỗi (`nvarchar(32)`) để dễ đọc và thêm giá trị |
| JSON | Cột hậu tố `Json`, kiểu `nvarchar(max)` |
| Index | Bắt đầu bằng `TenantId` |

<a id="tai-khoan"></a>
## Tài khoản và tenant

| Bảng | Cột chính | Ràng buộc, index |
| --- | --- | --- |
| **Plans** (nền tảng) | Name, MaxMembers, MaxResources, HistoryDays, FeaturesJson | Name duy nhất; seed Free/Pro/Business |
| **Tenants** | Name, Type (`Personal`/`Business`), PlanId, TimeZoneId, Locale, LogoUrl, WorkHoursJson, TrialEndsAt, IsLocked | – |
| **Users** (nền tảng) | Email, FullName, PasswordHash, TimeZoneId, Locale, IsPlatformAdmin, IsLocked, TwoFactorEnabled | Email duy nhất |
| **Memberships** | TenantId, UserId, DepartmentId, Role (`Owner`/`Admin`/`HR`/`Manager`/`Member`), JoinedAt | UNIQUE(TenantId, UserId) |
| **Departments** | TenantId, Name, ParentId, ManagerId | – |
| **Invitations** | TenantId, Email, Role, TokenHash, ExpiresAt, AcceptedAt | Hết hạn sau 7 ngày, dùng một lần |
| **RefreshTokens** (nền tảng) | UserId, TokenHash, FamilyId, ExpiresAt, RevokedAt, ReplacedById | Dùng lại token đã thay → thu hồi cả FamilyId |
| **Devices** (nền tảng) | UserId, Platform (`Android`/`iOS`/`Windows`), FcmToken, LastSeenAt | UNIQUE(FcmToken) |

<a id="lich"></a>
## Lịch, sự kiện, task

| Bảng | Cột chính | Ràng buộc, index |
| --- | --- | --- |
| **Calendars** S | TenantId, OwnerId, Name, Kind (`Personal`/`Department`/`Resource`), Color, DepartmentId | Không xóa được lịch cuối cùng của người dùng |
| **CalendarShares** S | CalendarId, UserId hoặc DepartmentId, Permission (`FreeBusy`/`Read`/`Write`/`Manage`) | Một trong UserId, DepartmentId phải có giá trị |
| **Events** S | TenantId, CalendarId, Title, Description, Location, StartUtc, EndUtc, TimeZoneId, IsAllDay, RRule, Color, ResourceId, OrganizerId | INDEX(TenantId, CalendarId, StartUtc); EndUtc > StartUtc |
| **EventExceptions** S | EventId, OriginalStartUtc, IsCancelled, OverrideJson | UNIQUE(EventId, OriginalStartUtc) |
| **EventAttendees** S | EventId, UserId hoặc Email (khách ngoài), Response (`Pending`/`Accepted`/`Declined`/`Tentative`) | UNIQUE(EventId, UserId) |
| **Tasks** S | TenantId, CalendarId, AssigneeId, CreatedById, Title, DueUtc, Status (`Todo`/`InProgress`/`Done`), Priority (`Low`/`Normal`/`High`), ChecklistJson | INDEX(TenantId, AssigneeId, DueUtc) |
| **Reminders** S | EventId hoặc TaskId, MinutesBefore, Channel (`Push`/`Email`/`Desktop`), NextFireUtc | INDEX(NextFireUtc) cho job |
| **Resources** | TenantId, Kind (`Room`/`Vehicle`/`Equipment`), Name, Capacity, Description | Chặn trùng giờ ở tầng Application |

<a id="doanh-nghiep"></a>
## Doanh nghiệp

| Bảng | Cột chính | Ràng buộc, index |
| --- | --- | --- |
| **Holidays** | TenantId, Date, Name, IsPaid | UNIQUE(TenantId, Date) |
| **Announcements** | TenantId, Title, Body, DepartmentId (null = cả công ty), AuthorId, PublishedAt | – |
| **LeaveTypes** | TenantId, Name, DaysPerYear, IsPaid, RequiresAttachment | – |
| **LeaveBalances** | TenantId, UserId, LeaveTypeId, Year, Entitled, Used | UNIQUE(TenantId, UserId, LeaveTypeId, Year) |
| **LeaveRequests** | TenantId, UserId, LeaveTypeId, FromDate, ToDate, HalfDay, Reason, Status (`Pending`/`Approved`/`Rejected`/`Cancelled`) | – |
| **ApprovalSteps** | TenantId, SubjectType (`Leave`/`ShiftSwap`/`Event`), SubjectId, Level, ApproverId, Decision, Comment, DecidedAt | INDEX(TenantId, ApproverId, Decision) cho hộp duyệt |

<a id="ca"></a>
## Ca và chấm công

| Bảng | Cột chính | Ràng buộc, index |
| --- | --- | --- |
| **ShiftTemplates** | TenantId, Name, StartTime, EndTime, BreakMinutes, Color | – |
| **ShiftAssignments** S | TenantId, UserId, ShiftTemplateId, Date, Status | UNIQUE(TenantId, UserId, Date, ShiftTemplateId) |
| **ShiftSwapRequests** | TenantId, FromAssignmentId, ToUserId, Status | – |
| **OfficeLocations** | TenantId, Name, Latitude, Longitude, RadiusMeters, QrSecret | QrSecret mã hóa khi lưu |
| **AttendanceRecords** | TenantId, UserId, OfficeLocationId, CheckInUtc, CheckOutUtc, Method (`QR`/`GPS`), IsAdjusted, AdjustReason | INDEX(TenantId, UserId, CheckInUtc) |

<a id="nen-tang"></a>
## Nền tảng và tích hợp

| Bảng | Cột chính | Ràng buộc, index |
| --- | --- | --- |
| **FeatureFlags** (nền tảng) | Key, PlanId hoặc TenantId, IsEnabled | – |
| **SystemAnnouncements** (nền tảng) | Message, Severity, StartsAt, EndsAt | – |
| **AuditLogs** | TenantId (null với hành động nền tảng), ActorId, ImpersonatorId, Action, TargetType, TargetId, Source (`api`/`admin`/`mcp`), DataJson, CreatedAt | INDEX(TenantId, CreatedAt); chỉ thêm, không sửa |
| **BookingPages** | TenantId, OwnerId, Slug, DurationMinutes, BufferMinutes, IsActive | UNIQUE(Slug) |
| **Webhooks** | TenantId, Url, EventsJson, Secret, IsActive | Secret mã hóa khi lưu |
| **ApiKeys** | TenantId, Name, KeyHash, Scopes, ExpiresAt, LastUsedAt | Chỉ lưu hash |

[↑ Về đầu trang](#top)
