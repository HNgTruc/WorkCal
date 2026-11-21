# Quy tắc làm việc với Claude (bắt buộc)

> Áp dụng cho **mọi phiên làm việc** trong repo WorkCal, ưu tiên cao hơn mọi rule khác trong `.claude/rules/`.
> Do chủ dự án (Trúc) đặt ra. Không được bỏ qua, không được "linh hoạt" khi chưa được cho phép.

## 1. Luôn suy nghĩ kỹ trước khi làm

Trước khi viết hoặc sửa bất kỳ dòng code nào:

1. Đọc task đang làm trong `docs/roadmap/` (mục **Việc cần làm**, **Xong khi**, **File code**).
2. Đọc tài liệu liên quan trong `docs/` và code hiện có ở các file được nhắc tới.
3. Nêu ngắn gọn kế hoạch: sẽ sửa file nào, theo thứ tự nào, kiểm tra bằng cách nào.
4. Nêu rủi ro hoặc chỗ có thể ảnh hưởng tới phần khác (tenant, đồng bộ, phân quyền, migration).
5. Chỉ bắt tay vào làm khi kế hoạch đã rõ và không còn câu hỏi mở (xem quy tắc 3).

## 2. Làm việc như một chuyên gia lập trình thực thụ

- Tuân thủ các rule còn lại trong `.claude/rules/` (clean architecture, multi-tenant, api, migration, MVVM, testing).
- Code mới phải có test; không để code chết, code comment bỏ dở, `TODO` không có lý do.
- Ưu tiên giải pháp đơn giản, đọc được, đúng chuẩn .NET; không dùng thủ thuật khó bảo trì.
- Luôn nghĩ tới bảo mật và cách ly tenant ([`docs/security/`](../../docs/security/README.md)).
- Khi đưa ra lựa chọn kỹ thuật, nói rõ lý do và đánh đổi như một chuyên gia giải thích cho đồng nghiệp.
- Cập nhật `README.md` của thư mục có thay đổi và tài liệu liên quan trong `docs/`.

## 3. Không tự ý suy diễn — hỏi cho tới khi đủ thông tin

**Khi chủ dự án chưa quyết định thì không được tự quyết.** Hỏi lại cho tới khi đủ thông tin để làm đúng.

Bắt buộc hỏi trước khi:

- Thêm, đổi tên, xóa thư mục hoặc project ngoài cấu trúc đã chốt.
- Thêm hoặc nâng cấp package NuGet / npm.
- Đổi schema CSDL, tên bảng, tên cột, hoặc tạo migration ngoài phạm vi task.
- Thêm tính năng, endpoint, màn hình không có trong task.
- Chọn giữa nhiều cách làm có đánh đổi khác nhau.
- Yêu cầu có chỗ mơ hồ, mâu thuẫn với `docs/`, hoặc thiếu dữ liệu.

Cách hỏi: liệt kê câu hỏi đánh số, mỗi câu kèm các lựa chọn và đề xuất của mình (ghi rõ là đề xuất). Chờ trả lời rồi mới làm.

Không được: tự điền giá trị "tạm", tự chọn rồi báo sau, hoặc làm luôn rồi hỏi "có ổn không".

## 4. Không tự ý commit — đưa lệnh commit tiếng Việt

- **Không bao giờ** tự chạy `git commit`, `git push`, `git merge`, `git rebase`, `git reset --hard` hay tạo tag.
- Được phép chạy lệnh git chỉ đọc: `git status`, `git diff`, `git log`.
- Kết thúc mỗi phiên task, đưa khối lệnh để chủ dự án tự commit theo mẫu:

```powershell
# Chạy trong PowerShell 7 (pwsh); dấu ` ở cuối dòng là xuống dòng tiếp lệnh
git checkout main; git pull                       # nhánh mới luôn tách từ main mới nhất
git checkout -b <loai>/<ma-task>-<mo-ta-ngan>     # ví dụ: feat/P1-04-lich-lap
git add <các file đã thay đổi>
git commit -m "<loai>(<pham-vi>): <mô tả ngắn bằng tiếng Việt>" `
  -m "- <thay đổi 1>
- <thay đổi 2>" `
  -m "Refs: <mã task>
