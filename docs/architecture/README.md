<a id="top"></a>

# architecture

[← Mục lục tài liệu](../README.md)

## Mục đích
Giải thích WorkCal được ghép từ những phần nào, dữ liệu chạy qua đâu, và vì sao chọn cách làm đó.

## Nội dung chính
| File / thư mục | Vai trò |
| --- | --- |
| [overview.md](overview.md) | Sơ đồ tổng thể, các tầng backend, tech stack |
| [multi-tenant.md](multi-tenant.md) | Mô hình tenant, lọc tự động, Row-Level Security |
| [offline-sync.md](offline-sync.md) | Lưu cục bộ, outbox, đồng bộ, xử lý xung đột |
| [recurrence-timezone.md](recurrence-timezone.md) | Lịch lặp, ngoại lệ, múi giờ |
| [diagrams/](diagrams/README.md) | File gốc của các sơ đồ (mermaid) |
| [adr/](adr/README.md) | Quyết định kiến trúc, mỗi quyết định một file |

## Phụ thuộc
Được dùng bởi: mọi task trong [roadmap](../roadmap/README.md). Chi tiết bảng xem [database](../database/README.md), chi tiết endpoint xem [api](../api/README.md).

## Quy ước và lưu ý
Quyết định nào khó đảo ngược (đổi thư viện, đổi CSDL, đổi mô hình tenant) phải có ADR trước khi code.

## Cập nhật lần cuối
2026-11-20 – tạo từ tài liệu thiết kế.
