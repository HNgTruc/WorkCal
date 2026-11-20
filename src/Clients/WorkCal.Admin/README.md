# WorkCal.Admin

[← Clients](../README.md)

## Mục đích
Web quản trị Blazor (Interactive Server): khu /platform và /org.

## Nội dung chính
| File / thư mục | Vai trò |
| --- | --- |
| [Components/](Components/README.md) | App.razor, Routes.razor, layout, component dùng chung |
| [Pages/](Pages/README.md) | Trang của web quản trị |
| [Program.cs](Program.cs) | Điểm vào ứng dụng, cấu hình service và pipeline |
| [Properties/](Properties/README.md) | launchSettings.json: cổng chạy khi dev |
| [Services/](Services/README.md) | Client gọi API cho web quản trị |
| [WorkCal.Admin.csproj](WorkCal.Admin.csproj) | File project |
| [_Imports.razor](_Imports.razor) | Using dùng chung cho mọi component |
| [appsettings.json](appsettings.json) | Cấu hình chung (không chứa bí mật) |

## Phụ thuộc
Được dùng bởi: `WorkCal.Admin.Tests`  ·  Phụ thuộc vào: `WorkCal.Contracts`

## Cách chạy / test
```powershell
dotnet run --project src/Clients/WorkCal.Admin   # https://localhost:5003
```

## Cập nhật lần cuối
2026-11-20 – tạo thư mục (P0-02).
