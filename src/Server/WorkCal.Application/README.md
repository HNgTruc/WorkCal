# WorkCal.Application

[← Server](../README.md)

## Mục đích
Tầng Application: use case dạng command/query theo feature, validator, interface.

## Nội dung chính
| File / thư mục | Vai trò |
| --- | --- |
| [Common/](Common/README.md) | ITenantContext, IPlanLimitService, pipeline behavior |
| [Features/](Features/README.md) | Mỗi feature một thư mục; bên trong chia Commands/, Queries/, Validators/ khi có code |
| [WorkCal.Application.csproj](WorkCal.Application.csproj) | File project |

## Phụ thuộc
Được dùng bởi: `WorkCal.Infrastructure`, `WorkCal.Api`, `WorkCal.Mcp`, `WorkCal.Application.Tests`  ·  Phụ thuộc vào: `WorkCal.Domain`, `WorkCal.Contracts`

## Cách chạy / test
```powershell
dotnet build src/Server/WorkCal.Application
```

## Cập nhật lần cuối
2026-11-20 – tạo thư mục (P0-02).
