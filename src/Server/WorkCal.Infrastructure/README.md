# WorkCal.Infrastructure

[← Server](../README.md)

## Mục đích
Tầng Infrastructure: EF Core, SQL Server, Redis, Hangfire, thông báo, file.

## Nội dung chính
| File / thư mục | Vai trò |
| --- | --- |
| [Caching/](Caching/README.md) | Cache Redis |
| [Files/](Files/README.md) | Xuất nhập Excel (ClosedXML), PDF (QuestPDF) |
| [Identity/](Identity/README.md) | ASP.NET Core Identity, phát JWT và refresh token (P0-11) |
| [Integrations/](Integrations/README.md) | Gửi webhook, đồng bộ lịch ngoài |
| [Jobs/](Jobs/README.md) | Job Hangfire: nhắc lịch, bảng công, dọn dữ liệu |
| [Notifications/](Notifications/README.md) | Gửi push (FCM) và email (MailKit) |
| [Persistence/](Persistence/README.md) | AppDbContext và mọi thứ liên quan CSDL |
| [Recurrence/](Recurrence/README.md) | Bung lịch lặp bằng Ical.Net + NodaTime |
| [Tenancy/](Tenancy/README.md) | Tra cứu tenant và membership cho TenantResolver |
| [WorkCal.Infrastructure.csproj](WorkCal.Infrastructure.csproj) | File project |

## Phụ thuộc
Được dùng bởi: `WorkCal.Api`, `WorkCal.Mcp`  ·  Phụ thuộc vào: `WorkCal.Application`

## Cách chạy / test
```powershell
dotnet build src/Server/WorkCal.Infrastructure
```

## Cập nhật lần cuối
2026-11-20 – tạo thư mục (P0-02).
