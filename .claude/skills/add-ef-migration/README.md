# add-ef-migration

[← skills](../README.md)

## Mục đích
Quy trình tạo một migration EF Core: sửa model, tạo và rà migration, thêm RLS cho bảng có `TenantId`, áp vào CSDL dev, cập nhật data-dictionary và ERD.

## Nội dung chính
| File | Vai trò |
| --- | --- |
| [SKILL.md](SKILL.md) | Hướng dẫn Claude đọc khi chạy skill |

## Quy ước và lưu ý
- Bám theo rule `ef-migrations` và [docs/database/migrations.md](../../../docs/database/migrations.md).
- Thay đổi schema phải được chủ dự án duyệt trước (agent `db-designer` đề xuất).

## Cập nhật lần cuối
2026-11-21 – tạo skill (P0-06).
