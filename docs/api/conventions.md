<a id="top"></a>

# Quy ước API

[← api](README.md) · [Mục lục tài liệu](../README.md)

REST, JSON, tiền tố `/api/v1`, thời gian luôn là UTC theo ISO 8601. Lỗi trả theo ProblemDetails (RFC 9457). Tài liệu tương tác bằng Scalar tại `/scalar` ở môi trường dev.

## Mục lục

- [Quy ước chung](#chung)
- [Lỗi](#loi)
- [Phân trang, lọc, sắp xếp](#phan-trang)
- [Versioning](#versioning)
- [Nhóm endpoint](#nhom)

<a id="chung"></a>
## Quy ước chung

| Mục | Quy ước |
| --- | --- |
| URL | Danh từ số nhiều, chữ thường, gạch ngang: `/leave-requests`, `/shift-templates` |
| Phương thức | `GET` đọc, `POST` tạo hoặc hành động, `PUT` thay toàn bộ, `PATCH` sửa một phần, `DELETE` xóa |
| JSON | camelCase; enum dạng chuỗi |
| Thời gian | `2026-12-01T02:00:00Z`; kèm `timeZoneId` khi cần hiểu giờ địa phương |
| Id | GUID v7 dạng chuỗi |
| Đồng thời | Bản ghi có `version`; gửi lại trong `If-Match` khi sửa, lệch thì 412 |
| Idempotency | `POST` tạo mới nhận header `Idempotency-Key` để thử lại an toàn |

<a id="loi"></a>
## Lỗi

```json
{
  "type": "https://workcal.dev/errors/validation",
  "title": "Dữ liệu không hợp lệ",
  "status": 400,
  "traceId": "00-4bf92f...",
  "errors": { "endUtc": ["Giờ kết thúc phải sau giờ bắt đầu"] }
}
```

| Mã | Khi nào |
| --- | --- |
| 400 | Dữ liệu không hợp lệ |
| 401 | Chưa đăng nhập, token hết hạn |
| 403 | Không đủ quyền; tenant bị khóa; vượt giới hạn gói (`code: plan_limit_exceeded`) |
| 404 | Không tồn tại **hoặc thuộc tenant khác** (không phân biệt để không lộ thông tin) |
| 409 | Trùng (đặt phòng trùng giờ, email đã tồn tại) |
| 412 | `If-Match` lệch `version` |
| 429 | Vượt giới hạn tần suất |

Xử lý lỗi tập trung: [`ExceptionHandler.cs`](../../src/Server/WorkCal.Api/Middleware/ExceptionHandler.cs).

<a id="phan-trang"></a>
## Phân trang, lọc, sắp xếp

- Danh sách dùng `?page=1&pageSize=50` (tối đa 200), trả `{ items, page, pageSize, totalCount }`.
- Dữ liệu theo thời gian dùng khoảng: `?from=&to=` (bắt buộc, tối đa 92 ngày với `/events`).
- Sắp xếp: `?sort=startUtc` hoặc `?sort=-createdAt`.

<a id="versioning"></a>
## Versioning

Phiên bản trong đường dẫn (`/api/v1`). Thay đổi phá vỡ tương thích thì mở `/api/v2` và giữ v1 ít nhất 6 tháng, vì app desktop và mobile cũ vẫn còn chạy.

<a id="nhom"></a>
## Nhóm endpoint

| Nhóm | Tiền tố | Controller |
| --- | --- | --- |
| Xác thực | `/auth` | [`V1/AuthController.cs`](../../src/Server/WorkCal.Api/Controllers/V1/AuthController.cs) |
| Lịch con | `/calendars` | [`V1/CalendarsController.cs`](../../src/Server/WorkCal.Api/Controllers/V1/CalendarsController.cs) |
| Sự kiện | `/events` | [`V1/EventsController.cs`](../../src/Server/WorkCal.Api/Controllers/V1/EventsController.cs) |
| Task | `/tasks` | [`V1/TasksController.cs`](../../src/Server/WorkCal.Api/Controllers/V1/TasksController.cs) |
| Free/busy | `/availability` | [`V1/`](../../src/Server/WorkCal.Api/Controllers/V1/) |
| Tài nguyên | `/resources` | [`V1/`](../../src/Server/WorkCal.Api/Controllers/V1/) |
| Ca, nghỉ phép, duyệt, chấm công | `/shifts`, `/leave-requests`, `/approvals`, `/attendance` | [`V1/`](../../src/Server/WorkCal.Api/Controllers/V1/) |
| Đồng bộ | `/sync` | [`V1/SyncController.cs`](../../src/Server/WorkCal.Api/Controllers/V1/SyncController.cs) |
| Thiết bị | `/devices` | [`V1/DevicesController.cs`](../../src/Server/WorkCal.Api/Controllers/V1/DevicesController.cs) |
| Quản trị công ty | `/org/*` | [`Org/`](../../src/Server/WorkCal.Api/Controllers/Org/) |
| Quản trị nền tảng | `/admin/*` | [`Admin/`](../../src/Server/WorkCal.Api/Controllers/Admin/) |
| Công khai | `/public/*` | [`Public/`](../../src/Server/WorkCal.Api/Controllers/Public/) |

Danh sách đầy đủ: [openapi.json](openapi.json).

[↑ Về đầu trang](#top)
