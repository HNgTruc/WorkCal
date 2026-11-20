# database

[← Mục lục tài liệu](../README.md)

## Mục đích
Mô tả cấu trúc CSDL SQL Server của WorkCal: quan hệ giữa các bảng, ý nghĩa từng cột, quy ước migration.

## Nội dung chính
| File | Vai trò |
| --- | --- |
| [erd.md](erd.md) | Sơ đồ quan hệ (mermaid) theo nhóm bảng |
| [data-dictionary.md](data-dictionary.md) | Từng bảng, cột chính, ràng buộc, index |
| [migrations.md](migrations.md) | Cách tạo, đặt tên, chạy migration |

## Phụ thuộc
Code: [`Infrastructure/Persistence/`](../../src/Server/WorkCal.Infrastructure/Persistence/). Mô hình tenant: [multi-tenant.md](../architecture/multi-tenant.md).

## Quy ước và lưu ý
Đổi schema thì cập nhật cả `data-dictionary.md` và `erd.md` trong cùng PR với migration.
