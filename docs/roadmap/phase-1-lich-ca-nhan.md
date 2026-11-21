<a id="top"></a>

# Giai đoạn 1 · Lịch cá nhân trên desktop · tuần 3–6

[← Giai đoạn 0](phase-0-nen-mong.md) · [Roadmap](README.md) · [Giai đoạn 2 →](phase-2-offline-mobile.md)

Làm trọn trải nghiệm lịch cá nhân online: API sự kiện, lịch lặp, task, lời nhắc và app WPF. Kết thúc bằng một bản demo desktop dùng được hằng ngày.

## Mục lục và tiến độ

**Tuần 3 · API lịch và sự kiện**
- [ ] [P1-01 · Entity lịch và sự kiện](#p1-01)
- [ ] [P1-02 · API lịch con](#p1-02)
- [ ] [P1-03 · API sự kiện không lặp](#p1-03)
- [ ] [P1-04 · Dịch vụ lịch lặp và múi giờ](#p1-04)

**Tuần 4 · Lịch lặp, task, lời nhắc**
- [ ] [P1-05 · Sửa và xóa sự kiện lặp theo phạm vi](#p1-05)
- [ ] [P1-06 · API task và checklist](#p1-06)
- [ ] [P1-07 · Lời nhắc qua email với Hangfire](#p1-07)

**Tuần 5 · App WPF**
- [ ] [P1-08 · Client.Core: API client và ViewModel](#p1-08)
- [ ] [P1-09 · Khung app WPF, đăng nhập, giao diện, đa ngôn ngữ](#p1-09)
- [ ] [P1-10 · Màn hình lịch với Syncfusion Scheduler](#p1-10)

**Tuần 6 · Hoàn thiện desktop**
- [ ] [P1-11 · Form sự kiện và danh sách task](#p1-11)
- [ ] [P1-12 · Thông báo toast và lưu token an toàn](#p1-12)
- [ ] [P1-13 · Tìm kiếm sự kiện và task](#p1-13)
- [ ] [P1-14 · Test và video demo](#p1-14)

**Khác:** [Mục tiêu và cổng kiểm tra](#muc-tieu) · [Rủi ro](#rui-ro)

<a id="muc-tieu"></a>
## Mục tiêu và cổng kiểm tra

- **Phạm vi:** F03, F04, F05, F06 (phần cá nhân), F07, F09 (email + desktop), F18 (tìm kiếm), F20.
- **Tổng ước tính:** khoảng 52 giờ.
- **Cổng kiểm tra:**
  - [ ] Tạo, sửa, xóa, kéo thả sự kiện trên WPF; dữ liệu lưu đúng ở server
  - [ ] Sự kiện lặp hàng tuần hiển thị đúng giờ qua mốc đổi giờ mùa hè (test với múi `Europe/Berlin`)
  - [ ] Sửa "chỉ lần này" và "từ lần này về sau" đều đúng
  - [ ] Lời nhắc tới đúng giờ qua email và toast
  - [ ] Có video demo 1–2 phút trong README

---

## Tuần 3 · API lịch và sự kiện

<a id="p1-01"></a>
### P1-01 · Entity lịch và sự kiện

- **Ước tính:** ~3h · **Chức năng:** F03, F06 · **Phụ thuộc:** P0-09
- **Việc cần làm:**
  1. Entity `Calendar` (Kind `Personal`/`Department`, Color, OwnerId), `Event` (StartUtc, EndUtc, TimeZoneId, IsAllDay, RRule, RecurrenceEndUtc), `EventException`, `Reminder` (UserId); bảng con đều có `TenantId`.
  2. Cấu hình EF, index `(TenantId, CalendarId, StartUtc)` INCLUDE `RecurrenceEndUtc`.
  3. Migration; tạo sẵn lịch "Cá nhân" khi đăng ký (sửa handler đăng ký của P0-11) và tạo bù cho tài khoản đã có (trong migration hoặc lúc khởi chạy dev).
  4. Bật ngưỡng coverage 70% cho Domain + Application trong CI ([test-strategy.md](../testing/test-strategy.md#coverage)).
- **Xong khi:** migration chạy được, đăng ký tài khoản mới có sẵn một lịch.
- **File code:**
  [`src/Server/WorkCal.Domain/Calendars/`](../../src/Server/WorkCal.Domain/Calendars/) ·
  [`src/Server/WorkCal.Domain/Events/`](../../src/Server/WorkCal.Domain/Events/) ·
  [`src/Server/WorkCal.Infrastructure/Persistence/Configurations/EventConfiguration.cs`](../../src/Server/WorkCal.Infrastructure/Persistence/Configurations/EventConfiguration.cs)
- **Tài liệu:** [database/data-dictionary.md](../database/data-dictionary.md)

<a id="p1-02"></a>
### P1-02 · API lịch con

- **Ước tính:** ~2.5h · **Chức năng:** F06 · **Phụ thuộc:** P1-01
- **Việc cần làm:** `GET/POST/PUT/DELETE /calendars`; validator; không cho xóa lịch cuối cùng.
- **Xong khi:** integration test CRUD xanh; tenant khác không thấy lịch.
- **File code:**
  [`src/Server/WorkCal.Application/Features/Calendars/`](../../src/Server/WorkCal.Application/Features/Calendars/) ·
  [`src/Server/WorkCal.Api/Controllers/V1/CalendarsController.cs`](../../src/Server/WorkCal.Api/Controllers/V1/CalendarsController.cs) ·
  [`src/Shared/WorkCal.Contracts/Calendars/`](../../src/Shared/WorkCal.Contracts/Calendars/)
- **Tài liệu:** [api/conventions.md](../api/conventions.md)

<a id="p1-03"></a>
### P1-03 · API sự kiện không lặp

- **Ước tính:** ~3h · **Chức năng:** F03 · **Phụ thuộc:** P1-02
- **Việc cần làm:** `POST /events`, `PUT /events/{id}`, `DELETE /events/{id}`, `GET /events?from=&to=&calendarIds=`; kiểm tra End > Start.
- **Xong khi:** lấy được sự kiện trong một tháng dưới 300 ms với 500 bản ghi.
- **File code:**
  [`src/Server/WorkCal.Application/Features/Events/`](../../src/Server/WorkCal.Application/Features/Events/) ·
  [`src/Server/WorkCal.Api/Controllers/V1/EventsController.cs`](../../src/Server/WorkCal.Api/Controllers/V1/EventsController.cs) ·
  [`src/Shared/WorkCal.Contracts/Events/`](../../src/Shared/WorkCal.Contracts/Events/)
- **Tài liệu:** [api/conventions.md](../api/conventions.md)

<a id="p1-04"></a>
### P1-04 · Dịch vụ lịch lặp và múi giờ

- **Ước tính:** ~5h · **Chức năng:** F05 · **Phụ thuộc:** P1-03
- **Việc cần làm:**
  1. `IRecurrenceService`: bung RRULE trong khoảng `from`–`to` theo giờ địa phương của `TimeZoneId`, rồi đổi sang UTC (Ical.Net + NodaTime).
  2. Áp `EventException` (bị hủy hoặc bị sửa).
  3. Gắn vào `GET /events`.
- **Xong khi:** bộ test gồm hằng ngày, hằng tuần nhiều thứ, hằng tháng ngày 31, `COUNT`, `UNTIL`, qua mốc đổi giờ đều đúng.
- **File code:**
  [`src/Server/WorkCal.Application/Common/IRecurrenceService.cs`](../../src/Server/WorkCal.Application/Common/IRecurrenceService.cs) ·
  [`src/Server/WorkCal.Infrastructure/Recurrence/RecurrenceService.cs`](../../src/Server/WorkCal.Infrastructure/Recurrence/RecurrenceService.cs) ·
  [`tests/WorkCal.Application.Tests/Recurrence/`](../../tests/WorkCal.Application.Tests/Recurrence/)
- **Tài liệu:** [architecture/recurrence-timezone.md](../architecture/recurrence-timezone.md)

---

## Tuần 4 · Lịch lặp, task, lời nhắc

<a id="p1-05"></a>
### P1-05 · Sửa và xóa sự kiện lặp theo phạm vi

- **Ước tính:** ~4h · **Chức năng:** F05 · **Phụ thuộc:** P1-04
- **Việc cần làm:** tham số `scope=this|following|all`; "this" tạo `EventException`; "following" cắt chuỗi bằng `UNTIL` và tạo chuỗi mới.
- **Xong khi:** test đủ 3 phạm vi cho cả sửa và xóa.
- **File code:**
  [`src/Server/WorkCal.Application/Features/Events/Commands/UpdateEvent/`](../../src/Server/WorkCal.Application/Features/Events/Commands/UpdateEvent/) ·
  [`src/Server/WorkCal.Application/Features/Events/Commands/DeleteEvent/`](../../src/Server/WorkCal.Application/Features/Events/Commands/DeleteEvent/)
- **Tài liệu:** [architecture/recurrence-timezone.md](../architecture/recurrence-timezone.md)

<a id="p1-06"></a>
### P1-06 · API task và checklist

- **Ước tính:** ~3h · **Chức năng:** F07 · **Phụ thuộc:** P1-02
- **Việc cần làm:** entity `WorkTask` (DueUtc, Status, Priority, ChecklistJson); CRUD + `PATCH /tasks/{id}/status`; task có hạn trả kèm trong `GET /events`.
- **Xong khi:** task hiện trên lịch theo ngày hạn.
- **File code:**
  [`src/Server/WorkCal.Domain/Tasks/`](../../src/Server/WorkCal.Domain/Tasks/) ·
  [`src/Server/WorkCal.Application/Features/Tasks/`](../../src/Server/WorkCal.Application/Features/Tasks/) ·
  [`src/Server/WorkCal.Api/Controllers/V1/TasksController.cs`](../../src/Server/WorkCal.Api/Controllers/V1/TasksController.cs)
- **Tài liệu:** [requirements/srs.md](../requirements/srs.md)

<a id="p1-07"></a>
### P1-07 · Lời nhắc qua email với Hangfire

- **Ước tính:** ~4h · **Chức năng:** F09 · **Phụ thuộc:** P1-04
- **Việc cần làm:**
  1. Cài Hangfire (storage SQL Server), dashboard chỉ bật ở dev.
  2. Khi tạo/sửa sự kiện: tính `NextFireUtc`, đặt job; job chạy xong thì đặt lần kế tiếp cho sự kiện lặp.
  3. Thêm `SmtpEmailSender` (MailKit) cho `IEmailSender` có từ P0-11, mẫu email tiếng Việt; dev vẫn dùng được `LogEmailSender`.
  4. Job kế thừa `TenantJobBase`, chạy lần lượt từng tenant ([multi-tenant.md](../architecture/multi-tenant.md#job-nen)).
- **Xong khi:** sự kiện có nhắc trước 10 phút gửi email đúng giờ (thử bằng Papercut/smtp4dev).
- **File code:**
  [`src/Server/WorkCal.Infrastructure/Jobs/ReminderJob.cs`](../../src/Server/WorkCal.Infrastructure/Jobs/ReminderJob.cs) ·
  [`src/Server/WorkCal.Infrastructure/Notifications/Email/`](../../src/Server/WorkCal.Infrastructure/Notifications/Email/) ·
  [`docker-compose.yml`](../../docker-compose.yml)
- **Tài liệu:** [architecture/overview.md](../architecture/overview.md)

---

## Tuần 5 · App WPF

<a id="p1-08"></a>
### P1-08 · Client.Core: API client và ViewModel

- **Ước tính:** ~4h · **Chức năng:** – · **Phụ thuộc:** P1-03
- **Việc cần làm:** Refit interface cho Auth, Calendars, Events, Tasks; sau đăng nhập gọi `switch-tenant` để lấy token có `tid` (một tenant thì tự chọn, nhiều tenant thì cho người dùng chọn); handler gắn token và tự refresh; ViewModel `CalendarViewModel`, `EventEditorViewModel`, `TaskListViewModel` (CommunityToolkit.Mvvm); interface `ITokenStore`, `INotificationService`.
- **Xong khi:** unit test ViewModel với API giả lập.
- **File code:**
  [`src/Clients/WorkCal.Client.Core/Api/`](../../src/Clients/WorkCal.Client.Core/Api/) ·
  [`src/Clients/WorkCal.Client.Core/ViewModels/`](../../src/Clients/WorkCal.Client.Core/ViewModels/) ·
  [`src/Clients/WorkCal.Client.Core/Services/`](../../src/Clients/WorkCal.Client.Core/Services/) ·
  [`tests/WorkCal.Client.Core.Tests/`](../../tests/WorkCal.Client.Core.Tests/)
- **Tài liệu:** [.claude/rules/ui-mvvm.md](../../.claude/rules/ui-mvvm.md)

<a id="p1-09"></a>
### P1-09 · Khung app WPF, đăng nhập, giao diện, đa ngôn ngữ

- **Ước tính:** ~4h · **Chức năng:** F20 · **Phụ thuộc:** P1-08
- **Việc cần làm:** DI với Generic Host; màn hình đăng nhập/đăng ký; layout sidebar (danh sách lịch con) + vùng lịch; theme sáng/tối; chuỗi giao diện trong `.resx` vi/en.
- **Xong khi:** đăng nhập được, đổi theme và ngôn ngữ không cần khởi động lại.
- **File code:**
  [`src/Clients/WorkCal.Desktop/App.xaml.cs`](../../src/Clients/WorkCal.Desktop/App.xaml.cs) ·
  [`src/Clients/WorkCal.Desktop/Views/`](../../src/Clients/WorkCal.Desktop/Views/) ·
  [`src/Clients/WorkCal.Desktop/Resources/`](../../src/Clients/WorkCal.Desktop/Resources/)
- **Tài liệu:** [user-manual/personal.md](../user-manual/personal.md)

<a id="p1-10"></a>
### P1-10 · Màn hình lịch với Syncfusion Scheduler

- **Ước tính:** ~5h · **Chức năng:** F04 · **Phụ thuộc:** P1-09
- **Việc cần làm:** đăng ký giấy phép Community; xem ngày/tuần/tháng/agenda; kéo thả và kéo giãn để đổi giờ (gọi API, lỗi thì hoàn tác); màu theo lịch con; bật/tắt lịch con.
- **Xong khi:** kéo thả một sự kiện lặp hỏi phạm vi sửa rồi lưu đúng.
- **File code:**
  [`src/Clients/WorkCal.Desktop/Views/CalendarView.xaml`](../../src/Clients/WorkCal.Desktop/Views/CalendarView.xaml) ·
  [`src/Clients/WorkCal.Desktop/Controls/`](../../src/Clients/WorkCal.Desktop/Controls/)
- **Tài liệu:** [architecture/overview.md](../architecture/overview.md)

---

## Tuần 6 · Hoàn thiện desktop

<a id="p1-11"></a>
### P1-11 · Form sự kiện và danh sách task

- **Ước tính:** ~4h · **Chức năng:** F03, F05, F07 · **Phụ thuộc:** P1-10
- **Việc cần làm:** form tạo/sửa sự kiện (cả ngày, lặp, màu, nhắc, địa điểm); hộp chọn phạm vi khi sửa sự kiện lặp; panel task có lọc theo trạng thái.
- **Xong khi:** mọi trường trong form lưu và hiển thị lại đúng.
- **File code:**
  [`src/Clients/WorkCal.Desktop/Views/EventEditorView.xaml`](../../src/Clients/WorkCal.Desktop/Views/EventEditorView.xaml) ·
  [`src/Clients/WorkCal.Desktop/Views/TaskListView.xaml`](../../src/Clients/WorkCal.Desktop/Views/TaskListView.xaml)
- **Tài liệu:** [user-manual/personal.md](../user-manual/personal.md)

<a id="p1-12"></a>
### P1-12 · Thông báo toast và lưu token an toàn

- **Ước tính:** ~3h · **Chức năng:** F09 · **Phụ thuộc:** P1-08
- **Việc cần làm:** `DpapiTokenStore` dùng `ProtectedData`; toast Windows cho lời nhắc của 24 giờ tới, đặt lại khi dữ liệu đổi.
- **Xong khi:** đóng app mở lại vẫn đăng nhập; toast hiện đúng giờ.
- **File code:**
  [`src/Clients/WorkCal.Desktop/Services/DpapiTokenStore.cs`](../../src/Clients/WorkCal.Desktop/Services/DpapiTokenStore.cs) ·
  [`src/Clients/WorkCal.Desktop/Services/ToastNotificationService.cs`](../../src/Clients/WorkCal.Desktop/Services/ToastNotificationService.cs)
- **Tài liệu:** [security/threat-model.md](../security/threat-model.md)

<a id="p1-13"></a>
### P1-13 · Tìm kiếm sự kiện và task

- **Ước tính:** ~2.5h · **Chức năng:** F18 · **Phụ thuộc:** P1-06
- **Việc cần làm:** `GET /search?q=` tìm theo tiêu đề, mô tả, địa điểm; ô tìm kiếm trên WPF, bấm kết quả nhảy tới ngày đó.
- **Xong khi:** tìm có dấu và không dấu đều ra kết quả.
- **File code:**
  [`src/Server/WorkCal.Application/Features/Search/`](../../src/Server/WorkCal.Application/Features/Search/) ·
  [`src/Clients/WorkCal.Desktop/Views/SearchView.xaml`](../../src/Clients/WorkCal.Desktop/Views/SearchView.xaml)
- **Tài liệu:** [api/conventions.md](../api/conventions.md)

<a id="p1-14"></a>
### P1-14 · Test và video demo

- **Ước tính:** ~5h · **Chức năng:** – · **Phụ thuộc:** P1-01 → P1-13
- **Việc cần làm:** bổ sung test cho phần còn thiếu, kiểm tra coverage Domain + Application vẫn ≥ 70%; sửa lỗi phát hiện; quay video demo, thêm ảnh chụp vào README; viết `user-manual/personal.md`.
- **Xong khi:** đủ 5 ý ở cổng kiểm tra.
- **File code:**
  [`tests/`](../../tests/) ·
  [`README.md`](../../README.md)
- **Tài liệu:** [user-manual/personal.md](../user-manual/personal.md) · [progress-log.md](progress-log.md)

---

<a id="rui-ro"></a>
## Rủi ro

| Rủi ro | Cách xử lý |
| --- | --- |
| Lịch lặp và múi giờ tốn hơn dự tính | Viết test trước (P1-04), chưa hỗ trợ RRULE quá hiếm như `BYSETPOS` |
| Syncfusion khó tùy biến | Dùng mặc định trước, chỉ chỉnh giao diện sau khi chức năng chạy |
| Giấy phép Community không còn phù hợp | Tách UI lịch sau interface để có thể thay control khác |

[↑ Về đầu trang](#top) · [← Roadmap](README.md)
