# UC-07 · Super Admin khóa một tenant

[← use-cases](README.md)

- **Tác nhân:** Super Admin.
- **Điều kiện trước:** đã đăng nhập `/platform` với 2FA.

**Luồng chính**
1. Super Admin tìm tenant theo tên, mở chi tiết (gói, số thành viên, hoạt động gần đây).
2. Chọn "Khóa tenant", nhập lý do.
3. Hệ thống đặt `IsLocked=true`, ghi audit, thu hồi refresh token của mọi thành viên trong tenant.
4. Thành viên đang dùng nhận lỗi 403 ở lần gọi API tiếp theo, app hiện thông báo tenant bị khóa.

**Luồng phụ**
- 4a. Thành viên thuộc nhiều tenant → vẫn đổi sang tenant khác được.
- 2a. Mở khóa → đặt lại `IsLocked=false`, ghi audit; thành viên phải đăng nhập lại.

**Kết quả:** tenant ngừng truy cập ngay, mọi thao tác có audit.

**Liên kết:** [F16](../srs.md#chuc-nang-cot-loi) · [P4-04](../../roadmap/phase-4-admin-v1.md#p4-04) · [user-manual/platform-admin.md](../../user-manual/platform-admin.md)
