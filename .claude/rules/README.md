# rules

[← .claude](../README.md)

## Mục đích
Quy tắc Claude Code phải tuân theo khi làm việc trong repo, chia theo chủ đề. Rule tóm tắt điều bắt buộc và link tới `docs/`; `docs/` vẫn là nguồn sự thật.

## Nội dung chính
| File | Áp dụng cho | Vai trò |
| --- | --- | --- |
| [working-agreement.md](working-agreement.md) | Mọi phiên | **Bắt buộc, ưu tiên cao nhất.** 5 quy tắc làm việc do chủ dự án đặt |
| [csharp-style.md](csharp-style.md) | `**/*.cs` | Định dạng, đặt tên, async, nullable, `TimeProvider` |
| [clean-architecture.md](clean-architecture.md) | `src/Server/**`, `src/Shared/**` | Hướng phụ thuộc, vị trí logic, command/query theo feature |
| [multi-tenant.md](multi-tenant.md) | `src/Server/**`, test integration và MCP | `ITenantEntity`, RLS, `IgnoreQueryFilters`, job nền theo tenant |
| [api-conventions.md](api-conventions.md) | Api, Contracts, API client | URL, JSON, thời gian, ProblemDetails, versioning |
| [ef-migrations.md](ef-migrations.md) | `Persistence/**`, Domain | Quy tắc migration, RLS, đổi cột hai bước |
| [ui-mvvm.md](ui-mvvm.md) | `src/Clients/**`, test client và Admin | MVVM với CommunityToolkit.Mvvm, View mỏng, Blazor gọi API qua HTTP |
| [testing.md](testing.md) | `tests/**`, `src/**/*.cs` | Công cụ, tên test, phần bắt buộc có test |
| [recurrence-timezone.md](recurrence-timezone.md) | `Infrastructure/Recurrence/**`, `Features/Events/**`, test lịch lặp | RRULE, NodaTime, `RecurrenceEndUtc`, scope sửa/xóa, sự kiện cả ngày |
| [offline-sync.md](offline-sync.md) | `Client.Core/Local/**`, `Client.Core/Sync/**`, `Features/Sync/**`, test sync | Outbox, phạm vi pull, `MIN_ACTIVE_ROWVERSION`, xung đột, `revoked` |
| [mcp-usage.md](mcp-usage.md) | Mọi phiên | Khi nào dùng MCP server nào, giới hạn |

## Quy ước và lưu ý
- Rule chỉ áp cho một phần code thì khai báo `paths:` ở frontmatter đầu file; Claude Code chỉ nạp rule khi làm việc với file khớp.
- Không sửa `working-agreement.md` khi chưa có đồng ý của chủ dự án.
- Thêm hoặc sửa rule khác: mô tả và hỏi chủ dự án trước ([quy tắc 5](working-agreement.md#quy-tac-5)).

## Cập nhật lần cuối
2026-11-21 – thêm 10 rule theo chủ đề; working-agreement thêm quy tắc 5 (P0-06).
