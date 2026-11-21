# CLAUDE.md · src/Clients

Bổ sung cho [`CLAUDE.md` gốc](../../CLAUDE.md) khi làm việc với ứng dụng client. Quy tắc làm việc trong [`working-agreement.md`](../../.claude/rules/working-agreement.md) vẫn ưu tiên cao nhất. Trước khi làm, mở [roadmap](../../docs/roadmap/README.md) để biết task đang làm và đọc mục **Việc cần làm**, **Xong khi** của task.

## Các project

| Project | Vai trò | Ghi chú |
| --- | --- | --- |
| [WorkCal.Client.Core](WorkCal.Client.Core/README.md) | ViewModel, API client (Refit), SQLite cục bộ, outbox, sync | Dùng chung cho Desktop và Mobile; không tham chiếu WPF hay MAUI |
| [WorkCal.Desktop](WorkCal.Desktop/README.md) | App WPF cho Windows | Chỉ View và dịch vụ riêng Windows (toast) |
| [WorkCal.Mobile](WorkCal.Mobile/README.md) | App .NET MAUI cho Android, iOS | Android build trên Windows; iOS chỉ build trên macOS |
| [WorkCal.Admin](WorkCal.Admin/README.md) | Web quản trị Blazor (Interactive Server) + MudBlazor | Gọi API qua HTTP; khu `/platform` và `/org` |

Rule chính: [ui-mvvm](../../.claude/rules/ui-mvvm.md), [offline-sync](../../.claude/rules/offline-sync.md), [api-conventions](../../.claude/rules/api-conventions.md), [testing](../../.claude/rules/testing.md).

Giao diện: skill [`workcal-ui-ux`](../../.claude/skills/workcal-ui-ux/SKILL.md). Kết thúc task: skill [`finish-task`](../../.claude/skills/finish-task/SKILL.md).

## Điều hay quên

- Logic viết trong Client.Core và test trong `WorkCal.Client.Core.Tests`; View chỉ binding.
- Ghi dữ liệu qua SQLite + outbox trước, sync sau ([offline-sync.md](../../docs/architecture/offline-sync.md)). Phạm vi đồng bộ và xung đột theo [ADR 0005](../../docs/architecture/adr/0005-pham-vi-dong-bo.md).
- Sự kiện cả ngày gửi `startDate`/`endDate` dạng `YYYY-MM-DD`, `endDate` không tính.
- Thông báo cục bộ mobile giữ tối đa 64 cái gần nhất (giới hạn iOS).
- Syncfusion cần license key trong User Secrets (Community), không ghi vào code.
- Android emulator gọi API máy host qua `10.0.2.2`; trên Windows dùng `127.0.0.1` thay `localhost`.
- Thêm màn hình, thư viện UI hoặc control ngoài task: hỏi chủ dự án trước.

## Lệnh

```powershell
dotnet run --project src/Clients/WorkCal.Desktop
dotnet run --project src/Clients/WorkCal.Admin        # https://localhost:5003
dotnet build src/Clients/WorkCal.Mobile -f net10.0-android
dotnet test tests/WorkCal.Client.Core.Tests
```
