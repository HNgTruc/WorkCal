# UC-08 · Dùng trợ lý AI qua WorkCal.Mcp

[← use-cases](README.md)

- **Tác nhân:** thành viên công ty dùng Claude hoặc Copilot.
- **Điều kiện trước:** công ty dùng gói Business, Owner đã bật MCP trong `/org/settings`.

**Luồng chính**
1. Người dùng thêm WorkCal vào trợ lý AI, đăng nhập bằng OAuth và chọn công ty.
2. Người dùng hỏi: "Thứ 3 tuần sau tôi và anh Minh cùng rảnh lúc nào?"
3. Trợ lý gọi `AvailabilityTools`, nhận các khung rảnh chung.
4. Người dùng: "Đặt họp 30 phút lúc 10h, phòng nào còn trống thì lấy."
5. Trợ lý gọi `EventTools`; WorkCal tạo sự kiện, mời anh Minh, ghi audit với nguồn `mcp`.

**Luồng phụ**
- 3a. Người dùng không có quyền xem free/busy của người được nhắc → tool trả lỗi quyền, trợ lý báo lại.
- 5a. Vượt giới hạn tần suất → tool trả lỗi, trợ lý đề nghị thử lại sau.

**Kết quả:** cuộc họp được tạo đúng quyền người dùng, có dấu vết trong audit.

**Liên kết:** [workcal-mcp-tools.md](../../mcp/workcal-mcp-tools.md) · [P5-11](../../roadmap/phase-5-doanh-nghiep-mo-rong.md#p5-11)
