<a id="top"></a>

# Hướng dẫn Super Admin

[← user-manual](README.md)

> Bản nháp. Mọi thao tác ở web quản trị, mục **/platform**. Bắt buộc bật xác thực 2 bước.

## Mục lục

- [Đăng nhập](#dang-nhap)
- [Tổng quan](#tong-quan)
- [Quản lý tenant](#tenant)
- [Gói dịch vụ](#goi)
- [Người dùng và đăng nhập thay](#nguoi-dung)
- [Thông báo hệ thống](#thong-bao)
- [Giám sát và nhật ký](#giam-sat)

<a id="dang-nhap"></a>
## Đăng nhập

Đăng nhập bằng tài khoản có quyền Super Admin, nhập mã 2 bước. Phiên tự hết hạn sau 30 phút không thao tác.

<a id="tong-quan"></a>
## Tổng quan

Số tenant, người dùng hoạt động theo ngày/tháng, tenant mới, tenant sắp hết dùng thử.

<a id="tenant"></a>
## Quản lý tenant

Tìm theo tên, xem gói, số thành viên, hoạt động gần đây. Khóa/mở khóa (bắt buộc lý do; thành viên bị đăng xuất ngay), đổi gói, gia hạn dùng thử. Xem tình huống đầy đủ ở [uc-07](../requirements/use-cases/uc-07-khoa-tenant.md).

<a id="goi"></a>
## Gói dịch vụ

Tạo và sửa gói Free/Pro/Business: số thành viên tối đa, số tài nguyên (phòng, xe, thiết bị), thời gian giữ lịch sử, bật tắt tính năng theo gói.

<a id="nguoi-dung"></a>
## Người dùng và đăng nhập thay

Tìm theo email, khóa tài khoản, đặt lại xác thực 2 bước. **Đăng nhập thay** để hỗ trợ: bắt buộc nhập lý do, có banner đỏ suốt phiên, mọi thao tác ghi vào nhật ký kèm tên bạn.

<a id="thong-bao"></a>
## Thông báo hệ thống

Tạo banner bảo trì hoặc thông báo phiên bản mới, đặt thời gian hiển thị; mọi ứng dụng đều thấy.

<a id="giam-sat"></a>
## Giám sát và nhật ký

Trang **Giám sát**: tình trạng API, CSDL, Redis, job nền (lỗi, đang chờ). Trang **Nhật ký**: mọi hành động của Super Admin, lọc theo người, tenant, thời gian.

[↑ Về đầu trang](#top)
