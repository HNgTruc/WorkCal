<a id="top"></a>

# Tool của WorkCal.Mcp

[← mcp](README.md) · [Mục lục tài liệu](../README.md)

WorkCal.Mcp là MCP server của sản phẩm (gói Business, từ v1.1). Endpoint `/mcp` (Streamable HTTP), viết bằng C# MCP SDK. Mọi tool gọi qua tầng Application nên đi qua đúng các lớp lọc tenant và phân quyền như API.

## Mục lục

- [Danh sách tool](#danh-sach)
- [Xác thực và phạm vi](#xac-thuc)
- [Bảo vệ](#bao-ve)
- [Thêm tool mới](#them-tool)

<a id="danh-sach"></a>
## Danh sách tool

| Tool | Tham số chính | Trả về | Ghi dữ liệu | Use case |
| --- | --- | --- | --- | --- |
| `list_events` | `from`, `to`, `calendarIds?` | Các lần xảy ra trong khoảng | Không | Features/Events |
| `create_event` | `title`, `start`, `end`, `attendees?`, `resourceId?`, `rrule?` | Sự kiện đã tạo | Có | Features/Events |
| `update_event` | `eventId`, `scope`, các trường đổi | Sự kiện sau khi sửa | Có | Features/Events |
| `cancel_event` | `eventId`, `scope` | Kết quả | Có | Features/Events |
| `find_free_slots` | `userIds`, `durationMinutes`, `from`, `to` | Khung rảnh chung | Không | Features/Availability |
| `find_available_rooms` | `start`, `end`, `capacity?` | Phòng trống | Không | Features/Resources |
| `list_tasks` | `status?`, `dueBefore?` | Task | Không | Features/Tasks |
| `create_task` | `title`, `due?`, `priority?`, `assigneeId?` | Task đã tạo | Có | Features/Tasks |
| `update_task_status` | `taskId`, `status` | Task | Có | Features/Tasks |
| `get_leave_balance` | `year?` | Số dư theo loại phép | Không | Features/Leaves |
| `submit_leave_request` | `leaveTypeId`, `from`, `to`, `reason` | Đơn đã gửi | Có | Features/Leaves |
| `list_my_shifts` | `from`, `to` | Ca đã xếp | Không | Features/Shifts |
| `request_shift_swap` | `assignmentId`, `toUserId` | Yêu cầu đổi ca | Có | Features/Shifts |

Code: [`Tools/`](../../src/Server/WorkCal.Mcp/Tools/) gồm `EventTools`, `AvailabilityTools`, `TaskTools`, `LeaveTools`, `ShiftTools`.

<a id="xac-thuc"></a>
## Xác thực và phạm vi

- OAuth 2.1 theo đặc tả MCP; người dùng đăng nhập WorkCal và chọn công ty khi kết nối.
- Token mang `TenantId` và `UserId`; tool chỉ làm được những gì người dùng đó được phép làm trong app.
- Owner bật/tắt WorkCal.Mcp cho cả công ty trong `/org/settings`; tắt thì mọi token MCP của công ty bị từ chối.

Code: [`Auth/`](../../src/Server/WorkCal.Mcp/Auth/).

<a id="bao-ve"></a>
## Bảo vệ

| Lớp | Chi tiết | Code |
| --- | --- | --- |
| Gói dịch vụ | Chỉ gói Business | [`Guards/`](../../src/Server/WorkCal.Mcp/Guards/) |
| Giới hạn tần suất | 60 lần gọi/phút/người; tool ghi 10 lần/phút | [`Guards/`](../../src/Server/WorkCal.Mcp/Guards/) |
| Audit | Tool ghi dữ liệu luôn ghi `AuditLogs` với `Source = mcp` | [`AuditBehavior.cs`](../../src/Server/WorkCal.Application/Common/Behaviors/AuditBehavior.cs) |
| Cách ly tenant | Test riêng cho mọi tool | [`tests/WorkCal.Mcp.Tests/`](../../tests/WorkCal.Mcp.Tests/) |
| Dữ liệu trả về | Chỉ trường cần thiết; tôn trọng quyền FreeBusy (không lộ tiêu đề) | – |

<a id="them-tool"></a>
## Thêm tool mới

Dùng skill [`add-mcp-tool`](../../.claude/skills/add-mcp-tool/SKILL.md): chọn use case có sẵn trong Application → viết tool gọi use case → thêm test cách ly → cập nhật bảng ở trang này.

[↑ Về đầu trang](#top)