Closes #<số issue nếu có>"
git push -u origin <tên nhánh>
gh pr create --title "<loai>(<pham-vi>): <mô tả>" --body "Refs: <mã task>"
```

Message theo [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/). Mỗi `-m` là một đoạn, git tự chèn dòng trống giữa các đoạn: tiêu đề, thân, footer.

- **Tiêu đề:** `<loai>(<pham-vi>): <mô tả>`. `<pham-vi>` không bắt buộc, là danh từ chỉ phần code bị đổi, ví dụ `api`, `sync`, `db`, `admin`, `repo`, `roadmap`.
- **`<loai>`:**

  | Loại | Dùng khi |
  | --- | --- |
  | `feat` | Thêm tính năng |
  | `fix` | Sửa lỗi |
  | `docs` | Chỉ đổi tài liệu |
  | `test` | Thêm hoặc sửa test |
  | `refactor` | Đổi cấu trúc code, không đổi hành vi |
  | `perf` | Cải thiện hiệu năng |
  | `style` | Định dạng, khoảng trắng; không đổi logic |
  | `build` | Build, package NuGet/npm, Docker, `Directory.*.props` |
  | `ci` | Workflow GitHub Actions |
  | `chore` | Việc lặt vặt khác (cấu hình repo, công cụ) |

- **Thân:** danh sách gạch đầu dòng các thay đổi chính.
- **Footer:** đoạn cuối, mỗi footer một dòng dạng `Từ-khóa: giá trị` hoặc `Từ-khóa #giá trị`. Luôn có `Refs: <mã task>`; thêm `Closes #<số>` khi có issue. Không gộp nhiều footer trên một dòng.
- **Thay đổi phá vỡ tương thích** (đổi API, DTO, giao thức đồng bộ, schema mà client cũ không dùng được nữa): thêm `!` ngay trước dấu hai chấm, ví dụ `feat(api)!: ...`, và thêm footer `BREAKING CHANGE: <mô tả và cách chuyển đổi>`. `BREAKING CHANGE` luôn viết hoa.
- **Merge PR:** chỉ dùng squash merge. Mỗi PR thành một commit trên `main`, tiêu đề lấy từ tiêu đề PR, nội dung gộp message các commit (giữ footer `Refs:`). Vì vậy tiêu đề PR cũng phải đúng mẫu `<loai>(<pham-vi>): <mô tả>`.
- Từ task [P0-04](../../docs/roadmap/phase-0-nen-mong.md#p0-04), CI chạy commitlint và báo đỏ PR có commit sai chuẩn.
- Mô tả và nội dung commit viết **tiếng Việt có dấu**, ngắn gọn, nói rõ đã làm gì.
- Kèm danh sách file đã thay đổi và nhắc tick task trong `docs/roadmap/`.

<a id="quy-tac-5"></a>

## 5. Mở rộng bộ công cụ Claude — hỏi trước khi thêm

Trong quá trình làm, Claude **được đề xuất** thêm hoặc mở rộng rule, hook, agent, skill trong `.claude/` và `CLAUDE.md` con khi thấy giúp làm project dễ hơn: một việc lặp lại nhiều lần, một lỗi hay mắc, một quy ước chưa được ghi.

Trước khi tạo hoặc sửa, **bắt buộc mô tả và hỏi chủ dự án**, gồm:

1. Loại (rule, hook, agent, skill, CLAUDE.md con) và đường dẫn file.
2. Làm gì, áp dụng khi nào (với rule: `paths:`; với hook: sự kiện và tool; với agent: công cụ được dùng).
3. Lý do: tình huống cụ thể cho thấy cần nó.
4. Ảnh hưởng: hook chặn gì, làm chậm bao lâu; có trùng hay mâu thuẫn với cái đã có không.
5. Nội dung chính hoặc bản nháp ngắn.

Chỉ tạo khi chủ dự án đồng ý. Làm xong thì cập nhật `README.md` của thư mục và đưa vào lệnh commit như mọi thay đổi khác. Sửa chính file `working-agreement.md` vẫn cần chủ dự án đồng ý riêng.
