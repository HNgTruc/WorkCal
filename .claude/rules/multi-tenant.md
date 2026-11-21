---
paths:
  - "src/Server/**"
  - "tests/WorkCal.Api.IntegrationTests/**"
  - "tests/WorkCal.Mcp.Tests/**"
---

# Rule: Multi-tenant

Thiết kế: [docs/architecture/multi-tenant.md](../../docs/architecture/multi-tenant.md) · kiểm chứng: [docs/security/tenant-isolation.md](../../docs/security/tenant-isolation.md) · [ADR 0002](../../docs/architecture/adr/0002-csdl-chung-tenantid.md), [ADR 0006](../../docs/architecture/adr/0006-job-nen-theo-tenant.md).

Lỗi ở đây là lộ dữ liệu khách hàng. Không có ngoại lệ "tạm thời".

## Bắt buộc

- Mọi entity nghiệp vụ implement `ITenantEntity` (có `TenantId`). Ngoại lệ là các bảng ghi "(nền tảng)" trong [data-dictionary.md](../../docs/database/data-dictionary.md) (Plans, Users, RefreshTokens, Devices, FeatureFlags, SystemAnnouncements) và chính bảng `Tenants`; thêm ngoại lệ mới phải hỏi.
- Bảng con (CalendarShares, EventExceptions, EventAttendees, Reminders) cũng có `TenantId`, luôn bằng `TenantId` của bảng cha; kiểm tra ở tầng Application.
- Không tự gán `TenantId` trong handler: `TenantInterceptor` lo việc này. Không nhận `TenantId` từ request body hay query string; tenant lấy từ `ITenantContext`.
- Index bắt đầu bằng `TenantId`.
- Bảng mới có `TenantId` → thêm vào security policy RLS trong **cùng** migration (script ở `Infrastructure/Persistence/Rls/`).
- Endpoint mới phải có dữ liệu mẫu trong bảng ánh xạ của bộ test `TenantIsolation`; thiếu thì test đỏ là đúng.
- Tài nguyên thuộc tenant khác trả **404**, không phải 403 (không lộ sự tồn tại).
- Job nền kế thừa `TenantJobBase`, chạy lần lượt từng tenant trong DI scope riêng; không dùng `IsPlatform`.

## Không được

- Không gọi `IgnoreQueryFilters()` và không đặt `SESSION_CONTEXT('IsPlatform')` ngoài `Application/Features/Platform/`. Mọi lần đọc chéo tenant trong Platform phải ghi `AuditLogs`.
- Không viết SQL thô bỏ qua `AppDbContext` khi chưa chắc `SessionContextInterceptor` đã đặt `TenantId` cho kết nối.
- Không cache dữ liệu tenant (Redis, memory) với key thiếu `TenantId`.

## Khi review

Dùng checklist ở [tenant-isolation.md#khi-them](../../docs/security/tenant-isolation.md#khi-them); agent `security-auditor` kiểm tra kỹ phần này.
