# hooks

[← .claude](../README.md)

## Mục đích
Hook Claude Code viết bằng PowerShell 7, khai báo trong [`../settings.json`](../settings.json). Hook là lớp kiểm tra cứng: Claude không bỏ qua được như với hướng dẫn trong `CLAUDE.md`.

## Nội dung chính
| File | Sự kiện | Làm gì | Khi vi phạm |
| --- | --- | --- | --- |
| [guard-secrets.ps1](guard-secrets.ps1) | PreToolUse: Read, Edit, MultiEdit, Write, NotebookEdit, Grep, Glob, Bash, PowerShell | Chặn chạm tới `.env*` (trừ `.env.example`), `appsettings.Production.json`, `*.pfx`, `secrets.json`, lệnh `dotnet user-secrets list` | Chặn tool (mã 2) |
| [format-on-edit.ps1](format-on-edit.ps1) | PostToolUse: Edit, MultiEdit, Write | `dotnet format <project> --include <file>` cho file `.cs`, giới hạn 60 giây | Lỗi hoặc quá giờ: báo Claude (mã 2) |
| [check-readme.ps1](check-readme.ps1) | Stop | Gọi [`scripts/check-readme.ps1`](../../scripts/check-readme.ps1) | Claude phải bổ sung README rồi mới kết thúc lượt (mã 2) |
| [verify-build.ps1](verify-build.ps1) | Stop | `dotnet build WorkCal.slnx` nếu có file code chưa commit thay đổi kể từ lần build thành công trước | Claude phải sửa lỗi build rồi mới kết thúc lượt (mã 2) |
| [guard-migrations.ps1](guard-migrations.ps1) | PreToolUse: Edit, MultiEdit, Write | Chặn sửa file trong `Migrations/` đã có trên `origin/main` (hoặc `main`) | Chặn tool (mã 2) |
| [session-context.ps1](session-context.ps1) | SessionStart | Đưa vào đầu phiên: task tiếp theo theo roadmap, nhánh hiện tại, số file chưa commit, lời nhắc quy tắc | Không chặn |
| [_common.ps1](_common.ps1) | – | Hàm dùng chung: đọc JSON stdin, chặn/cảnh báo, chạy tiến trình có timeout, lưu trạng thái | – |

## Cách chạy / test
Claude Code gọi hook qua `pwsh -NoProfile -ExecutionPolicy Bypass -File ${CLAUDE_PROJECT_DIR}/.claude/hooks/<file>`. Test tay bằng cách đưa JSON giả qua stdin:

```powershell
'{"tool_name":"Read","tool_input":{"file_path":"D:/Data/GitHub/WorkCal/.env"}}' |
  pwsh -NoProfile -File .claude/hooks/guard-secrets.ps1; $LASTEXITCODE   # 2
'{"tool_input":{"file_path":"D:/Data/GitHub/WorkCal/src/Server/WorkCal.Domain/X.cs"}}' |
  pwsh -NoProfile -File .claude/hooks/format-on-edit.ps1; $LASTEXITCODE  # 0 nếu format được
'{"session_id":"thu","stop_hook_active":false}' |
  pwsh -NoProfile -File .claude/hooks/verify-build.ps1; $LASTEXITCODE    # 0 khi build sạch
```

Trong Claude Code: gõ `/hooks` để xem hook đã nạp.

## Quy ước và lưu ý
- Mã thoát: `0` cho qua; `2` chặn và gửi stderr cho Claude; mã khác là lỗi không chặn, chỉ hiện cho người dùng.
- Hai hook Stop có cơ chế chống lặp: khi Claude đã bị giữ lại một lần (`stop_hook_active`) mà tình trạng không đổi, hook chỉ cảnh báo (mã 1) và cho dừng.
- `verify-build` lưu dấu vân tay trạng thái file trong thư mục tạm của hệ điều hành (`%TEMP%\workcal-claude-hooks`), không ghi vào repo. Lượt chỉ sửa tài liệu không build.
- `verify-build` build cả solution, gồm MAUI Android, nên có thể mất vài phút; timeout hook 900 giây.
- `guard-secrets` khớp theo tên file trong câu lệnh, chặt hơn cần thiết (ví dụ `.env.example.bak` cũng bị chặn). Không phải ranh giới bảo mật tuyệt đối: script tự mở file vẫn qua được, nên vẫn giữ quy tắc trong `CLAUDE.md`.
- Thêm hoặc sửa hook: mô tả và hỏi chủ dự án trước ([quy tắc 5](../rules/working-agreement.md#quy-tac-5)).

## Cập nhật lần cuối
2026-11-21 – tạo 6 hook và `_common.ps1` (P0-06).
