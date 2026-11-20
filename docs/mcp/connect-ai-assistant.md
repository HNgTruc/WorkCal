<a id="top"></a>

# Nối trợ lý AI với WorkCal

[← mcp](README.md) · [Mục lục tài liệu](../README.md)

> Bản nháp. Hoàn thiện khi WorkCal.Mcp chạy thật ([P5-12](../roadmap/phase-5-doanh-nghiep-mo-rong.md#p5-12)); thêm ảnh chụp từng bước.

## Mục lục

- [Điều kiện](#dieu-kien)
- [Claude](#claude)
- [GitHub Copilot trong VS Code](#copilot)
- [Câu hỏi mẫu](#cau-hoi)
- [Gỡ kết nối](#go)

<a id="dieu-kien"></a>
## Điều kiện

- Công ty dùng gói Business và Owner đã bật MCP trong **Quản trị → Cài đặt → Trợ lý AI**.
- Địa chỉ MCP của công ty: `https://<ten-mien-workcal>/mcp`.

<a id="claude"></a>
## Claude

1. Mở phần kết nối (connector) trong cài đặt Claude, chọn thêm connector tùy chỉnh.
2. Dán địa chỉ MCP của WorkCal.
3. Đăng nhập WorkCal trong cửa sổ hiện ra, chọn công ty, cho phép truy cập.

<a id="copilot"></a>
## GitHub Copilot trong VS Code

Thêm vào `.vscode/mcp.json`:

```json
{
  "servers": {
    "workcal": { "type": "http", "url": "https://<ten-mien-workcal>/mcp" }
  }
}
```

Lần gọi đầu tiên VS Code mở trang đăng nhập WorkCal.

<a id="cau-hoi"></a>
## Câu hỏi mẫu

- "Tuần này tôi còn những cuộc họp nào?"
- "Thứ 3 tuần sau tôi và chị Lan cùng rảnh lúc nào? Đặt 30 phút, lấy phòng nào còn trống."
- "Tạo task gửi báo cáo tháng, hạn thứ 6."
- "Tôi còn bao nhiêu ngày phép năm? Xin nghỉ thứ 6 tuần sau."

<a id="go"></a>
## Gỡ kết nối

Xóa connector trong trợ lý AI, hoặc vào **Hồ sơ → Ứng dụng đã kết nối** trong WorkCal để thu hồi quyền.

[↑ Về đầu trang](#top)
