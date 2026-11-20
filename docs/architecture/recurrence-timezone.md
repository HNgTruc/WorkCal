<a id="top"></a>

# Lịch lặp và múi giờ

[← architecture](README.md) · [Mục lục tài liệu](../README.md)

Sự kiện lặp được lưu **một dòng gốc kèm chuỗi RRULE**, không sinh sẵn từng lần vào CSDL. Server bung các lần xảy ra theo giờ địa phương của sự kiện rồi mới đổi ra UTC, để cuộc họp 9 giờ sáng vẫn là 9 giờ sau khi đổi giờ mùa hè.

## Mục lục

- [Lưu trữ](#luu-tru)
- [Bung lịch lặp khi đọc](#bung)
- [Sửa và xóa theo phạm vi](#pham-vi)
- [Múi giờ](#mui-gio)
- [Trường hợp cần test](#test)
- [Code liên quan](#code)

<a id="luu-tru"></a>
## Lưu trữ

| Bảng | Cột chính |
| --- | --- |
| `Events` | `StartUtc`, `EndUtc`, `TimeZoneId` (IANA, ví dụ `Asia/Ho_Chi_Minh`), `IsAllDay`, `RRule` |
| `EventExceptions` | `EventId`, `OriginalStartUtc`, `IsCancelled`, `OverrideJson` |

Ví dụ RRULE: `FREQ=WEEKLY;BYDAY=MO,WE;UNTIL=20270101T000000Z` (thứ 2 và thứ 4 hằng tuần đến hết 2026).

<a id="bung"></a>
## Bung lịch lặp khi đọc

1. `GET /events?from=&to=` lấy các sự kiện có thể giao với khoảng (sự kiện thường theo `StartUtc`, sự kiện lặp theo ngày bắt đầu và `UNTIL`).
2. Với sự kiện lặp, [`RecurrenceService`](../../src/Server/WorkCal.Infrastructure/Recurrence/RecurrenceService.cs) dùng Ical.Net tính các lần xảy ra **theo giờ địa phương** của `TimeZoneId`, đổi sang UTC bằng NodaTime.
3. Áp `EventExceptions`: bỏ lần bị hủy, thay lần bị sửa.
4. Trả danh sách "lần xảy ra" có `EventId` + `OccurrenceStartUtc` để client sửa đúng lần.

<a id="pham-vi"></a>
## Sửa và xóa theo phạm vi

Tham số `scope` trên `PUT` và `DELETE /events/{id}`:

| scope | Sửa | Xóa |
| --- | --- | --- |
| `this` | Tạo `EventExceptions` với nội dung mới | Tạo `EventExceptions` với `IsCancelled=true` |
| `following` | Cắt chuỗi cũ bằng `UNTIL` ngay trước lần này, tạo chuỗi mới từ lần này | Cắt chuỗi cũ bằng `UNTIL` |
| `all` | Sửa dòng gốc, giữ các ngoại lệ còn hợp lệ | Xóa mềm dòng gốc và ngoại lệ |

<a id="mui-gio"></a>
## Múi giờ

- Server luôn lưu UTC kèm `TimeZoneId`; API nhận và trả ISO 8601 có `Z`.
- Client hiển thị theo múi giờ thiết bị; tạo sự kiện thì gửi `TimeZoneId` của thiết bị (hoặc múi mặc định của công ty).
- Sự kiện cả ngày lưu ngày địa phương (00:00 tới 00:00 hôm sau theo `TimeZoneId`), hiển thị cùng ngày ở mọi múi.
- Dùng NodaTime (`DateTimeZoneProviders.Tzdb`), không dùng `TimeZoneInfo` để tránh khác biệt giữa Windows và Linux.

<a id="test"></a>
## Trường hợp cần test

| Trường hợp | Kỳ vọng |
| --- | --- |
| Hằng tuần qua mốc đổi giờ (múi `Europe/Berlin`) | Giờ địa phương không đổi, giờ UTC lệch 1 tiếng |
| Hằng tháng ngày 31 | Bỏ qua tháng không có ngày 31 (đúng RFC 5545) |
| `COUNT=10` có 2 lần bị hủy | Còn 8 lần hiển thị |
| Sửa "từ lần này về sau" ở lần thứ 5 | Chuỗi cũ còn 4 lần, chuỗi mới bắt đầu từ lần 5 |
| Sự kiện cả ngày, người xem ở múi khác | Vẫn hiện đúng một ngày |

Test nằm ở [`tests/WorkCal.Application.Tests/Recurrence/`](../../tests/WorkCal.Application.Tests/Recurrence/).

<a id="code"></a>
## Code liên quan

[`IRecurrenceService.cs`](../../src/Server/WorkCal.Application/Common/IRecurrenceService.cs) ·
[`RecurrenceService.cs`](../../src/Server/WorkCal.Infrastructure/Recurrence/RecurrenceService.cs) ·
[`Features/Events/`](../../src/Server/WorkCal.Application/Features/Events/) ·
Task: [P1-04](../roadmap/phase-1-lich-ca-nhan.md#p1-04), [P1-05](../roadmap/phase-1-lich-ca-nhan.md#p1-05)

[↑ Về đầu trang](#top)
