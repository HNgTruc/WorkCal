# UC-02 · Tạo và sửa sự kiện lặp

[← use-cases](README.md)

- **Tác nhân:** người dùng bất kỳ.
- **Điều kiện trước:** đã đăng nhập, có ít nhất một lịch có quyền Write.

**Luồng chính**
1. Người dùng tạo "Họp nhóm", 9:00–10:00 thứ 2 và thứ 4, lặp hằng tuần đến hết năm.
2. Hệ thống lưu một dòng `Events` với `RRule=FREQ=WEEKLY;BYDAY=MO,WE;UNTIL=...` và `TimeZoneId` của người dùng.
3. Lịch hiển thị mọi lần lặp trong khoảng đang xem.
4. Người dùng kéo buổi thứ 4 tuần sau sang 14:00, chọn "Chỉ lần này".
5. Hệ thống tạo `EventExceptions` cho ngày đó với giờ mới.

**Luồng phụ**
- 4a. Chọn "Từ lần này về sau" → chuỗi cũ được cắt bằng `UNTIL`, tạo chuỗi mới từ ngày đó.
- 4b. Chọn "Tất cả" → sửa dòng `Events` gốc.
- 3a. Qua mốc đổi giờ mùa hè (múi có DST) → vẫn hiển thị 9:00 giờ địa phương.

**Kết quả:** chuỗi sự kiện đúng giờ, ngoại lệ được lưu riêng.

**Liên kết:** [F05](../srs.md#chuc-nang-cot-loi) · [P1-04](../../roadmap/phase-1-lich-ca-nhan.md#p1-04), [P1-05](../../roadmap/phase-1-lich-ca-nhan.md#p1-05) · [recurrence-timezone.md](../../architecture/recurrence-timezone.md)
