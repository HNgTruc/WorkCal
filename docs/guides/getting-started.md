<a id="top"></a>

# Bắt đầu

[← guides](README.md) · [Mục lục tài liệu](../README.md)

Chạy WorkCal trên máy trong khoảng 5 phút (chưa tính thời gian cài công cụ).

## Mục lục

- [Công cụ cần có](#cong-cu)
- [Chạy backend](#backend)
- [Chạy các ứng dụng](#ung-dung)
- [Dữ liệu demo](#demo)
- [Làm việc với Claude Code](#claude-code)

<a id="cong-cu"></a>
## Công cụ cần có

| Công cụ | Phiên bản | Dùng cho |
| --- | --- | --- |
| .NET SDK | 10 | Build mọi project, lệnh `dnx` cho NuGet MCP |
| Workload MAUI | theo .NET 10 | App mobile (`dotnet workload install maui`) |
| Android SDK | API 36 | Build app mobile; thiếu thì báo lỗi `XA5207` (lệnh cài ở dưới bảng) |
| Docker Desktop | mới nhất | SQL Server, Redis, Seq, SQL MCP Server |
| Visual Studio 2026 hoặc VS Code + C# Dev Kit | – | Viết code; WPF cần Windows |
| Node.js | LTS | Playwright MCP và test Playwright |
| PowerShell | 7+ | Script trong `scripts/` và hook `.claude/` |

Cài Android SDK API 36 (đường dẫn SDK mặc định của Visual Studio, thay `<user>`):

```powershell
dotnet build src/Clients/WorkCal.Mobile -t:InstallAndroidDependencies -f net10.0-android `
  "-p:AndroidSdkDirectory=C:\Users\<user>\AppData\Local\Android\Sdk" `
  "-p:AcceptAndroidSDKLicenses=True"
```

<a id="backend"></a>
## Chạy backend

Chạy trong PowerShell 7 (`pwsh`):

```powershell
git clone https://github.com/HNgTruc/WorkCal.git
cd WorkCal
Copy-Item .env.example .env          # mở .env, đổi 3 mật khẩu
docker compose up -d                 # sqlserver, redis, seq
docker compose ps                    # đợi cả 3 service báo (healthy)

# Chuỗi kết nối dev lưu bằng User Secrets, không ghi vào appsettings.json
$api = "src/Server/WorkCal.Api"
dotnet user-secrets set --project $api "ConnectionStrings:Default" "Server=127.0.0.1,14330;Database=WorkCal;User Id=sa;Password=<MSSQL_SA_PASSWORD>;TrustServerCertificate=true"
dotnet user-secrets set --project $api "ConnectionStrings:Redis" "127.0.0.1:6379,password=<REDIS_PASSWORD>"

dotnet ef database update --project src/Server/WorkCal.Infrastructure --startup-project src/Server/WorkCal.Api
dotnet run --project src/Server/WorkCal.Api
```

Mở `https://localhost:5001/scalar` để xem và gọi thử API (từ task P0-12); log ở Seq `http://localhost:5341`, đăng nhập `admin` bằng `SEQ_ADMIN_PASSWORD`, lần đầu Seq bắt đổi mật khẩu. Lệnh `dotnet ef database update` dùng được từ task P0-09.

| Service | Địa chỉ trên máy | Tài khoản |
| --- | --- | --- |
| SQL Server 2022 | `127.0.0.1,14330` | `sa` / `MSSQL_SA_PASSWORD` |
| Redis | `127.0.0.1:6379` | mật khẩu `REDIS_PASSWORD` |
| Seq | `http://localhost:5341` | `admin` / `SEQ_ADMIN_PASSWORD` |

Cổng SQL Server là 14330 để không đụng SQL Server cài sẵn trên máy. Mọi cổng chỉ mở cho `127.0.0.1` (IPv4), nên dùng `127.0.0.1` thay cho `localhost`: Windows thử `localhost` bằng IPv6 (`::1`) trước và bị từ chối. Dừng: `docker compose stop`; xóa sạch cả dữ liệu: `docker compose down -v`.

<a id="ung-dung"></a>
## Chạy các ứng dụng

| App | Lệnh |
| --- | --- |
| Desktop (Windows) | `dotnet run --project src/Clients/WorkCal.Desktop` |
| Mobile (Android emulator) | `dotnet build src/Clients/WorkCal.Mobile -t:Run -f net10.0-android` |
| Web quản trị | `dotnet run --project src/Clients/WorkCal.Admin` |
| MCP server (v1.1) | `dotnet run --project src/Server/WorkCal.Mcp` |

Địa chỉ API cho client đặt trong `appsettings.Development.json` của từng app.

<a id="demo"></a>
## Dữ liệu demo

```powershell
pwsh scripts/seed-demo-data.ps1
```

Tạo 1 công ty, 3 phòng ban, 10 người dùng (mật khẩu chung ghi trong output của script), lịch họp và đơn nghỉ mẫu.

<a id="claude-code"></a>
## Làm việc với Claude Code

1. Mở Claude Code ở gốc repo; `CLAUDE.md` và `.claude/` được nạp tự động.
2. Đặt biến `GITHUB_PAT`, chạy `/mcp` kiểm tra 5 MCP server ([dev-servers.md](../mcp/dev-servers.md)).
3. Mỗi lần làm: mở [roadmap](../roadmap/README.md) → chọn task → làm theo [quy trình](../roadmap/README.md#quy-trinh).

[↑ Về đầu trang](#top)
