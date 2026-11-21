# 0007 · Use case dùng handler tự viết và FluentValidation, không dùng MediatR

[← adr](README.md)

- **Trạng thái:** Đã chấp nhận
- **Ngày:** 2026-11-21

## Bối cảnh
Tầng Application viết use case dạng command/query theo feature, đi qua một pipeline chung: validate, log, transaction, audit ([overview.md](../overview.md#luong-request)). Cần chọn cách hiện thực pipeline, thư viện validate và cách ánh xạ entity sang DTO trước P0-11. Từ năm 2025, MediatR (từ v13) và AutoMapper chuyển sang giấy phép kép RPL-1.5 và thương mại; bản Community miễn phí cho cá nhân và công ty doanh thu dưới 5 triệu USD nhưng cần license key.

## Các lựa chọn
| Lựa chọn | Ưu | Nhược |
| --- | --- | --- |
| Handler tự viết + decorator, FluentValidation, mapping viết tay | Không phụ thuộc giấy phép thương mại; code ít, đọc thẳng được luồng; dễ test | Tự viết khoảng vài chục dòng hạ tầng (interface, decorator, đăng ký DI) |
| MediatR v13 bản Community | Quen thuộc, nhiều ví dụ | Cần license key; điều khoản có thể đổi; thêm một tầng gián tiếp |
| MediatR 12 (MIT) | Miễn phí | Không còn phát triển, không nhận bản vá mới |

## Quyết định
Tự viết `ICommandHandler<TCommand, TResult>` và `IQueryHandler<TQuery, TResult>` trong `Application/Common/`, pipeline là các decorator (validation, logging, transaction cho command, audit) đăng ký qua DI. Validator dùng FluentValidation (Apache-2.0). Ánh xạ entity sang DTO viết tay, không dùng AutoMapper.

## Hệ quả
- Controller và MCP tool nhận handler qua DI, gọi trực tiếp; không có lớp "mediator" trung gian.
- Lỗi validate từ FluentValidation được decorator chuyển thành ProblemDetails 400 ([conventions.md](../../api/conventions.md#loi)).
- Thêm package `FluentValidation` (và `FluentValidation.DependencyInjectionExtensions` nếu cần quét validator) khi làm task đầu tiên dùng tới (P0-11), qua `Directory.Packages.props`.
- Rule [`clean-architecture`](../../../.claude/rules/clean-architecture.md) và skill [`add-feature`](../../../.claude/skills/add-feature/SKILL.md) mô tả theo khuôn này.
