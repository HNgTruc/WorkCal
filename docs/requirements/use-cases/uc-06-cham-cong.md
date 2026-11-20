# UC-06 · Chấm công bằng QR

[← use-cases](README.md)

- **Tác nhân:** nhân viên, HR.
- **Điều kiện trước:** HR đã khai báo văn phòng và bật chấm công; nhân viên có ca hôm nay.

**Luồng chính**
1. Màn hình ở văn phòng hiển thị mã QR đổi mỗi 30 giây.
2. Nhân viên mở app, chọn "Chấm công vào", quét mã.
3. Server kiểm tra mã còn hiệu lực và thuộc văn phòng, ghi `AttendanceRecords`.
4. Cuối ngày, job đối chiếu với ca đã xếp: đúng giờ, đi muộn, về sớm, tăng ca.
5. HR xem bảng công tháng, xuất Excel.

**Luồng phụ**
- 2a. Không quét được QR → dùng GPS nếu đang trong bán kính văn phòng; bản ghi đánh dấu phương thức GPS.
- 3a. Mã đã hết hạn (chụp lại ảnh cũ) → từ chối.
- 5a. HR sửa công cho một ngày → bắt buộc nhập lý do, ghi audit.

**Kết quả:** bảng công chính xác, có dấu vết sửa đổi.

**Liên kết:** [F25, F26](../srs.md#chuc-nang-mo-rong) · [P5-03](../../roadmap/phase-5-doanh-nghiep-mo-rong.md#p5-03), [P5-04](../../roadmap/phase-5-doanh-nghiep-mo-rong.md#p5-04)
