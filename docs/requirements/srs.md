<a id="top"></a>

# Đặc tả yêu cầu (SRS)

[← requirements](README.md) · [Mục lục tài liệu](../README.md)

WorkCal là hệ thống quản lý lịch làm việc cho người dùng cá nhân và doanh nghiệp, chạy trên Windows desktop (WPF), điện thoại Android/iOS (.NET MAUI) và web quản trị (Blazor), dùng chung một backend ASP.NET Core. Mỗi doanh nghiệp là một tenant riêng; người dùng cá nhân cũng là một tenant có đúng một thành viên.

## Mục lục

- [1. Phạm vi và mục tiêu](#pham-vi)
- [2. Ngoài phạm vi](#ngoai-pham-vi)
- [3. Chức năng cốt lõi F01–F20](#chuc-nang-cot-loi)
- [4. Chức năng doanh nghiệp mở rộng F21–F36](#chuc-nang-mo-rong)
- [5. Yêu cầu phi chức năng](#phi-chuc-nang)
- [6. Thuật ngữ](#thuat-ngu)

<a id="pham-vi"></a>
## 1. Phạm vi và mục tiêu

**Phiên bản 1.0** (tuần 18):

1. Quản lý sự kiện, task và lời nhắc, có lịch lặp và múi giờ.
2. Dùng được khi mất mạng, tự đồng bộ khi có mạng lại.
3. Doanh nghiệp tạo không gian riêng, mời nhân viên, chia phòng ban, xem lịch rảnh, đặt lịch họp, duyệt nghỉ phép; có web quản trị cho Super Admin và cho từng công ty.
4. Code sạch, có test và CI để làm portfolio trên GitHub.

**Phiên bản 1.1** (tuần 24): ca làm việc, chấm công, báo cáo, tích hợp ngoài, MCP server của WorkCal.

<a id="ngoai-pham-vi"></a>
## 2. Ngoài phạm vi

Thanh toán gói thật, desktop cho macOS/Linux, đồng bộ hai chiều Google Calendar/Outlook (F35, để sau v1.1). Xem [backlog](../roadmap/backlog.md).

<a id="chuc-nang-cot-loi"></a>
## 3. Chức năng cốt lõi F01–F20

Ưu tiên theo MoSCoW: **M** bắt buộc cho 1.0, **S** nên có, **C** có thì tốt.

| Mã | Module | Chức năng | Ưu tiên | Giai đoạn |
| --- | --- | --- | --- | --- |
| F01 | Xác thực | Đăng ký, đăng nhập email/mật khẩu, quên mật khẩu, xác minh email | M | [0](../roadmap/phase-0-nen-mong.md#p0-11) |
| F02 | Xác thực | Đăng nhập Google, xác thực 2 bước (TOTP) | S | [4](../roadmap/phase-4-admin-v1.md#p4-02) |
| F03 | Lịch | Tạo/sửa/xóa sự kiện: tiêu đề, thời gian, địa điểm, mô tả, màu, cả ngày | M | [1](../roadmap/phase-1-lich-ca-nhan.md#p1-03) |
| F04 | Lịch | Xem theo ngày/tuần/tháng/danh sách; kéo thả đổi giờ trên desktop | M | [1](../roadmap/phase-1-lich-ca-nhan.md#p1-10) |
| F05 | Lịch | Sự kiện lặp, sửa một lần hoặc cả chuỗi | M | [1](../roadmap/phase-1-lich-ca-nhan.md#p1-04) |
| F06 | Lịch | Nhiều lịch con (Cá nhân, Công việc, Phòng ban), bật/tắt hiển thị, chia sẻ | M | [1](../roadmap/phase-1-lich-ca-nhan.md#p1-02), [3](../roadmap/phase-3-doanh-nghiep.md#p3-07) |
| F07 | Công việc | Task có hạn, độ ưu tiên, trạng thái, checklist; hiện trên lịch | M | [1](../roadmap/phase-1-lich-ca-nhan.md#p1-06) |
| F08 | Công việc | Manager giao task cho thành viên, theo dõi tiến độ | S | [3](../roadmap/phase-3-doanh-nghiep.md) |
| F09 | Nhắc | Nhắc trước X phút qua thông báo desktop, push mobile, email | M | [1](../roadmap/phase-1-lich-ca-nhan.md#p1-07), [2](../roadmap/phase-2-offline-mobile.md#p2-10) |
| F10 | Cộng tác | Mời người tham gia, phản hồi Đồng ý / Từ chối / Có thể | M | [3](../roadmap/phase-3-doanh-nghiep.md#p3-09) |
| F11 | Cộng tác | Xem lịch rảnh/bận của đồng nghiệp, gợi ý khung giờ chung | S | [3](../roadmap/phase-3-doanh-nghiep.md#p3-10) |
| F12 | Cộng tác | Đặt phòng họp, chặn trùng phòng | S | [3](../roadmap/phase-3-doanh-nghiep.md#p3-11) |
| F13 | Doanh nghiệp | Tạo tenant, mời thành viên, phân vai trò, phòng ban | M | [3](../roadmap/phase-3-doanh-nghiep.md#p3-01) |
| F14 | Doanh nghiệp | Cài đặt tenant: logo, múi giờ, giờ làm việc, ngày nghỉ lễ | S | [4](../roadmap/phase-4-admin-v1.md#p4-08) |
| F15 | Doanh nghiệp | Nhật ký hoạt động (audit log) | S | [4](../roadmap/phase-4-admin-v1.md#p4-03) |
| F16 | Nền tảng | Trang Super Admin: tenant, gói, giới hạn | M | [4](../roadmap/phase-4-admin-v1.md#p4-04) |
| F17 | Nền tảng | Gói Free / Pro / Business với giới hạn tính năng | S | [3](../roadmap/phase-3-doanh-nghiep.md#p3-08) |
| F18 | Tiện ích | Tìm kiếm sự kiện/task, xuất/nhập file .ics | S | [1](../roadmap/phase-1-lich-ca-nhan.md#p1-13), [4](../roadmap/phase-4-admin-v1.md#p4-09) |
| F19 | Tiện ích | Thống kê thời gian theo lịch con, theo tuần | C | [backlog](../roadmap/backlog.md) |
| F20 | Tiện ích | Giao diện sáng/tối, tiếng Việt/tiếng Anh | S | [1](../roadmap/phase-1-lich-ca-nhan.md#p1-09) |

<a id="chuc-nang-mo-rong"></a>
## 4. Chức năng doanh nghiệp mở rộng F21–F36

| Mã | Module | Chức năng | Ưu tiên | Giai đoạn |
| --- | --- | --- | --- | --- |
| F21 | Ca làm việc | Mẫu ca, xếp ca theo tuần cho phòng ban bằng kéo thả | S | [5](../roadmap/phase-5-doanh-nghiep-mo-rong.md#p5-01) |
| F22 | Ca làm việc | Đăng ký ca, đổi ca với đồng nghiệp, Manager duyệt | S | [5](../roadmap/phase-5-doanh-nghiep-mo-rong.md#p5-02) |
| F23 | Nghỉ phép | Loại phép, số ngày phép, gửi đơn, duyệt 2 cấp Manager → HR | M | [3](../roadmap/phase-3-doanh-nghiep.md#p3-12) |
| F24 | Nghỉ phép | Đơn được duyệt tự chặn lịch, báo người tổ chức họp bị trùng | S | [3](../roadmap/phase-3-doanh-nghiep.md#p3-12) |
| F25 | Chấm công | Check-in/out trên mobile bằng QR hoặc GPS trong bán kính | S | [5](../roadmap/phase-5-doanh-nghiep-mo-rong.md#p5-03) |
| F26 | Chấm công | Bảng công tháng: đi muộn, về sớm, tăng ca; xuất Excel | S | [5](../roadmap/phase-5-doanh-nghiep-mo-rong.md#p5-04) |
| F27 | Tài nguyên | Đặt xe, máy chiếu, thiết bị | C | [backlog](../roadmap/backlog.md) |
| F28 | Doanh nghiệp | Lịch công ty: ngày lễ, sự kiện toàn công ty, giờ làm việc chuẩn | S | [4](../roadmap/phase-4-admin-v1.md#p4-08) |
| F29 | Doanh nghiệp | Nhập nhân viên và phòng ban từ Excel/CSV | S | [5](../roadmap/phase-5-doanh-nghiep-mo-rong.md#p5-06) |
| F30 | Doanh nghiệp | Bảng tin nội bộ, đẩy push | C | [5](../roadmap/phase-5-doanh-nghiep-mo-rong.md#p5-07) |
| F31 | Cộng tác | Sự kiện cần duyệt trước khi vào lịch | C | [backlog](../roadmap/backlog.md) |
| F32 | Cộng tác | Trang đặt hẹn công khai cho khách | C | [5](../roadmap/phase-5-doanh-nghiep-mo-rong.md#p5-08) |
| F33 | Báo cáo | Dashboard giờ họp, dùng phòng, nghỉ phép, đi muộn; xuất Excel/PDF | S | [5](../roadmap/phase-5-doanh-nghiep-mo-rong.md#p5-05) |
| F34 | Xác thực | SSO Microsoft Entra ID / Google Workspace | C | [5](../roadmap/phase-5-doanh-nghiep-mo-rong.md#p5-10) |
| F35 | Tích hợp | Đồng bộ hai chiều Google Calendar và Outlook | C | [backlog](../roadmap/backlog.md) |
| F36 | Tích hợp | Webhook và API key cho HRM, ERP | C | [5](../roadmap/phase-5-doanh-nghiep-mo-rong.md#p5-09) |

<a id="phi-chuc-nang"></a>
## 5. Yêu cầu phi chức năng

| Nhóm | Chỉ tiêu | Kiểm chứng |
| --- | --- | --- |
| Hiệu năng | API đọc lịch 1 tháng dưới 300 ms (p95) với 500 sự kiện; mở app desktop dưới 2 giây | Test hiệu năng trong CI |
| Offline | Xem/tạo/sửa không cần mạng; đồng bộ xong trong 5 giây khi có mạng lại | [offline-sync.md](../architecture/offline-sync.md) |
| Thời gian thực | Thay đổi từ thiết bị khác hiện trong 2 giây khi online | [realtime.md](../api/realtime.md) |
| Cách ly dữ liệu | Không truy vấn nào đọc được dữ liệu tenant khác | [tenant-isolation.md](../security/tenant-isolation.md) |
| Mở rộng | API stateless, chạy nhiều instance; SignalR dùng Redis backplane | [overview.md](../architecture/overview.md) |
| Chất lượng code | Coverage Domain + Application ≥ 70%; CI chạy build + test mỗi PR | [test-strategy.md](../testing/test-strategy.md) |
| Khả dụng | Health check, log có cấu trúc (Serilog), OpenTelemetry | [deploy.md](../guides/deploy.md) |
| Nền tảng | Desktop Windows 10+; Android 8+, iOS 15+ | – |
| Đa ngôn ngữ | Chuỗi giao diện trong `.resx`, mặc định tiếng Việt | – |

<a id="thuat-ngu"></a>
## 6. Thuật ngữ

| Thuật ngữ | Nghĩa |
| --- | --- |
| Tenant | Một không gian dữ liệu riêng: một công ty, hoặc một người dùng cá nhân |
| Lịch con | Một nhóm sự kiện có màu riêng (Cá nhân, Công việc, Phòng ban, Phòng họp) |
| RRULE | Quy tắc lặp theo chuẩn RFC 5545, ví dụ `FREQ=WEEKLY;BYDAY=MO,WE` |
| Outbox | Hàng đợi thay đổi lưu trên máy khi chưa gửi được lên server |
| Free/busy | Chỉ thấy khoảng bận, không thấy nội dung sự kiện |
| Cổng kiểm tra | Tiêu chí phải đạt trước khi sang giai đoạn tiếp theo trong roadmap |

[↑ Về đầu trang](#top)
