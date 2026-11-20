# UC-01 · Đăng ký và bắt đầu dùng

[← use-cases](README.md)

- **Tác nhân:** người dùng mới.
- **Điều kiện trước:** chưa có tài khoản.

**Luồng chính**
1. Người dùng mở app, chọn "Đăng ký", nhập họ tên, email, mật khẩu.
2. Hệ thống tạo User, tenant `Personal`, Membership vai trò Owner, lịch "Cá nhân"; gửi email xác minh.
3. Người dùng đăng nhập, thấy lịch trống ở chế độ xem tuần.

**Luồng phụ**
- 1a. Email đã tồn tại → báo lỗi, gợi ý "Quên mật khẩu".
- 1b. Đăng ký qua lời mời của công ty → sau bước 2, thêm Membership vào tenant đó và chọn tenant đó làm mặc định.

**Kết quả:** người dùng có tài khoản, một tenant cá nhân và một lịch.

**Liên kết:** [F01](../srs.md#chuc-nang-cot-loi) · [P0-11](../../roadmap/phase-0-nen-mong.md#p0-11) · [authentication.md](../../api/authentication.md) · [`Features/Auth/`](../../../src/Server/WorkCal.Application/Features/Auth/)
