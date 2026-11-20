# Server

[← src](../README.md)

## Mục đích
Backend: Domain, Application, Infrastructure, Api, Mcp.

## Nội dung chính
| File / thư mục | Vai trò |
| --- | --- |
| [WorkCal.Api/](WorkCal.Api/README.md) | REST API, SignalR hub, middleware; điểm vào của backend |
| [WorkCal.Application/](WorkCal.Application/README.md) | Tầng Application: use case dạng command/query theo feature, validator, interface |
| [WorkCal.Domain/](WorkCal.Domain/README.md) | Tầng Domain: entity, value object, quy tắc nghiệp vụ; không phụ thuộc framework nào |
| [WorkCal.Infrastructure/](WorkCal.Infrastructure/README.md) | Tầng Infrastructure: EF Core, SQL Server, Redis, Hangfire, thông báo, file |
| [WorkCal.Mcp/](WorkCal.Mcp/README.md) | MCP server của sản phẩm cho trợ lý AI (bản 1.1, giai đoạn 5) |

## Cập nhật lần cuối
2026-11-20 – tạo thư mục (P0-02).
