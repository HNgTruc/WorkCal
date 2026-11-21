---
name: write-folder-readme
description: Viết hoặc cập nhật README.md cho một thư mục trong repo WorkCal theo mẫu chung (bắt buộc có mục "## Mục đích"). Dùng khi tạo thư mục mới, thêm hoặc đổi file trong thư mục, hoặc khi hook check-readme báo thiếu.
---

# Viết README cho thư mục

Mọi thư mục trong repo phải có `README.md` có mục `## Mục đích`. [`scripts/check-readme.ps1`](../../../scripts/check-readme.ps1) kiểm tra ở hook Stop và ở CI. Thư mục được miễn: `bin`, `obj`, `.git`, `.vs`, `.vscode`, `.idea`, `node_modules`, `TestResults`, `*/Resources/Images`.

## Mẫu

```markdown
# <tên thư mục>

[← <thư mục cha>](../README.md)

## Mục đích
<Một hai câu: thư mục này chứa gì và để làm gì trong WorkCal.>

## Nội dung chính
| File / thư mục | Vai trò |
| --- | --- |
| [Ten.cs](Ten.cs) | <vai trò> |
| [ThuMucCon/](ThuMucCon/README.md) | <vai trò> |

## Cách chạy / test
<Lệnh build, chạy, test liên quan. Bỏ mục này nếu không có.>

## Quy ước và lưu ý
- <Quy ước riêng của thư mục, link tới rule hoặc tài liệu trong docs/.>

## Cập nhật lần cuối
YYYY-MM-DD – <việc đã làm> (<mã task>).
```

## Cách làm

1. Đọc các file trong thư mục và README của thư mục cha để viết đúng vai trò.
2. Link tương đối tới file và thư mục con; thư mục con link tới `README.md` của nó.
3. Thư mục cha cũng phải có dòng cho thư mục mới trong bảng **Nội dung chính**.
4. Mục **Cập nhật lần cuối** chỉ giữ một dòng mới nhất, ngày theo giờ Việt Nam.
5. Viết tiếng Việt có dấu, câu ngắn; không mô tả lại code từng dòng.
6. Chạy `pwsh scripts/check-readme.ps1` để xác nhận.
