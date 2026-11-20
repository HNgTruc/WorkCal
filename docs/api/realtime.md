<a id="top"></a>

# Thời gian thực (SignalR)

[← api](README.md) · [Mục lục tài liệu](../README.md)

Hub `/hubs/calendar` chỉ dùng để **báo có thay đổi**; client nhận tín hiệu thì gọi [`/sync/pull`](sync-protocol.md#pull). Cách này giữ một đường dữ liệu duy nhất và client offline lâu vẫn bắt kịp đúng.

## Mục lục

- [Kết nối](#ket-noi)
- [Nhóm](#nhom)
- [Sự kiện server gửi](#su-kien)
- [Mở rộng nhiều instance](#mo-rong)

<a id="ket-noi"></a>
## Kết nối

```csharp
var hub = new HubConnectionBuilder()
    .WithUrl($"{baseUrl}/hubs/calendar", o => o.AccessTokenProvider = tokenStore.GetAccessTokenAsync)
    .WithAutomaticReconnect()
    .Build();

hub.On<string>("ChangesAvailable", cursor => syncEngine.PullAsync());
await hub.StartAsync();
```

Token gửi qua query `access_token` (SignalR không gửi header khi dùng WebSocket). Đổi tenant thì ngắt và kết nối lại với token mới.

<a id="nhom"></a>
## Nhóm

| Nhóm | Ai tham gia | Dùng cho |
| --- | --- | --- |
| `user:{userId}` | Mọi thiết bị của một người | Thay đổi lịch của chính họ, lời mời mới |
| `tenant:{tenantId}` | Mọi thành viên đang online | Ngày lễ, thông báo toàn công ty, banner hệ thống |
| `dept:{departmentId}` | Thành viên phòng ban | Lịch phòng ban, bảng tin phòng ban |

Server tự thêm vào nhóm khi kết nối, dựa trên claim trong token.

<a id="su-kien"></a>
## Sự kiện server gửi

| Sự kiện | Tham số | Client làm gì |
| --- | --- | --- |
| `ChangesAvailable` | `cursor` | Gọi `/sync/pull` |
| `InvitationReceived` | `eventId` | Hiện thông báo trong app |
| `ApprovalRequested` | `approvalId`, `subjectType` | Cập nhật số đơn chờ duyệt |
| `Announcement` | `id`, `title` | Hiện banner hoặc bảng tin |
| `TenantLocked` | – | Đăng xuất khỏi tenant, báo người dùng |

<a id="mo-rong"></a>
## Mở rộng nhiều instance

Dùng Redis backplane (`AddStackExchangeRedis`) để tin nhắn tới đúng client dù client nối vào instance API nào.

Code: [`CalendarHub.cs`](../../src/Server/WorkCal.Api/Hubs/CalendarHub.cs) · [`RealtimeClient.cs`](../../src/Clients/WorkCal.Client.Core/Sync/RealtimeClient.cs) · Task: [P2-06](../roadmap/phase-2-offline-mobile.md#p2-06)

[↑ Về đầu trang](#top)
