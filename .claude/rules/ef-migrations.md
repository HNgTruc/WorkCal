---
paths:
  - "src/Server/WorkCal.Infrastructure/Persistence/**"
  - "src/Server/WorkCal.Domain/**"
---

# Rule: EF Core và migration

Nguồn sự thật: [docs/database/migrations.md](../../docs/database/migrations.md) · schema: [data-dictionary.md](../../docs/database/data-dictionary.md), [erd.md](../../docs/database/erd.md). Skill: [`add-ef-migration`](../skills/add-ef-migration/SKILL.md).

## Bắt buộc

- Không sửa migration đã merge vào `main`; muốn đổi thì tạo migration mới.
- Mỗi PR tối đa một migration, kèm cập nhật `data-dictionary.md` và `erd.md` trong cùng PR.
- Tên migration `<ĐộngTừ><ĐốiTượng>` tiếng Anh PascalCase: `AddLeaveRequests`, `AddRecurrenceToEvents`.
- Bảng mới có `TenantId` → thêm vào security policy RLS trong cùng migration bằng `migrationBuilder.Sql(...)` gọi script ở `Persistence/Rls/`.
- Đổi tên hoặc xóa cột làm hai bước qua hai phiên bản (thêm cột mới, chuyển dữ liệu → bỏ cột cũ) để client cũ đồng bộ không lỗi.
- Cấu hình entity bằng `IEntityTypeConfiguration<T>`, không dùng data annotation trong Domain.
- Bảng đồng bộ (đánh dấu **S**) có `Version rowversion`, `UpdatedAt`, `IsDeleted`, `DeletedAt`. Khóa chính GUID v7 (`Guid.CreateVersion7()`).
- Seed dữ liệu cố định (gói dịch vụ) bằng `HasData`; dữ liệu demo bằng script, không bằng migration.
- Production chạy script idempotent trong pipeline deploy; không gọi `Database.Migrate()` lúc khởi động.

## Không được

- Không chạy `dotnet ef database drop`, `DROP DATABASE`, `docker compose down -v` (bị chặn trong `settings.json`); cần làm sạch CSDL dev thì nhờ chủ dự án.
- Không sửa schema trực tiếp bằng SQL hay qua MCP `workcal-sql` (chỉ đọc).

## Hỏi trước

Đổi tên bảng, tên cột hoặc thêm migration ngoài phạm vi task (quy tắc 3).
