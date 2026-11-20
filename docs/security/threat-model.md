<a id="top"></a>

# Mô hình nguy cơ

[← security](README.md) · [Mục lục tài liệu](../README.md)

Liệt kê nguy cơ theo nhóm, mỗi dòng có cách chặn và nơi thực thi trong code. Cập nhật khi thêm tính năng có dữ liệu nhạy cảm hoặc endpoint công khai.

## Mục lục

- [Tài sản cần bảo vệ](#tai-san)
- [Nguy cơ và cách chặn](#nguy-co)
- [Bí mật và cấu hình](#bi-mat)
- [Checklist trước khi merge](#checklist)

<a id="tai-san"></a>
## Tài sản cần bảo vệ

Lịch và nội dung cuộc họp, thông tin nhân sự (nghỉ phép, chấm công, vị trí GPS), tài khoản người dùng, quyền Super Admin, khóa tích hợp (webhook secret, API key, FCM).

<a id="nguy-co"></a>
## Nguy cơ và cách chặn

| Nguy cơ | Mức | Cách chặn | Nơi thực thi |
| --- | --- | --- | --- |
| Đọc dữ liệu tenant khác | Cao | Query filter + RLS + test tự quét endpoint; trả 404 thay vì 403 | [tenant-isolation.md](tenant-isolation.md) |
| Leo quyền trong tenant | Cao | Policy theo vai trò ở API, kiểm tra phạm vi phòng ban ở Application | [roles-permissions.md](../requirements/roles-permissions.md) |
| Dò mật khẩu | Trung bình | Khóa 15 phút sau 5 lần sai, rate limit `/auth/*`, PBKDF2 | [authentication.md](../api/authentication.md) |
| Lộ refresh token | Cao | Xoay vòng, thu hồi cả họ khi dùng lại, lưu hash | [`Infrastructure/Identity/`](../../src/Server/WorkCal.Infrastructure/Identity/) |
| Lạm dụng đăng nhập thay | Cao | Chỉ Super Admin, bắt buộc lý do, token ngắn hạn, banner, audit mọi request | [P4-05](../roadmap/phase-4-admin-v1.md#p4-05) |
| Chấm công gian lận (chụp QR, giả GPS) | Trung bình | QR đổi mỗi 30 giây; GPS chỉ là phương án phụ, đánh dấu để HR xem | [P5-03](../roadmap/phase-5-doanh-nghiep-mo-rong.md#p5-03) |
| Spam trang đặt hẹn công khai | Trung bình | Rate limit theo IP, CAPTCHA, giới hạn số lịch mỗi ngày | [P5-08](../roadmap/phase-5-doanh-nghiep-mo-rong.md#p5-08) |
| Giả mạo webhook | Trung bình | Ký HMAC-SHA256 với secret riêng, kèm timestamp chống phát lại | [P5-09](../roadmap/phase-5-doanh-nghiep-mo-rong.md#p5-09) |
| Trợ lý AI làm quá quyền | Trung bình | Tool chạy bằng quyền người dùng, rate limit, audit nguồn `mcp` | [workcal-mcp-tools.md](../mcp/workcal-mcp-tools.md) |
| Token lưu trên máy bị đánh cắp | Trung bình | DPAPI trên Windows, SecureStorage trên mobile | [authentication.md](../api/authentication.md#luu-token) |
| Lỗ hổng trong package | Trung bình | Dependabot, NuGet MCP kiểm tra trước khi thêm package | [dev-servers.md](../mcp/dev-servers.md) |
| XSS, CSRF trên web quản trị | Trung bình | Blazor tự mã hóa đầu ra; cookie SameSite=Strict; chống CSRF mặc định | [`WorkCal.Admin/`](../../src/Clients/WorkCal.Admin/) |

<a id="bi-mat"></a>
## Bí mật và cấu hình

- Dev: User Secrets; Production: biến môi trường hoặc Azure Key Vault.
- Không commit `.env`, `appsettings.Production.json` có giá trị thật, file `.pfx`; hook [`guard-secrets`](../../.claude/hooks/) chặn Claude Code sửa các file này.
- Bật GitHub secret scanning và push protection.
- Cột nhạy cảm (`QrSecret`, webhook `Secret`) mã hóa bằng Data Protection trước khi lưu.

<a id="checklist"></a>
## Checklist trước khi merge

- [ ] Endpoint mới có policy phân quyền và có trong bộ test cách ly tenant
- [ ] Không log dữ liệu nhạy cảm (mật khẩu, token, tọa độ GPS chi tiết)
- [ ] Input có validator; output không lộ trường không cần
- [ ] Hành động quản trị có ghi audit
- [ ] Đã chạy agent `security-auditor` với thay đổi lớn

[↑ Về đầu trang](#top)
