---
name: add-ef-migration
description: Quy trình tạo một migration EF Core cho WorkCal, kèm RLS cho bảng có TenantId và cập nhật data-dictionary/ERD. Dùng khi task cần thêm hoặc đổi bảng, cột, index.
---

# Tạo migration EF Core

Áp dụng rule [`ef-migrations`](../../rules/ef-migrations.md) và [`multi-tenant`](../../rules/multi-tenant.md). Tài liệu: [docs/database/migrations.md](../../../docs/database/migrations.md).

## 1. Trước khi tạo

1. Thay đổi schema đã được chủ dự án duyệt (đề xuất từ agent `db-designer` hoặc ghi trong task). Chưa duyệt thì dừng và hỏi.
2. PR này chưa có migration nào khác (mỗi PR tối đa một migration).
3. Docker đang chạy: `docker compose up -d`; chuỗi kết nối dev nằm trong User Secrets của WorkCal.Api (không đọc, không in ra).

## 2. Sửa model

- Entity trong Domain, cấu hình trong `Infrastructure/Persistence/Configurations/` bằng `IEntityTypeConfiguration<T>`.
- Bảng có `TenantId`: index bắt đầu bằng `TenantId`; bảng đồng bộ thêm `Version` (rowversion), `UpdatedAt`, `IsDeleted`, `DeletedAt`.
- Đổi tên hoặc xóa cột: chỉ làm bước 1 (thêm cột mới, chuyển dữ liệu); bỏ cột cũ ở phiên bản sau.

## 3. Tạo migration

```powershell
dotnet ef migrations add <ĐộngTừĐốiTượng> `
  --project src/Server/WorkCal.Infrastructure `
  --startup-project src/Server/WorkCal.Api
```

Tên tiếng Anh PascalCase, ví dụ `AddLeaveRequests`, `AddRecurrenceToEvents`.

## 4. Rà soát file sinh ra

- Đọc kỹ `Up` và `Down`: không có lệnh xóa bảng hoặc cột ngoài dự kiến, kiểu dữ liệu đúng, index đúng thứ tự cột.
- Bảng mới có `TenantId` → viết script trong `Infrastructure/Persistence/Rls/` thêm `FILTER` và `BLOCK PREDICATE` vào `security.TenantPolicy`, gọi bằng `migrationBuilder.Sql(...)` trong `Up`, và gỡ trong `Down`.
- Không sửa migration đã merge vào `main`.

## 5. Áp và kiểm tra

```powershell
dotnet ef database update --project src/Server/WorkCal.Infrastructure --startup-project src/Server/WorkCal.Api
dotnet test tests/WorkCal.Api.IntegrationTests
```

Bộ `TenantIsolation` phải xanh, gồm kiểm tra RLS (không đặt `SESSION_CONTEXT` thì `SELECT` trả 0 dòng).

## 6. Tài liệu và commit

1. Cập nhật [data-dictionary.md](../../../docs/database/data-dictionary.md) và [erd.md](../../../docs/database/erd.md) trong cùng PR.
2. Lệnh commit dùng loại `feat(db)` hoặc `refactor(db)`; nếu client cũ không đồng bộ được nữa thì thêm `!` và footer `BREAKING CHANGE:` (phải hỏi chủ dự án trước).

Không bao giờ chạy `dotnet ef database drop`, `DROP DATABASE`, `docker compose down -v`; cần làm sạch CSDL dev thì nhờ chủ dự án.
