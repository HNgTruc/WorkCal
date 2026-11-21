# .claude

[← README gốc](../README.md)

## Mục đích
Cấu hình Claude Code dùng chung cho cả dự án: quyền, hook, quy tắc, agent, skill. Được commit cùng code để mọi máy làm việc theo một chuẩn.

## Nội dung chính
| Thư mục / file | Vai trò |
| --- | --- |
| [settings.json](settings.json) | Quyền (allow/deny) và khai báo hook |
| [hooks/](hooks/README.md) | `session-context`, `guard-secrets`, `guard-migrations`, `format-on-edit`, `check-readme`, `verify-build` (PowerShell 7) |
| [rules/](rules/README.md) | Quy tắc theo chủ đề; `working-agreement.md` là bắt buộc |
| [agents/](agents/README.md) | `code-reviewer`, `security-auditor`, `test-writer`, `db-designer`, `docs-writer` |
| [skills/](skills/README.md) | `add-feature`, `add-ef-migration`, `write-folder-readme`, `finish-task`, `workcal-ui-ux`; các skill khác thêm ở giai đoạn dùng tới |

## Quyền trong settings.json
- **Cho phép không hỏi:** `dotnet build/test/format`, `git status/diff/log`, `docker compose ps/logs` (cả Bash và PowerShell).
- **Chặn:** `git commit/push/reset --hard/merge/rebase/tag`; xóa CSDL (`dotnet ef database drop`, `sqlcmd`, câu lệnh chứa `DROP DATABASE`, `docker compose down -v`, `docker volume rm`); đọc và sửa `.env`, `.env.*` (trừ `.env.example`), `appsettings.Production.json`, `*.pfx`, `secrets.json`, thư mục User Secrets.
- Luật chặn so khớp theo chữ trong câu lệnh nên không phải ranh giới tuyệt đối; hook `guard-secrets` là lớp thứ hai cho file bí mật.

## Cách chạy / test
Mở Claude Code ở gốc repo: `CLAUDE.md` và `.claude/` được nạp tự động. Gõ `/permissions`, `/hooks`, `/agents` để kiểm tra. Hook cần PowerShell 7 (`pwsh`) trên PATH.

## Quy ước và lưu ý
- `settings.local.json` là cấu hình riêng máy, nằm trong `.gitignore`.
- Mọi phiên làm việc bắt đầu bằng việc đọc [`CLAUDE.md`](../CLAUDE.md) và [`rules/working-agreement.md`](rules/working-agreement.md).
- Thêm hoặc mở rộng rule, hook, agent, skill: mô tả và hỏi chủ dự án trước ([quy tắc 5](rules/working-agreement.md#quy-tac-5)).

## Cập nhật lần cuối
2026-11-21 – thêm settings.json, 6 hook, 10 rule, 5 agent, 5 skill; quy tắc 5 (P0-06).
