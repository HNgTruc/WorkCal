# .github

[← README gốc](../README.md)

## Mục đích
Cấu hình GitHub cho repo: mẫu pull request, mẫu issue và (từ task P0-04) workflow CI.

## Nội dung chính
| File / thư mục | Vai trò | Trạng thái |
| --- | --- | --- |
| [pull_request_template.md](pull_request_template.md) | Mẫu PR: mã task, checklist build, test, tenant, secret, README | Đã có |
| [ISSUE_TEMPLATE/](ISSUE_TEMPLATE/README.md) | Mẫu issue `task` và `bug`, tắt issue trống | Đã có |
| `workflows/` | `ci.yml`, `deploy.yml` | Làm ở [P0-04](../docs/roadmap/phase-0-nen-mong.md#p0-04) |

## Quy ước và lưu ý
- Nhánh `main` được bảo vệ: chỉ nhận PR, áp cả admin, 0 người duyệt bắt buộc. Check CI bắt buộc thêm ở P0-04.
- Chỉ bật squash merge; tiêu đề commit lấy từ tiêu đề PR, tự xóa nhánh sau khi merge.
- Label: 9 label mặc định của GitHub (`documentation` đổi tên thành `docs`) và `phase-0` … `phase-5`.
- Milestone: `Giai đoạn 0` … `Giai đoạn 5`, không đặt hạn chót.

## Cập nhật lần cuối
2026-11-20 – tạo thư mục, mẫu PR và mẫu issue (P0-01); ghi quy ước squash merge.
