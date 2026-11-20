# 0003 · Giữ backend ASP.NET Core, không chuyển sang Rust

[← adr](README.md)

- **Trạng thái:** Đã chấp nhận
- **Ngày:** 2026-11-20

## Bối cảnh
Đã cân nhắc viết backend bằng Rust (Axum, SQLx, PostgreSQL) vì hiệu năng và để làm điểm nhấn portfolio. Client vẫn là C#.

## Các lựa chọn
| Lựa chọn | Ưu | Nhược |
| --- | --- | --- |
| ASP.NET Core | Cùng ngôn ngữ với client, dùng chung DTO, có sẵn Identity, SignalR, Hangfire | Ít "mới lạ" hơn trên portfolio |
| Rust (Axum + SQLx) | Nhanh, ít RAM, an toàn bộ nhớ | Học dốc, không có SignalR/Identity/Hangfire, mất DTO dùng chung, thêm vài tuần |

## Quyết định
Giữ ASP.NET Core trên .NET 10.

## Hệ quả
- Dùng chung `WorkCal.Contracts` giữa server và client.
- Tiến độ roadmap giữ nguyên 24 tuần.
- Có thể thử Rust cho một service nhỏ, tách riêng, sau v1.1.
