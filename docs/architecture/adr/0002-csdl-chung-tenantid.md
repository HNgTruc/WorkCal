# 0002 · Multi-tenant bằng CSDL chung + cột TenantId + RLS

[← adr](README.md)

- **Trạng thái:** Đã chấp nhận
- **Ngày:** 2026-11-20

## Bối cảnh
Hệ thống phục vụ cả người dùng cá nhân và nhiều doanh nghiệp nhỏ. Dữ liệu các công ty không được lẫn vào nhau; chi phí vận hành phải thấp.

## Các lựa chọn
| Lựa chọn | Ưu | Nhược |
| --- | --- | --- |
| CSDL chung + TenantId | Rẻ, một migration, dễ báo cáo toàn hệ thống | Cách ly dựa vào code, cần nhiều lớp bảo vệ |
| Schema riêng mỗi tenant | Cách ly tốt hơn | Migration lặp theo số tenant, khó vận hành |
| CSDL riêng mỗi tenant | Cách ly mạnh nhất | Đắt, quản lý hàng nghìn CSDL |

## Quyết định
CSDL chung, mọi bảng nghiệp vụ có `TenantId`. Hai lớp bảo vệ: global query filter của EF Core và Row-Level Security của SQL Server; thêm bộ test cách ly tự quét mọi endpoint.

## Hệ quả
- Mọi entity mới phải implement `ITenantEntity`; index bắt đầu bằng `TenantId`.
- Đọc chéo tenant chỉ được phép trong module Platform, có audit.
- Có đường nâng cấp sang CSDL riêng cho khách lớn sau này. Chi tiết: [multi-tenant.md](../multi-tenant.md).
