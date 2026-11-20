# WorkCal.Client.Core

[← Clients](../README.md)

## Mục đích
ViewModel, API client, SQLite cục bộ, đồng bộ; dùng chung cho Desktop và Mobile.

## Nội dung chính
| File / thư mục | Vai trò |
| --- | --- |
| [Api/](Api/README.md) | Client gọi REST API |
| [Local/](Local/README.md) | SQLite + EF Core, bảng outbox |
| [Services/](Services/README.md) | Dịch vụ dùng chung: điều hướng, lưu token, cấu hình |
| [Sync/](Sync/README.md) | SyncEngine, client SignalR |
| [ViewModels/](ViewModels/README.md) | ViewModel (CommunityToolkit.Mvvm) |
| [WorkCal.Client.Core.csproj](WorkCal.Client.Core.csproj) | File project |

## Phụ thuộc
Được dùng bởi: `WorkCal.Desktop`, `WorkCal.Mobile`, `WorkCal.Client.Core.Tests`  ·  Phụ thuộc vào: `WorkCal.Contracts`

## Cách chạy / test
```powershell
dotnet build src/Clients/WorkCal.Client.Core
```

## Cập nhật lần cuối
2026-11-20 – tạo thư mục (P0-02).
