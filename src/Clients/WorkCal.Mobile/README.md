# WorkCal.Mobile

[← Clients](../README.md)

## Mục đích
App .NET MAUI cho Android và iOS.

## Nội dung chính
| File / thư mục | Vai trò |
| --- | --- |
| [App.cs](App.cs) | Lớp Application, tạo cửa sổ đầu tiên |
| [MauiProgram.cs](MauiProgram.cs) | Tạo MauiApp, đăng ký service |
| [Platforms/](Platforms/README.md) | Code riêng từng nền tảng |
| [Services/](Services/README.md) | Dịch vụ riêng mobile: push, quét QR, GPS |
| [Views/](Views/README.md) | Trang MAUI |
| [WorkCal.Mobile.csproj](WorkCal.Mobile.csproj) | File project |

## Phụ thuộc
Được dùng bởi: không có  ·  Phụ thuộc vào: `WorkCal.Client.Core`

## Cách chạy / test
```powershell
dotnet build src/Clients/WorkCal.Mobile -t:Run -f net10.0-android   # cần máy ảo hoặc điện thoại Android
```

## Cập nhật lần cuối
2026-11-20 – tạo thư mục (P0-02).
