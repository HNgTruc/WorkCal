# 0004 · Web quản trị bằng Blazor, gọi API qua HTTP

[← adr](README.md)

- **Trạng thái:** Đã chấp nhận
- **Ngày:** 2026-11-20

## Bối cảnh
Cần trang quản trị cho Super Admin (`/platform`) và quản trị công ty (`/org`), dùng được trên trình duyệt.

## Các lựa chọn
| Lựa chọn | Ưu | Nhược |
| --- | --- | --- |
| Blazor + MudBlazor | Toàn C#, component bảng/form sẵn | Interactive Server cần kết nối liên tục |
| React/Next.js | Hệ sinh thái lớn | Thêm ngôn ngữ, mất DTO dùng chung |
| Màn hình quản trị trong app WPF | Không thêm app | Không dùng được trên trình duyệt, Super Admin khó dùng |

## Quyết định
Blazor Web App (Interactive Server) + MudBlazor. WorkCal.Admin **gọi WorkCal.Api qua HTTP** như mọi client khác, không truy cập CSDL trực tiếp.

## Hệ quả
- Chỉ một lớp phân quyền (ở API) cho mọi client.
- Endpoint quản trị nằm dưới `/api/v1/admin/*` và `/api/v1/org/*`.
- Test bằng bUnit và Playwright.
