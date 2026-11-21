# 0008 · Xác thực dùng bảng Users tự thiết kế, không dùng đầy đủ ASP.NET Core Identity

[← adr](README.md)

- **Trạng thái:** Đã chấp nhận
- **Ngày:** 2026-11-21

## Bối cảnh
Một người có một tài khoản nhưng thuộc nhiều tenant với vai trò khác nhau (`Memberships`). Token mang tenant đang chọn (`tid`, `role`). Bảng `Users` trong [data-dictionary.md](../../database/data-dictionary.md#tai-khoan) đã thiết kế riêng, trong khi [overview.md](../overview.md#tech-stack) ghi "ASP.NET Core Identity". Cần chốt trước P0-09.

## Các lựa chọn
| Lựa chọn | Ưu | Nhược |
| --- | --- | --- |
| Bảng `Users` tự thiết kế, chỉ dùng `PasswordHasher<User>` của Identity Core, token email tự quản | Schema gọn, khớp mô hình nhiều tenant; kiểm soát rõ luồng token | Tự viết khóa tài khoản, token xác thực email và đặt lại mật khẩu |
| Đầy đủ ASP.NET Core Identity (`IdentityUser`, bảng `AspNet*`) | Có sẵn lockout, token provider, 2FA | Thêm 7 bảng `AspNet*` không theo quy ước (GUID v7, tên bảng); vai trò của Identity là toàn cục, không theo tenant |

## Quyết định
Giữ bảng `Users` tự thiết kế. Hash mật khẩu bằng `PasswordHasher<User>` (package `Microsoft.Extensions.Identity.Core`). Token xác thực email và đặt lại mật khẩu lưu dạng hash trong bảng `UserTokens`, dùng một lần, có hạn. Khóa tài khoản bằng `AccessFailedCount` và `LockoutEndUtc`. Access token JWT do server tự cấp.

## Hệ quả
- Thêm bảng `UserTokens` và hai cột lockout vào `Users` ([data-dictionary.md](../../database/data-dictionary.md#tai-khoan)).
- TOTP (P4-02) tự viết trên cùng bảng `Users` (`TwoFactorEnabled`) cùng bảng lưu bí mật và mã dự phòng, thiết kế khi làm P4-02.
- Đăng nhập Google và SSO (F02b, F34) dùng middleware OAuth/OIDC của ASP.NET Core rồi ánh xạ vào `Users`, không cần Identity đầy đủ.
