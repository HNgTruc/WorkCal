<a id="top"></a>

# Lỗi hay gặp

[← guides](README.md) · [Mục lục tài liệu](../README.md)

Ghi thêm mỗi khi gặp lỗi mất hơn 15 phút để sửa.

## Mục lục

- [Môi trường](#moi-truong)
- [Backend](#backend)
- [Client](#client)
- [Claude Code và MCP](#claude)

<a id="moi-truong"></a>
## Môi trường

| Triệu chứng | Nguyên nhân thường gặp | Cách sửa |
| --- | --- | --- |
| Container SQL Server tắt ngay sau khi chạy | Mật khẩu `sa` không đủ mạnh | Đặt `MSSQL_SA_PASSWORD` ≥ 8 ký tự, có chữ hoa, chữ thường, số, ký tự đặc biệt trong `.env`, rồi `docker compose down -v` và `up -d` lại |
| `docker compose up` báo `Thiếu ... trong .env` | Chưa tạo `.env` | `Copy-Item .env.example .env`, đổi mật khẩu |
| Đổi mật khẩu trong `.env` nhưng SQL Server hoặc Seq vẫn dùng mật khẩu cũ | Mật khẩu chỉ áp dụng lúc tạo dữ liệu lần đầu, đã lưu trong volume | `docker compose down -v` (xóa dữ liệu dev) rồi `up -d` |
| Kết nối SQL Server báo lỗi 1225 *The remote computer refused the network connection* dù container `healthy` | Dùng `localhost`: Windows thử IPv6 `::1` trước, còn Docker chỉ mở cổng cho `127.0.0.1` | Dùng `127.0.0.1,14330` (dấu phẩy) thay cho `localhost` |
| Build app mobile lỗi `XA5207` | Thiếu Android SDK API 36 | Chạy lệnh cài trong [getting-started](getting-started.md#cong-cu) |
| Integration test báo không kết nối được Docker | Docker Desktop chưa chạy | Mở Docker Desktop rồi chạy lại `dotnet test` |
| `dnx` không tồn tại | Chưa có .NET 10 SDK | Cài .NET 10 SDK, mở lại terminal |

<a id="backend"></a>
## Backend

| Triệu chứng | Nguyên nhân thường gặp | Cách sửa |
| --- | --- | --- |
| Truy vấn trả rỗng dù có dữ liệu | Thiếu `SESSION_CONTEXT` (RLS) hoặc sai `tid` | Kiểm tra `SessionContextInterceptor` đã đăng ký; giải mã token xem `tid` |
| Sự kiện lặp lệch 1 giờ | Dùng `TimeZoneInfo` thay vì NodaTime, hoặc thiếu `TimeZoneId` | Xem [recurrence-timezone.md](../architecture/recurrence-timezone.md#mui-gio) |
| Lời nhắc không gửi | Hangfire server chưa chạy hoặc job lỗi | Mở Hangfire dashboard (dev), xem tab Failed |

<a id="client"></a>
## Client

| Triệu chứng | Nguyên nhân thường gặp | Cách sửa |
| --- | --- | --- |
| Android emulator không gọi được API localhost | Emulator coi `localhost` là chính nó | Dùng `10.0.2.2` thay cho `localhost` |
| Thay đổi không đồng bộ giữa hai máy | Outbox kẹt mục lỗi `rejected` liên tục | Xem bảng outbox trong SQLite, đọc `LastError` |
| Syncfusion hiện cảnh báo bản quyền | Chưa đăng ký license key | Gọi `SyncfusionLicenseProvider.RegisterLicense` lúc khởi động |

<a id="claude"></a>
## Claude Code và MCP

| Triệu chứng | Nguyên nhân thường gặp | Cách sửa |
| --- | --- | --- |
| Server `github` không kết nối | Thiếu hoặc hết hạn `GITHUB_PAT` | Tạo token mới, mở lại terminal |
| Hook không chạy | Chưa cài PowerShell 7 hoặc chưa cho phép chạy script | Cài `pwsh`, kiểm tra `.claude/settings.json` |
| `workcal-sql` báo lỗi | Container `sql-mcp` chưa chạy | `docker compose up -d sql-mcp`, xem log container |

[↑ Về đầu trang](#top)
