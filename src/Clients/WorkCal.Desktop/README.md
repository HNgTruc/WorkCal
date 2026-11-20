# WorkCal.Desktop

[← Clients](../README.md)

## Mục đích
App WPF cho Windows.

## Nội dung chính
| File / thư mục | Vai trò |
| --- | --- |
| [App.xaml](App.xaml) | Khai báo ứng dụng WPF, mở MainWindow |
| [App.xaml.cs](App.xaml.cs) | Code-behind của App |
| [Controls/](Controls/README.md) | Control tự viết |
| [Resources/](Resources/README.md) | Style, theme, chuỗi giao diện (.resx) |
| [Services/](Services/README.md) | Dịch vụ riêng Windows: toast, lưu token bằng DPAPI |
| [Views/](Views/README.md) | Cửa sổ và view XAML |
| [WorkCal.Desktop.csproj](WorkCal.Desktop.csproj) | File project |

## Phụ thuộc
Được dùng bởi: không có  ·  Phụ thuộc vào: `WorkCal.Client.Core`

## Cách chạy / test
```powershell
dotnet run --project src/Clients/WorkCal.Desktop
```

## Cập nhật lần cuối
2026-11-20 – tạo thư mục (P0-02).
