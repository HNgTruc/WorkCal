<a id="top"></a>

# Vai trò và quyền

[← requirements](README.md) · [Mục lục tài liệu](../README.md)

WorkCal có 6 vai trò ở hai cấp: **nền tảng** (Super Admin, không thuộc tenant nào) và **tenant** (5 vai trò trong một công ty). Một tài khoản có thể thuộc nhiều tenant với vai trò khác nhau; quyền tính theo tenant đang chọn (claim `tid` trong token).

## Mục lục

- [Danh sách vai trò](#vai-tro)
- [Ma trận quyền](#ma-tran)
- [Quyền trên từng lịch](#quyen-lich)
- [Cách thực thi trong code](#thuc-thi)

<a id="vai-tro"></a>
## Danh sách vai trò

| Vai trò | Cấp | Mô tả |
| --- | --- | --- |
| Super Admin | Nền tảng | Cờ `IsPlatformAdmin` trên bảng Users. Quản lý tenant, gói, người dùng toàn hệ thống qua `/platform` |
| Owner | Tenant | Toàn quyền trong tenant, đổi gói, chuyển quyền sở hữu. Người dùng cá nhân là Owner của tenant `Personal` |
| Admin | Tenant | Quản lý thành viên, phòng ban, phòng họp, tài nguyên, cài đặt |
| HR | Tenant | Ca làm việc, chính sách nghỉ phép, duyệt phép cấp cuối, chấm công, báo cáo nhân sự |
| Manager | Phòng ban | Xem lịch thành viên phòng mình, xếp ca, giao task, duyệt nghỉ phép cấp 1 |
| Member | Tenant | Lịch cá nhân, tham gia sự kiện được mời, xin nghỉ, chấm công, xem free/busy đồng nghiệp |

<a id="ma-tran"></a>
## Ma trận quyền

`●` được phép · `◐` được phép trong phạm vi phòng ban mình · `○` chỉ của bản thân · trống: không được.

| Hành động | Super Admin | Owner | Admin | HR | Manager | Member |
| --- | :-: | :-: | :-: | :-: | :-: | :-: |
| Quản lý tenant, gói, người dùng toàn hệ thống | ● | | | | | |
| Đăng nhập thay người dùng (có audit) | ● | | | | | |
| Đổi gói, chuyển quyền sở hữu | | ● | | | | |
| Mời, khóa thành viên, đổi vai trò | | ● | ● | | | |
| Quản lý phòng ban | | ● | ● | | | |
| Quản lý phòng họp, tài nguyên | | ● | ● | | | |
| Cài đặt công ty, SSO, webhook, API key | | ● | ● | | | |
| Ngày lễ, giờ làm việc chuẩn | | ● | ● | ● | | |
| Loại phép, số ngày phép | | ● | | ● | | |
| Duyệt nghỉ phép cấp 1 | | | | | ◐ | |
| Duyệt nghỉ phép cấp cuối | | ● | | ● | | |
| Xếp ca, duyệt đổi ca | | | | ● | ◐ | |
| Xem, sửa bảng công | | ● | | ● | ◐ (xem) | ○ (xem) |
| Xem báo cáo | | ● | | ● | ◐ | |
| Xem chi tiết lịch người khác | | | | | ◐ | |
| Xem free/busy đồng nghiệp | | ● | ● | ● | ● | ● |
| Tạo sự kiện, task, mời họp, đặt phòng | | ● | ● | ● | ● | ● |
| Giao task cho người khác | | ● | ● | | ◐ | |
| Xin nghỉ, chấm công, xin đổi ca | | ● | ● | ● | ● | ● |
| Xem audit log công ty | | ● | ● | | | |
| Bật/tắt WorkCal.Mcp cho công ty | | ● | | | | |

<a id="quyen-lich"></a>
## Quyền trên từng lịch

Ngoài vai trò, mỗi lịch con có quyền chia sẻ riêng (bảng `CalendarShares`):

| Mức | Thấy gì | Làm gì |
| --- | --- | --- |
| FreeBusy | Khoảng bận, không thấy tiêu đề | – |
| Read | Đầy đủ chi tiết | – |
| Write | Đầy đủ chi tiết | Tạo, sửa, xóa sự kiện |
| Manage | Đầy đủ chi tiết | Như Write + chia sẻ lại, đổi tên, xóa lịch |

<a id="thuc-thi"></a>
## Cách thực thi trong code

- Policy theo vai trò ở tầng API: [`src/Server/WorkCal.Api/Authorization/`](../../src/Server/WorkCal.Api/Authorization/)
- Kiểm tra quyền trên lịch và phạm vi phòng ban ở tầng Application: [`src/Server/WorkCal.Application/Common/Authorization/`](../../src/Server/WorkCal.Application/Common/Authorization/)
- Test theo ma trận: [`tests/WorkCal.Api.IntegrationTests/Authorization/`](../../tests/WorkCal.Api.IntegrationTests/Authorization/)
- Task liên quan: [P3-03](../roadmap/phase-3-doanh-nghiep.md#p3-03), [P3-07](../roadmap/phase-3-doanh-nghiep.md#p3-07)

[↑ Về đầu trang](#top)
