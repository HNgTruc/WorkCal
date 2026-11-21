# skills

[← .claude](../README.md)

## Mục đích
Skill Claude Code của WorkCal: quy trình nhiều bước được viết sẵn để làm đúng và giống nhau mỗi lần. Mỗi skill là một thư mục có `SKILL.md` (nội dung Claude đọc) và `README.md` (mô tả cho người).

## Nội dung chính
| Thư mục | Dùng khi | Trạng thái |
| --- | --- | --- |
| [add-feature/](add-feature/README.md) | Thêm use case, endpoint, entity theo lát cắt dọc | Có (P0-06) |
| [add-ef-migration/](add-ef-migration/README.md) | Thêm hoặc đổi bảng, cột, index | Có (P0-06) |
| [write-folder-readme/](write-folder-readme/README.md) | Tạo thư mục mới, hook check-readme báo thiếu | Có (P0-06) |
| [finish-task/](finish-task/README.md) | Xong task hoặc cuối phiên: kiểm tra, soạn lệnh commit đúng commitlint | Có (P0-06) |
| [workcal-ui-ux/](workcal-ui-ux/README.md) | Thiết kế, dựng, rà soát giao diện WPF, MAUI, Blazor; animation (GSAP cho Blazor) | Có (P0-06) |
| `add-blazor-page/` | Thêm trang web quản trị | Làm ở giai đoạn 4 |
| `add-maui-screen/` | Thêm màn hình mobile | Làm ở giai đoạn 2 |
| `add-mcp-tool/` | Thêm tool cho WorkCal.Mcp | Làm ở giai đoạn 5 |

## Cách chạy / test
Claude tự nạp skill khi việc đang làm khớp `description`; cũng có thể gọi bằng tên, ví dụ `/add-ef-migration`.

## Quy ước và lưu ý
- Skill không lặp lại nội dung `docs/`: link tới tài liệu và rule liên quan.
- Mỗi thư mục skill cần `README.md` có `## Mục đích` để qua `check-readme` (chốt 2026-11-21).
- Thêm hoặc sửa skill: mô tả và hỏi chủ dự án trước ([quy tắc 5](../rules/working-agreement.md#quy-tac-5)).

## Cập nhật lần cuối
2026-11-21 – tạo 3 skill khung, finish-task và workcal-ui-ux (P0-06).
