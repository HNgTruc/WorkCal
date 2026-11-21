<a id="top"></a>

# requirements

[← Mục lục tài liệu](../README.md)

## Mục đích
Mô tả WorkCal phải làm gì: chức năng, yêu cầu phi chức năng, vai trò và quyền, các tình huống sử dụng chính. Đây là nguồn gốc của mọi task trong [roadmap](../roadmap/README.md).

## Nội dung chính
| File / thư mục | Vai trò |
| --- | --- |
| [srs.md](srs.md) | Đặc tả yêu cầu: phạm vi, F01–F36, yêu cầu phi chức năng |
| [roles-permissions.md](roles-permissions.md) | 6 vai trò và ma trận quyền |
| [use-cases/](use-cases/README.md) | Mỗi tình huống sử dụng một file, có luồng chính và luồng phụ |

## Phụ thuộc
Được dùng bởi: [roadmap](../roadmap/README.md), [api](../api/README.md), [user-manual](../user-manual/README.md).

## Quy ước và lưu ý
- Mã chức năng `Fxx` cố định, không đánh lại số. Chức năng bỏ đi thì ghi "Đã bỏ" thay vì xóa dòng.
- Thêm chức năng mới: thêm vào `srs.md`, cập nhật [backlog](../roadmap/backlog.md) hoặc file giai đoạn.

## Cập nhật lần cuối
2026-11-21 – tách F02 (TOTP = M, Google = F02b), bỏ loại lịch Resource khỏi thuật ngữ.
