<a id="top"></a>

# Backlog

[← Roadmap](README.md)

Việc để sau, ý tưởng mới và tính năng chưa xếp vào giai đoạn nào. Mỗi lần xong một giai đoạn, rà lại danh sách này để chọn việc cho giai đoạn kế tiếp.

## Mục lục

- [Tính năng đã có trong thiết kế, chưa xếp lịch](#chua-xep)
- [Ý tưởng mới](#y-tuong)
- [Nợ kỹ thuật](#no-ky-thuat)
- [Cách thêm một mục](#cach-them)

<a id="chua-xep"></a>
## Tính năng đã có trong thiết kế, chưa xếp lịch

| Mã | Tính năng | Ưu tiên | Ghi chú |
| --- | --- | --- | --- |
| F19 | Thống kê thời gian theo lịch con, theo tuần | C | Có thể gộp vào báo cáo F33 |
| F27 | Đặt xe, thiết bị (mở rộng giao diện) | C | Bảng `Resources` đã hỗ trợ từ giai đoạn 3, còn thiếu giao diện riêng |
| F31 | Sự kiện cần duyệt trước khi vào lịch | C | Dùng lại `ApprovalStep` |
| F35 | Đồng bộ hai chiều Google Calendar, Outlook | C | Cần OAuth với từng nhà cung cấp, xử lý webhook thay đổi |
| – | Desktop cho macOS, Linux (MAUI hoặc Avalonia) | C | Sau v1.1 |
| – | Thanh toán gói thật (Stripe, VNPay) | C | Hiện gói chỉ để giới hạn tính năng |
| – | CSDL riêng cho khách Business lớn | C | Xem tài liệu thiết kế mục 8 |

<a id="y-tuong"></a>
## Ý tưởng mới

_Chưa có. Ghi ý tưởng theo mẫu ở cuối file._

<a id="no-ky-thuat"></a>
## Nợ kỹ thuật

_Ghi lại những chỗ làm tạm để kịp tiến độ, kèm link tới file code._

| Ngày ghi | Mô tả | File code | Xử lý ở |
| --- | --- | --- | --- |
| | | | |

<a id="cach-them"></a>
## Cách thêm một mục

```markdown
| F?? hoặc – | Tên ngắn | M/S/C | Lý do, phụ thuộc, link issue |
```

Khi một mục được chọn vào giai đoạn: chuyển nó thành task có mã `Px-yy` trong file giai đoạn đó và xóa dòng ở đây.

[↑ Về đầu trang](#top) · [← Roadmap](README.md)
