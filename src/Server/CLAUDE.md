# CLAUDE.md · src/Server

Bổ sung cho [`CLAUDE.md` gốc](../../CLAUDE.md) khi làm việc với backend. Quy tắc làm việc trong [`working-agreement.md`](../../.claude/rules/working-agreement.md) vẫn ưu tiên cao nhất. Trước khi làm, mở [roadmap](../../docs/roadmap/README.md) để biết task đang làm và đọc mục **Việc cần làm**, **Xong khi** của task.

## Các project

| Project | Vai trò | Rule chính |
| --- | --- | --- |
| [WorkCal.Domain](WorkCal.Domain/README.md) | Entity, value object, quy tắc nghiệp vụ; không phụ thuộc framework | [clean-architecture](../../.claude/rules/clean-architecture.md) |
| [WorkCal.Application](WorkCal.Application/README.md) | Command/query theo `Features/<Feature>/`, validator, interface | [clean-architecture](../../.claude/rules/clean-architecture.md), [multi-tenant](../../.claude/rules/multi-tenant.md) |
| [WorkCal.Infrastructure](WorkCal.Infrastructure/README.md) | EF Core, RLS, Redis, Hangfire, thông báo, file | [ef-migrations](../../.claude/rules/ef-migrations.md), [multi-tenant](../../.claude/rules/multi-tenant.md) |
| [WorkCal.Api](WorkCal.Api/README.md) | Controller, SignalR hub, middleware `TenantResolver`, DI | [api-conventions](../../.claude/rules/api-conventions.md) |
| [WorkCal.Mcp](WorkCal.Mcp/README.md) | MCP server của sản phẩm (v1.1), gọi tầng Application | [multi-tenant](../../.claude/rules/multi-tenant.md) |

## Điều hay quên

- Phụ thuộc chỉ đi vào trong: Api → Infrastructure → Application → Domain. Controller không gọi `AppDbContext`.
- Entity nghiệp vụ có `ITenantEntity`; bảng mới vào policy RLS trong cùng migration; endpoint mới vào bộ test `TenantIsolation`.
- `IgnoreQueryFilters()` chỉ trong `Application/Features/Platform/`. Job nền kế thừa `TenantJobBase`.
- Thời gian: UTC + `TimeZoneId`; lịch lặp bằng Ical.Net + NodaTime (rule [recurrence-timezone](../../.claude/rules/recurrence-timezone.md)); lấy giờ hiện tại qua `TimeProvider`.
- Push/pull đồng bộ: rule [offline-sync](../../.claude/rules/offline-sync.md).
- Lỗi trả ProblemDetails; thuộc tenant khác trả 404.
- Thêm package NuGet, endpoint hoặc bảng ngoài task: hỏi chủ dự án trước.

## Skill và agent

- Thêm chức năng: skill [`add-feature`](../../.claude/skills/add-feature/SKILL.md). Thêm migration: [`add-ef-migration`](../../.claude/skills/add-ef-migration/SKILL.md).
- Thiết kế bảng: agent `db-designer`. Rà soát: `code-reviewer`, `security-auditor`. Kết thúc task: skill [`finish-task`](../../.claude/skills/finish-task/SKILL.md).

## Lệnh

```powershell
dotnet build WorkCal.slnx
dotnet test tests/WorkCal.Domain.Tests
dotnet test tests/WorkCal.Api.IntegrationTests        # cần Docker Desktop
dotnet run --project src/Server/WorkCal.Api           # https://localhost:5001/scalar
```
