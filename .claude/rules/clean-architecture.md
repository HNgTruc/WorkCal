---
paths:
  - "src/Server/**"
  - "src/Shared/**"
---

# Rule: Clean Architecture phía server

Thiết kế: [docs/architecture/overview.md#cac-tang](../../docs/architecture/overview.md#cac-tang).

## Hướng phụ thuộc

`Api → Infrastructure → Application → Domain`. `WorkCal.Mcp` dùng tầng Application như Api. `WorkCal.Contracts` (DTO) không phụ thuộc project nào khác.

| Project | Được tham chiếu | Không được |
| --- | --- | --- |
| Domain | Không gì ngoài BCL (và NodaTime nếu cần kiểu thời gian) | EF Core, ASP.NET Core, bất kỳ package hạ tầng nào |
| Application | Domain, Contracts | EF Core provider, HttpContext, Redis, Hangfire |
| Infrastructure | Application, Domain | Api |
| Api, Mcp | Application, Infrastructure (chỉ để đăng ký DI) | Gọi thẳng `AppDbContext` từ controller hay tool |

## Bắt buộc

- Use case viết dạng command/query theo feature trong `Application/Features/<Feature>/` (chia `Commands/`, `Queries/`, `Validators/` khi bắt đầu có code). Handler implement `ICommandHandler<TCommand, TResult>` / `IQueryHandler<TQuery, TResult>` (tự viết, không MediatR); decorator lo validate (FluentValidation), log, transaction, audit; mapping sang DTO viết tay, không AutoMapper ([ADR 0007](../../docs/architecture/adr/0007-use-case-tu-viet.md)).
- Quy tắc nghiệp vụ (trùng giờ, quyền trên lịch, luồng duyệt) nằm trong Domain; entity tự bảo vệ bất biến của nó, không để setter public tùy ý.
- Application định nghĩa interface (`ITenantContext`, `IEmailSender`, `IPlanLimitService`...), Infrastructure hiện thực.
- Controller và hub mỏng: nhận request → gửi command/query → trả kết quả. Không có logic nghiệp vụ.
- DTO đi qua API nằm trong `WorkCal.Contracts`; không trả entity Domain ra ngoài.

## Hỏi trước

- Thêm project, thư mục ngoài cây đã chốt ở tài liệu thiết kế mục 13.
