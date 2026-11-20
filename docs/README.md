<a id="top"></a>

# Tài liệu WorkCal

Mục lục toàn bộ tài liệu. Bấm vào tên thư mục để xem README của thư mục đó, bấm vào tên file để mở thẳng.

**Bắt đầu từ đây:** [Roadmap và tiến độ](roadmap/README.md) · [Chạy dự án trong 5 phút](guides/getting-started.md)

## Mục lục

- [Roadmap](#roadmap)
- [Yêu cầu](#requirements)
- [Kiến trúc](#architecture)
- [Cơ sở dữ liệu](#database)
- [API](#api)
- [MCP](#mcp)
- [Bảo mật](#security)
- [Kiểm thử](#testing)
- [Hướng dẫn kỹ thuật](#guides)
- [Hướng dẫn sử dụng](#user-manual)
- [Quy ước viết tài liệu](#quy-uoc)

<a id="roadmap"></a>
## [Roadmap](roadmap/README.md)

| File | Nội dung |
| --- | --- |
| [roadmap/README.md](roadmap/README.md) | Tổng quan 6 giai đoạn, giai đoạn đang làm, cách dùng |
| [phase-0-nen-mong.md](roadmap/phase-0-nen-mong.md) | Giai đoạn 0 · Nền móng · tuần 1–2 |
| [phase-1-lich-ca-nhan.md](roadmap/phase-1-lich-ca-nhan.md) | Giai đoạn 1 · Lịch cá nhân desktop · tuần 3–6 |
| [phase-2-offline-mobile.md](roadmap/phase-2-offline-mobile.md) | Giai đoạn 2 · Offline và mobile · tuần 7–10 |
| [phase-3-doanh-nghiep.md](roadmap/phase-3-doanh-nghiep.md) | Giai đoạn 3 · Doanh nghiệp, multi-tenant · tuần 11–14 |
| [phase-4-admin-v1.md](roadmap/phase-4-admin-v1.md) | Giai đoạn 4 · Web quản trị và v1.0 · tuần 15–18 |
| [phase-5-doanh-nghiep-mo-rong.md](roadmap/phase-5-doanh-nghiep-mo-rong.md) | Giai đoạn 5 · Doanh nghiệp mở rộng (v1.1) · tuần 19–24 |
| [backlog.md](roadmap/backlog.md) | Việc để sau, ý tưởng, nợ kỹ thuật |
| [progress-log.md](roadmap/progress-log.md) | Nhật ký tiến độ theo tuần |

<a id="requirements"></a>
## [Yêu cầu](requirements/README.md)

| File | Nội dung |
| --- | --- |
| [srs.md](requirements/srs.md) | Đặc tả chức năng F01–F36, yêu cầu phi chức năng |
| [roles-permissions.md](requirements/roles-permissions.md) | Ma trận vai trò × quyền |
| [use-cases/](requirements/use-cases/) | Mỗi use case một file |

<a id="architecture"></a>
## [Kiến trúc](architecture/README.md)

| File | Nội dung |
| --- | --- |
| [overview.md](architecture/overview.md) | Sơ đồ tổng thể, luồng dữ liệu |
| [multi-tenant.md](architecture/multi-tenant.md) | Lọc tenant, RLS, đổi tenant |
| [offline-sync.md](architecture/offline-sync.md) | Outbox, cursor, xử lý xung đột |
| [recurrence-timezone.md](architecture/recurrence-timezone.md) | RRULE, ngoại lệ, múi giờ |
| [diagrams/](architecture/diagrams/) | File gốc sơ đồ |
| [adr/](architecture/adr/) | Quyết định kiến trúc (0001, 0002…) |

<a id="database"></a>
## [Cơ sở dữ liệu](database/README.md)

| File | Nội dung |
| --- | --- |
| [erd.md](database/erd.md) | ERD dạng mermaid |
| [data-dictionary.md](database/data-dictionary.md) | Từng bảng, từng cột, ràng buộc |
| [migrations.md](database/migrations.md) | Quy ước tạo và chạy migration |

<a id="api"></a>
## [API](api/README.md)

| File | Nội dung |
| --- | --- |
| [openapi.json](api/openapi.json) | Xuất tự động từ API |
| [conventions.md](api/conventions.md) | REST, ProblemDetails, phân trang, versioning |
| [authentication.md](api/authentication.md) | JWT, refresh token, đổi tenant, 2FA, SSO, API key |
| [sync-protocol.md](api/sync-protocol.md) | /sync/push, /sync/pull |
| [realtime.md](api/realtime.md) | SignalR hub, sự kiện phát ra |

<a id="mcp"></a>
## [MCP](mcp/README.md)

| File | Nội dung |
| --- | --- |
| [dev-servers.md](mcp/dev-servers.md) | MCP server dùng lúc code: cài đặt, biến môi trường |
| [workcal-mcp-tools.md](mcp/workcal-mcp-tools.md) | Tool của WorkCal.Mcp, tham số, quyền |
| [connect-ai-assistant.md](mcp/connect-ai-assistant.md) | Hướng dẫn người dùng nối Claude/Copilot |

<a id="security"></a>
## [Bảo mật](security/README.md)

| File | Nội dung |
| --- | --- |
| [threat-model.md](security/threat-model.md) | Nguy cơ và cách chặn |
| [tenant-isolation.md](security/tenant-isolation.md) | Các lớp cách ly tenant, bộ test kiểm chứng |

<a id="testing"></a>
## [Kiểm thử](testing/README.md)

| File | Nội dung |
| --- | --- |
| [test-strategy.md](testing/test-strategy.md) | Loại test, phạm vi, coverage mục tiêu |

<a id="guides"></a>
## [Hướng dẫn kỹ thuật](guides/README.md)

| File | Nội dung |
| --- | --- |
| [getting-started.md](guides/getting-started.md) | Cài môi trường, chạy trong 5 phút |
| [deploy.md](guides/deploy.md) | Deploy API, web quản trị, MCP |
| [troubleshooting.md](guides/troubleshooting.md) | Lỗi hay gặp |

<a id="user-manual"></a>
## [Hướng dẫn sử dụng](user-manual/README.md)

| File | Dành cho |
| --- | --- |
| [personal.md](user-manual/personal.md) | Người dùng cá nhân |
| [member.md](user-manual/member.md) | Nhân viên |
| [manager.md](user-manual/manager.md) | Quản lý phòng ban |
| [org-admin.md](user-manual/org-admin.md) | Owner, Admin, HR |
| [platform-admin.md](user-manual/platform-admin.md) | Super Admin |

<a id="quy-uoc"></a>
## Quy ước viết tài liệu

- Mỗi file dài hơn một màn hình có **mục lục ở đầu**, mỗi mục là link tới phần tương ứng, và link **↑ Về đầu trang** ở cuối.
- Anchor đặt rõ ràng bằng `<a id="ten-khong-dau"></a>` ngay trên tiêu đề, vì tiêu đề tiếng Việt có dấu sinh anchor không ổn định.
- Khi nhắc tới code, **luôn để link tương đối tới file**, ví dụ [`src/Server/WorkCal.Api/Program.cs`](../src/Server/WorkCal.Api/Program.cs).
- Thêm file mới vào `docs/` thì thêm một dòng vào mục lục này và vào README của thư mục chứa nó.

[↑ Về đầu trang](#top)
