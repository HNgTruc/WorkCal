# UC-03 · Làm việc khi mất mạng

[← use-cases](README.md)

- **Tác nhân:** người dùng có desktop và điện thoại.
- **Điều kiện trước:** đã đồng bộ ít nhất một lần trên cả hai thiết bị.

**Luồng chính**
1. Điện thoại mất mạng. Người dùng tạo task "Gọi khách hàng" và đổi giờ một sự kiện.
2. App ghi vào SQLite và thêm 2 dòng vào outbox; giao diện hiện "Đang chờ đồng bộ".
3. Có mạng lại: SyncEngine gửi outbox lên `/sync/push`, rồi gọi `/sync/pull`.
4. Server phát `ChangesAvailable` qua SignalR; desktop kéo thay đổi về.
5. Trong 5 giây, cả hai thiết bị hiện cùng dữ liệu.

**Luồng phụ**
- 3a. Desktop cũng đã sửa cùng sự kiện lúc điện thoại offline → server gộp theo trường: trường chỉ một bên sửa thì giữ, cùng sửa một trường thì bản sau thắng.
- 3b. Mạng chập chờn giữa lúc gửi → thử lại có backoff, không tạo bản ghi trùng (Id sinh ở client).

**Kết quả:** không mất dữ liệu, hai thiết bị khớp nhau.

**Liên kết:** [P2-02](../../roadmap/phase-2-offline-mobile.md#p2-02), [P2-04](../../roadmap/phase-2-offline-mobile.md#p2-04) · [offline-sync.md](../../architecture/offline-sync.md) · [sync-protocol.md](../../api/sync-protocol.md)
