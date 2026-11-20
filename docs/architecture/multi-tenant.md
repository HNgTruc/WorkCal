<a id="top"></a>

# Mô hình multi-tenant

[← architecture](README.md) · [Mục lục tài liệu](../README.md)

WorkCal dùng **một CSDL chung, mỗi bảng có cột `TenantId`**, bảo vệ bằng hai lớp: global query filter của EF Core và Row-Level Security của SQL Server. Quyết định này ghi ở [ADR 0002](adr/0002-csdl-chung-tenantid.md).

## Mục lục

- [So sánh các mô hình](#so-sanh)
- [Tenant cá nhân và doanh nghiệp](#loai-tenant)
- [Cách xác định tenant của request](#xac-dinh)
- [Lớp 1: query filter và interceptor](#lop-1)
- [Lớp 2: Row-Level Security](#lop-2)
- [Ngoại lệ: module Platform](#platform)
- [Giới hạn theo gói](#goi)

<a id="so-sanh"></a>
## So sánh các mô hình

| Mô hình | Cách ly | Chi phí | Quyết định |
| --- | --- | --- | --- |
| CSDL chung + cột TenantId | Logic (code + RLS) | Thấp | Dùng cho 1.0 |
| Schema riêng mỗi tenant | Trung bình | Trung bình, migration phức tạp | Không dùng |
| CSDL riêng mỗi tenant | Cao | Cao | Dành cho khách Business lớn về sau |

<a id="loai-tenant"></a>
## Tenant cá nhân và doanh nghiệp

- Đăng ký không qua lời mời → hệ thống tự tạo tenant `Personal` và gán người dùng làm Owner.
- Tạo công ty → tenant `Business`. Một người có thể thuộc nhiều tenant qua bảng `Memberships`.
- Bảng `Users` nằm ngoài tenant: mỗi người có một tài khoản duy nhất.

Nhờ vậy mọi code đều đi theo một luồng tenant, không có nhánh riêng cho người dùng cá nhân.

<a id="xac-dinh"></a>
## Cách xác định tenant của request

1. Đăng nhập xong, người dùng chọn tenant; server cấp JWT có claim `tid` và `role` của tenant đó.
2. Đổi tenant = gọi `POST /auth/switch-tenant` để lấy token mới ([authentication.md](../api/authentication.md)).
3. Middleware [`TenantResolver`](../../src/Server/WorkCal.Api/Middleware/TenantResolver.cs) đọc `tid`, kiểm tra người dùng còn là thành viên và tenant chưa bị khóa, rồi gán vào [`ITenantContext`](../../src/Server/WorkCal.Application/Common/ITenantContext.cs) (scoped).

<a id="lop-1"></a>
## Lớp 1: query filter và interceptor

```csharp
// AppDbContext.OnModelCreating
foreach (var type in model.GetEntityTypes().Where(t => typeof(ITenantEntity).IsAssignableFrom(t.ClrType)))
{
    // e => e.TenantId == _tenant.Id && !e.IsDeleted
    builder.Entity(type.ClrType).HasQueryFilter(BuildTenantFilter(type.ClrType));
}
```

- Mọi entity có `ITenantEntity` tự được lọc theo tenant hiện tại.
- [`TenantInterceptor`](../../src/Server/WorkCal.Infrastructure/Persistence/Interceptors/TenantInterceptor.cs) tự gán `TenantId` khi thêm mới và chặn sửa bản ghi của tenant khác.
- Mọi index bắt đầu bằng `TenantId`, ví dụ `(TenantId, CalendarId, StartUtc)` trên bảng Events.

<a id="lop-2"></a>
## Lớp 2: Row-Level Security

Phòng khi lỡ viết SQL thô hoặc quên filter:

```sql
CREATE FUNCTION security.fn_tenant_access(@TenantId uniqueidentifier)
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS ok
WHERE @TenantId = CAST(SESSION_CONTEXT(N'TenantId') AS uniqueidentifier)
   OR CAST(SESSION_CONTEXT(N'IsPlatform') AS bit) = 1;

CREATE SECURITY POLICY security.TenantPolicy
ADD FILTER PREDICATE security.fn_tenant_access(TenantId) ON dbo.Events,
ADD BLOCK  PREDICATE security.fn_tenant_access(TenantId) ON dbo.Events
-- ... lặp lại cho mọi bảng có TenantId
WITH (STATE = ON);
```

[`SessionContextInterceptor`](../../src/Server/WorkCal.Infrastructure/Persistence/Interceptors/SessionContextInterceptor.cs) gọi `sp_set_session_context` mỗi khi mở kết nối. Script RLS nằm trong [`Persistence/Rls/`](../../src/Server/WorkCal.Infrastructure/Persistence/Rls/).

<a id="platform"></a>
## Ngoại lệ: module Platform

- Chỉ code trong [`Features/Platform/`](../../src/Server/WorkCal.Application/Features/Platform/) được gọi `IgnoreQueryFilters()` và đặt `IsPlatform=1`.
- Mọi lần đọc chéo tenant đều ghi audit.
- Quy tắc cho Claude Code: [`.claude/rules/multi-tenant.md`](../../.claude/rules/multi-tenant.md).

<a id="goi"></a>
## Giới hạn theo gói

`IPlanLimitService` kiểm tra ở tầng Application: số thành viên, số phòng họp, thời gian giữ lịch sử, tính năng theo gói (feature flag). Vượt giới hạn trả lỗi 403 kèm mã `plan_limit_exceeded` và gói cần nâng cấp.

Kiểm chứng toàn bộ: [security/tenant-isolation.md](../security/tenant-isolation.md).

[↑ Về đầu trang](#top)
