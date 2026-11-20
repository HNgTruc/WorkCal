<a id="top"></a>

# Giai đoạn 0 · Nền móng · tuần 1–2

[← Roadmap](README.md) · [Giai đoạn 1 →](phase-1-lich-ca-nhan.md)

Dựng khung repo, công cụ và phần lõi backend để mọi giai đoạn sau chỉ việc thêm tính năng. Kết thúc khi CI xanh và đăng ký, đăng nhập được qua API.

## Mục lục và tiến độ

**Tuần 1 · Repo, công cụ, quy ước**
- [x] [P0-01 · Tạo repo và quy ước Git](#p0-01) · 2026-11-20
- [x] [P0-02 · Solution và các project rỗng](#p0-02) · 2026-11-21
- [x] [P0-03 · Docker Compose cho môi trường dev](#p0-03) · 2026-11-21
- [ ] [P0-04 · CI với GitHub Actions](#p0-04)
- [x] [P0-05 · README gốc, README từng thư mục, check-readme](#p0-05) · 2026-11-21
- [ ] [P0-06 · Thư mục .claude và CLAUDE.md](#p0-06)
- [ ] [P0-07 · Cấu hình MCP server lúc code](#p0-07)

**Tuần 2 · Domain, tenant, đăng nhập**

- [ ] [P0-08 · Domain Common](#p0-08)
- [ ] [P0-09 · Entity tài khoản, tenant và migration đầu](#p0-09)
- [ ] [P0-10 · TenantResolver và lọc tenant tự động](#p0-10)
- [ ] [P0-11 · Đăng ký, đăng nhập, refresh token](#p0-11)
- [ ] [P0-12 · Log, xử lý lỗi, OpenAPI, health check](#p0-12)
- [ ] [P0-13 · Test nền móng](#p0-13)

**Khác:** [Mục tiêu và cổng kiểm tra](#muc-tieu) · [Rủi ro](#rui-ro)

<a id="muc-tieu"></a>

## Mục tiêu và cổng kiểm tra

- **Phạm vi:** F01 (đăng ký, đăng nhập), khung tenant cho mọi giai đoạn sau.
- **Tổng ước tính:** khoảng 30 giờ.
- **Cổng kiểm tra (đủ cả 4 mới sang giai đoạn 1):**
    - [ ] CI chạy build, test, check-readme trên mọi PR và đều xanh
    - [ ] Đăng ký, đăng nhập, refresh token chạy được qua Scalar
    - [ ] Test chứng minh truy vấn chỉ trả dữ liệu của tenant hiện tại
    - [ ] `docker compose up -d` + `dotnet run` chạy được trên máy sạch theo [getting-started](../guides/getting-started.md)

---

## Tuần 1 · Repo, công cụ, quy ước

<a id="p0-01"></a>

### P0-01 · Tạo repo và quy ước Git

- **Ước tính:** ~1h · **Chức năng:** – · **Phụ thuộc:** –
- **Việc cần làm:**
    1. Tạo repo `WorkCal` trên GitHub, thêm LICENSE (MIT).
    2. Bật branch protection cho `main`: bắt buộc PR, áp cả admin, 0 người duyệt. Check CI bắt buộc thêm ở [P0-04](#p0-04).
    3. Thêm `.gitignore` (mẫu VisualStudio), `.editorconfig`, `.gitattributes`.
    4. Giữ label mặc định của GitHub, đổi `documentation` thành `docs`, thêm `phase-0`…`phase-5`; tạo 6 milestone `Giai đoạn 0`…`Giai đoạn 5`, không đặt hạn chót.
    5. Thêm template PR và issue.
- **Xong khi:** push thẳng vào `main` bị chặn; tạo issue có sẵn template.
- **File code:**
  [`.gitignore`](../../.gitignore) ·
  [`.editorconfig`](../../.editorconfig) ·
  [`.gitattributes`](../../.gitattributes) ·
  [`LICENSE`](../../LICENSE) ·
  [`.github/pull_request_template.md`](../../.github/pull_request_template.md) ·
  [`.github/ISSUE_TEMPLATE/`](../../.github/ISSUE_TEMPLATE/)
- **Tài liệu:** [README gốc](../../README.md)

<a id="p0-02"></a>

### P0-02 · Solution và các project rỗng

- **Ước tính:** ~2h · **Chức năng:** – · **Phụ thuộc:** P0-01
- **Việc cần làm:**
    1. Tạo `WorkCal.slnx` và 16 project (10 trong `src/`, 6 trong `tests/`) theo cây thư mục ở tài liệu thiết kế mục 13; tạo luôn các thư mục con, mỗi thư mục có `README.md`.
    2. Thêm tham chiếu đúng hướng: Api → Infrastructure → Application → Domain; Application, Api → Contracts; Mcp → Application, Infrastructure; Client.Core → Contracts; Desktop, Mobile → Client.Core; Admin → Contracts.
    3. `Directory.Build.props`: `net10.0` (biến `WorkCalTargetFramework`), `Nullable=enable`, `TreatWarningsAsErrors=true`, `EnforceCodeStyleInBuild=true`, `GenerateDocumentationFile=true` (tắt CS1591).
    4. `Directory.Packages.props`: quản lý version NuGet tập trung; chỉ có package tối thiểu (MAUI, xUnit v3, test SDK).
    5. `global.json`: ghim SDK 10.0.401, cho lên bản 10.0.x mới hơn.
    6. Mobile build Android trên Windows; iOS chỉ thêm khi build trên macOS.
- **Xong khi:** `dotnet build` thành công, không có cảnh báo; `dotnet test` chạy được (chưa có test).
- **File code:**
  [`WorkCal.slnx`](../../WorkCal.slnx) ·
  [`global.json`](../../global.json) ·
  [`Directory.Build.props`](../../Directory.Build.props) ·
  [`Directory.Packages.props`](../../Directory.Packages.props) ·
  [`src/Server/`](../../src/Server/) ·
  [`src/Clients/`](../../src/Clients/) ·
  [`tests/`](../../tests/)
- **Tài liệu:** [architecture/overview.md](../architecture/overview.md)

<a id="p0-03"></a>

### P0-03 · Docker Compose cho môi trường dev

- **Ước tính:** ~1.5h · **Chức năng:** – · **Phụ thuộc:** P0-02
- **Việc cần làm:**
    1. Service `sqlserver` (2022), `redis`, `seq`, có volume giữ dữ liệu và healthcheck. Image ghim bản chính: `mssql/server:2022-latest`, `redis:8`, `datalust/seq:2026`.
    2. Cổng chỉ mở cho `127.0.0.1`: SQL Server `14330` (tránh SQL Server cài sẵn), Redis `6379`, Seq `5341`.
    3. Mật khẩu SQL Server, Redis, Seq (admin) đọc từ `.env`; `.env.example` liệt kê biến cần có; `.env` nằm trong `.gitignore`.
    4. Chuỗi kết nối dev đặt bằng User Secrets (`UserSecretsId` trong `WorkCal.Api.csproj`), không ghi vào `appsettings.json`.
    5. Cập nhật [getting-started](../guides/getting-started.md) (lệnh PowerShell, cổng, cài Android SDK API 36) và [troubleshooting](../guides/troubleshooting.md).
- **Xong khi:** `docker compose up -d` chạy đủ 3 service và `docker compose ps` báo `healthy`; kết nối được SQL Server từ máy qua `127.0.0.1,14330`; đăng nhập được Seq.
- **File code:**
  [`docker-compose.yml`](../../docker-compose.yml) ·
  [`.env.example`](../../.env.example)
- **Tài liệu:** [guides/getting-started.md](../guides/getting-started.md)

<a id="p0-04"></a>

### P0-04 · CI với GitHub Actions

- **Ước tính:** ~2h · **Chức năng:** – · **Phụ thuộc:** P0-02, P0-05
- **Việc cần làm:**
    1. Job `build-test` trên `ubuntu-latest`: cài SDK theo `global.json`, workload `maui-android` + Android SDK, restore, build cả solution (`EnableWindowsTargeting=true` cho WPF), test, upload kết quả TRX.
    2. Job `check-readme`: chạy `scripts/check-readme.ps1`.
    3. Cache NuGet để chạy nhanh hơn.
    4. Job `commitlint`: kiểm tra mọi commit trong PR theo Conventional Commits 1.0.0 (mẫu trong [working-agreement](../../.claude/rules/working-agreement.md#4-không-tự-ý-commit--đưa-lệnh-commit-tiếng-việt)), bắt buộc footer `Refs:`, và kiểm tra tiêu đề PR (squash merge dùng tiêu đề PR làm commit). Dùng action `wagoid/commitlint-github-action` + `commitlint.config.mjs`, không thêm package npm; bỏ qua PR của Dependabot.
    5. Thêm job `build-test`, `check-readme` và `commitlint` vào status check bắt buộc của branch protection `main` (P0-01 mới bật "bắt buộc qua PR", vì GitHub chỉ cho chọn check đã từng chạy).
    6. `.github/dependabot.yml`: NuGet, GitHub Actions, image Docker; mỗi thứ Hai, gộp theo nhóm.
- **Xong khi:** PR mở ra là CI tự chạy; một PR thiếu README hoặc có commit sai chuẩn bị báo đỏ và không merge được.
- **File code:**
  [`.github/workflows/ci.yml`](../../.github/workflows/ci.yml) ·
  [`commitlint.config.mjs`](../../commitlint.config.mjs) ·
  [`.github/dependabot.yml`](../../.github/dependabot.yml)
- **Tài liệu:** [testing/test-strategy.md](../testing/test-strategy.md)

<a id="p0-05"></a>

### P0-05 · README gốc, README từng thư mục, check-readme

- **Ước tính:** ~2.5h · **Chức năng:** – · **Phụ thuộc:** P0-02
- **Việc cần làm:**
    1. README gốc: giới thiệu, cách chạy trong 5 phút, bản đồ thư mục.
    2. Tạo `README.md` cho mọi thư mục theo mẫu ở tài liệu thiết kế mục 13.3.
    3. Viết `scripts/check-readme.ps1`: quét thư mục, bỏ qua `bin/`, `obj/` (và thư mục công cụ, `*/Resources/Images`), báo lỗi nếu thiếu README hoặc README thiếu mục `## Mục đích`.
    4. Tạo `docs/README.md` làm mục lục tài liệu.
- **Xong khi:** chạy script trên repo hiện tại không báo lỗi; xóa thử một README hoặc mục `## Mục đích` thì script báo đúng thư mục đó.
- **Ghi chú:** làm trước P0-04 (đã chốt 2026-11-21) để CI có ngay job `check-readme`. README gốc tiếng Việt, có đoạn tóm tắt tiếng Anh ở đầu.
- **File code:**
  [`README.md`](../../README.md) ·
  [`scripts/check-readme.ps1`](../../scripts/check-readme.ps1) ·
  [`docs/README.md`](../README.md)
- **Tài liệu:** [docs/README.md](../README.md)

<a id="p0-06"></a>

### P0-06 · Thư mục .claude và CLAUDE.md

- **Ước tính:** ~3h · **Chức năng:** – · **Phụ thuộc:** P0-05
- **Việc cần làm:**
    1. `settings.json`: cho phép `dotnet build/test/format`, chặn xóa CSDL và push thẳng `main`.
    2. Bốn hook: `guard-secrets`, `format-on-edit`, `check-readme`, `verify-build`.
    3. Rules (đã có `working-agreement`): `csharp-style`, `clean-architecture`, `multi-tenant`, `api-conventions`, `ef-migrations`, `ui-mvvm`, `testing`, `mcp-usage`.
    4. Agent: `code-reviewer`, `test-writer`, `db-designer`, `security-auditor`, `docs-writer`.
    5. Skill khung: `add-feature`, `add-ef-migration`, `write-folder-readme` (các skill còn lại thêm ở giai đoạn dùng tới).
    6. `CLAUDE.md` gốc, `src/Server/CLAUDE.md`, `src/Clients/CLAUDE.md`; có dòng nhắc đọc roadmap.
- **Đã làm trước (2026-11-20):** `CLAUDE.md` bản đầy đủ và `.claude/rules/working-agreement.md` (4 quy tắc làm việc bắt buộc). Bước 3 và 6 chỉ còn bổ sung các rule khác và CLAUDE.md con.
- **Xong khi:** sửa thử `.env` qua Claude Code bị hook chặn; sửa file `.cs` thì được format tự động.
- **File code:**
  [`CLAUDE.md`](../../CLAUDE.md) ·
  [`.claude/settings.json`](../../.claude/settings.json) ·
  [`.claude/hooks/`](../../.claude/hooks/) ·
  [`.claude/rules/`](../../.claude/rules/) ·
  [`.claude/agents/`](../../.claude/agents/) ·
  [`.claude/skills/`](../../.claude/skills/) ·
  [`src/Server/CLAUDE.md`](../../src/Server/CLAUDE.md) ·
  [`src/Clients/CLAUDE.md`](../../src/Clients/CLAUDE.md)
- **Tài liệu:** [.claude/README.md](../../.claude/README.md)

<a id="p0-07"></a>

### P0-07 · Cấu hình MCP server lúc code

- **Ước tính:** ~1.5h · **Chức năng:** – · **Phụ thuộc:** P0-03, P0-06
- **Việc cần làm:**
    1. `.mcp.json` với `microsoft-learn`, `nuget`, `github`, `playwright`.
    2. `workcal-sql`: thêm service SQL MCP Server vào docker-compose, cấu hình `dab-config.json` với tài khoản chỉ đọc.
    3. Ghi cách cài và biến môi trường vào `docs/mcp/dev-servers.md`.
- **Xong khi:** trong Claude Code liệt kê được 5 server và gọi thử mỗi server một lần.
- **File code:**
  [`.mcp.json`](../../.mcp.json) ·
  [`tools/mcp/dab-config.json`](../../tools/mcp/dab-config.json) ·
  [`docker-compose.yml`](../../docker-compose.yml) ·
  [`.claude/rules/mcp-usage.md`](../../.claude/rules/mcp-usage.md)
- **Tài liệu:** [mcp/dev-servers.md](../mcp/dev-servers.md)

---

## Tuần 2 · Domain, tenant, đăng nhập

<a id="p0-08"></a>

### P0-08 · Domain Common

- **Ước tính:** ~2h · **Chức năng:** – · **Phụ thuộc:** P0-02
- **Việc cần làm:**
    1. `BaseEntity`: `Id` (Guid v7), `CreatedAt`, `UpdatedAt`, `Version`.
    2. Interface `ITenantEntity` (có `TenantId`), `ISoftDelete` (`IsDeleted`, `DeletedAt`).
    3. Lớp cơ sở cho domain event.
- **Xong khi:** có unit test cho việc sinh Id tăng dần theo thời gian.
- **File code:**
  [`src/Server/WorkCal.Domain/Common/BaseEntity.cs`](../../src/Server/WorkCal.Domain/Common/BaseEntity.cs) ·
  [`src/Server/WorkCal.Domain/Common/ITenantEntity.cs`](../../src/Server/WorkCal.Domain/Common/ITenantEntity.cs) ·
  [`src/Server/WorkCal.Domain/Common/ISoftDelete.cs`](../../src/Server/WorkCal.Domain/Common/ISoftDelete.cs) ·
  [`src/Server/WorkCal.Domain/DomainEvents/`](../../src/Server/WorkCal.Domain/DomainEvents/)
- **Tài liệu:** [database/data-dictionary.md](../database/data-dictionary.md)

<a id="p0-09"></a>

### P0-09 · Entity tài khoản, tenant và migration đầu

- **Ước tính:** ~3h · **Chức năng:** F01, F13 · **Phụ thuộc:** P0-08
- **Việc cần làm:**
    1. Entity `Plan`, `Tenant` (Type: Personal/Business), `User`, `Membership`, `RefreshToken`.
    2. `AppDbContext` + cấu hình từng entity (index bắt đầu bằng `TenantId`).
    3. Migration `InitialCreate`, seed 3 gói Free/Pro/Business.
- **Xong khi:** `dotnet ef database update` tạo đúng bảng trên SQL Server trong Docker.
- **File code:**
  [`src/Server/WorkCal.Domain/Tenancy/`](../../src/Server/WorkCal.Domain/Tenancy/) ·
  [`src/Server/WorkCal.Domain/Identity/`](../../src/Server/WorkCal.Domain/Identity/) ·
  [`src/Server/WorkCal.Infrastructure/Persistence/AppDbContext.cs`](../../src/Server/WorkCal.Infrastructure/Persistence/AppDbContext.cs) ·
  [`src/Server/WorkCal.Infrastructure/Persistence/Configurations/`](../../src/Server/WorkCal.Infrastructure/Persistence/Configurations/) ·
  [`src/Server/WorkCal.Infrastructure/Persistence/Migrations/`](../../src/Server/WorkCal.Infrastructure/Persistence/Migrations/)
- **Tài liệu:** [database/erd.md](../database/erd.md) · [database/migrations.md](../database/migrations.md)

<a id="p0-10"></a>

### P0-10 · TenantResolver và lọc tenant tự động

- **Ước tính:** ~3h · **Chức năng:** – · **Phụ thuộc:** P0-09
- **Việc cần làm:**
    1. `ITenantContext` (scoped) trong Application.
    2. Middleware `TenantResolver`: đọc claim `tid`, kiểm tra membership và tenant chưa bị khóa.
    3. Global query filter cho mọi `ITenantEntity`; interceptor tự gán `TenantId` khi thêm mới và chặn ghi sang tenant khác.
- **Xong khi:** test tạo dữ liệu ở 2 tenant, truy vấn từ tenant A không thấy dữ liệu tenant B.
- **File code:**
  [`src/Server/WorkCal.Application/Common/ITenantContext.cs`](../../src/Server/WorkCal.Application/Common/ITenantContext.cs) ·
  [`src/Server/WorkCal.Api/Middleware/TenantResolver.cs`](../../src/Server/WorkCal.Api/Middleware/TenantResolver.cs) ·
  [`src/Server/WorkCal.Infrastructure/Persistence/Interceptors/TenantInterceptor.cs`](../../src/Server/WorkCal.Infrastructure/Persistence/Interceptors/TenantInterceptor.cs)
- **Tài liệu:** [architecture/multi-tenant.md](../architecture/multi-tenant.md) · [.claude/rules/multi-tenant.md](../../.claude/rules/multi-tenant.md)

<a id="p0-11"></a>

### P0-11 · Đăng ký, đăng nhập, refresh token

- **Ước tính:** ~4h · **Chức năng:** F01 · **Phụ thuộc:** P0-10
- **Việc cần làm:**
    1. `POST /auth/register`: tạo User + tenant Personal + Membership Owner.
    2. `POST /auth/login`: trả access token (15 phút, có `tid`, `role`) + refresh token (30 ngày).
    3. `POST /auth/refresh`: xoay vòng, phát hiện dùng lại thì thu hồi cả họ token.
    4. `POST /auth/logout`, khóa tài khoản sau 5 lần sai.
- **Xong khi:** gọi đủ 4 endpoint qua Scalar; test dùng lại refresh token cũ bị từ chối.
- **File code:**
  [`src/Server/WorkCal.Application/Features/Auth/`](../../src/Server/WorkCal.Application/Features/Auth/) ·
  [`src/Server/WorkCal.Infrastructure/Identity/`](../../src/Server/WorkCal.Infrastructure/Identity/) ·
  [`src/Server/WorkCal.Api/Controllers/V1/AuthController.cs`](../../src/Server/WorkCal.Api/Controllers/V1/AuthController.cs) ·
  [`src/Shared/WorkCal.Contracts/Auth/`](../../src/Shared/WorkCal.Contracts/Auth/)
- **Tài liệu:** [api/authentication.md](../api/authentication.md)

<a id="p0-12"></a>

### P0-12 · Log, xử lý lỗi, OpenAPI, health check

- **Ước tính:** ~2h · **Chức năng:** – · **Phụ thuộc:** P0-02
- **Việc cần làm:**
    1. Serilog ghi ra console và Seq.
    2. Trả lỗi theo ProblemDetails, có `traceId`.
    3. OpenAPI + Scalar ở môi trường dev; `scripts/export-openapi.ps1` xuất ra `docs/api/openapi.json`.
    4. `/health` kiểm tra SQL Server và Redis.
- **Xong khi:** lỗi validation trả 400 đúng định dạng; log hiện trên Seq.
- **File code:**
  [`src/Server/WorkCal.Api/Program.cs`](../../src/Server/WorkCal.Api/Program.cs) ·
  [`src/Server/WorkCal.Api/Middleware/ExceptionHandler.cs`](../../src/Server/WorkCal.Api/Middleware/ExceptionHandler.cs) ·
  [`scripts/export-openapi.ps1`](../../scripts/export-openapi.ps1)
- **Tài liệu:** [api/conventions.md](../api/conventions.md)

<a id="p0-13"></a>

### P0-13 · Test nền móng

- **Ước tính:** ~3h · **Chức năng:** – · **Phụ thuộc:** P0-10, P0-11
- **Việc cần làm:**
    1. `WebApplicationFactory` + Testcontainers SQL Server dùng chung cho integration test.
    2. Test auth đầy đủ luồng; test cách ly tenant đầu tiên trong thư mục `TenantIsolation/`.
    3. Unit test cho Domain.
- **Xong khi:** `dotnet test` xanh trên máy và trên CI.
- **File code:**
  [`tests/WorkCal.Domain.Tests/`](../../tests/WorkCal.Domain.Tests/) ·
  [`tests/WorkCal.Api.IntegrationTests/Infrastructure/`](../../tests/WorkCal.Api.IntegrationTests/Infrastructure/) ·
  [`tests/WorkCal.Api.IntegrationTests/TenantIsolation/`](../../tests/WorkCal.Api.IntegrationTests/TenantIsolation/) ·
  [`tests/WorkCal.Api.IntegrationTests/Auth/`](../../tests/WorkCal.Api.IntegrationTests/Auth/)
- **Tài liệu:** [testing/test-strategy.md](../testing/test-strategy.md) · [security/tenant-isolation.md](../security/tenant-isolation.md)

---

<a id="rui-ro"></a>

## Rủi ro

| Rủi ro                                            | Cách xử lý                                                          |
| ------------------------------------------------- | ------------------------------------------------------------------- |
| Mất nhiều thời gian chỉnh `.claude/` cho hoàn hảo | Chỉ làm bản tối thiểu, bổ sung rule và skill khi giai đoạn sau cần  |
| Testcontainers chạy chậm trên máy yếu             | Dùng chung một container cho cả bộ test, reset dữ liệu bằng Respawn |
| Guid v7 chưa quen                                 | Dùng `Guid.CreateVersion7()` có sẵn từ .NET 9                       |

[↑ Về đầu trang](#top) · [← Roadmap](README.md)
