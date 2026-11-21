<a id="top"></a>

# Giai đoạn 4 · Web quản trị và phát hành v1.0 · tuần 15–18

[← Giai đoạn 3](phase-3-doanh-nghiep.md) · [Roadmap](README.md) · [Giai đoạn 5 →](phase-5-doanh-nghiep-mo-rong.md)

Làm web quản trị WorkCal.Admin cho Super Admin và quản trị công ty, hoàn thiện audit, deploy và tài liệu, rồi phát hành v1.0 trên GitHub.

## Mục lục và tiến độ

**Tuần 15 · Khung web quản trị**
- [ ] [P4-01 · Khung WorkCal.Admin](#p4-01)
- [ ] [P4-02 · 2FA và bảo vệ khu /platform](#p4-02)
- [ ] [P4-03 · Audit log đầy đủ](#p4-03)

**Tuần 16 · Quản trị nền tảng**
- [ ] [P4-04 · /platform: tổng quan, tenant, gói](#p4-04)
- [ ] [P4-05 · /platform: người dùng, đăng nhập thay](#p4-05)
- [ ] [P4-06 · /platform: thông báo hệ thống, giám sát, audit](#p4-06)

**Tuần 17 · Quản trị công ty**
- [ ] [P4-07 · /org: thành viên, phòng ban, tài nguyên](#p4-07)
- [ ] [P4-08 · /org: nghỉ phép, lịch công ty, cài đặt, gói](#p4-08)
- [ ] [P4-09 · Xuất và nhập file .ics](#p4-09)

**Tuần 18 · Phát hành v1.0**
- [ ] [P4-10 · Test web quản trị](#p4-10)
- [ ] [P4-11 · Deploy](#p4-11)
- [ ] [P4-12 · Dữ liệu demo và tài liệu](#p4-12)
- [ ] [P4-13 · Phát hành v1.0](#p4-13)

**Khác:** [Mục tiêu và cổng kiểm tra](#muc-tieu) · [Rủi ro](#rui-ro)

<a id="muc-tieu"></a>
## Mục tiêu và cổng kiểm tra

- **Phạm vi:** F02 (2FA), F14, F15, F16, F18 (.ics), F28, tài liệu thiết kế mục 4.
- **Tổng ước tính:** khoảng 52 giờ.
- **Cổng kiểm tra:**
  - [ ] Super Admin khóa một tenant thì mọi thành viên tenant đó bị đăng xuất ở lần gọi API kế tiếp
  - [ ] Mọi hành động quản trị và đăng nhập thay đều có dòng audit
  - [ ] API và web quản trị chạy trên môi trường thật, có HTTPS
  - [ ] README có ảnh, video demo, hướng dẫn chạy; có GitHub Release `v1.0.0` kèm CHANGELOG

---

## Tuần 15 · Khung web quản trị

<a id="p4-01"></a>
### P4-01 · Khung WorkCal.Admin

- **Ước tính:** ~4h · **Chức năng:** F16 · **Phụ thuộc:** P3-03
- **Việc cần làm:** Blazor Web App (Interactive Server) + MudBlazor; đăng nhập qua API; layout hai khu `/platform` và `/org`, menu theo vai trò; API client dùng chung.
- **Xong khi:** Super Admin vào được `/platform`, Owner vào được `/org`, Member bị từ chối cả hai.
- **File code:**
  [`src/Clients/WorkCal.Admin/Program.cs`](../../src/Clients/WorkCal.Admin/Program.cs) ·
  [`src/Clients/WorkCal.Admin/Components/Layout/`](../../src/Clients/WorkCal.Admin/Components/Layout/) ·
  [`src/Clients/WorkCal.Admin/Services/`](../../src/Clients/WorkCal.Admin/Services/) ·
  [`.claude/skills/add-blazor-page/SKILL.md`](../../.claude/skills/add-blazor-page/SKILL.md)
- **Tài liệu:** [architecture/overview.md](../architecture/overview.md)

<a id="p4-02"></a>
### P4-02 · 2FA và bảo vệ khu /platform

- **Ước tính:** ~3h · **Chức năng:** F02 · **Phụ thuộc:** P4-01
- **Việc cần làm:** TOTP (bật, tắt, mã dự phòng); bắt buộc 2FA với `IsPlatformAdmin`; phiên hết hạn sau 30 phút không thao tác; giới hạn tần suất `/auth/*` bằng rate limiter có sẵn của ASP.NET Core (`Microsoft.AspNetCore.RateLimiting`), trả 429.
- **Xong khi:** Super Admin chưa bật 2FA bị buộc bật trước khi vào `/platform`.
- **File code:**
  [`src/Server/WorkCal.Application/Features/Auth/Commands/TwoFactor/`](../../src/Server/WorkCal.Application/Features/Auth/Commands/TwoFactor/) ·
  [`src/Clients/WorkCal.Admin/Pages/Account/`](../../src/Clients/WorkCal.Admin/Pages/Account/)
- **Tài liệu:** [api/authentication.md](../api/authentication.md) · [security/threat-model.md](../security/threat-model.md)

<a id="p4-03"></a>
### P4-03 · Audit log đầy đủ

- **Ước tính:** ~3h · **Chức năng:** F15 · **Phụ thuộc:** P3-03
- **Việc cần làm:** interceptor hoặc behavior ghi `AuditLog` (ActorId, Action, Target, DataJson, Source: api/admin/mcp) cho hành động quản trị; endpoint lọc theo người, thời gian.
- **Xong khi:** đổi vai trò một thành viên sinh đúng một dòng audit.
- **File code:**
  [`src/Server/WorkCal.Domain/Platform/AuditLog.cs`](../../src/Server/WorkCal.Domain/Platform/AuditLog.cs) ·
  [`src/Server/WorkCal.Application/Common/Behaviors/AuditBehavior.cs`](../../src/Server/WorkCal.Application/Common/Behaviors/AuditBehavior.cs)
- **Tài liệu:** [security/threat-model.md](../security/threat-model.md)

---

## Tuần 16 · Quản trị nền tảng

<a id="p4-04"></a>
### P4-04 · /platform: tổng quan, tenant, gói

- **Ước tính:** ~5h · **Chức năng:** F16, F17 · **Phụ thuộc:** P4-02
- **Việc cần làm:** API `/admin/stats`, `/admin/tenants`, `/admin/plans` (module Platform dùng `IgnoreQueryFilters()` có audit); trang Dashboard, Tenants (tìm, khóa/mở, đổi gói, gia hạn dùng thử), Plans (giới hạn, feature flag).
- **Xong khi:** đủ ý đầu của cổng kiểm tra.
- **File code:**
  [`src/Server/WorkCal.Application/Features/Platform/`](../../src/Server/WorkCal.Application/Features/Platform/) ·
  [`src/Server/WorkCal.Api/Controllers/Admin/`](../../src/Server/WorkCal.Api/Controllers/Admin/) ·
  [`src/Clients/WorkCal.Admin/Pages/Platform/Dashboard.razor`](../../src/Clients/WorkCal.Admin/Pages/Platform/Dashboard.razor) ·
  [`src/Clients/WorkCal.Admin/Pages/Platform/Tenants/`](../../src/Clients/WorkCal.Admin/Pages/Platform/Tenants/) ·
  [`src/Clients/WorkCal.Admin/Pages/Platform/Plans/`](../../src/Clients/WorkCal.Admin/Pages/Platform/Plans/)
- **Tài liệu:** [user-manual/platform-admin.md](../user-manual/platform-admin.md)

<a id="p4-05"></a>
### P4-05 · /platform: người dùng, đăng nhập thay

- **Ước tính:** ~4h · **Chức năng:** F16 · **Phụ thuộc:** P4-04
- **Việc cần làm:** tìm theo email, khóa tài khoản, reset 2FA; đăng nhập thay người dùng: token ngắn hạn có claim `impersonator`, banner đỏ trên giao diện, bắt buộc nhập lý do, ghi audit.
- **Xong khi:** mọi request trong phiên đăng nhập thay đều mang `impersonator` trong audit.
- **File code:**
  [`src/Server/WorkCal.Application/Features/Platform/Users/`](../../src/Server/WorkCal.Application/Features/Platform/Users/) ·
  [`src/Clients/WorkCal.Admin/Pages/Platform/Users/`](../../src/Clients/WorkCal.Admin/Pages/Platform/Users/)
- **Tài liệu:** [security/threat-model.md](../security/threat-model.md)

<a id="p4-06"></a>
### P4-06 · /platform: thông báo hệ thống, giám sát, audit

- **Ước tính:** ~3h · **Chức năng:** F16 · **Phụ thuộc:** P4-03
- **Việc cần làm:** CRUD `SystemAnnouncement`, hiện banner trên mọi client; trang Monitoring nhúng health check và link Hangfire dashboard (chỉ Super Admin); trang Audit log toàn hệ thống.
- **Xong khi:** tạo banner bảo trì thì desktop, mobile, admin đều thấy.
- **File code:**
  [`src/Clients/WorkCal.Admin/Pages/Platform/Announcements/`](../../src/Clients/WorkCal.Admin/Pages/Platform/Announcements/) ·
  [`src/Clients/WorkCal.Admin/Pages/Platform/Monitoring.razor`](../../src/Clients/WorkCal.Admin/Pages/Platform/Monitoring.razor) ·
  [`src/Clients/WorkCal.Admin/Pages/Platform/AuditLogs.razor`](../../src/Clients/WorkCal.Admin/Pages/Platform/AuditLogs.razor)
- **Tài liệu:** [user-manual/platform-admin.md](../user-manual/platform-admin.md)

---

## Tuần 17 · Quản trị công ty

<a id="p4-07"></a>
### P4-07 · /org: thành viên, phòng ban, tài nguyên

- **Ước tính:** ~5h · **Chức năng:** F13 · **Phụ thuộc:** P4-01
- **Việc cần làm:** trang Members (mời, đổi vai trò, khóa, chuyển dữ liệu khi nghỉ việc), Departments (cây, chọn Manager), Resources (phòng, xe, thiết bị).
- **Xong khi:** làm được mọi việc quản trị thành viên mà không cần app desktop.
- **File code:**
  [`src/Clients/WorkCal.Admin/Pages/Org/Members/`](../../src/Clients/WorkCal.Admin/Pages/Org/Members/) ·
  [`src/Clients/WorkCal.Admin/Pages/Org/Departments/`](../../src/Clients/WorkCal.Admin/Pages/Org/Departments/) ·
  [`src/Clients/WorkCal.Admin/Pages/Org/Resources/`](../../src/Clients/WorkCal.Admin/Pages/Org/Resources/)
- **Tài liệu:** [user-manual/org-admin.md](../user-manual/org-admin.md)

<a id="p4-08"></a>
### P4-08 · /org: nghỉ phép, lịch công ty, cài đặt, gói

- **Ước tính:** ~5h · **Chức năng:** F14, F23, F28 · **Phụ thuộc:** P4-07
- **Việc cần làm:** trang Leaves (loại phép, số ngày, số dư từng người), Holidays (ngày lễ, sự kiện toàn công ty, giờ làm việc), Settings (logo, múi giờ, ngôn ngữ), Usage (gói, mức dùng), Audit của công ty.
- **Xong khi:** thêm ngày lễ thì hiện trên lịch mọi thành viên.
- **File code:**
  [`src/Clients/WorkCal.Admin/Pages/Org/Leaves/`](../../src/Clients/WorkCal.Admin/Pages/Org/Leaves/) ·
  [`src/Clients/WorkCal.Admin/Pages/Org/Holidays/`](../../src/Clients/WorkCal.Admin/Pages/Org/Holidays/) ·
  [`src/Clients/WorkCal.Admin/Pages/Org/Settings/`](../../src/Clients/WorkCal.Admin/Pages/Org/Settings/) ·
  [`src/Server/WorkCal.Application/Features/Organization/`](../../src/Server/WorkCal.Application/Features/Organization/)
- **Tài liệu:** [user-manual/org-admin.md](../user-manual/org-admin.md)

<a id="p4-09"></a>
### P4-09 · Xuất và nhập file .ics

- **Ước tính:** ~3h · **Chức năng:** F18 · **Phụ thuộc:** P1-04
- **Việc cần làm:** `GET /calendars/{id}/export.ics`, `POST /calendars/{id}/import` bằng Ical.Net; nút xuất/nhập trên desktop.
- **Xong khi:** nhập file .ics xuất từ Google Calendar giữ đúng sự kiện lặp.
- **File code:**
  [`src/Server/WorkCal.Application/Features/Calendars/Commands/ImportIcs/`](../../src/Server/WorkCal.Application/Features/Calendars/Commands/ImportIcs/) ·
  [`src/Server/WorkCal.Application/Features/Calendars/Queries/ExportIcs/`](../../src/Server/WorkCal.Application/Features/Calendars/Queries/ExportIcs/)
- **Tài liệu:** [architecture/recurrence-timezone.md](../architecture/recurrence-timezone.md)

---

## Tuần 18 · Phát hành v1.0

<a id="p4-10"></a>
### P4-10 · Test web quản trị

- **Ước tính:** ~3h · **Chức năng:** – · **Phụ thuộc:** P4-04 → P4-08
- **Việc cần làm:** bUnit cho component; Playwright cho 3 luồng chính (khóa tenant, mời thành viên, cấu hình nghỉ phép).
- **Xong khi:** test chạy trên CI.
- **File code:**
  [`tests/WorkCal.Admin.Tests/`](../../tests/WorkCal.Admin.Tests/)
- **Tài liệu:** [testing/test-strategy.md](../testing/test-strategy.md)

<a id="p4-11"></a>
### P4-11 · Deploy

- **Ước tính:** ~5h · **Chức năng:** – · **Phụ thuộc:** P4-10
- **Việc cần làm:** chọn Azure App Service (gói dành cho sinh viên) hoặc VPS + Docker; SQL Server/Azure SQL, Redis; secret qua biến môi trường hoặc Key Vault; workflow `deploy.yml` chạy khi tạo tag.
- **Xong khi:** đủ ý thứ ba của cổng kiểm tra.
- **File code:**
  [`.github/workflows/deploy.yml`](../../.github/workflows/deploy.yml) ·
  [`src/Server/WorkCal.Api/appsettings.Production.json`](../../src/Server/WorkCal.Api/appsettings.Production.json)
- **Tài liệu:** [guides/deploy.md](../guides/deploy.md)

<a id="p4-12"></a>
### P4-12 · Dữ liệu demo và tài liệu

- **Ước tính:** ~4h · **Chức năng:** – · **Phụ thuộc:** P4-11
- **Việc cần làm:** `seed-demo-data.ps1` tạo 1 công ty, 3 phòng ban, 10 người, lịch họp, đơn nghỉ; hoàn thiện `user-manual/`, `getting-started.md`, `troubleshooting.md`; ảnh chụp và video demo trong README.
- **Xong khi:** người lạ đọc README chạy được bản demo trong 10 phút.
- **File code:**
  [`scripts/seed-demo-data.ps1`](../../scripts/seed-demo-data.ps1) ·
  [`README.md`](../../README.md)
- **Tài liệu:** [user-manual/](../user-manual/) · [guides/](../guides/)

<a id="p4-13"></a>
### P4-13 · Phát hành v1.0

- **Ước tính:** ~2h · **Chức năng:** – · **Phụ thuộc:** P4-12
- **Việc cần làm:** cập nhật CHANGELOG; tag `v1.0.0`; GitHub Release kèm bản cài WPF (MSIX hoặc zip) và APK Android; cập nhật roadmap và progress log.
- **Xong khi:** đủ ý cuối của cổng kiểm tra.
- **File code:**
  [`CHANGELOG.md`](../../CHANGELOG.md)
- **Tài liệu:** [README.md](README.md) · [progress-log.md](progress-log.md)

---

<a id="rui-ro"></a>
## Rủi ro

| Rủi ro | Cách xử lý |
| --- | --- |
| Web quản trị nhiều trang, dễ tràn thời gian | Dùng component bảng và form có sẵn của MudBlazor; skill `add-blazor-page` giữ khuôn mẫu |
| Chi phí hosting | Dùng ưu đãi sinh viên của Azure hoặc VPS nhỏ; tắt môi trường khi không demo |
| Deploy lần đầu gặp lỗi cấu hình | Thử deploy sớm từ tuần 15 với bản nhỏ |

[↑ Về đầu trang](#top) · [← Roadmap](README.md)
