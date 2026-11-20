<a id="top"></a>

# Xác thực và phân quyền

[← api](README.md) · [Mục lục tài liệu](../README.md)

Người dùng đăng nhập bằng email/mật khẩu (hoặc Google, SSO), nhận **access token JWT 15 phút** và **refresh token 30 ngày**. Token gắn với một tenant; đổi tenant thì xin token mới.

## Mục lục

- [Luồng đăng nhập](#luong)
- [Nội dung access token](#token)
- [Refresh token](#refresh)
- [Đổi tenant](#doi-tenant)
- [Xác thực 2 bước](#2fa)
- [Google và SSO](#sso)
- [API key](#api-key)
- [Lưu token trên client](#luu-token)

<a id="luong"></a>
## Luồng đăng nhập

| Endpoint | Mô tả |
| --- | --- |
| `POST /auth/register` | Tạo User, tenant `Personal`, Membership Owner, lịch "Cá nhân" |
| `POST /auth/login` | Trả `accessToken`, `refreshToken`, danh sách tenant của người dùng |
| `POST /auth/refresh` | Đổi refresh token cũ lấy cặp token mới |
| `POST /auth/logout` | Thu hồi refresh token hiện tại |
| `POST /auth/switch-tenant` | Cấp token mới cho tenant khác |
| `POST /auth/forgot-password`, `POST /auth/reset-password` | Quên mật khẩu qua email |

Khóa tài khoản 15 phút sau 5 lần sai mật khẩu. `/auth/*` có giới hạn tần suất chặt hơn các endpoint khác.

<a id="token"></a>
## Nội dung access token

| Claim | Ý nghĩa |
| --- | --- |
| `sub` | UserId |
| `tid` | TenantId đang chọn |
| `role` | Vai trò trong tenant đó |
| `dept` | DepartmentId (nếu có) |
| `plat` | `true` nếu là Super Admin |
| `impersonator` | UserId của Super Admin khi đang đăng nhập thay |

<a id="refresh"></a>
## Refresh token

- Lưu dạng hash trong bảng `RefreshTokens`, cùng `FamilyId`.
- Mỗi lần dùng thì cấp token mới và đánh dấu token cũ đã thay (**xoay vòng**).
- Token đã thay mà bị dùng lại → coi là bị lộ, thu hồi cả họ (`FamilyId`), người dùng phải đăng nhập lại.

<a id="doi-tenant"></a>
## Đổi tenant

```http
POST /api/v1/auth/switch-tenant
Authorization: Bearer <token hiện tại>

{ "tenantId": "0193..." }
```

Server kiểm tra người dùng là thành viên và tenant chưa bị khóa, trả cặp token mới có `tid` mới. Client xóa dữ liệu cục bộ của tenant cũ khỏi bộ nhớ hiển thị (SQLite giữ riêng theo tenant).

<a id="2fa"></a>
## Xác thực 2 bước

TOTP (Google Authenticator, Microsoft Authenticator) kèm 10 mã dự phòng. Bắt buộc với Super Admin; Owner có thể bắt buộc cho cả công ty. Task: [P4-02](../roadmap/phase-4-admin-v1.md#p4-02).

<a id="sso"></a>
## Google và SSO

- Đăng nhập Google qua OAuth cho người dùng cá nhân (F02).
- SSO doanh nghiệp qua OpenID Connect với Microsoft Entra ID hoặc Google Workspace (F34). Owner cấu hình trong `/org/settings`; email cùng tên miền tự vào đúng tenant.

Code: [`Infrastructure/Identity/`](../../src/Server/WorkCal.Infrastructure/Identity/).

<a id="api-key"></a>
## API key

Cho hệ thống ngoài (HRM, ERP) gọi API thay mặt công ty. Gửi qua header `X-Api-Key`; chỉ lưu hash; có `Scopes` (ví dụ `events:read`, `leaves:write`) và hạn dùng. Task: [P5-09](../roadmap/phase-5-doanh-nghiep-mo-rong.md#p5-09).

<a id="luu-token"></a>
## Lưu token trên client

| Client | Nơi lưu |
| --- | --- |
| Desktop WPF | DPAPI (`ProtectedData`): [`DpapiTokenStore.cs`](../../src/Clients/WorkCal.Desktop/Services/DpapiTokenStore.cs) |
| Mobile MAUI | `SecureStorage` (Keychain/Keystore): [`SecureStorageTokenStore.cs`](../../src/Clients/WorkCal.Mobile/Services/SecureStorageTokenStore.cs) |
| Web quản trị | Cookie HttpOnly, Secure, SameSite=Strict |

[↑ Về đầu trang](#top)
