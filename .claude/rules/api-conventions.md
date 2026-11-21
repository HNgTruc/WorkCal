---
paths:
  - "src/Server/WorkCal.Api/**"
  - "src/Shared/WorkCal.Contracts/**"
  - "src/Clients/WorkCal.Client.Core/Api/**"
---

# Rule: Quy ước API

Nguồn sự thật: [docs/api/conventions.md](../../docs/api/conventions.md) · xác thực: [authentication.md](../../docs/api/authentication.md) · đồng bộ: [sync-protocol.md](../../docs/api/sync-protocol.md).

## Bắt buộc

- Tiền tố `/api/v1`; URL danh từ số nhiều, chữ thường, gạch ngang (`/leave-requests`). Quản trị công ty ở `/org/*`, nền tảng ở `/admin/*`, công khai ở `/public/*`.
- JSON camelCase, enum dạng chuỗi, Id là GUID v7 dạng chuỗi.
- Thời gian là UTC ISO 8601 (`2026-12-01T02:00:00Z`), kèm `timeZoneId` khi cần giờ địa phương. Sự kiện cả ngày gửi `startDate`/`endDate` dạng `YYYY-MM-DD`, `endDate` không tính.
- Lỗi trả ProblemDetails (RFC 9457) qua `ExceptionHandler`; không tự dựng JSON lỗi trong controller. Mã lỗi theo bảng trong conventions.md (thuộc tenant khác → 404; vượt gói → 403 kèm `code: plan_limit_exceeded`; lệch `version` → 412).
- Sửa bản ghi đồng bộ dùng `If-Match` với `version`; `POST` tạo mới nhận `Idempotency-Key`.
- Danh sách phân trang `page`/`pageSize` (tối đa 200), trả `{ items, page, pageSize, totalCount }`; dữ liệu theo thời gian bắt buộc `from`/`to`.
- Endpoint mới: có `[Authorize]` với policy theo vai trò ([roles-permissions.md](../../docs/requirements/roles-permissions.md)), có mô tả OpenAPI, có integration test và có mặt trong bộ test `TenantIsolation`.

## Thay đổi phá vỡ tương thích

Đổi tên trường, bỏ trường, đổi nghĩa trong DTO hay giao thức `/sync` làm app desktop và mobile cũ hỏng. Phải hỏi chủ dự án trước; nếu làm thì mở `/api/v2`, giữ v1 tối thiểu 6 tháng, commit dùng `!` và footer `BREAKING CHANGE:`.

## Hỏi trước

Endpoint không có trong task đang làm (quy tắc 3).
