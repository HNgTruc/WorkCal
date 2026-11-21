---
name: finish-task
description: Quy trình kết thúc một task WorkCal - kiểm tra "Xong khi", build, test, README, tài liệu, rồi soạn lệnh commit PowerShell đúng Conventional Commits và commitlint (footer Refs) để chủ dự án tự chạy. Dùng khi xong một task roadmap hoặc cuối phiên làm việc.
---

# Kết thúc task và soạn lệnh commit

Claude **không** commit, push, merge (quy tắc 4; các lệnh này cũng bị chặn trong `settings.json`). Skill này chuẩn bị mọi thứ để chủ dự án chạy một khối lệnh là xong.

## 1. Kiểm tra trước khi giao

1. Đọc lại task trong `docs/roadmap/`: đi qua từng ý **Xong khi**, ghi rõ ý nào đã kiểm tra được và ý nào cần chủ dự án tự thử (ví dụ thao tác trong Claude Code, chạy trên Windows, build iOS).
2. `dotnet build WorkCal.slnx` không cảnh báo; `dotnet test` xanh (integration cần Docker). Không chạy được ở môi trường hiện tại thì nói rõ và đưa lệnh để chủ dự án chạy.
3. `pwsh scripts/check-readme.ps1` qua; README thư mục đã đổi có dòng **Cập nhật lần cuối** mới.
4. Tài liệu `docs/` liên quan đã khớp với code; link tương đối đúng.
5. Task chạm tenant, phân quyền, đồng bộ, migration: đã gọi agent `code-reviewer` (và `security-auditor` khi cần) và xử lý mục **Phải sửa**.
6. `git status`: không có file rác, không có `.env`, `bin/`, `obj/`, file cá nhân lọt vào.

## 2. Soạn lệnh commit

Theo mẫu trong [working-agreement.md](../../rules/working-agreement.md) mục 4 và [`commitlint.config.mjs`](../../../commitlint.config.mjs):

- **Nhánh:** `<loai>/<mã-task>-<mô-tả-ngắn-không-dấu>`, ví dụ `feat/P1-04-lich-lap`, tách từ `main` mới nhất.
- **Tiêu đề:** `<loai>(<pham-vi>): <mô tả tiếng Việt có dấu, chữ thường đầu câu>`, tối đa 100 ký tự. `<pham-vi>` chỉ gồm chữ thường không dấu, số, gạch ngang (CI kiểm tra tiêu đề PR bằng regex `^(feat|fix|docs|test|refactor|perf|style|build|ci|chore|revert)(\([a-z0-9-]+\))?!?: \S.*$`).
- **Thân:** gạch đầu dòng các thay đổi chính.
- **Footer:** `Refs: <mã task>` (bắt buộc, commitlint chặn nếu thiếu); thêm `Closes #<số>` nếu có issue; thay đổi phá vỡ tương thích thêm `!` và `BREAKING CHANGE: ...` (phải được chủ dự án đồng ý trước).
- **`git add`:** liệt kê đúng file và thư mục đã đổi; không dùng `git add .` hay `git add -A`.
- Tiêu đề PR trùng tiêu đề commit (squash merge lấy tiêu đề PR).

Khuôn lệnh (PowerShell 7):

```powershell
git checkout main; git pull
git checkout -b <loai>/<ma-task>-<mo-ta-ngan>
git add <file 1> <file 2> <thư mục/>
git commit -m "<loai>(<pham-vi>): <mô tả>" `
  -m "- <thay đổi 1>
- <thay đổi 2>" `
  -m "Refs: <mã task>"
git push -u origin <loai>/<ma-task>-<mo-ta-ngan>
gh pr create --title "<loai>(<pham-vi>): <mô tả>" --body "Refs: <mã task>"
```

Nếu đang đứng sẵn trên nhánh của task (đã tách từ `main` trước khi sửa) thì bỏ hai dòng đầu và nói rõ điều đó. Nếu thay đổi chưa commit đang nằm trên `main`, `git checkout -b` sẽ mang chúng sang nhánh mới, nên vẫn dùng được khuôn trên nhưng **bỏ `git pull`** khi `main` cục bộ chưa tụt sau origin (hỏi chủ dự án nếu không chắc).

## 3. Báo cáo cuối

Trình bày ngắn gọn, tiếng Việt:

1. Đã làm gì (theo từng ý **Việc cần làm**), file đã thay đổi.
2. **Xong khi**: ý nào đạt, ý nào chủ dự án cần tự thử và thử thế nào.
3. Khối lệnh commit ở trên.
4. Nhắc: sau khi merge, tick task trong `docs/roadmap/phase-*.md` kèm ngày, cập nhật dòng "task tiếp theo" trong [docs/roadmap/README.md](../../../docs/roadmap/README.md#dang-lam) và số task trong bảng tổng quan; ghi tuần vào [progress-log.md](../../../docs/roadmap/progress-log.md) nếu hết tuần.
5. Nếu phiên kết thúc: cập nhật file bàn giao trong project claude.ai khi chủ dự án yêu cầu.
