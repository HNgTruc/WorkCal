<a id="top"></a>

# Giai đoạn 5 · Doanh nghiệp mở rộng (v1.1) · tuần 19–24

[← Giai đoạn 4](phase-4-admin-v1.md) · [Roadmap](README.md)

Thêm các tính năng quản lý giờ làm cho doanh nghiệp (ca làm, chấm công, báo cáo), tích hợp hệ thống ngoài và MCP server của WorkCal. Kết thúc bằng bản v1.1.

## Mục lục và tiến độ

**Tuần 19 · Ca làm việc**
- [ ] [P5-01 · Mẫu ca và bảng xếp ca](#p5-01)
- [ ] [P5-02 · Đổi ca và duyệt](#p5-02)

**Tuần 20 · Chấm công**
- [ ] [P5-03 · Check-in bằng QR và GPS](#p5-03)
- [ ] [P5-04 · Bảng công tháng](#p5-04)

**Tuần 21 · Báo cáo và vận hành công ty**
- [ ] [P5-05 · Báo cáo và xuất file](#p5-05)
- [ ] [P5-06 · Nhập nhân viên từ Excel](#p5-06)
- [ ] [P5-07 · Bảng tin nội bộ](#p5-07)

**Tuần 22 · Tích hợp**
- [ ] [P5-08 · Trang đặt hẹn công khai](#p5-08)
- [ ] [P5-09 · Webhook và API key](#p5-09)
- [ ] [P5-10 · Đăng nhập một lần (SSO)](#p5-10)

**Tuần 23 · WorkCal.Mcp**
- [ ] [P5-11 · Khung WorkCal.Mcp và tool lịch](#p5-11)
- [ ] [P5-12 · Tool task, nghỉ phép, ca và bảo vệ](#p5-12)

**Tuần 24 · Phát hành v1.1**
- [ ] [P5-13 · Hoàn thiện và phát hành v1.1](#p5-13)

**Khác:** [Mục tiêu và cổng kiểm tra](#muc-tieu) · [Rủi ro](#rui-ro)

<a id="muc-tieu"></a>
## Mục tiêu và cổng kiểm tra

- **Phạm vi:** F21, F22, F25, F26, F29, F30, F32, F33, F34, F36, WorkCal.Mcp (tài liệu thiết kế mục 13.4). Các mục còn lại (F19, F27 mở rộng, F31, F35) nằm trong [backlog](backlog.md).
- **Tổng ước tính:** khoảng 75 giờ.
- **Cổng kiểm tra:**
  - [ ] HR xếp ca cả tháng cho một phòng ban, nhân viên chấm công bằng QR, bảng công tháng khớp với ca đã xếp
  - [ ] Xuất được báo cáo nghỉ phép và bảng công ra Excel và PDF
  - [ ] Nối Claude với WorkCal.Mcp, hỏi giờ rảnh chung và tạo được cuộc họp; test chứng minh tool không trả dữ liệu tenant khác
  - [ ] GitHub Release `v1.1.0` kèm CHANGELOG

---

## Tuần 19 · Ca làm việc

<a id="p5-01"></a>
### P5-01 · Mẫu ca và bảng xếp ca

- **Ước tính:** ~6h · **Chức năng:** F21 · **Phụ thuộc:** P3-04
- **Việc cần làm:** entity `ShiftTemplate`, `ShiftAssignment`; API `/shift-templates`, `/shifts`; trang xếp ca kéo thả theo tuần trong `/org/shifts` (Syncfusion Scheduler dạng timeline); ca hiện trên lịch nhân viên.
- **Xong khi:** xếp ca một tuần cho 10 người trong vài phút, không cho xếp trùng ca.
- **File code:**
  [`src/Server/WorkCal.Domain/Shifts/`](../../src/Server/WorkCal.Domain/Shifts/) ·
  [`src/Server/WorkCal.Application/Features/Shifts/`](../../src/Server/WorkCal.Application/Features/Shifts/) ·
  [`src/Clients/WorkCal.Admin/Pages/Org/Shifts/`](../../src/Clients/WorkCal.Admin/Pages/Org/Shifts/)
- **Tài liệu:** [user-manual/org-admin.md](../user-manual/org-admin.md)

<a id="p5-02"></a>
### P5-02 · Đổi ca và duyệt

- **Ước tính:** ~4h · **Chức năng:** F22 · **Phụ thuộc:** P5-01, P3-12
- **Việc cần làm:** nhân viên đăng ký ca trống, xin đổi ca với đồng nghiệp (đồng nghiệp đồng ý → Manager duyệt) qua `ApprovalStep`; màn hình trên mobile.
- **Xong khi:** đổi ca xong, lịch của cả hai người cập nhật và có thông báo.
- **File code:**
  [`src/Server/WorkCal.Application/Features/Shifts/Commands/SwapRequest/`](../../src/Server/WorkCal.Application/Features/Shifts/Commands/SwapRequest/) ·
  [`src/Clients/WorkCal.Mobile/Views/Shifts/`](../../src/Clients/WorkCal.Mobile/Views/Shifts/)
- **Tài liệu:** [user-manual/member.md](../user-manual/member.md)

---

## Tuần 20 · Chấm công

<a id="p5-03"></a>
### P5-03 · Check-in bằng QR và GPS

- **Ước tính:** ~6h · **Chức năng:** F25 · **Phụ thuộc:** P2-08
- **Việc cần làm:** entity `OfficeLocation` (tọa độ, bán kính, `QrSecret`), `AttendanceRecord`; mã QR đổi mỗi 30 giây (TOTP từ `QrSecret`) hiển thị trên màn hình văn phòng; mobile quét QR hoặc gửi GPS; server kiểm tra hợp lệ.
- **Xong khi:** chụp lại mã QR cũ hoặc đứng ngoài bán kính thì bị từ chối.
- **File code:**
  [`src/Server/WorkCal.Domain/Attendance/`](../../src/Server/WorkCal.Domain/Attendance/) ·
  [`src/Server/WorkCal.Application/Features/Attendance/`](../../src/Server/WorkCal.Application/Features/Attendance/) ·
  [`src/Clients/WorkCal.Mobile/Services/QrScannerService.cs`](../../src/Clients/WorkCal.Mobile/Services/QrScannerService.cs) ·
  [`src/Clients/WorkCal.Mobile/Services/LocationService.cs`](../../src/Clients/WorkCal.Mobile/Services/LocationService.cs)
- **Tài liệu:** [security/threat-model.md](../security/threat-model.md)

<a id="p5-04"></a>
### P5-04 · Bảng công tháng

- **Ước tính:** ~5h · **Chức năng:** F26 · **Phụ thuộc:** P5-01, P5-03
- **Việc cần làm:** job cuối ngày đối chiếu chấm công với ca: đi muộn, về sớm, vắng, tăng ca; HR sửa công có lý do (ghi audit); xuất Excel bằng ClosedXML.
- **Xong khi:** bảng công một tháng mẫu khớp tính tay.
- **File code:**
  [`src/Server/WorkCal.Infrastructure/Jobs/TimesheetJob.cs`](../../src/Server/WorkCal.Infrastructure/Jobs/TimesheetJob.cs) ·
  [`src/Server/WorkCal.Application/Features/Attendance/Queries/Timesheet/`](../../src/Server/WorkCal.Application/Features/Attendance/Queries/Timesheet/) ·
  [`src/Clients/WorkCal.Admin/Pages/Org/Attendance/`](../../src/Clients/WorkCal.Admin/Pages/Org/Attendance/)
- **Tài liệu:** [user-manual/org-admin.md](../user-manual/org-admin.md)

---

## Tuần 21 · Báo cáo và vận hành công ty

<a id="p5-05"></a>
### P5-05 · Báo cáo và xuất file

- **Ước tính:** ~5h · **Chức năng:** F33 · **Phụ thuộc:** P5-04
- **Việc cần làm:** `GET /reports/{type}` cho giờ họp theo phòng ban, tỉ lệ dùng phòng họp, nghỉ phép, đi muộn; trang Reports có biểu đồ; xuất Excel (ClosedXML) và PDF (QuestPDF).
- **Xong khi:** mỗi báo cáo xuất được cả hai định dạng.
- **File code:**
  [`src/Server/WorkCal.Application/Features/Reports/`](../../src/Server/WorkCal.Application/Features/Reports/) ·
  [`src/Server/WorkCal.Infrastructure/Files/`](../../src/Server/WorkCal.Infrastructure/Files/) ·
  [`src/Clients/WorkCal.Admin/Pages/Org/Reports/`](../../src/Clients/WorkCal.Admin/Pages/Org/Reports/)
- **Tài liệu:** [user-manual/org-admin.md](../user-manual/org-admin.md)

<a id="p5-06"></a>
### P5-06 · Nhập nhân viên từ Excel

- **Ước tính:** ~3h · **Chức năng:** F29 · **Phụ thuộc:** P3-02
- **Việc cần làm:** file mẫu tải về; `POST /org/members/import` kiểm tra từng dòng, xem trước kết quả, xác nhận mới gửi lời mời; tôn trọng giới hạn gói.
- **Xong khi:** file có dòng lỗi được báo đúng số dòng, dòng hợp lệ vẫn nhập được.
- **File code:**
  [`src/Server/WorkCal.Application/Features/Members/Commands/ImportMembers/`](../../src/Server/WorkCal.Application/Features/Members/Commands/ImportMembers/) ·
  [`src/Clients/WorkCal.Admin/Pages/Org/Members/Import.razor`](../../src/Clients/WorkCal.Admin/Pages/Org/Members/Import.razor)
- **Tài liệu:** [user-manual/org-admin.md](../user-manual/org-admin.md)

<a id="p5-07"></a>
### P5-07 · Bảng tin nội bộ

- **Ước tính:** ~3h · **Chức năng:** F30 · **Phụ thuộc:** P2-10
- **Việc cần làm:** entity `Announcement` (toàn công ty hoặc theo phòng ban); trang đăng tin trong `/org`; hiện trên desktop/mobile, gửi push.
- **Xong khi:** tin gửi cho một phòng ban chỉ người phòng đó nhận.
- **File code:**
  [`src/Server/WorkCal.Domain/Organization/Announcement.cs`](../../src/Server/WorkCal.Domain/Organization/Announcement.cs) ·
  [`src/Server/WorkCal.Application/Features/Announcements/`](../../src/Server/WorkCal.Application/Features/Announcements/)
- **Tài liệu:** [user-manual/member.md](../user-manual/member.md)

---

## Tuần 22 · Tích hợp

<a id="p5-08"></a>
### P5-08 · Trang đặt hẹn công khai

- **Ước tính:** ~5h · **Chức năng:** F32 · **Phụ thuộc:** P3-10
- **Việc cần làm:** entity `BookingPage` (Slug, thời lượng, khoảng đệm); `GET /public/booking/{slug}/slots`, `POST /public/booking/{slug}` không cần đăng nhập, có giới hạn tần suất và CAPTCHA; trang công khai trong WorkCal.Admin.
- **Xong khi:** khách đặt được lịch, hai khách không đặt trùng một khung giờ.
- **File code:**
  [`src/Server/WorkCal.Application/Features/Booking/`](../../src/Server/WorkCal.Application/Features/Booking/) ·
  [`src/Server/WorkCal.Api/Controllers/Public/BookingController.cs`](../../src/Server/WorkCal.Api/Controllers/Public/BookingController.cs) ·
  [`src/Clients/WorkCal.Admin/Pages/Public/Booking.razor`](../../src/Clients/WorkCal.Admin/Pages/Public/Booking.razor)
- **Tài liệu:** [security/threat-model.md](../security/threat-model.md)

<a id="p5-09"></a>
### P5-09 · Webhook và API key

- **Ước tính:** ~4h · **Chức năng:** F36 · **Phụ thuộc:** P4-08
- **Việc cần làm:** entity `Webhook` (Url, Events, Secret), `ApiKey` (KeyHash, Scopes); gửi webhook qua Hangfire, ký HMAC, thử lại khi lỗi; xác thực bằng API key cho hệ thống ngoài.
- **Xong khi:** webhook `leave.approved` tới endpoint thử với chữ ký đúng.
- **File code:**
  [`src/Server/WorkCal.Application/Features/Integrations/`](../../src/Server/WorkCal.Application/Features/Integrations/) ·
  [`src/Server/WorkCal.Infrastructure/Integrations/Webhooks/`](../../src/Server/WorkCal.Infrastructure/Integrations/Webhooks/)
- **Tài liệu:** [api/authentication.md](../api/authentication.md)

<a id="p5-10"></a>
### P5-10 · Đăng nhập một lần (SSO)

- **Ước tính:** ~4h · **Chức năng:** F34 · **Phụ thuộc:** P4-08
- **Việc cần làm:** OpenID Connect với Microsoft Entra ID và Google Workspace; Owner cấu hình trong `/org/settings`; người dùng có email cùng tên miền tự vào đúng tenant.
- **Xong khi:** đăng nhập bằng tài khoản Entra thử nghiệm vào thẳng công ty.
- **File code:**
  [`src/Server/WorkCal.Infrastructure/Identity/Sso/`](../../src/Server/WorkCal.Infrastructure/Identity/Sso/) ·
  [`src/Clients/WorkCal.Admin/Pages/Org/Settings/Sso.razor`](../../src/Clients/WorkCal.Admin/Pages/Org/Settings/Sso.razor)
- **Tài liệu:** [api/authentication.md](../api/authentication.md)

---

## Tuần 23 · WorkCal.Mcp

<a id="p5-11"></a>
### P5-11 · Khung WorkCal.Mcp và tool lịch

- **Ước tính:** ~6h · **Chức năng:** – · **Phụ thuộc:** P3-10
- **Việc cần làm:** project `WorkCal.Mcp` dùng C# MCP SDK, endpoint `/mcp` (Streamable HTTP); OAuth, token mang TenantId và UserId; `EventTools` và `AvailabilityTools` gọi qua tầng Application; bật/tắt theo gói trong `/org/settings`.
- **Xong khi:** từ Claude hỏi "tuần sau tôi rảnh lúc nào" và tạo được cuộc họp.
- **File code:**
  [`src/Server/WorkCal.Mcp/Program.cs`](../../src/Server/WorkCal.Mcp/Program.cs) ·
  [`src/Server/WorkCal.Mcp/Auth/`](../../src/Server/WorkCal.Mcp/Auth/) ·
  [`src/Server/WorkCal.Mcp/Tools/EventTools.cs`](../../src/Server/WorkCal.Mcp/Tools/EventTools.cs) ·
  [`src/Server/WorkCal.Mcp/Tools/AvailabilityTools.cs`](../../src/Server/WorkCal.Mcp/Tools/AvailabilityTools.cs) ·
  [`.claude/skills/add-mcp-tool/SKILL.md`](../../.claude/skills/add-mcp-tool/SKILL.md)
- **Tài liệu:** [mcp/workcal-mcp-tools.md](../mcp/workcal-mcp-tools.md)

<a id="p5-12"></a>
### P5-12 · Tool task, nghỉ phép, ca và bảo vệ

- **Ước tính:** ~5h · **Chức năng:** – · **Phụ thuộc:** P5-11
- **Việc cần làm:** `TaskTools`, `LeaveTools`, `ShiftTools`; `Guards/` giới hạn tần suất, kiểm tra gói, ghi audit với nguồn `mcp`; test cách ly tenant cho mọi tool; viết hướng dẫn nối Claude/Copilot.
- **Xong khi:** đủ ý thứ ba của cổng kiểm tra.
- **File code:**
  [`src/Server/WorkCal.Mcp/Tools/`](../../src/Server/WorkCal.Mcp/Tools/) ·
  [`src/Server/WorkCal.Mcp/Guards/`](../../src/Server/WorkCal.Mcp/Guards/) ·
  [`tests/WorkCal.Mcp.Tests/`](../../tests/WorkCal.Mcp.Tests/)
- **Tài liệu:** [mcp/workcal-mcp-tools.md](../mcp/workcal-mcp-tools.md) · [mcp/connect-ai-assistant.md](../mcp/connect-ai-assistant.md)

---

## Tuần 24 · Phát hành v1.1

<a id="p5-13"></a>
### P5-13 · Hoàn thiện và phát hành v1.1

- **Ước tính:** ~6h · **Chức năng:** – · **Phụ thuộc:** P5-01 → P5-12
- **Việc cần làm:** sửa lỗi tồn đọng; cập nhật dữ liệu demo với ca và chấm công; cập nhật tài liệu, README, video; tag `v1.1.0`, GitHub Release, CHANGELOG; rà backlog cho kế hoạch tiếp theo.
- **Xong khi:** đủ cả 4 ý của cổng kiểm tra.
- **File code:**
  [`CHANGELOG.md`](../../CHANGELOG.md) ·
  [`scripts/seed-demo-data.ps1`](../../scripts/seed-demo-data.ps1)
- **Tài liệu:** [backlog.md](backlog.md) · [progress-log.md](progress-log.md)

---

<a id="rui-ro"></a>
## Rủi ro

| Rủi ro | Cách xử lý |
| --- | --- |
| Giai đoạn nhiều tính năng nhất, dễ trễ | Ưu tiên theo thứ tự: ca → chấm công → báo cáo → MCP; phần trễ chuyển sang backlog |
| GPS giả lập vượt qua được | Ưu tiên QR động, GPS chỉ là phương án phụ, ghi nhận để HR kiểm tra |
| Đặc tả MCP thay đổi | Bám C# MCP SDK chính thức, cập nhật theo bản phát hành |

[↑ Về đầu trang](#top) · [← Roadmap](README.md)
