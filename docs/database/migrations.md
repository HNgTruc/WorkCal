<a id="top"></a>

# Quy ước migration

[← database](README.md) · [Mục lục tài liệu](../README.md)

Migration dùng EF Core, nằm ở [`Persistence/Migrations/`](../../src/Server/WorkCal.Infrastructure/Persistence/Migrations/). Quy tắc cho Claude Code: [`.claude/rules/ef-migrations.md`](../../.claude/rules/ef-migrations.md), skill: [`add-ef-migration`](../../.claude/skills/add-ef-migration/SKILL.md).

## Mục lục

- [Lệnh thường dùng](#lenh)
- [Đặt tên](#dat-ten)
- [Quy tắc](#quy-tac)
- [Script ngoài EF](#script)

<a id="lenh"></a>
## Lệnh thường dùng

```bash
# Tạo migration
dotnet ef migrations add AddLeaveRequests \
  --project src/Server/WorkCal.Infrastructure \
  --startup-project src/Server/WorkCal.Api

# Áp vào CSDL dev
dotnet ef database update --project src/Server/WorkCal.Infrastructure --startup-project src/Server/WorkCal.Api

# Xuất script SQL để deploy
dotnet ef migrations script --idempotent -o artifacts/migrate.sql \
  --project src/Server/WorkCal.Infrastructure --startup-project src/Server/WorkCal.Api
```

<a id="dat-ten"></a>
## Đặt tên

`<Động từ><Đối tượng>` bằng tiếng Anh, PascalCase: `InitialCreate`, `AddEvents`, `AddRecurrenceToEvents`, `AddRlsPolicies`, `RenameRoomsToResources`.

<a id="quy-tac"></a>
## Quy tắc

1. Không sửa migration đã merge vào `main`; muốn đổi thì tạo migration mới.
2. Mỗi PR tối đa một migration, đi kèm cập nhật [data-dictionary.md](data-dictionary.md) và [erd.md](erd.md).
3. Bảng mới có `TenantId` thì thêm vào security policy RLS trong cùng migration.
4. Đổi tên hoặc xóa cột: làm hai bước qua hai phiên bản (thêm cột mới, chuyển dữ liệu → bỏ cột cũ) để client cũ không lỗi khi đồng bộ.
5. Seed dữ liệu cố định (gói dịch vụ) bằng `HasData`; dữ liệu demo bằng [`scripts/seed-demo-data.ps1`](../../scripts/seed-demo-data.ps1).
6. Production chạy script idempotent trong pipeline deploy, không gọi `Database.Migrate()` lúc khởi động.

<a id="script"></a>
## Script ngoài EF

Script SQL không biểu diễn được bằng EF (hàm và policy RLS) để trong [`Persistence/Rls/`](../../src/Server/WorkCal.Infrastructure/Persistence/Rls/) và được gọi bằng `migrationBuilder.Sql(...)` trong migration tương ứng.

[↑ Về đầu trang](#top)
