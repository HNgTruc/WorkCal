# Rule: Dùng MCP server khi code

Áp dụng mọi phiên. Danh sách và cách cài: [docs/mcp/dev-servers.md](../../docs/mcp/dev-servers.md) (`.mcp.json` tạo ở [P0-07](../../docs/roadmap/phase-0-nen-mong.md#p0-07)).

| Server | Dùng khi | Lưu ý |
| --- | --- | --- |
| `microsoft-learn` | Hỏi API .NET, ASP.NET Core, EF Core, Blazor, MAUI, WPF | Tra trước khi đoán tên method, tham số, hành vi |
| `nuget` | Định thêm hoặc nâng package | Kiểm tra phiên bản và lỗ hổng; **vẫn phải hỏi chủ dự án** trước khi thêm (quy tắc 3) |
| `github` | Đọc issue, xem kết quả CI, xem PR | Không merge, không push, không tạo release (quy tắc 4) |
| `playwright` | Mở web quản trị để kiểm tra giao diện | Chỉ môi trường dev |
| `workcal-sql` | Xem dữ liệu CSDL dev khi debug | **Chỉ đọc**, chỉ CSDL dev; đổi schema luôn qua migration |

## Không được

- Không dán token, chuỗi kết nối, mật khẩu vào chat, file hay tham số MCP.
- Không trỏ MCP vào CSDL production hay dịch vụ thật của khách hàng.
- Không dùng dữ liệu `workcal-sql` trả về làm dữ liệu seed hay test cố định.
