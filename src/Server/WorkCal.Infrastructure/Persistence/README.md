# Persistence

[← WorkCal.Infrastructure](../README.md)

## Mục đích
AppDbContext và mọi thứ liên quan CSDL.

## Nội dung chính
| File / thư mục | Vai trò |
| --- | --- |
| [Configurations/](Configurations/README.md) | Cấu hình EF Core cho từng entity |
| [Interceptors/](Interceptors/README.md) | TenantInterceptor, cập nhật UpdatedAt, audit (P0-10) |
| [Migrations/](Migrations/README.md) | Migration EF Core; không sửa migration đã merge |
| [Rls/](Rls/README.md) | Policy Row-Level Security và gán SESSION_CONTEXT |

## Cập nhật lần cuối
2026-11-20 – tạo thư mục (P0-02).
