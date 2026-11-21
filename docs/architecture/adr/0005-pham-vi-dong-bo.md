# 0005 · Phạm vi đồng bộ offline và cách hiện sự kiện được mời

[← adr](README.md)

- **Trạng thái:** Đã chấp nhận
- **Ngày:** 2026-11-21

## Bối cảnh
Client lưu dữ liệu trong SQLite để dùng khi mất mạng. Cần chốt: client giữ những gì, người được mời họp thấy cuộc họp ra sao, mất quyền thì xử lý thế nào, và cursor `rowversion` có bỏ sót bản ghi khi nhiều transaction chạy song song hay không.

## Các lựa chọn
| Lựa chọn | Ưu | Nhược |
| --- | --- | --- |
| Đồng bộ mọi lịch người dùng xem được (kể cả FreeBusy) | Xem được mọi thứ khi offline | Tải nặng, lưu nội dung người dùng không được xem |
| Chỉ lịch sở hữu, lịch chia sẻ quyền Read trở lên và sự kiện được mời | Đủ dùng offline, đúng quyền | Lịch FreeBusy chỉ xem khi online |
| Sao một bản sự kiện vào lịch mỗi người được mời | Giống Outlook/Google | Phải lan truyền mọi thay đổi tới các bản sao, dễ lệch |
| Một bản duy nhất, hiện qua `EventAttendees` | Không có dữ liệu trùng | Truy vấn lịch phải gộp thêm sự kiện được mời |

## Quyết định
- Phạm vi đồng bộ: lịch sở hữu, lịch được chia sẻ quyền `Read`/`Write`/`Manage`, sự kiện được mời. Lịch `FreeBusy` và lịch người khác chỉ xem online.
- Sự kiện chỉ có một bản ở lịch người tổ chức; người được mời thấy qua `EventAttendees`, chỉ sửa phản hồi và lời nhắc của mình.
- Mất quyền → pull trả mục `revoked` để client xóa bản cục bộ. Được thêm quyền → pull trả kèm dữ liệu mà dòng cấp quyền mới mở ra.
- Cursor không vượt `MIN_ACTIVE_ROWVERSION()` để không bỏ sót transaction commit chậm.

## Hệ quả
- `GET /events` và `GET /sync/pull` đều phải gộp sự kiện được mời; cần index `EventAttendees(TenantId, UserId)`.
- `Reminders` có `UserId` vì mỗi người có lời nhắc riêng.
- Cần test: được chia sẻ, bị thu hồi, transaction chậm. Chi tiết: [offline-sync.md](../offline-sync.md#pham-vi), [sync-protocol.md](../../api/sync-protocol.md#pull).
