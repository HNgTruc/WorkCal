<a id="top"></a>

# Giai đoạn 2 · Offline và mobile · tuần 7–10

[← Giai đoạn 1](phase-1-lich-ca-nhan.md) · [Roadmap](README.md) · [Giai đoạn 3 →](phase-3-doanh-nghiep.md)

Cho app chạy khi mất mạng, đồng bộ giữa nhiều thiết bị và ra mắt app MAUI. Đây là giai đoạn khó nhất; nếu trễ, làm mobile online trước rồi bổ sung offline sau.

## Mục lục và tiến độ

**Tuần 7 · Lưu cục bộ và outbox**
- [ ] [P2-01 · SQLite cục bộ trong Client.Core](#p2-01)
- [ ] [P2-02 · Outbox và ghi cục bộ trước](#p2-02)
- [ ] [P2-03 · Server: cột đồng bộ và /sync/pull](#p2-03)

**Tuần 8 · Đồng bộ và thời gian thực**
- [ ] [P2-04 · /sync/push và xử lý xung đột](#p2-04)
- [ ] [P2-05 · SyncEngine phía client](#p2-05)
- [ ] [P2-06 · SignalR hub và Redis backplane](#p2-06)
- [ ] [P2-07 · Test đồng bộ nhiều thiết bị](#p2-07)

**Tuần 9 · App MAUI**
- [ ] [P2-08 · Khung app MAUI, đăng nhập, SecureStorage](#p2-08)
- [ ] [P2-09 · Màn hình lịch, sự kiện, task trên mobile](#p2-09)

**Tuần 10 · Thông báo trên mobile**
- [ ] [P2-10 · Push qua FCM](#p2-10)
- [ ] [P2-11 · Thông báo cục bộ khi offline](#p2-11)
- [ ] [P2-12 · Job dọn bản ghi xóa mềm](#p2-12)

**Khác:** [Mục tiêu và cổng kiểm tra](#muc-tieu) · [Rủi ro](#rui-ro)

<a id="muc-tieu"></a>
## Mục tiêu và cổng kiểm tra

- **Phạm vi:** yêu cầu phi chức năng Offline và Thời gian thực, F09 (push mobile), app MAUI cho F03–F07.
- **Tổng ước tính:** khoảng 50 giờ.
- **Cổng kiểm tra:**
  - [ ] Tắt mạng, tạo/sửa/xóa trên desktop và mobile; bật mạng lại thì cả hai khớp nhau trong 5 giây
  - [ ] Hai thiết bị cùng sửa một sự kiện lúc offline: trường khác nhau được giữ cả hai, trường trùng thì bản sau thắng
  - [ ] Đang online, sửa trên máy này thì máy kia thấy trong 2 giây
  - [ ] Push và thông báo cục bộ tới đúng giờ, không bị báo trùng

---

## Tuần 7 · Lưu cục bộ và outbox

<a id="p2-01"></a>
### P2-01 · SQLite cục bộ trong Client.Core

- **Ước tính:** ~4h · **Chức năng:** – · **Phụ thuộc:** P1-08
- **Việc cần làm:** `LocalDbContext` (EF Core SQLite) với bảng Calendars, Events, EventExceptions, Tasks, Reminders, SyncState; repository đọc từ SQLite thay vì gọi API trực tiếp.
- **Xong khi:** mở app lúc mất mạng vẫn thấy dữ liệu đã tải trước đó.
- **File code:**
  [`src/Clients/WorkCal.Client.Core/Local/LocalDbContext.cs`](../../src/Clients/WorkCal.Client.Core/Local/LocalDbContext.cs) ·
  [`src/Clients/WorkCal.Client.Core/Local/Repositories/`](../../src/Clients/WorkCal.Client.Core/Local/Repositories/)
- **Tài liệu:** [architecture/offline-sync.md](../architecture/offline-sync.md)

<a id="p2-02"></a>
### P2-02 · Outbox và ghi cục bộ trước

- **Ước tính:** ~4h · **Chức năng:** – · **Phụ thuộc:** P2-01
- **Việc cần làm:** mọi thao tác ghi lưu vào SQLite và thêm một dòng `OutboxItem` (EntityType, EntityId, Operation, Payload, BaseVersion) trong cùng transaction; Id sinh ở client bằng Guid v7.
- **Xong khi:** tạo sự kiện lúc offline hiện ngay trên lịch và có trong outbox.
- **File code:**
  [`src/Clients/WorkCal.Client.Core/Local/Outbox/`](../../src/Clients/WorkCal.Client.Core/Local/Outbox/)
- **Tài liệu:** [architecture/offline-sync.md](../architecture/offline-sync.md)

<a id="p2-03"></a>
### P2-03 · Server: cột đồng bộ và /sync/pull

- **Ước tính:** ~4h · **Chức năng:** – · **Phụ thuộc:** P1-06
- **Việc cần làm:** đảm bảo mọi bảng đồng bộ có `Version` (rowversion), `UpdatedAt`, `IsDeleted`; `GET /sync/pull?since={cursor}` trả bản ghi đổi sau cursor (kể cả đã xóa mềm), phân trang, kèm cursor mới.
- **Xong khi:** gọi pull hai lần liên tiếp, lần thứ hai trả rỗng.
- **File code:**
  [`src/Server/WorkCal.Application/Features/Sync/Queries/Pull/`](../../src/Server/WorkCal.Application/Features/Sync/Queries/Pull/) ·
  [`src/Server/WorkCal.Api/Controllers/V1/SyncController.cs`](../../src/Server/WorkCal.Api/Controllers/V1/SyncController.cs) ·
  [`src/Server/WorkCal.Infrastructure/Persistence/Interceptors/SoftDeleteInterceptor.cs`](../../src/Server/WorkCal.Infrastructure/Persistence/Interceptors/SoftDeleteInterceptor.cs)
- **Tài liệu:** [api/sync-protocol.md](../api/sync-protocol.md)

---

## Tuần 8 · Đồng bộ và thời gian thực

<a id="p2-04"></a>
### P2-04 · /sync/push và xử lý xung đột

- **Ước tính:** ~5h · **Chức năng:** – · **Phụ thuộc:** P2-03
- **Việc cần làm:** nhận lô thay đổi; so `BaseVersion`: khớp thì ghi, lệch thì gộp theo trường (trường chỉ một bên sửa thì giữ, cùng sửa thì bản sau thắng); trả kết quả từng mục và bản cuối.
- **Xong khi:** test xung đột trên cùng trường và khác trường đều đúng.
- **File code:**
  [`src/Server/WorkCal.Application/Features/Sync/Commands/Push/`](../../src/Server/WorkCal.Application/Features/Sync/Commands/Push/) ·
  [`src/Server/WorkCal.Application/Features/Sync/ConflictResolver.cs`](../../src/Server/WorkCal.Application/Features/Sync/ConflictResolver.cs)
- **Tài liệu:** [api/sync-protocol.md](../api/sync-protocol.md)

<a id="p2-05"></a>
### P2-05 · SyncEngine phía client

- **Ước tính:** ~4h · **Chức năng:** – · **Phụ thuộc:** P2-02, P2-04
- **Việc cần làm:** theo dõi trạng thái mạng; push outbox rồi pull; thử lại có backoff; hiển thị trạng thái "Đã đồng bộ / Đang chờ".
- **Xong khi:** rút mạng giữa lúc đồng bộ, cắm lại thì hoàn tất mà không nhân đôi dữ liệu.
- **File code:**
  [`src/Clients/WorkCal.Client.Core/Sync/SyncEngine.cs`](../../src/Clients/WorkCal.Client.Core/Sync/SyncEngine.cs) ·
  [`src/Clients/WorkCal.Client.Core/Sync/ConnectivityMonitor.cs`](../../src/Clients/WorkCal.Client.Core/Sync/ConnectivityMonitor.cs)
- **Tài liệu:** [architecture/offline-sync.md](../architecture/offline-sync.md)

<a id="p2-06"></a>
### P2-06 · SignalR hub và Redis backplane

- **Ước tính:** ~3h · **Chức năng:** – · **Phụ thuộc:** P2-03
- **Việc cần làm:** `CalendarHub` tại `/hubs/calendar`, nhóm `user:{id}` và `tenant:{id}`; sau khi ghi thì phát `ChangesAvailable(cursor)`; client nhận thì gọi pull.
- **Xong khi:** hai cửa sổ WPF cùng tài khoản thấy thay đổi của nhau trong 2 giây.
- **File code:**
  [`src/Server/WorkCal.Api/Hubs/CalendarHub.cs`](../../src/Server/WorkCal.Api/Hubs/CalendarHub.cs) ·
  [`src/Clients/WorkCal.Client.Core/Sync/RealtimeClient.cs`](../../src/Clients/WorkCal.Client.Core/Sync/RealtimeClient.cs)
- **Tài liệu:** [api/realtime.md](../api/realtime.md)

<a id="p2-07"></a>
### P2-07 · Test đồng bộ nhiều thiết bị

- **Ước tính:** ~3h · **Chức năng:** – · **Phụ thuộc:** P2-05, P2-06
- **Việc cần làm:** test giả lập 2 client offline cùng sửa, xóa, tạo; kiểm tra trạng thái cuối giống nhau ở cả hai.
- **Xong khi:** bộ test chạy ổn định 10 lần liên tiếp.
- **File code:**
  [`tests/WorkCal.Client.Core.Tests/Sync/`](../../tests/WorkCal.Client.Core.Tests/Sync/) ·
  [`tests/WorkCal.Api.IntegrationTests/Sync/`](../../tests/WorkCal.Api.IntegrationTests/Sync/)
- **Tài liệu:** [testing/test-strategy.md](../testing/test-strategy.md)

---

## Tuần 9 · App MAUI

<a id="p2-08"></a>
### P2-08 · Khung app MAUI, đăng nhập, SecureStorage

- **Ước tính:** ~4h · **Chức năng:** – · **Phụ thuộc:** P2-05
- **Việc cần làm:** Shell với tab Lịch, Task, Tôi; dùng lại ViewModel từ Client.Core; `SecureStorageTokenStore`; chạy trên Android emulator (iOS cần máy Mac, để sau nếu chưa có).
- **Xong khi:** đăng nhập trên Android, dữ liệu đồng bộ từ desktop sang.
- **File code:**
  [`src/Clients/WorkCal.Mobile/MauiProgram.cs`](../../src/Clients/WorkCal.Mobile/MauiProgram.cs) ·
  [`src/Clients/WorkCal.Mobile/AppShell.xaml`](../../src/Clients/WorkCal.Mobile/AppShell.xaml) ·
  [`src/Clients/WorkCal.Mobile/Services/SecureStorageTokenStore.cs`](../../src/Clients/WorkCal.Mobile/Services/SecureStorageTokenStore.cs)
- **Tài liệu:** [guides/getting-started.md](../guides/getting-started.md)

<a id="p2-09"></a>
### P2-09 · Màn hình lịch, sự kiện, task trên mobile

- **Ước tính:** ~6h · **Chức năng:** F03, F04, F07 · **Phụ thuộc:** P2-08
- **Việc cần làm:** Syncfusion Scheduler MAUI (ngày, tuần, agenda); form sự kiện và task; vuốt để đánh dấu task xong.
- **Xong khi:** làm được mọi thao tác như desktop trừ kéo thả.
- **File code:**
  [`src/Clients/WorkCal.Mobile/Views/`](../../src/Clients/WorkCal.Mobile/Views/)
- **Tài liệu:** [user-manual/personal.md](../user-manual/personal.md)

---

## Tuần 10 · Thông báo trên mobile

<a id="p2-10"></a>
### P2-10 · Push qua FCM

- **Ước tính:** ~4h · **Chức năng:** F09 · **Phụ thuộc:** P2-08, P1-07
- **Việc cần làm:** project Firebase; `POST /devices` lưu token; `ReminderJob` gửi FCM HTTP v1 ngoài email; xử lý token hết hạn.
- **Xong khi:** điện thoại nhận push nhắc lịch khi app đang tắt.
- **File code:**
  [`src/Server/WorkCal.Infrastructure/Notifications/Fcm/`](../../src/Server/WorkCal.Infrastructure/Notifications/Fcm/) ·
  [`src/Server/WorkCal.Api/Controllers/V1/DevicesController.cs`](../../src/Server/WorkCal.Api/Controllers/V1/DevicesController.cs) ·
  [`src/Clients/WorkCal.Mobile/Platforms/Android/`](../../src/Clients/WorkCal.Mobile/Platforms/Android/)
- **Tài liệu:** [guides/deploy.md](../guides/deploy.md)

<a id="p2-11"></a>
### P2-11 · Thông báo cục bộ khi offline

- **Ước tính:** ~3h · **Chức năng:** F09 · **Phụ thuộc:** P2-10
- **Việc cần làm:** đặt local notification cho 7 ngày tới sau mỗi lần đồng bộ; ID cố định theo (EventId, thời điểm) để push và local không báo trùng.
- **Xong khi:** bật chế độ máy bay, nhắc vẫn tới đúng giờ và chỉ một lần.
- **File code:**
  [`src/Clients/WorkCal.Mobile/Services/LocalNotificationService.cs`](../../src/Clients/WorkCal.Mobile/Services/LocalNotificationService.cs)
- **Tài liệu:** [architecture/offline-sync.md](../architecture/offline-sync.md)

<a id="p2-12"></a>
### P2-12 · Job dọn bản ghi xóa mềm

- **Ước tính:** ~2h · **Chức năng:** – · **Phụ thuộc:** P2-03
- **Việc cần làm:** Hangfire job hằng đêm xóa hẳn bản ghi `IsDeleted` quá 30 ngày; client có cursor cũ hơn 30 ngày thì tải lại toàn bộ.
- **Xong khi:** có test cho cả hai trường hợp.
- **File code:**
  [`src/Server/WorkCal.Infrastructure/Jobs/PurgeSoftDeletedJob.cs`](../../src/Server/WorkCal.Infrastructure/Jobs/PurgeSoftDeletedJob.cs)
- **Tài liệu:** [api/sync-protocol.md](../api/sync-protocol.md)

---

<a id="rui-ro"></a>
## Rủi ro

| Rủi ro | Cách xử lý |
| --- | --- |
| Đồng bộ phức tạp hơn dự tính | Chốt giao thức trong `api/sync-protocol.md` trước khi code; nếu trễ quá 1 tuần thì ra mobile online trước |
| Không có máy Mac để build iOS | Làm Android trước, iOS dùng GitHub Actions macOS runner hoặc để sau v1.0 |
| FCM cấu hình rắc rối | Làm local notification trước, push sau |

[↑ Về đầu trang](#top) · [← Roadmap](README.md)
