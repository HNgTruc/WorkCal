<a id="top"></a>

# Chiến lược kiểm thử

[← testing](README.md) · [Mục lục tài liệu](../README.md)

Mọi PR phải xanh ở CI: build không cảnh báo, toàn bộ test qua, check-readme qua. Coverage tầng Domain + Application tối thiểu 70%.

## Mục lục

- [Các loại test](#loai)
- [Cách chạy](#chay)
- [Quy ước](#quy-uoc)
- [Những thứ bắt buộc phải có test](#bat-buoc)

<a id="loai"></a>
## Các loại test

| Loại | Project | Công cụ | Kiểm tra gì |
| --- | --- | --- | --- |
| Unit Domain | [`WorkCal.Domain.Tests`](../../tests/WorkCal.Domain.Tests/) | xUnit, FluentAssertions | Quy tắc nghiệp vụ, không cần CSDL |
| Unit Application | [`WorkCal.Application.Tests`](../../tests/WorkCal.Application.Tests/) | xUnit, NSubstitute | Handler, validator, lịch lặp |
| Integration API | [`WorkCal.Api.IntegrationTests`](../../tests/WorkCal.Api.IntegrationTests/) | WebApplicationFactory, Testcontainers (SQL Server, Redis), Respawn | Endpoint thật với CSDL thật, phân quyền, cách ly tenant, sync |
| Client | [`WorkCal.Client.Core.Tests`](../../tests/WorkCal.Client.Core.Tests/) | xUnit, SQLite in-memory | ViewModel, outbox, SyncEngine, xung đột |
| MCP | [`WorkCal.Mcp.Tests`](../../tests/WorkCal.Mcp.Tests/) | xUnit, MCP client của SDK | Tool trả đúng dữ liệu, không lộ tenant khác |
| Web quản trị | [`WorkCal.Admin.Tests`](../../tests/WorkCal.Admin.Tests/) | bUnit, Playwright | Component; 3 luồng end-to-end chính |

<a id="chay"></a>
## Cách chạy

```bash
dotnet test                                   # toàn bộ (cần Docker cho integration)
dotnet test tests/WorkCal.Domain.Tests        # nhanh, không cần Docker
dotnet test --collect:"XPlat Code Coverage"   # kèm coverage
```

CI: [`.github/workflows/ci.yml`](../../.github/workflows/ci.yml).

<a id="quy-uoc"></a>
## Quy ước

- Tên test: `Phương_thức_Tình_huống_Kỳ_vọng`, ví dụ `Expand_WeeklyAcrossDst_KeepsLocalTime`.
- Một test kiểm tra một hành vi; bố cục Arrange / Act / Assert.
- Integration test dùng chung một container cho cả bộ, reset dữ liệu bằng Respawn giữa các test.
- Không dùng `Thread.Sleep`; thời gian giả lập bằng `TimeProvider`.

<a id="bat-buoc"></a>
## Những thứ bắt buộc phải có test

| Phần | Lý do | Tài liệu |
| --- | --- | --- |
| Cách ly tenant | Lỗi ở đây là lộ dữ liệu khách hàng | [tenant-isolation.md](../security/tenant-isolation.md) |
| Lịch lặp và múi giờ | Dễ sai ở mốc đổi giờ, ngày 31 | [recurrence-timezone.md](../architecture/recurrence-timezone.md#test) |
| Đồng bộ và xung đột | Sai là mất dữ liệu người dùng | [offline-sync.md](../architecture/offline-sync.md) |
| Ma trận phân quyền | Leo quyền | [roles-permissions.md](../requirements/roles-permissions.md) |
| Duyệt nhiều cấp | Sai luồng là sai số dư phép | [uc-05](../requirements/use-cases/uc-05-xin-nghi-phep.md) |
| Đặt phòng đồng thời | Hai người cùng giữ một phòng | [P3-11](../roadmap/phase-3-doanh-nghiep.md#p3-11) |

[↑ Về đầu trang](#top)
