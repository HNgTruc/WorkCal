<a id="top"></a>

# MCP server lúc phát triển

[← mcp](README.md) · [Mục lục tài liệu](../README.md)

Năm MCP server khai báo trong [`.mcp.json`](../../.mcp.json) ở gốc repo, dùng chung cho mọi người làm dự án. Token lấy từ biến môi trường, không ghi vào file.

## Mục lục

- [Danh sách server](#danh-sach)
- [File .mcp.json](#file)
- [Cài đặt](#cai-dat)
- [Quy tắc dùng](#quy-tac)

<a id="danh-sach"></a>
## Danh sách server

| Server | Dùng để | Yêu cầu |
| --- | --- | --- |
| `microsoft-learn` | Tra tài liệu chính thức .NET, EF Core, Blazor, MAUI, Azure | Không cần xác thực |
| `nuget` | Tra phiên bản, tìm và sửa package có lỗ hổng | .NET 10 SDK (lệnh `dnx`) |
| `github` | Đọc issue, tạo PR, xem kết quả CI | Biến `GITHUB_PAT` |
| `playwright` | Mở web quản trị, kiểm tra giao diện | Node.js |
| `workcal-sql` | Xem dữ liệu CSDL dev | Docker; SQL MCP Server của Microsoft (đang preview) |

<a id="file"></a>
## File .mcp.json

```json
{
  "mcpServers": {
    "microsoft-learn": { "type": "http", "url": "https://learn.microsoft.com/api/mcp" },
    "nuget": { "type": "stdio", "command": "dnx", "args": ["NuGet.Mcp.Server", "--yes"] },
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": { "Authorization": "Bearer ${GITHUB_PAT}" }
    },
    "playwright": { "type": "stdio", "command": "npx", "args": ["@playwright/mcp@latest"] },
    "workcal-sql": { "type": "http", "url": "http://localhost:5100/mcp" }
  }
}
```

Địa chỉ `workcal-sql` phụ thuộc cổng đặt cho service `sql-mcp` trong [`docker-compose.yml`](../../docker-compose.yml); kiểm tra lại theo tài liệu SQL MCP Server khi dựng.

<a id="cai-dat"></a>
## Cài đặt

1. Cài .NET 10 SDK, Node.js LTS, Docker Desktop.
2. Tạo GitHub fine-grained token chỉ cho repo WorkCal (quyền Issues, Pull requests, Actions: read/write), đặt biến môi trường `GITHUB_PAT`.
3. `docker compose up -d` để chạy SQL Server và `sql-mcp`.
4. Cấu hình `workcal-sql` trong [`tools/mcp/dab-config.json`](../../tools/mcp/dab-config.json): chỉ expose các bảng cần xem, dùng tài khoản SQL `workcal_readonly`.
5. Mở Claude Code ở gốc repo, chạy `/mcp` để xem cả 5 server đã kết nối.

<a id="quy-tac"></a>
## Quy tắc dùng

Chi tiết trong [`.claude/rules/mcp-usage.md`](../../.claude/rules/mcp-usage.md). Tóm tắt:

- Hỏi API .NET, EF Core, MAUI → `microsoft-learn` trước khi đoán.
- Thêm hoặc nâng package → `nuget` để kiểm tra lỗ hổng và tương thích.
- `workcal-sql` **chỉ đọc**, chỉ nối CSDL dev; đổi schema luôn qua migration.
- Không dán token vào chat hay file; không cho MCP truy cập CSDL production.

[↑ Về đầu trang](#top)
