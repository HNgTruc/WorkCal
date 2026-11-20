<a id="top"></a>

# Giao thức đồng bộ

[← api](README.md) · [Mục lục tài liệu](../README.md)

Hai endpoint cho client offline: `POST /sync/push` gửi thay đổi trong outbox, `GET /sync/pull` kéo thay đổi từ server theo cursor. Thiết kế tổng thể: [architecture/offline-sync.md](../architecture/offline-sync.md).

## Mục lục

- [Bảng được đồng bộ](#bang)
- [POST /sync/push](#push)
- [GET /sync/pull](#pull)
- [Mã kết quả từng mục](#ma-ket-qua)

<a id="bang"></a>
## Bảng được đồng bộ

`calendars`, `calendarShares`, `events`, `eventExceptions`, `eventAttendees`, `tasks`, `reminders`, `shiftAssignments`. Các bảng khác client đọc qua API thường.

<a id="push"></a>
## POST /sync/push

```http
POST /api/v1/sync/push
Authorization: Bearer <token>

{
  "deviceId": "0193...",
  "changes": [
    {
      "outboxId": 41,
      "entity": "events",
      "id": "0193a7c2-...",
      "op": "update",
      "baseVersion": "AAAAAAAAB9E=",
      "fields": { "startUtc": "2026-12-03T07:00:00Z", "endUtc": "2026-12-03T08:00:00Z" }
    }
  ]
}
```

```json
{
  "results": [
    {
      "outboxId": 41,
      "status": "merged",
      "record": { "id": "0193a7c2-...", "version": "AAAAAAAAB9I=", "title": "Họp nhóm", "startUtc": "2026-12-03T07:00:00Z" }
    }
  ],
  "cursor": "AAAAAAAAB9I="
}
```

- Tối đa 100 mục một lần; xử lý theo thứ tự `outboxId`.
- Mỗi mục độc lập: một mục lỗi không làm hỏng cả lô.
- `op` là `create`, `update` hoặc `delete`; `create` dùng Id sinh ở client.

<a id="pull"></a>
## GET /sync/pull

```http
GET /api/v1/sync/pull?since=AAAAAAAAB9E=&limit=500
```

```json
{
  "changes": {
    "events": [ { "id": "...", "version": "...", "isDeleted": false } ],
    "tasks":  [ { "id": "...", "version": "...", "isDeleted": true } ]
  },
  "cursor": "AAAAAAAAB+A=",
  "hasMore": false,
  "fullResyncRequired": false
}
```

- Không có `since` hoặc `since` cũ hơn 30 ngày → `fullResyncRequired: true`, client xóa dữ liệu cục bộ và tải lại.
- `hasMore: true` → gọi tiếp với `cursor` vừa nhận.

<a id="ma-ket-qua"></a>
## Mã kết quả từng mục

| status | Ý nghĩa | Client làm gì |
| --- | --- | --- |
| `applied` | Ghi thẳng, không xung đột | Xóa mục outbox, ghi `record` |
| `merged` | Có xung đột, đã gộp theo trường | Xóa mục outbox, ghi đè bằng `record` |
| `deleted` | Bản ghi đã bị xóa ở server | Xóa cục bộ, báo người dùng nếu họ vừa sửa |
| `rejected` | Không hợp lệ hoặc không đủ quyền (kèm `error`) | Xóa mục outbox, hoàn tác cục bộ, báo người dùng |
| `retry` | Lỗi tạm thời | Giữ mục, thử lại sau |

Code: [`Features/Sync/`](../../src/Server/WorkCal.Application/Features/Sync/) · [`SyncController.cs`](../../src/Server/WorkCal.Api/Controllers/V1/SyncController.cs) · Task: [P2-03](../roadmap/phase-2-offline-mobile.md#p2-03), [P2-04](../roadmap/phase-2-offline-mobile.md#p2-04)

[↑ Về đầu trang](#top)
