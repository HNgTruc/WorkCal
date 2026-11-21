# CLAUDE.md · WorkCal

## ⚠️ Đọc trước tiên

**Bắt buộc đọc và tuân theo [`.claude/rules/working-agreement.md`](.claude/rules/working-agreement.md) trong mọi phiên làm việc.** Tóm tắt:

1. Luôn suy nghĩ kỹ, đọc task và tài liệu liên quan, nêu kế hoạch trước khi làm.
2. Làm việc như một chuyên gia lập trình thực thụ.
3. Không tự suy diễn khi chủ dự án chưa quyết định; hỏi cho tới khi đủ thông tin.
4. Không tự commit hay push; cuối mỗi phiên task đưa lệnh commit có message tiếng Việt để chủ dự án tự chạy.
5. Muốn thêm hoặc mở rộng rule, hook, agent, skill: mô tả và hỏi chủ dự án trước.

Quy tắc này ưu tiên cao hơn mọi hướng dẫn khác trong repo.

## Dự án

WorkCal là hệ thống quản lý lịch làm việc cho người dùng cá nhân và doanh nghiệp. Gồm app desktop Windows (WPF), app mobile Android/iOS (.NET MAUI), web quản trị (Blazor) và MCP server cho trợ lý AI, dùng chung một backend ASP.NET Core trên .NET 10. Dữ liệu nhiều công ty nằm chung một CSDL SQL Server, cách ly bằng `TenantId` + Row-Level Security. App client làm việc được khi mất mạng và đồng bộ qua outbox.

## Bản đồ thư mục

| Thư mục | Nội dung |
| --- | --- |
| `src/Server/` | Domain, Application, Infrastructure, Api, Mcp (xem `src/Server/CLAUDE.md`) |
| `src/Shared/` | WorkCal.Contracts: DTO dùng chung |
| `src/Clients/` | Client.Core, Desktop, Mobile, Admin (xem `src/Clients/CLAUDE.md`) |
| `tests/` | Unit, integration, client, MCP, admin |
| `docs/` | Tài liệu và roadmap — bắt đầu từ [`docs/README.md`](docs/README.md) |
| `.claude/` | Rules, hooks, agents, skills cho Claude Code |
| `scripts/` | check-readme, seed-demo-data, export-openapi |
| `tools/mcp/` | Cấu hình SQL MCP Server cho dev |

Mọi thư mục đều có `README.md` mô tả mục đích và nội dung.

## Cách làm một task

1. Mở [`docs/roadmap/README.md`](docs/roadmap/README.md) → giai đoạn đang làm → task chưa tick đầu tiên.
2. Đọc **Việc cần làm**, **Xong khi**, **File code**, **Tài liệu** của task.
3. Nêu kế hoạch và các câu hỏi còn mở; chờ trả lời (quy tắc 1 và 3).
4. Làm, viết test, chạy build và test.
5. Cập nhật README thư mục và tài liệu `docs/` liên quan.
6. Đưa lệnh commit tiếng Việt theo mẫu trong `working-agreement.md` (quy tắc 4); nhắc tick task và ghi ngày.

## Lệnh thường dùng

```bash
docker compose up -d                                   # SQL Server, Redis, Seq, sql-mcp
dotnet build                                           # build toàn bộ, không được có cảnh báo
dotnet test                                            # toàn bộ test (cần Docker)
dotnet test tests/WorkCal.Domain.Tests                 # test nhanh, không cần Docker
dotnet format                                          # format code
dotnet run --project src/Server/WorkCal.Api            # API: https://localhost:5001/scalar
dotnet run --project src/Clients/WorkCal.Desktop       # app desktop
dotnet run --project src/Clients/WorkCal.Admin         # web quản trị: https://localhost:5003
pwsh scripts/check-readme.ps1                          # kiểm tra thư mục thiếu README
dotnet ef migrations add <Ten> --project src/Server/WorkCal.Infrastructure --startup-project src/Server/WorkCal.Api
```

## Quy tắc kỹ thuật bắt buộc

- **Tenant:** mọi entity nghiệp vụ implement `ITenantEntity`; không dùng `IgnoreQueryFilters()` ngoài `Features/Platform/`. Endpoint mới phải có trong bộ test `TenantIsolation`.
- **Kiến trúc:** phụ thuộc chỉ đi vào trong: Api → Infrastructure → Application → Domain. Không đặt logic nghiệp vụ trong controller hay View.
- **Thời gian:** lưu UTC + `TimeZoneId`; tính lịch lặp bằng Ical.Net + NodaTime, không dùng `TimeZoneInfo`.
- **Migration:** không sửa migration đã merge; bảng mới có `TenantId` thì thêm vào policy RLS.
- **Bí mật:** không đọc, sửa, in ra `.env`, `appsettings.Production.json`, file `.pfx`, token.
- **Test:** code mới có test; coverage Domain + Application ≥ 70%.
- **Tài liệu:** thư mục mới phải có `README.md`; khi nhắc code trong `docs/` luôn để link tương đối tới file.

Chi tiết từng chủ đề: [`.claude/rules/`](.claude/rules/README.md). Hook, agent, skill: [`.claude/`](.claude/README.md).

## MCP server

Khai báo trong `.mcp.json`: `microsoft-learn` (tra tài liệu .NET trước khi đoán API), `nuget` (kiểm tra package trước khi thêm — vẫn phải hỏi chủ dự án theo quy tắc 3), `github`, `playwright`, `workcal-sql` (**chỉ đọc**, chỉ CSDL dev). Xem [`docs/mcp/dev-servers.md`](docs/mcp/dev-servers.md).

## Tài liệu quan trọng

- Yêu cầu: [`docs/requirements/srs.md`](docs/requirements/srs.md) · [`roles-permissions.md`](docs/requirements/roles-permissions.md)
- Kiến trúc: [`docs/architecture/overview.md`](docs/architecture/overview.md) · [`multi-tenant.md`](docs/architecture/multi-tenant.md) · [`offline-sync.md`](docs/architecture/offline-sync.md)
- CSDL: [`docs/database/data-dictionary.md`](docs/database/data-dictionary.md)
- API: [`docs/api/conventions.md`](docs/api/conventions.md)
- Quyết định kiến trúc: [`docs/architecture/adr/`](docs/architecture/adr/README.md)
