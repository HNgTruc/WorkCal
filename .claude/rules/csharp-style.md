---
paths:
  - "**/*.cs"
---

# Rule: Phong cách C#

Nguồn sự thật về định dạng và đặt tên là [`.editorconfig`](../../.editorconfig); dự án bật `TreatWarningsAsErrors` và `EnforceCodeStyleInBuild` ([`Directory.Build.props`](../../Directory.Build.props)) nên vi phạm style là lỗi build. Hook `format-on-edit` tự chạy `dotnet format` sau mỗi lần sửa file `.cs`.

## Bắt buộc

- File-scoped namespace, `using` đặt ngoài namespace, bỏ `using` thừa.
- Đặt tên: kiểu, method, property PascalCase; interface có tiền tố `I`; field private `_camelCase`; hằng số PascalCase.
- Luôn có ngoặc nhọn kể cả thân một dòng; kiểu Allman.
- `Nullable` bật: không tắt bằng `#nullable disable` hay `!` để né cảnh báo; xử lý null thật sự.
- Async: hàm async có hậu tố `Async`, nhận `CancellationToken` ở tham số cuối và truyền tiếp; không dùng `.Result`, `.Wait()`, `async void` (trừ event handler UI).
- Thời gian lấy qua `TimeProvider`, không gọi `DateTime.Now`/`UtcNow` trực tiếp trong code nghiệp vụ (để test giả lập được).
- Không để code chết, code comment bỏ dở, `TODO` không kèm lý do và mã task.

## Nên

- Primary constructor cho service đơn giản; `record` cho DTO và value object.
- Collection expression (`[]`), switch expression, pattern matching khi làm code dễ đọc hơn.
- Comment giải thích **vì sao**, không lặp lại code làm gì. Comment viết tiếng Việt có dấu.

## Không được

- Không tắt analyzer bằng `#pragma warning disable` hoặc sửa `.editorconfig` để build qua; nếu luật thật sự không hợp, hỏi chủ dự án.
