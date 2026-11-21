---
paths:
  - "tests/**"
  - "src/**/*.cs"
---

# Rule: Kiểm thử

Nguồn sự thật: [docs/testing/test-strategy.md](../../docs/testing/test-strategy.md). Agent: [`test-writer`](../agents/test-writer.md).

## Bắt buộc

- Code mới có test. Coverage dòng của `WorkCal.Domain` + `WorkCal.Application` tối thiểu 70% (CI chặn từ P1-01).
- Công cụ: xUnit v3, **AwesomeAssertions** (`.Should()`), NSubstitute, Testcontainers (SQL Server, Redis) + Respawn cho integration, bUnit và Playwright cho Admin. Không dùng FluentAssertions 8 trở lên (giấy phép thương mại).
- Tên test `Phương_thức_Tình_huống_Kỳ_vọng`, ví dụ `Expand_WeeklyAcrossDst_KeepsLocalTime`. Một test một hành vi, bố cục Arrange / Act / Assert.
- Không `Thread.Sleep`; thời gian giả lập bằng `TimeProvider` (`FakeTimeProvider`).
- Integration test dùng chung container cho cả bộ, reset dữ liệu bằng Respawn giữa các test.
- Test đặt đúng project theo tầng (bảng "Các loại test" trong test-strategy.md).

## Phần bắt buộc phải có test

Cách ly tenant, lịch lặp và múi giờ (mốc đổi giờ, ngày 31), đồng bộ và xung đột, phạm vi đồng bộ (`revoked`, `MIN_ACTIVE_ROWVERSION`), ma trận phân quyền, duyệt nhiều cấp, đặt tài nguyên đồng thời, job nền theo tenant. Chi tiết và link: [test-strategy.md#bat-buoc](../../docs/testing/test-strategy.md#bat-buoc).

## Chạy

```powershell
dotnet test tests/WorkCal.Domain.Tests        # nhanh, không cần Docker
dotnet test                                   # toàn bộ, cần Docker Desktop
```

Không sửa hoặc xóa test đang đỏ để CI xanh; sửa code hoặc hỏi chủ dự án nếu test sai.
