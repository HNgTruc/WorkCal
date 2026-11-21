---
paths:
  - "src/Clients/**"
  - "tests/WorkCal.Client.Core.Tests/**"
  - "tests/WorkCal.Admin.Tests/**"
---

# Rule: Giao diện và MVVM

Thiết kế: [ADR 0001](../../docs/architecture/adr/0001-wpf-va-maui.md) (WPF + MAUI chung Client.Core), [ADR 0004](../../docs/architecture/adr/0004-blazor-cho-web-quan-tri.md) (Blazor + MudBlazor), [offline-sync.md](../../docs/architecture/offline-sync.md).

Thiết kế và rà soát giao diện: skill [`workcal-ui-ux`](../skills/workcal-ui-ux/SKILL.md).

## WPF và MAUI

- Logic nằm trong `WorkCal.Client.Core` (ViewModel, API client, SQLite, outbox, sync), viết một lần, test một lần trong `WorkCal.Client.Core.Tests`.
- ViewModel dùng CommunityToolkit.Mvvm (`[ObservableProperty]`, `[RelayCommand]`); không tham chiếu kiểu WPF hay MAUI (`System.Windows.*`, `Microsoft.Maui.*`) trong Client.Core.
- View mỏng: chỉ binding, style, animation. Code-behind chỉ chứa việc thuần giao diện (focus, cuộn, hiệu ứng); không gọi API, không đọc SQLite, không có logic nghiệp vụ.
- Dịch vụ phụ thuộc nền tảng (thông báo, lưu token, quét QR, GPS) khai báo interface trong Client.Core, hiện thực ở Desktop hoặc Mobile, đăng ký qua DI.
- Dữ liệu ghi đi qua SQLite cục bộ + outbox trước, sync sau; giao diện không chờ mạng cho thao tác sự kiện và task.
- Gọi API qua Refit interface trong `Client.Core/Api/`; không dùng `HttpClient` rời rạc trong ViewModel.
- Chuỗi hiển thị cho người dùng viết tiếng Việt có dấu.

## Blazor (WorkCal.Admin)

- Admin gọi WorkCal.Api qua HTTP như mọi client khác; không tham chiếu Infrastructure, không truy cập CSDL.
- Dùng component MudBlazor có sẵn cho bảng, form, dialog trước khi tự viết.
- Trang ở `Pages/Platform/` (Super Admin) và `Pages/Org/` (Owner, Admin, HR); kiểm tra quyền bằng policy, không chỉ ẩn menu.
- Logic gọi API và xử lý dữ liệu nằm trong `Services/`, component chỉ hiển thị và nhận sự kiện.

## Hỏi trước

Thêm màn hình không có trong task, thêm thư viện UI hoặc control (quy tắc 3).
