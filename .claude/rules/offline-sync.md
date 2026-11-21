---
paths:
  - "src/Clients/WorkCal.Client.Core/Local/**"
  - "src/Clients/WorkCal.Client.Core/Sync/**"
  - "src/Server/WorkCal.Application/Features/Sync/**"
  - "src/Server/WorkCal.Api/Controllers/V1/SyncController.cs"
  - "src/Shared/WorkCal.Contracts/Sync/**"
  - "tests/WorkCal.Client.Core.Tests/Sync/**"
  - "tests/WorkCal.Api.IntegrationTests/Sync/**"
---

# Rule: Lưu cục bộ và đồng bộ offline

Nguồn sự thật: [docs/architecture/offline-sync.md](../../docs/architecture/offline-sync.md), giao thức [docs/api/sync-protocol.md](../../docs/api/sync-protocol.md), phạm vi [ADR 0005](../../docs/architecture/adr/0005-pham-vi-dong-bo.md). Sai ở đây là mất dữ liệu người dùng.

## Client

- Mọi thay đổi ghi vào SQLite và `OutboxItem` **trong cùng một transaction**. Id sinh ở client bằng GUID v7.
- Outbox giữ thứ tự theo `Id` tăng dần; `Payload` chỉ chứa trường đã đổi, kèm `BaseVersion`. Gửi lô tối đa 100 mục, backoff 1s, 2s, 4s… tối đa 60s.
- Sau push luôn pull để lấy bản đã gộp; server là nguồn sự thật cuối cùng. SignalR `ChangesAvailable` chỉ là tín hiệu để pull.
- Nhận mục `revoked` thì xóa bản cục bộ tương ứng. Cursor rỗng hoặc cũ hơn 30 ngày thì tải lại toàn bộ.
- Thông báo cục bộ: 7 ngày tới, tối đa 64 cái, ID cố định theo `(EventId, thời điểm nhắc)`.

## Server

- Phạm vi pull: lịch sở hữu, lịch chia sẻ quyền `Read` trở lên (trực tiếp hoặc qua phòng ban), sự kiện được mời qua `EventAttendees`, task giao cho mình, lời nhắc của mình. Lịch `FreeBusy` và lịch người khác không đồng bộ.
- Pull chỉ trả bản ghi có `Version < MIN_ACTIVE_ROWVERSION()`, cursor mới không vượt giá trị này; trả cả bản ghi đã xóa mềm; phân trang 500.
- Dòng cấp quyền mới (`CalendarShares`, `EventAttendees`) có `Version` lớn hơn cursor → trả kèm toàn bộ dữ liệu dòng đó mở ra.
- Xung đột gộp theo từng trường trong `ConflictResolver`: trường chỉ một bên sửa giữ bên đó; cùng trường thì bản **đến server sau** thắng (không dùng đồng hồ client); xóa thắng sửa.
- Xóa luôn là xóa mềm (`IsDeleted`, `DeletedAt`); xóa hẳn chỉ do job sau 30 ngày.
- Đổi DTO hay hành vi `/sync` mà client cũ không hiểu là thay đổi phá vỡ tương thích: hỏi chủ dự án trước (rule [`api-conventions`](api-conventions.md)).

## Test bắt buộc

Hai thiết bị sửa offline cùng/khác trường; xóa và sửa đồng thời; transaction commit chậm không bị bỏ sót; được chia sẻ thì nhận đủ sự kiện cũ, bị thu hồi thì nhận `revoked`; outbox thử lại sau lỗi mạng không tạo bản ghi trùng.
