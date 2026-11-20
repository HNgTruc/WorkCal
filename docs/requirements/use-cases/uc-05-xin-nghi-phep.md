# UC-05 · Xin nghỉ phép, duyệt 2 cấp

[← use-cases](README.md)

- **Tác nhân:** Member, Manager của phòng ban, HR.
- **Điều kiện trước:** công ty đã cấu hình loại phép và số ngày phép.

**Luồng chính**
1. Member xem số dư phép năm, gửi đơn nghỉ thứ 5–thứ 6 kèm lý do.
2. Manager nhận push, mở hộp duyệt trên mobile, chọn Duyệt.
3. HR nhận thông báo, duyệt cấp cuối trên web quản trị.
4. Hệ thống trừ số dư, tạo sự kiện "Nghỉ phép" chặn lịch Member, báo cho người tổ chức các cuộc họp trùng ngày.

**Luồng phụ**
- 2a. Manager từ chối → dừng, Member nhận thông báo kèm lý do.
- 1a. Số dư không đủ → chặn gửi với loại phép có lương, gợi ý phép không lương.
- 1b. Member là Manager → bước 2 chuyển cho người quản lý phòng ban cấp trên, không có thì chuyển thẳng HR.

**Kết quả:** đơn được duyệt, lịch tự cập nhật, mọi bước có trong `ApprovalSteps`.

**Liên kết:** [F23, F24](../srs.md#chuc-nang-mo-rong) · [P3-12](../../roadmap/phase-3-doanh-nghiep.md#p3-12) · [`Features/Leaves/`](../../../src/Server/WorkCal.Application/Features/Leaves/)
