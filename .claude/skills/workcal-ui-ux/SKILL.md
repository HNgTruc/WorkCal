---
name: workcal-ui-ux
description: Quy trình và checklist thiết kế, dựng, rà soát giao diện WorkCal trên WPF (Desktop), .NET MAUI (Mobile) và Blazor + MudBlazor (Admin), gồm trợ năng, trạng thái offline, màu sự kiện lịch và animation (GSAP chỉ cho Blazor). Dùng khi làm hoặc review màn hình, component, theme, animation.
---

# Giao diện WorkCal

Dùng cùng rule [`ui-mvvm`](../../rules/ui-mvvm.md). Ghi chú theo nền tảng: [references/stacks.md](references/stacks.md). Animation web bằng GSAP: [references/gsap-blazor.md](references/gsap-blazor.md).

## 1. Chuẩn bị

1. Đọc task trong `docs/roadmap/` và trang hướng dẫn của vai trò dùng màn hình trong [`docs/user-manual/`](../../../docs/user-manual/README.md) (cá nhân, member, manager, org-admin, platform-admin).
2. Xác định nền tảng: Desktop (WPF), Mobile (MAUI), Admin (Blazor + MudBlazor). Logic luôn ở `WorkCal.Client.Core` hoặc `Admin/Services`, không ở View.
3. Kiểm tra design system: repo **chưa có** tài liệu bảng màu, kiểu chữ, khoảng cách. Khi cần tới, đề xuất một bộ (màu chính, màu ngữ nghĩa thành công/cảnh báo/lỗi, màu nền sáng và tối, cỡ chữ, thang khoảng cách) kèm lý do, rồi **hỏi chủ dự án**; không tự chọn giá trị tạm. Đã chốt thì dùng đúng bộ đó qua resource/theme.
4. Màn hình mới, thư viện UI hoặc control mới ngoài task: hỏi trước (quy tắc 3).

## 2. Checklist theo thứ tự ưu tiên

| # | Nhóm | Phải có | Tránh |
| --- | --- | --- | --- |
| 1 | Trợ năng | Tương phản chữ tối thiểu 4.5:1 (chữ lớn 3:1); mọi nút chỉ có icon đều có tên đọc được; dùng được bằng bàn phím, thứ tự Tab hợp lý, focus nhìn thấy | Bỏ khung focus; thông tin chỉ thể hiện bằng màu |
| 2 | Chạm và tương tác | Vùng chạm tối thiểu 44×44 (iOS) / 48×48 dp (Android), cách nhau từ 8; phản hồi ngay khi bấm; nút bị khóa khi đang gửi | Chức năng chỉ có khi rê chuột; bấm hai lần tạo hai bản ghi |
| 3 | Trạng thái | Mỗi danh sách và màn hình có đủ: đang tải, trống (kèm hành động gợi ý), lỗi (kèm thử lại), **offline** (dữ liệu cục bộ vẫn xem và sửa được, có dấu "chưa đồng bộ") | Màn hình trắng khi chờ mạng; chặn thao tác sự kiện/task vì mất mạng |
| 4 | Màu và theme | Màu lấy từ `ResourceDictionary` (WPF, MAUI) hoặc `MudTheme` (Admin); hỗ trợ sáng và tối | Mã hex viết thẳng trong View hay component |
| 5 | Kiểu chữ | Chữ thân tối thiểu 14 (desktop, web) / 16 (mobile); giãn dòng khoảng 1.4–1.5; phân cấp tiêu đề rõ | Chữ dưới 12; quá ba cỡ chữ trên một màn hình |
| 6 | Bố cục | Lưới và khoảng cách theo một thang thống nhất; co giãn theo kích thước cửa sổ; tiếng Việt có dấu không bị cắt | Canh lề bằng `Margin` lớn cố định; chiều rộng cố định làm tràn chữ |
| 7 | Animation | 150–300 ms cho chuyển trạng thái; chỉ animate vị trí, tỉ lệ, độ mờ; tôn trọng thiết lập giảm chuyển động của hệ điều hành | Một thời lượng cho mọi thứ; animate kích thước gây giật bố cục |
| 8 | Form | Nhãn luôn hiển thị; lỗi hiện ngay dưới ô nhập, bằng tiếng Việt, nói cách sửa; giữ dữ liệu đã nhập khi lỗi | Chỉ dùng placeholder làm nhãn; chỉ báo lỗi ở đầu trang |
| 9 | Điều hướng | Nút quay lại dự đoán được; mobile tối đa 5 mục ở thanh dưới; Admin tách khu `/platform` và `/org`, menu theo vai trò | Menu chứa chức năng người dùng không có quyền dùng |
| 10 | Biểu đồ, báo cáo | Có chú thích và tooltip; màu phân biệt được với người mù màu; có số liệu dạng chữ | Phân biệt nhóm chỉ bằng màu đỏ/xanh |

## 3. Riêng cho lịch

- Màu sự kiện và lịch do người dùng chọn phải đủ tương phản với chữ trên nó: tính độ sáng và đổi chữ sáng/tối tự động.
- Trùng giờ, chờ duyệt, đã hủy, chưa đồng bộ: thể hiện bằng icon hoặc kiểu viền **kèm** màu, có tooltip/tên đọc được.
- Luôn hiển thị theo múi giờ của người dùng; khi khác múi giờ của lịch hoặc người tổ chức thì ghi rõ.
- Sự kiện cả ngày hiển thị ở dải riêng, không gắn giờ; sự kiện lặp có dấu hiệu lặp và hỏi "chỉ lần này / từ lần này / tất cả" khi sửa.
- Lưới lịch dùng Syncfusion Scheduler (giấy phép Community, key trong User Secrets). Tùy biến bằng template và style của control, không vẽ lại lưới.
- Kéo thả trên desktop phải có cách làm tương đương bằng bàn phím hoặc form.

## 4. Trước khi giao

- [ ] Chạy thử ở theme sáng và tối, cửa sổ hẹp và rộng (Desktop, Admin), màn hình nhỏ (Mobile).
- [ ] Đi hết luồng chỉ bằng bàn phím (Desktop, Admin); bật trình đọc màn hình kiểm tra nút icon (Narrator, TalkBack/VoiceOver).
- [ ] Ngắt mạng: màn hình vẫn dùng được với dữ liệu cục bộ, có dấu chưa đồng bộ.
- [ ] Không có mã màu viết thẳng, không có chuỗi tiếng Anh sót lại trên giao diện.
- [ ] ViewModel có test trong `WorkCal.Client.Core.Tests`; component Admin có test bUnit nếu có logic hiển thị.
- [ ] Cập nhật README thư mục và `docs/user-manual/` nếu luồng người dùng thay đổi.
