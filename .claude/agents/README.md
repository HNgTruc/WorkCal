# agents

[← .claude](../README.md)

## Mục đích
Subagent Claude Code dùng riêng cho WorkCal. Mỗi agent chạy trong ngữ cảnh riêng, chỉ có các công cụ khai báo ở frontmatter, nên phù hợp cho việc rà soát độc lập hoặc việc lặp lại.

## Nội dung chính
| File | Dùng khi | Công cụ | Được sửa file |
| --- | --- | --- | --- |
| [code-reviewer.md](code-reviewer.md) | Xong task, trước khi đưa lệnh commit | Read, Grep, Glob, Bash (git, build, test) | Không |
| [security-auditor.md](security-auditor.md) | Task chạm tenant, phân quyền, xác thực, bí mật | Read, Grep, Glob, Bash (git) | Không |
| [test-writer.md](test-writer.md) | Code mới thiếu test, coverage dưới 70% | Read, Grep, Glob, Edit, Write, Bash | Chỉ trong `tests/` |
| [db-designer.md](db-designer.md) | Trước khi tạo entity hoặc migration | Read, Grep, Glob | Không, chỉ đề xuất |
| [docs-writer.md](docs-writer.md) | Code đổi hành vi, thêm thư mục, cần ghi quyết định | Read, Grep, Glob, Edit, Write, Bash | Chỉ file Markdown |

## Cách chạy / test
Trong Claude Code: gõ `/agents` để xem danh sách, hoặc yêu cầu trực tiếp, ví dụ "dùng code-reviewer rà thay đổi hiện tại".

## Quy ước và lưu ý
- Không ghim model: agent dùng model của phiên (chốt 2026-11-21).
- Agent vẫn chịu `permissions.deny` và hook trong [`../settings.json`](../settings.json), nên không commit, push hay đọc file bí mật được.
- Thêm hoặc sửa agent: mô tả và hỏi chủ dự án trước ([quy tắc 5](../rules/working-agreement.md#quy-tac-5)).

## Cập nhật lần cuối
2026-11-21 – tạo 5 agent (P0-06).
