# .github

[← README gốc](../README.md)

## Mục đích
Cấu hình GitHub cho repo: mẫu pull request, mẫu issue, workflow CI và Dependabot.

## Nội dung chính
| File / thư mục | Vai trò | Trạng thái |
| --- | --- | --- |
| [pull_request_template.md](pull_request_template.md) | Mẫu PR: mã task, checklist build, test, tenant, secret, README | Đã có |
| [ISSUE_TEMPLATE/](ISSUE_TEMPLATE/README.md) | Mẫu issue `task` và `bug`, tắt issue trống | Đã có |
| [workflows/](workflows/README.md) | `ci.yml`: build, test, check-readme, commitlint | Đã có (P0-04); `deploy.yml` ở giai đoạn 4 |
| [dependabot.yml](dependabot.yml) | Nâng version NuGet, GitHub Actions, image Docker mỗi thứ Hai, gộp theo nhóm | Đã có (P0-04) |

## Quy ước và lưu ý
- Nhánh `main` được bảo vệ: chỉ nhận PR, áp cả admin, 0 người duyệt bắt buộc; 3 status check bắt buộc `build-test`, `check-readme`, `commitlint`.
- Chỉ bật squash merge; tiêu đề commit lấy từ tiêu đề PR, tự xóa nhánh sau khi merge.
- Label: 9 label mặc định của GitHub (`documentation` đổi tên thành `docs`) và `phase-0` … `phase-5`.
- Milestone: `Giai đoạn 0` … `Giai đoạn 5`, không đặt hạn chót.

## Cập nhật lần cuối
2026-11-21 – thêm workflows/ci.yml và dependabot.yml (P0-04).
