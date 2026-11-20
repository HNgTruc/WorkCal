# UC-04 · Tìm giờ rảnh và mời họp

[← use-cases](README.md)

- **Tác nhân:** thành viên công ty (người tổ chức), các đồng nghiệp được mời.
- **Điều kiện trước:** cùng tenant; công ty có phòng họp.

**Luồng chính**
1. Người tổ chức chọn 4 đồng nghiệp, thời lượng 60 phút, trong tuần sau.
2. Hệ thống gọi `/availability/query`, trả các khung rảnh chung trong giờ làm việc.
3. Người tổ chức chọn một khung, chọn phòng "Phòng A" (còn trống), gửi lời mời.
4. Đồng nghiệp nhận email và push, thấy sự kiện trên lịch với trạng thái "Chờ phản hồi".
5. Đồng nghiệp chọn Đồng ý / Từ chối / Có thể; người tổ chức thấy kết quả.

**Luồng phụ**
- 2a. Không có khung chung → gợi ý khung có nhiều người rảnh nhất, ghi rõ ai bận.
- 3a. Phòng vừa bị người khác đặt cùng lúc → báo lỗi, gợi ý phòng khác.

**Kết quả:** cuộc họp có trên lịch mọi người, phòng được giữ chỗ.

**Liên kết:** [F10–F12](../srs.md#chuc-nang-cot-loi) · [P3-09](../../roadmap/phase-3-doanh-nghiep.md#p3-09) → [P3-11](../../roadmap/phase-3-doanh-nghiep.md#p3-11)
