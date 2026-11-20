# mcp

[← Mục lục tài liệu](../README.md)

## Mục đích
WorkCal dùng MCP theo hai cách: các MCP server hỗ trợ Claude Code **lúc phát triển**, và **WorkCal.Mcp**, MCP server của sản phẩm để người dùng nối trợ lý AI vào lịch của họ.

## Nội dung chính
| File | Vai trò |
| --- | --- |
| [dev-servers.md](dev-servers.md) | MCP server lúc code: cài đặt, biến môi trường, quy tắc dùng |
| [workcal-mcp-tools.md](workcal-mcp-tools.md) | Tool của WorkCal.Mcp: tham số, quyền, bảo vệ |
| [connect-ai-assistant.md](connect-ai-assistant.md) | Hướng dẫn người dùng nối Claude hoặc Copilot với WorkCal |

## Phụ thuộc
Cấu hình: [`.mcp.json`](../../.mcp.json), [`tools/mcp/`](../../tools/mcp/). Code: [`src/Server/WorkCal.Mcp/`](../../src/Server/WorkCal.Mcp/).
