# adr

[← architecture](../README.md)

## Mục đích
Ghi lại các quyết định kiến trúc (Architecture Decision Record): bối cảnh, lựa chọn đã cân nhắc, quyết định và hệ quả. Đọc lại để biết **vì sao** code như hiện tại.

## Nội dung chính
| Số | Quyết định | Trạng thái |
| --- | --- | --- |
| [0001](0001-wpf-va-maui.md) | Desktop dùng WPF, mobile dùng .NET MAUI, chung Client.Core | Đã chấp nhận |
| [0002](0002-csdl-chung-tenantid.md) | Multi-tenant bằng CSDL chung + cột TenantId + RLS | Đã chấp nhận |
| [0003](0003-giu-aspnet-core-thay-rust.md) | Giữ backend ASP.NET Core, không chuyển sang Rust | Đã chấp nhận |
| [0004](0004-blazor-cho-web-quan-tri.md) | Web quản trị bằng Blazor, gọi API qua HTTP | Đã chấp nhận |

Mẫu trống: [template.md](template.md).

## Quy ước và lưu ý
- Đánh số tăng dần, không dùng lại số. Tên file `NNNN-ten-ngan.md`.
- Không sửa nội dung ADR đã chấp nhận; muốn đổi thì viết ADR mới và đổi trạng thái ADR cũ thành "Bị thay bởi NNNN".
