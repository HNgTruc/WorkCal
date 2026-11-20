# api

[← Mục lục tài liệu](../README.md)

## Mục đích
Tài liệu cho người gọi API WorkCal: quy ước chung, xác thực, giao thức đồng bộ, thời gian thực. Danh sách endpoint đầy đủ lấy từ `openapi.json` (sinh tự động).

## Nội dung chính
| File | Vai trò |
| --- | --- |
| [openapi.json](openapi.json) | Đặc tả OpenAPI, ghi đè bằng `scripts/export-openapi.ps1` |
| [conventions.md](conventions.md) | REST, lỗi, phân trang, versioning, danh sách nhóm endpoint |
| [authentication.md](authentication.md) | Đăng nhập, token, đổi tenant, 2FA, SSO, API key |
| [sync-protocol.md](sync-protocol.md) | `/sync/push`, `/sync/pull` |
| [realtime.md](realtime.md) | SignalR hub và sự kiện |

## Phụ thuộc
Code: [`WorkCal.Api/`](../../src/Server/WorkCal.Api/), DTO: [`WorkCal.Contracts/`](../../src/Shared/WorkCal.Contracts/).

## Quy ước và lưu ý
Không sửa tay `openapi.json`. CI so sánh file này với bản sinh từ code; lệch thì báo đỏ.
