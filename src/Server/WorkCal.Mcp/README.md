# WorkCal.Mcp

[← Server](../README.md)

## Mục đích
MCP server của sản phẩm cho trợ lý AI (bản 1.1, giai đoạn 5).

## Nội dung chính
| File / thư mục | Vai trò |
| --- | --- |
| [Auth/](Auth/README.md) | OAuth, gắn TenantId và UserId vào phiên |
| [Guards/](Guards/README.md) | Giới hạn tần suất, kiểm tra gói, ghi audit |
| [Program.cs](Program.cs) | Điểm vào ứng dụng, cấu hình service và pipeline |
| [Properties/](Properties/README.md) | launchSettings.json: cổng chạy khi dev |
| [Tools/](Tools/README.md) | EventTools, AvailabilityTools, TaskTools, LeaveTools, ShiftTools |
| [WorkCal.Mcp.csproj](WorkCal.Mcp.csproj) | File project |
| [appsettings.json](appsettings.json) | Cấu hình chung (không chứa bí mật) |

## Phụ thuộc
Được dùng bởi: `WorkCal.Mcp.Tests`  ·  Phụ thuộc vào: `WorkCal.Application`, `WorkCal.Infrastructure`

## Cách chạy / test
```powershell
dotnet run --project src/Server/WorkCal.Mcp      # https://localhost:5005
```

## Cập nhật lần cuối
2026-11-20 – tạo thư mục (P0-02).
