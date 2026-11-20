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
| Docker Desktop | mới nhất | SQL Server, Redis, Seq, SQL MCP Server |
| Visual Studio 2026 hoặc VS Code + C# Dev Kit | – | Viết code; WPF cần Windows |
| Node.js | LTS | Playwright MCP và test Playwright |
| PowerShell | 7+ | Script trong `scripts/` và hook `.claude/` |

<a id="backend"></a>
## Chạy backend

```bash
git clone https://github.com/<tai-khoan>/WorkCal.git
cd WorkCal
cp .env.example .env                 # điền mật khẩu SQL Server dev
docker compose up -d                 # sqlserver, redis, seq, sql-mcp

cd src/Server/WorkCal.Api
dotnet user-secrets set "ConnectionStrings:Default" "Server=localhost,1433;Database=WorkCal;User Id=sa;Password=<mat-khau>;TrustServerCertificate=true"
cd ../../..
dotnet ef database update --project src/Server/WorkCal.Infrastructure --startup-project src/Server/WorkCal.Api
dotnet run --project src/Server/WorkCal.Api
```

Mở `https://localhost:5001/scalar` để xem và gọi thử API; log ở Seq `http://localhost:5341`.

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
