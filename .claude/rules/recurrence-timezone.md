---
paths:
  - "src/Server/WorkCal.Infrastructure/Recurrence/**"
  - "src/Server/WorkCal.Application/Features/Events/**"
  - "src/Server/WorkCal.Domain/Events/**"
  - "src/Server/WorkCal.Application/Common/IRecurrenceService.cs"
  - "tests/WorkCal.Application.Tests/Recurrence/**"
---

# Rule: Lịch lặp và múi giờ

Nguồn sự thật: [docs/architecture/recurrence-timezone.md](../../docs/architecture/recurrence-timezone.md). Sai ở đây làm cuộc họp lệch giờ sau đổi giờ mùa hè hoặc mất lần xảy ra.

## Bắt buộc

- Lưu một dòng gốc kèm `RRule` (RFC 5545); không sinh sẵn từng lần vào CSDL. Ngoại lệ lưu ở `EventExceptions` (`OriginalStartUtc`, `IsCancelled`, `OverrideJson`).
- Bung lần xảy ra bằng Ical.Net **theo giờ địa phương** của `TimeZoneId` (IANA), đổi sang UTC bằng NodaTime `DateTimeZoneProviders.Tzdb`. Không dùng `TimeZoneInfo`, không cộng trừ giờ thủ công.
- `RecurrenceEndUtc` tính lại mỗi khi tạo hoặc sửa sự kiện lặp, kể cả khi cắt chuỗi `scope=following`: không lặp → `null`; có `UNTIL` → kết thúc lần cuối không vượt `UNTIL`; có `COUNT` → bung đủ `COUNT` lần (tính cả lần bị hủy); không `UNTIL`/`COUNT` → `null`.
- Truy vấn khoảng dùng đúng điều kiện có index trong tài liệu (`StartUtc < @to AND (...)`); không tải hết sự kiện rồi lọc trong bộ nhớ.
- Sửa và xóa theo `scope` `this` / `following` / `all` đúng bảng trong tài liệu; xóa `all` là xóa mềm dòng gốc và ngoại lệ.
- Sự kiện cả ngày: API và sync dùng `startDate`/`endDate` `YYYY-MM-DD`, `endDate` không tính; CSDL lưu 00:00 địa phương đổi ra UTC; validator từ chối `isAllDay: true` có kèm giờ.
- Giờ hiện tại lấy qua `TimeProvider`.

## Test bắt buộc

Mỗi thay đổi trong phạm vi rule này phải giữ xanh và bổ sung (nếu cần) các ca: hằng tuần qua mốc đổi giờ `Europe/Berlin`, hằng tháng ngày 31, `COUNT=10` có 2 lần hủy, sửa `following` ở lần thứ 5, cả ngày với người xem ở múi khác. Test ở `tests/WorkCal.Application.Tests/Recurrence/`.
