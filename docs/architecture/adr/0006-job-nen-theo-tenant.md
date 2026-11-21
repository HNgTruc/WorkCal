# 0006 · Job nền chạy lần lượt từng tenant

[← adr](README.md)

- **Trạng thái:** Đã chấp nhận
- **Ngày:** 2026-11-21

## Bối cảnh
Job Hangfire (lời nhắc, dọn xóa mềm, cộng phép năm) phải xử lý dữ liệu mọi tenant nhưng không có request nên không có tenant. Query filter và RLS sẽ trả 0 dòng nếu không đặt tenant.

## Các lựa chọn
| Lựa chọn | Ưu | Nhược |
| --- | --- | --- |
| Job dùng quyền Platform (`IsPlatform=1`, `IgnoreQueryFilters()`) | Một truy vấn cho mọi tenant, nhanh | Mở ngoại lệ Platform ra ngoài `Features/Platform/`; lỗi code job có thể ghi nhầm tenant |
| Job chạy lần lượt từng tenant với `ITenantContext` riêng | Giữ nguyên hai lớp cách ly | Vòng lặp theo số tenant, chậm hơn khi có nhiều tenant |

## Quyết định
Job lấy danh sách tenant qua `ITenantDirectory` (thuộc `Features/Platform/`), rồi với mỗi tenant mở DI scope mới, đặt `ITenantContext` và `SESSION_CONTEXT` như một request thường.

## Hệ quả
- Có base class `TenantJobBase` cho mọi job theo tenant.
- Lỗi ở một tenant không chặn tenant khác.
- Khi số tenant lớn có thể chia lô mà không đổi mô hình cách ly. Chi tiết: [multi-tenant.md](../multi-tenant.md#job-nen).
