# WorkCal.Api

[← Server](../README.md)

## Mục đích
REST API, SignalR hub, middleware; điểm vào của backend.

## Nội dung chính
| File / thư mục | Vai trò |
| --- | --- |
| [Authorization/](Authorization/README.md) | Policy phân quyền theo vai trò |
| [Controllers/](Controllers/README.md) | Controller theo nhóm endpoint |
| [Hubs/](Hubs/README.md) | SignalR hub /hubs/calendar |
| [Middleware/](Middleware/README.md) | TenantResolver, xử lý lỗi (P0-10, P0-12) |
| [Program.cs](Program.cs) | Điểm vào ứng dụng, cấu hình service và pipeline |
| [Properties/](Properties/README.md) | launchSettings.json: cổng chạy khi dev |
| [WorkCal.Api.csproj](WorkCal.Api.csproj) | File project |
| [appsettings.json](appsettings.json) | Cấu hình chung (không chứa bí mật) |

## Phụ thuộc
Được dùng bởi: `WorkCal.Api.IntegrationTests`  ·  Phụ thuộc vào: `WorkCal.Infrastructure`, `WorkCal.Application`, `WorkCal.Contracts`

## Cách chạy / test
```powershell
dotnet run --project src/Server/WorkCal.Api      # https://localhost:5001
```

## Cập nhật lần cuối
2026-11-20 – tạo thư mục (P0-02).
