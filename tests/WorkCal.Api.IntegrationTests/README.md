# WorkCal.Api.IntegrationTests

[← tests](../README.md)

## Mục đích
Integration test API với SQL Server thật (Testcontainers).

## Nội dung chính
| File / thư mục | Vai trò |
| --- | --- |
| [TenantIsolation/](TenantIsolation/README.md) | Test đọc/ghi chéo tenant phải bị chặn; endpoint mới phải có test ở đây |
| [WorkCal.Api.IntegrationTests.csproj](WorkCal.Api.IntegrationTests.csproj) | File project |

## Phụ thuộc
Được dùng bởi: không có  ·  Phụ thuộc vào: `WorkCal.Api`

## Cách chạy / test
```powershell
dotnet test tests/WorkCal.Api.IntegrationTests
```

## Cập nhật lần cuối
2026-11-20 – tạo thư mục (P0-02).
