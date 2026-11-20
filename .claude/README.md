# .claude

[← README gốc](../README.md)

## Mục đích
Cấu hình Claude Code dùng chung cho cả dự án: quy tắc, hook, agent, skill. Được commit cùng code để mọi máy làm việc theo một chuẩn.

## Nội dung chính
| Thư mục / file | Vai trò | Trạng thái |
| --- | --- | --- |
| [rules/](rules/README.md) | Quy tắc theo chủ đề; `working-agreement.md` là bắt buộc | Đã có working-agreement |
| `settings.json` | Quyền, khai báo hook | Làm ở [P0-06](../docs/roadmap/phase-0-nen-mong.md#p0-06) |
| `hooks/` | guard-secrets, format-on-edit, check-readme, verify-build | Làm ở P0-06 |
| `agents/` | code-reviewer, test-writer, db-designer, security-auditor, docs-writer | Làm ở P0-06 |
| `skills/` | add-feature, add-ef-migration, add-blazor-page, add-maui-screen, add-mcp-tool, write-folder-readme | Làm ở P0-06 và khi cần |

## Quy ước và lưu ý
- `settings.local.json` là cấu hình riêng máy, nằm trong `.gitignore`.
- Mọi phiên làm việc bắt đầu bằng việc đọc [`CLAUDE.md`](../CLAUDE.md) và [`rules/working-agreement.md`](rules/working-agreement.md).

## Cập nhật lần cuối
2026-11-20 – tạo thư mục, thêm quy tắc làm việc.
