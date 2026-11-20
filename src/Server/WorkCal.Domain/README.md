# WorkCal.Domain

[← Server](../README.md)

## Mục đích
Tầng Domain: entity, value object, quy tắc nghiệp vụ; không phụ thuộc framework nào.

## Nội dung chính
| File / thư mục | Vai trò |
| --- | --- |
| [Approvals/](Approvals/README.md) | Bước duyệt dùng chung cho phép, đổi ca, sự kiện cần duyệt |
| [Attendance/](Attendance/README.md) | Văn phòng chấm công, lần check-in/check-out |
| [Calendars/](Calendars/README.md) | Lịch con và chia sẻ lịch |
| [Common/](Common/README.md) | BaseEntity, ITenantEntity, ISoftDelete (P0-08) |
| [DomainEvents/](DomainEvents/README.md) | Lớp cơ sở và các domain event (P0-08) |
| [Events/](Events/README.md) | Sự kiện, lịch lặp, ngoại lệ, người tham gia |
| [Identity/](Identity/README.md) | User, RefreshToken (P0-09) |
| [Leaves/](Leaves/README.md) | Loại phép, số dư phép, đơn nghỉ |
| [Organization/](Organization/README.md) | Phòng ban, lời mời, ngày lễ, bảng tin |
| [Platform/](Platform/README.md) | Gói dịch vụ, feature flag, thông báo hệ thống |
| [Resources/](Resources/README.md) | Tài nguyên đặt được: phòng họp, xe, thiết bị |
| [Shifts/](Shifts/README.md) | Mẫu ca, xếp ca, đổi ca |
| [Tasks/](Tasks/README.md) | Công việc và checklist |
| [Tenancy/](Tenancy/README.md) | Tenant, Plan, Membership (P0-09) |
| [WorkCal.Domain.csproj](WorkCal.Domain.csproj) | File project |

## Phụ thuộc
Được dùng bởi: `WorkCal.Application`, `WorkCal.Domain.Tests`  ·  Phụ thuộc vào: không có

## Cách chạy / test
```powershell
dotnet build src/Server/WorkCal.Domain
```

## Cập nhật lần cuối
2026-11-20 – tạo thư mục (P0-02).
