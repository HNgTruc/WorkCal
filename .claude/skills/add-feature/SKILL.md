---
name: add-feature
description: Quy trình thêm một chức năng backend WorkCal theo lát cắt dọc (Domain → Application → Infrastructure → Api → Contracts → test → docs). Dùng khi task roadmap yêu cầu thêm use case, endpoint hoặc entity mới.
---

# Thêm một chức năng theo lát cắt dọc

Áp dụng rule [`clean-architecture`](../../rules/clean-architecture.md), [`multi-tenant`](../../rules/multi-tenant.md), [`api-conventions`](../../rules/api-conventions.md), [`testing`](../../rules/testing.md).

## 0. Chuẩn bị (quy tắc 1 và 3)

1. Đọc task trong `docs/roadmap/` (Việc cần làm, Xong khi, File code, Tài liệu) và tài liệu nghiệp vụ liên quan (`docs/requirements/`, use case).
2. Xác định: entity mới hay sửa, command/query nào, endpoint nào, vai trò nào được gọi, có ảnh hưởng `/sync` không.
3. Có bảng hoặc cột mới → gọi agent `db-designer` lấy đề xuất, chờ chủ dự án duyệt.
4. Trình kế hoạch và câu hỏi; chờ trả lời rồi mới viết code.

## 1. Domain (`src/Server/WorkCal.Domain/<Nhóm>/`)

- Entity implement `ITenantEntity`; constructor và method bảo vệ bất biến; không setter public tùy ý.
- Quy tắc nghiệp vụ thuần (trùng giờ, chuyển trạng thái) viết ở đây và có unit test trong `WorkCal.Domain.Tests`.

## 2. Application (`src/Server/WorkCal.Application/Features/<Feature>/`)

- Tạo `Commands/`, `Queries/`, `Validators/` khi có file đầu tiên (kèm README cho mỗi thư mục mới).
- Command/query + handler theo khuôn đã có trong code (thư viện mediator và validator chốt ở giai đoạn 0; chưa có thì hỏi).
- Kiểm tra giới hạn gói qua `IPlanLimitService` nếu chức năng tính theo gói.
- Unit test handler và validator trong `WorkCal.Application.Tests`.

## 3. Infrastructure (`src/Server/WorkCal.Infrastructure/`)

- Cấu hình EF bằng `IEntityTypeConfiguration<T>`; index bắt đầu bằng `TenantId`.
- Cần migration → làm theo skill [`add-ef-migration`](../add-ef-migration/SKILL.md).

## 4. Contracts và Api

- DTO request/response trong `src/Shared/WorkCal.Contracts/`; không trả entity.
- Controller mỏng trong `Controllers/V1/` (hoặc `Org/`, `Admin/`, `Public/`), có `[Authorize]` với policy đúng vai trò, mô tả OpenAPI.
- Lỗi để `ExceptionHandler` trả ProblemDetails; thuộc tenant khác → 404.

## 5. Integration test

- Test endpoint trong `WorkCal.Api.IntegrationTests` (đúng quyền, sai quyền, dữ liệu không hợp lệ).
- Thêm dữ liệu mẫu cho route mới vào bảng ánh xạ của bộ `TenantIsolation`.

## 6. Kết thúc

1. `dotnet build` sạch cảnh báo, `dotnet test` xanh.
2. Gọi agent `code-reviewer`; task chạm tenant hoặc phân quyền thì gọi thêm `security-auditor`.
3. Cập nhật README các thư mục đã đổi, `docs/api/`, `docs/database/` nếu có; gọi agent `docs-writer` nếu thay đổi lớn.
4. Làm theo skill [`finish-task`](../finish-task/SKILL.md) để kiểm tra lần cuối và soạn lệnh commit.
