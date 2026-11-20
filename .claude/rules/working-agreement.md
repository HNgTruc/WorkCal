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

```bash
git checkout -b <loai>/<ma-task>-<mo-ta-ngan>     # ví dụ: feat/P1-04-lich-lap
git add <các file đã thay đổi>
git commit -m "<loai>(<pham-vi>): <mô tả ngắn bằng tiếng Việt>" \
  -m "- <thay đổi 1>
- <thay đổi 2>
- Task: <mã task>, Closes #<số issue nếu có>"
```

- `<loai>` theo Conventional Commits: `feat`, `fix`, `docs`, `test`, `refactor`, `chore`, `ci`.
- Mô tả và nội dung commit viết **tiếng Việt có dấu**, ngắn gọn, nói rõ đã làm gì.
- Kèm danh sách file đã thay đổi và nhắc tick task trong `docs/roadmap/`.
