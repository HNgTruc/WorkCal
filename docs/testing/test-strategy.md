<a id="top"></a>

# Chiến lược kiểm thử

[← testing](README.md) · [Mục lục tài liệu](../README.md)

Mọi PR phải xanh ở CI: build không cảnh báo, toàn bộ test qua, check-readme qua. Coverage tầng Domain + Application tối thiểu 70% (xem [Coverage](#coverage)).

## Mục lục

- [Các loại test](#loai)
- [Cách chạy](#chay)
- [Coverage](#coverage)
- [Quy ước](#quy-uoc)
- [Những thứ bắt buộc phải có test](#bat-buoc)

<a id="loai"></a>
## Các loại test

| Loại | Project | Công cụ | Kiểm tra gì |
| --- | --- | --- | --- |
| Unit Domain | [`WorkCal.Domain.Tests`](../../tests/WorkCal.Domain.Tests/) | xUnit, AwesomeAssertions | Quy tắc nghiệp vụ, không cần CSDL |
| Unit Application | [`WorkCal.Application.Tests`](../../tests/WorkCal.Application.Tests/) | xUnit, AwesomeAssertions, NSubstitute | Handler, validator, lịch lặp |
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

**Thư viện assertion:** AwesomeAssertions (fork Apache-2.0 của FluentAssertions 7, cú pháp `.Should().Be()`). Không dùng FluentAssertions 8 trở lên vì đã chuyển sang giấy phép thương mại.

<a id="coverage"></a>
## Coverage

| Giai đoạn | CI làm gì |
| --- | --- |
| Từ P0-13 | Thu coverage bằng `XPlat Code Coverage` (coverlet), gộp bằng ReportGenerator, in tóm tắt vào summary của job; **không chặn** |
| Từ P1-01 (có code nghiệp vụ) | Line coverage của `WorkCal.Domain` + `WorkCal.Application` dưới 70% → job `build-test` đỏ, PR không merge được |

Chỉ tính hai project trên; Infrastructure, Api, client đo để tham khảo.

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
| Phạm vi đồng bộ | Được chia sẻ thì nhận đủ sự kiện cũ, bị thu hồi thì nhận `revoked`; transaction commit chậm không bị bỏ sót (`MIN_ACTIVE_ROWVERSION`) | [offline-sync.md](../architecture/offline-sync.md#pham-vi) |
| Job nền theo tenant | Job không đọc, ghi dữ liệu tenant khác | [multi-tenant.md](../architecture/multi-tenant.md#job-nen) |

[↑ Về đầu trang](#top)
