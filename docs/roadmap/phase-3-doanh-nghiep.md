<a id="top"></a>

# Giai đoạn 3 · Doanh nghiệp, multi-tenant · tuần 11–14

[← Giai đoạn 2](phase-2-offline-mobile.md) · [Roadmap](README.md) · [Giai đoạn 4 →](phase-4-admin-v1.md)

Biến WorkCal từ app cá nhân thành công cụ cho công ty: tenant doanh nghiệp, vai trò, phòng ban, mời họp, xem lịch rảnh, đặt phòng và nghỉ phép có duyệt. Kết thúc khi bộ test cách ly tenant chứng minh không đọc chéo được.

## Mục lục và tiến độ

**Tuần 11 · Tenant, thành viên, vai trò**
- [ ] [P3-01 · Tạo công ty và đổi tenant](#p3-01)
- [ ] [P3-02 · Lời mời thành viên qua email](#p3-02)
- [ ] [P3-03 · Vai trò và policy phân quyền](#p3-03)
- [ ] [P3-04 · Phòng ban](#p3-04)

**Tuần 12 · Cách ly dữ liệu và chia sẻ lịch**
- [ ] [P3-05 · Row-Level Security trên SQL Server](#p3-05)
- [ ] [P3-06 · Bộ test cách ly tenant](#p3-06)
- [ ] [P3-07 · Chia sẻ lịch và quyền trên lịch](#p3-07)
- [ ] [P3-08 · Giới hạn theo gói](#p3-08)

**Tuần 13 · Cộng tác**
- [ ] [P3-09 · Mời họp và phản hồi](#p3-09)
- [ ] [P3-10 · Lịch rảnh/bận và gợi ý giờ họp](#p3-10)
- [ ] [P3-11 · Phòng họp và tài nguyên](#p3-11)

**Tuần 14 · Nghỉ phép và giao diện**
- [ ] [P3-12 · Nghỉ phép duyệt 2 cấp](#p3-12)
- [ ] [P3-13 · Giao diện doanh nghiệp trên desktop và mobile](#p3-13)

**Khác:** [Mục tiêu và cổng kiểm tra](#muc-tieu) · [Rủi ro](#rui-ro)

<a id="muc-tieu"></a>
## Mục tiêu và cổng kiểm tra

- **Phạm vi:** F06 (chia sẻ), F08, F10, F11, F12, F13, F17, F23, F24.
- **Tổng ước tính:** khoảng 52 giờ.
- **Cổng kiểm tra:**
  - [ ] Bộ test `TenantIsolation` gọi mọi endpoint bằng token tenant A với Id của tenant B và đều nhận 404 hoặc 403
  - [ ] Truy vấn SQL thô không đặt `SESSION_CONTEXT` không đọc được dòng nào (RLS hoạt động)
  - [ ] Một người thuộc 2 công ty đổi qua lại được và chỉ thấy dữ liệu công ty đang chọn
  - [ ] Luồng xin nghỉ: Member gửi → Manager duyệt trên mobile → HR duyệt → lịch tự chặn

---

## Tuần 11 · Tenant, thành viên, vai trò

<a id="p3-01"></a>
### P3-01 · Tạo công ty và đổi tenant

- **Ước tính:** ~3h · **Chức năng:** F13 · **Phụ thuộc:** P0-11
- **Việc cần làm:** `POST /tenants` tạo tenant Business, người tạo là Owner; `GET /me/tenants`; `POST /auth/switch-tenant` cấp token mới có `tid` khác.
- **Xong khi:** test đổi tenant, token cũ vẫn chỉ truy cập tenant cũ.
- **File code:**
  [`src/Server/WorkCal.Application/Features/Tenants/`](../../src/Server/WorkCal.Application/Features/Tenants/) ·
  [`src/Server/WorkCal.Application/Features/Auth/Commands/SwitchTenant/`](../../src/Server/WorkCal.Application/Features/Auth/Commands/SwitchTenant/) ·
  [`src/Server/WorkCal.Api/Controllers/V1/TenantsController.cs`](../../src/Server/WorkCal.Api/Controllers/V1/TenantsController.cs)
- **Tài liệu:** [architecture/multi-tenant.md](../architecture/multi-tenant.md) · [api/authentication.md](../api/authentication.md)

<a id="p3-02"></a>
### P3-02 · Lời mời thành viên qua email

- **Ước tính:** ~3h · **Chức năng:** F13 · **Phụ thuộc:** P3-01
- **Việc cần làm:** entity `Invitation` (Email, Role, TokenHash, ExpiresAt); `POST /org/invitations`, `POST /invitations/{token}/accept` (chưa có tài khoản thì đăng ký luôn); email mời.
- **Xong khi:** lời mời hết hạn sau 7 ngày, dùng lần hai bị từ chối.
- **File code:**
  [`src/Server/WorkCal.Domain/Tenancy/Invitation.cs`](../../src/Server/WorkCal.Domain/Tenancy/Invitation.cs) ·
  [`src/Server/WorkCal.Application/Features/Members/`](../../src/Server/WorkCal.Application/Features/Members/) ·
  [`src/Server/WorkCal.Api/Controllers/Org/MembersController.cs`](../../src/Server/WorkCal.Api/Controllers/Org/MembersController.cs)
- **Tài liệu:** [requirements/use-cases/](../requirements/use-cases/)

<a id="p3-03"></a>
### P3-03 · Vai trò và policy phân quyền

- **Ước tính:** ~4h · **Chức năng:** F13 · **Phụ thuộc:** P3-01
- **Việc cần làm:** enum Role (Owner, Admin, HR, Manager, Member); policy `RequireOrgAdmin`, `RequireHR`, `RequireManagerOfDepartment`; kiểm tra quyền trên từng lịch ở tầng Application.
- **Xong khi:** ma trận vai trò × endpoint có test cho mỗi ô quan trọng.
- **File code:**
  [`src/Server/WorkCal.Api/Authorization/`](../../src/Server/WorkCal.Api/Authorization/) ·
  [`src/Server/WorkCal.Application/Common/Authorization/`](../../src/Server/WorkCal.Application/Common/Authorization/)
- **Tài liệu:** [requirements/roles-permissions.md](../requirements/roles-permissions.md)

<a id="p3-04"></a>
### P3-04 · Phòng ban

- **Ước tính:** ~2.5h · **Chức năng:** F13 · **Phụ thuộc:** P3-03
- **Việc cần làm:** entity `Department` (ParentId, ManagerId); CRUD; gán thành viên vào phòng ban; tự tạo lịch phòng ban.
- **Xong khi:** cây phòng ban 3 cấp hiển thị đúng; Manager chỉ thấy lịch phòng mình.
- **File code:**
  [`src/Server/WorkCal.Domain/Tenancy/Department.cs`](../../src/Server/WorkCal.Domain/Tenancy/Department.cs) ·
  [`src/Server/WorkCal.Application/Features/Departments/`](../../src/Server/WorkCal.Application/Features/Departments/)
- **Tài liệu:** [database/data-dictionary.md](../database/data-dictionary.md)

---

## Tuần 12 · Cách ly dữ liệu và chia sẻ lịch

<a id="p3-05"></a>
### P3-05 · Row-Level Security trên SQL Server

- **Ước tính:** ~4h · **Chức năng:** – · **Phụ thuộc:** P0-10
- **Việc cần làm:** hàm predicate `fn_tenant_access`, security policy cho mọi bảng có `TenantId`; interceptor đặt `SESSION_CONTEXT('TenantId')` khi mở kết nối; tài khoản Platform có cờ bỏ qua có kiểm soát.
- **Xong khi:** chạy SQL thô không đặt context thì không ra dòng nào.
- **File code:**
  [`src/Server/WorkCal.Infrastructure/Persistence/Rls/`](../../src/Server/WorkCal.Infrastructure/Persistence/Rls/) ·
  [`src/Server/WorkCal.Infrastructure/Persistence/Interceptors/SessionContextInterceptor.cs`](../../src/Server/WorkCal.Infrastructure/Persistence/Interceptors/SessionContextInterceptor.cs) ·
  [`src/Server/WorkCal.Infrastructure/Persistence/Migrations/`](../../src/Server/WorkCal.Infrastructure/Persistence/Migrations/)
- **Tài liệu:** [security/tenant-isolation.md](../security/tenant-isolation.md)

<a id="p3-06"></a>
### P3-06 · Bộ test cách ly tenant

- **Ước tính:** ~4h · **Chức năng:** – · **Phụ thuộc:** P3-05
- **Việc cần làm:** tạo dữ liệu mẫu 2 tenant; test tự quét mọi route trong API, gọi bằng token tenant A với Id tenant B; route mới thêm mà chưa có dữ liệu mẫu thì test báo lỗi.
- **Xong khi:** đủ ý đầu tiên của cổng kiểm tra.
- **File code:**
  [`tests/WorkCal.Api.IntegrationTests/TenantIsolation/`](../../tests/WorkCal.Api.IntegrationTests/TenantIsolation/)
- **Tài liệu:** [security/tenant-isolation.md](../security/tenant-isolation.md) · [.claude/agents/security-auditor.md](../../.claude/agents/security-auditor.md)

<a id="p3-07"></a>
### P3-07 · Chia sẻ lịch và quyền trên lịch

- **Ước tính:** ~3h · **Chức năng:** F06 · **Phụ thuộc:** P3-03
- **Việc cần làm:** entity `CalendarShare` (người hoặc phòng ban, Permission: FreeBusy/Read/Write/Manage); `POST /calendars/{id}/shares`; `GET /events` trả theo quyền (FreeBusy chỉ thấy "Bận").
- **Xong khi:** test 4 mức quyền.
- **File code:**
  [`src/Server/WorkCal.Domain/Calendars/CalendarShare.cs`](../../src/Server/WorkCal.Domain/Calendars/CalendarShare.cs) ·
  [`src/Server/WorkCal.Application/Features/Calendars/Commands/ShareCalendar/`](../../src/Server/WorkCal.Application/Features/Calendars/Commands/ShareCalendar/)
- **Tài liệu:** [requirements/roles-permissions.md](../requirements/roles-permissions.md)

<a id="p3-08"></a>
### P3-08 · Giới hạn theo gói

- **Ước tính:** ~2h · **Chức năng:** F17 · **Phụ thuộc:** P3-02
- **Việc cần làm:** `IPlanLimitService` kiểm tra số thành viên, số phòng họp, tính năng theo gói; trả lỗi rõ ràng kèm gói cần nâng cấp.
- **Xong khi:** gói Free mời quá giới hạn thì bị chặn với thông báo dễ hiểu.
- **File code:**
  [`src/Server/WorkCal.Application/Common/IPlanLimitService.cs`](../../src/Server/WorkCal.Application/Common/IPlanLimitService.cs) ·
  [`src/Server/WorkCal.Infrastructure/Tenancy/PlanLimitService.cs`](../../src/Server/WorkCal.Infrastructure/Tenancy/PlanLimitService.cs)
- **Tài liệu:** [requirements/srs.md](../requirements/srs.md)

---

## Tuần 13 · Cộng tác

<a id="p3-09"></a>
### P3-09 · Mời họp và phản hồi

- **Ước tính:** ~3.5h · **Chức năng:** F10 · **Phụ thuộc:** P3-07
- **Việc cần làm:** entity `EventAttendee`; thêm người khi tạo sự kiện; `POST /events/{id}/rsvp`; email và push khi được mời, khi giờ họp đổi.
- **Xong khi:** người được mời thấy sự kiện trên lịch mình, phản hồi hiện cho người tổ chức.
- **File code:**
  [`src/Server/WorkCal.Domain/Events/EventAttendee.cs`](../../src/Server/WorkCal.Domain/Events/EventAttendee.cs) ·
  [`src/Server/WorkCal.Application/Features/Events/Commands/Rsvp/`](../../src/Server/WorkCal.Application/Features/Events/Commands/Rsvp/)
- **Tài liệu:** [requirements/use-cases/](../requirements/use-cases/)

<a id="p3-10"></a>
### P3-10 · Lịch rảnh/bận và gợi ý giờ họp

- **Ước tính:** ~4h · **Chức năng:** F11 · **Phụ thuộc:** P3-09
- **Việc cần làm:** `POST /availability/query` nhận danh sách người + khoảng thời gian, trả khoảng bận và khung rảnh chung trong giờ làm việc; cache Redis 5 phút, xóa cache khi lịch đổi.
- **Xong khi:** gợi ý đúng với 5 người có lịch lặp xen kẽ.
- **File code:**
  [`src/Server/WorkCal.Application/Features/Availability/`](../../src/Server/WorkCal.Application/Features/Availability/) ·
  [`src/Server/WorkCal.Infrastructure/Caching/`](../../src/Server/WorkCal.Infrastructure/Caching/)
- **Tài liệu:** [api/conventions.md](../api/conventions.md)

<a id="p3-11"></a>
### P3-11 · Phòng họp và tài nguyên

- **Ước tính:** ~3h · **Chức năng:** F12 · **Phụ thuộc:** P3-09
- **Việc cần làm:** entity `Resource` (Kind: Room/Vehicle/Equipment, Capacity); chọn phòng khi tạo họp; chặn trùng giờ ở tầng Application (có khóa để tránh đặt cùng lúc).
- **Xong khi:** hai request đặt cùng phòng cùng giờ gửi đồng thời chỉ một cái thành công.
- **File code:**
  [`src/Server/WorkCal.Domain/Resources/`](../../src/Server/WorkCal.Domain/Resources/) ·
  [`src/Server/WorkCal.Application/Features/Resources/`](../../src/Server/WorkCal.Application/Features/Resources/)
- **Tài liệu:** [database/data-dictionary.md](../database/data-dictionary.md)

---

## Tuần 14 · Nghỉ phép và giao diện

<a id="p3-12"></a>
### P3-12 · Nghỉ phép duyệt 2 cấp

- **Ước tính:** ~6h · **Chức năng:** F23, F24 · **Phụ thuộc:** P3-04
- **Việc cần làm:**
  1. Entity `LeaveType`, `LeaveBalance`, `LeaveRequest`, `ApprovalStep` (dùng chung cho đổi ca và sự kiện cần duyệt sau này).
  2. Gửi đơn → Manager phòng ban duyệt → HR duyệt; từ chối ở bước nào thì dừng.
  3. Duyệt xong: trừ số dư, tạo sự kiện "Nghỉ phép" chặn lịch, báo người tổ chức các cuộc họp bị trùng.
  4. `GET /approvals/pending`, `POST /approvals/{id}/decide`.
- **Xong khi:** đủ ý cuối của cổng kiểm tra.
- **File code:**
  [`src/Server/WorkCal.Domain/Leaves/`](../../src/Server/WorkCal.Domain/Leaves/) ·
  [`src/Server/WorkCal.Domain/Approvals/`](../../src/Server/WorkCal.Domain/Approvals/) ·
  [`src/Server/WorkCal.Application/Features/Leaves/`](../../src/Server/WorkCal.Application/Features/Leaves/) ·
  [`src/Server/WorkCal.Application/Features/Approvals/`](../../src/Server/WorkCal.Application/Features/Approvals/)
- **Tài liệu:** [requirements/use-cases/](../requirements/use-cases/) · [user-manual/manager.md](../user-manual/manager.md)

<a id="p3-13"></a>
### P3-13 · Giao diện doanh nghiệp trên desktop và mobile

- **Ước tính:** ~6h · **Chức năng:** F10, F11, F23 · **Phụ thuộc:** P3-09 → P3-12
- **Việc cần làm:** chọn công ty ở góc trên; thêm người khi tạo họp, xem khung rảnh; màn hình xin nghỉ; hộp duyệt cho Manager trên mobile.
- **Xong khi:** demo trọn luồng mời họp và xin nghỉ trên 2 thiết bị.
- **File code:**
  [`src/Clients/WorkCal.Client.Core/ViewModels/`](../../src/Clients/WorkCal.Client.Core/ViewModels/) ·
  [`src/Clients/WorkCal.Desktop/Views/`](../../src/Clients/WorkCal.Desktop/Views/) ·
  [`src/Clients/WorkCal.Mobile/Views/`](../../src/Clients/WorkCal.Mobile/Views/)
- **Tài liệu:** [user-manual/member.md](../user-manual/member.md) · [user-manual/manager.md](../user-manual/manager.md)

---

<a id="rui-ro"></a>
## Rủi ro

| Rủi ro | Cách xử lý |
| --- | --- |
| RLS làm chậm truy vấn | Đo bằng Query Store; predicate đơn giản, dùng index `TenantId` |
| Ma trận quyền phức tạp dần | Ghi ma trận vào `roles-permissions.md` trước, test theo ma trận |
| Duyệt nhiều cấp lan sang nhiều tính năng | Làm `ApprovalStep` chung ngay từ đầu |

[↑ Về đầu trang](#top) · [← Roadmap](README.md)
