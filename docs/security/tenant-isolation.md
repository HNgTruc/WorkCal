<a id="top"></a>

# Cách ly tenant

[← security](README.md) · [Mục lục tài liệu](../README.md)

Dữ liệu của mỗi công ty được bảo vệ bằng bốn lớp, và một bộ test tự động chứng minh không đọc chéo được. Thiết kế chi tiết: [architecture/multi-tenant.md](../architecture/multi-tenant.md).

## Mục lục

- [Bốn lớp bảo vệ](#bon-lop)
- [Bộ test cách ly](#bo-test)
- [Khi thêm bảng hoặc endpoint mới](#khi-them)

<a id="bon-lop"></a>
## Bốn lớp bảo vệ

| Lớp | Cơ chế | Chặn được gì | Code |
| --- | --- | --- | --- |
| 1. Token | Claim `tid` được ký; `TenantResolver` kiểm tra membership và tenant chưa khóa | Dùng token của tenant đã rời hoặc bị khóa | [`TenantResolver.cs`](../../src/Server/WorkCal.Api/Middleware/TenantResolver.cs) |
| 2. EF Core | Global query filter + `TenantInterceptor` gán và kiểm tra `TenantId` khi ghi | Truy vấn LINQ quên điều kiện tenant, ghi nhầm tenant | [`Interceptors/`](../../src/Server/WorkCal.Infrastructure/Persistence/Interceptors/) |
| 3. SQL Server | Row-Level Security theo `SESSION_CONTEXT('TenantId')` | SQL thô, Dapper, báo cáo viết tay | [`Persistence/Rls/`](../../src/Server/WorkCal.Infrastructure/Persistence/Rls/) |
| 4. Test | Bộ test tự quét mọi route | Endpoint mới quên kiểm tra | [`TenantIsolation/`](../../tests/WorkCal.Api.IntegrationTests/TenantIsolation/) |

<a id="bo-test"></a>
## Bộ test cách ly

1. Tạo dữ liệu mẫu đầy đủ cho **tenant A** và **tenant B** (lịch, sự kiện, task, đơn nghỉ, ca, chấm công…).
2. Liệt kê mọi route của API bằng `EndpointDataSource`.
3. Với mỗi route có tham số Id: gọi bằng token tenant A với Id thuộc tenant B → phải nhận 404 hoặc 403.
4. Với mỗi route danh sách: gọi bằng token tenant A → kết quả không chứa Id nào của tenant B.
5. Route mới mà chưa có dữ liệu mẫu trong bảng ánh xạ → **test thất bại**, buộc người viết bổ sung.
6. Kiểm tra RLS: mở kết nối không đặt `SESSION_CONTEXT`, `SELECT` trên mọi bảng có `TenantId` → 0 dòng.

Tool của WorkCal.Mcp có bộ test tương tự trong [`tests/WorkCal.Mcp.Tests/`](../../tests/WorkCal.Mcp.Tests/).

<a id="khi-them"></a>
## Khi thêm bảng hoặc endpoint mới

- [ ] Entity implement `ITenantEntity`
- [ ] Index bắt đầu bằng `TenantId`
- [ ] Thêm bảng vào security policy RLS trong migration
- [ ] Thêm dữ liệu mẫu cho route mới vào bảng ánh xạ của bộ test cách ly
- [ ] Không dùng `IgnoreQueryFilters()` ngoài module Platform

Task gốc: [P0-10](../roadmap/phase-0-nen-mong.md#p0-10), [P3-05](../roadmap/phase-3-doanh-nghiep.md#p3-05), [P3-06](../roadmap/phase-3-doanh-nghiep.md#p3-06).

[↑ Về đầu trang](#top)
