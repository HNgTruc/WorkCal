# WorkCal

> **English summary.** WorkCal is a work-schedule management system for individuals and businesses: a Windows desktop app (WPF), an Android/iOS app (.NET MAUI), a Blazor admin portal and an MCP server for AI assistants, all served by one ASP.NET Core backend on .NET 10. Many companies share one SQL Server database, isolated by `TenantId` and Row-Level Security; client apps keep working offline and sync through an outbox. The project is in early development (phase 0 of 6). Documentation is written in Vietnamese.

[![CI](https://github.com/HNgTruc/WorkCal/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/HNgTruc/WorkCal/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Mục đích
Hệ thống quản lý lịch làm việc cho người dùng cá nhân và doanh nghiệp. Người dùng lập, chia sẻ và đồng bộ lịch trên Windows và điện thoại; doanh nghiệp có không gian riêng để mời nhân viên, chia phòng ban, xem lịch rảnh, đặt lịch họp, duyệt nghỉ phép, và một web quản trị riêng. Dự án cá nhân, làm theo quy trình như sản phẩm thật: tài liệu thiết kế, roadmap, test, CI.

## Trạng thái
Đang ở **giai đoạn 0 · Nền móng** (repo, công cụ, khung solution). Bản 1.0 dự kiến ở tuần 18, bản 1.1 ở tuần 24. Tiến độ từng task: [docs/roadmap/README.md](docs/roadmap/README.md).

## Tính năng chính
| Nhóm | Bản 1.0 | Bản 1.1 |
| --- | --- | --- |
| Lịch cá nhân | Sự kiện, lịch lặp, múi giờ, task, lời nhắc (push, email, desktop) | |
| Làm việc offline | Xem, tạo, sửa khi mất mạng; tự đồng bộ khi có mạng lại | |
| Doanh nghiệp | Tenant riêng, mời thành viên, phòng ban, 6 vai trò, free/busy, đặt phòng họp, nghỉ phép | Ca làm việc, chấm công QR/GPS, báo cáo, SSO, webhook |
| Quản trị | Web `/platform` (Super Admin) và `/org` (công ty) | |
| Trợ lý AI | | MCP server: xem lịch, tìm giờ rảnh, tạo sự kiện |

Danh sách đầy đủ F01–F36: [docs/requirements/srs.md](docs/requirements/srs.md).

## Công nghệ
| Phần | Công nghệ |
| --- | --- |
| Backend | ASP.NET Core trên .NET 10, Clean Architecture, SignalR, Hangfire |
| CSDL | SQL Server 2022 + EF Core 10 (multi-tenant: `TenantId` + Row-Level Security), Redis |
| Desktop | WPF |
| Mobile | .NET MAUI (Android, iOS), SQLite cục bộ |
| Web quản trị | Blazor Web App + MudBlazor |
| Test, CI | xUnit v3, Testcontainers, GitHub Actions |

Lý do chọn từng công nghệ: [docs/architecture/adr/](docs/architecture/adr/README.md).

## Chạy trong 5 phút
Cần .NET 10 SDK, Docker Desktop và PowerShell 7. Đầy đủ các bước (kể cả workload MAUI, Android SDK, User Secrets): [docs/guides/getting-started.md](docs/guides/getting-started.md).

```powershell
git clone https://github.com/HNgTruc/WorkCal.git
cd WorkCal
Copy-Item .env.example .env        # đổi 3 mật khẩu trong .env
docker compose up -d               # SQL Server, Redis, Seq
dotnet build WorkCal.slnx
dotnet test WorkCal.slnx
```

## Bản đồ thư mục
| Thư mục / file | Nội dung |
| --- | --- |
| [src/Server/](src/Server/README.md) | Domain, Application, Infrastructure, Api, Mcp |
| [src/Shared/](src/Shared/README.md) | `WorkCal.Contracts`: DTO dùng chung |
| [src/Clients/](src/Clients/README.md) | Client.Core, Desktop, Mobile, Admin |
| [tests/](tests/README.md) | Unit, integration, client, MCP, admin |
| [docs/](docs/README.md) | Tài liệu và roadmap |
| [scripts/](scripts/README.md) | Script PowerShell (check-readme, ...) |
| [.claude/](.claude/README.md) | Quy tắc, hook, agent, skill cho Claude Code |
| [.github/](.github/README.md) | Mẫu PR, mẫu issue, CI |
| `WorkCal.slnx`, `Directory.Build.props`, `Directory.Packages.props`, `global.json` | Solution, cấu hình build chung, version package, version SDK |
| `docker-compose.yml`, `.env.example` | Môi trường dev |
| `commitlint.config.mjs` | Quy tắc kiểm tra commit trong CI |

Mọi thư mục đều có `README.md` mô tả mục đích và nội dung; `pwsh scripts/check-readme.ps1` kiểm tra điều này.

## Quy trình làm việc
- Mỗi task trong [roadmap](docs/roadmap/README.md) làm trên một nhánh riêng, mở PR vào `main` và squash merge; `main` không nhận push thẳng.
- Commit và tiêu đề PR theo [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/), footer `Refs: <mã task>`; mẫu đầy đủ ở [.claude/rules/working-agreement.md](.claude/rules/working-agreement.md).
- Claude Code làm việc theo [CLAUDE.md](CLAUDE.md) và quy tắc trong [.claude/rules/](.claude/rules/README.md).

## Giấy phép
[MIT](LICENSE).
