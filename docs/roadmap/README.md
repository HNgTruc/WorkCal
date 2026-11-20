# Roadmap WorkCal

## Mục đích
Kế hoạch làm việc của WorkCal, chia thành 6 giai đoạn trong 24 tuần: **v1.0 ở tuần 18**, **v1.1 ở tuần 24**. Ước tính dựa trên nhịp làm 10–15 giờ mỗi tuần.

> File này là điểm vào. Mỗi lần ngồi làm: mở file giai đoạn đang chạy → chọn task chưa tick đầu tiên → bấm vào để xem việc cần làm và file code liên quan.

## Mục lục

- [Tổng quan giai đoạn](#tong-quan)
- [Giai đoạn đang làm](#dang-lam)
- [Cách dùng roadmap](#cach-dung)
- [Quy trình làm một task](#quy-trinh)
- [Quy ước trong file giai đoạn](#quy-uoc)
- [Các file trong thư mục](#cac-file)

<a id="tong-quan"></a>
## Tổng quan giai đoạn

| Giai đoạn | Tuần | Mục tiêu | Cổng kiểm tra | Trạng thái | File |
| --- | --- | --- | --- | --- | --- |
| 0 · Nền móng | 1–2 | Repo, CI, `.claude/`, Domain, đăng nhập | CI xanh, check-readme chạy, đăng nhập được qua API | Đang làm (3/13) | [phase-0-nen-mong.md](phase-0-nen-mong.md) |
| 1 · Lịch cá nhân desktop | 3–6 | Sự kiện, lịch lặp, task, nhắc, app WPF | Demo lịch cá nhân đầy đủ trên desktop | Chưa bắt đầu | [phase-1-lich-ca-nhan.md](phase-1-lich-ca-nhan.md) |
| 2 · Offline và mobile | 7–10 | SQLite + outbox, sync, SignalR, app MAUI, push | Hai thiết bị sửa offline, có mạng lại vẫn khớp | Chưa bắt đầu | [phase-2-offline-mobile.md](phase-2-offline-mobile.md) |
| 3 · Doanh nghiệp, multi-tenant | 11–14 | Tenant, vai trò, phòng ban, mời họp, free/busy, nghỉ phép | Bộ test đọc chéo tenant đều bị chặn | Chưa bắt đầu | [phase-3-doanh-nghiep.md](phase-3-doanh-nghiep.md) |
| 4 · Web quản trị và v1.0 | 15–18 | WorkCal.Admin, audit, deploy, tài liệu | Phát hành v1.0 trên GitHub | Chưa bắt đầu | [phase-4-admin-v1.md](phase-4-admin-v1.md) |
| 5 · Doanh nghiệp mở rộng (v1.1) | 19–24 | Ca làm, chấm công, báo cáo, SSO, WorkCal.Mcp | Phát hành v1.1 | Chưa bắt đầu | [phase-5-doanh-nghiep-mo-rong.md](phase-5-doanh-nghiep-mo-rong.md) |

Trạng thái dùng một trong bốn giá trị: `Chưa bắt đầu` · `Đang làm` · `Đang kiểm tra cổng` · `Xong (YYYY-MM-DD)`.

<a id="dang-lam"></a>
## Giai đoạn đang làm

**Giai đoạn 0 · Nền móng** → [mở file](phase-0-nen-mong.md) · task tiếp theo: [P0-04](phase-0-nen-mong.md#p0-04)

_Cập nhật hai dòng trên mỗi khi chuyển giai đoạn hoặc xong một task._

<a id="cach-dung"></a>
## Cách dùng roadmap

- **Một task = một GitHub Issue.** Tiêu đề issue bắt đầu bằng mã task, ví dụ `P1-04 Recurrence service`. Gắn label `phase-1` và milestone `Giai đoạn 1`.
- **Mục lục đầu mỗi file giai đoạn là nơi duy nhất ghi tiến độ.** Xong task thì đổi `- [ ]` thành `- [x]` và thêm ngày ở cuối dòng.
- **Mỗi task có link tới file code** sẽ tạo hoặc sửa. File chưa tồn tại thì link báo 404 trên GitHub, đó là chỗ cần tạo.
- **Mỗi tuần ghi một dòng** vào [progress-log.md](progress-log.md): làm được gì, vướng gì, tuần sau làm gì.
- **Việc phát sinh ngoài kế hoạch** ghi vào [backlog.md](backlog.md), không chen vào giai đoạn đang làm.
- **Claude Code:** `CLAUDE.md` ở gốc repo có dòng _"Trước khi làm, đọc `docs/roadmap/README.md` và file giai đoạn đang làm; xong task thì tick vào mục lục và ghi ngày"_.

<a id="quy-trinh"></a>
## Quy trình làm một task

1. Mở file giai đoạn, chọn task chưa tick đầu tiên trong mục lục, bấm vào để đọc chi tiết.
2. Tạo nhánh `feat/P1-04-recurrence` (hoặc `fix/`, `docs/`, `chore/`).
3. Mở các file trong mục **File code** của task, làm theo **Việc cần làm**.
4. Chạy `dotnet build` và `dotnet test`; kiểm tra từng ý trong **Xong khi**.
5. Cập nhật README của thư mục có thay đổi (hook `check-readme` sẽ nhắc).
6. Tick task trong mục lục, ghi ngày, commit cùng nhánh.
7. Mở PR (tiêu đề đúng mẫu Conventional Commits, nội dung `Closes #<số issue>`), squash merge khi CI xanh.

<a id="quy-uoc"></a>
## Quy ước trong file giai đoạn

Mỗi file giai đoạn có cùng bố cục:

1. **Mục lục và tiến độ**: danh sách task có checkbox, mỗi dòng là link tới phần chi tiết.
2. **Mục tiêu, phạm vi, cổng kiểm tra.**
3. **Chi tiết từng task**, nhóm theo tuần. Mỗi task gồm:
   - `Ước tính`: số giờ làm (ước lượng, sửa lại sau khi làm xong để rút kinh nghiệm)
   - `Chức năng`: mã F trong tài liệu thiết kế (mục 3)
   - `Phụ thuộc`: task phải xong trước
   - `Việc cần làm`: các bước cụ thể
   - `Xong khi`: tiêu chí kiểm tra được
   - `File code`: link tới file sẽ tạo hoặc sửa
   - `Tài liệu`: link tới file trong `docs/` cần đọc hoặc cập nhật
4. **Rủi ro** của giai đoạn và cách xử lý.

Mẫu trống ở [templates/phase-template.md](templates/phase-template.md).

<a id="cac-file"></a>
## Các file trong thư mục

| File | Nội dung |
| --- | --- |
| [phase-0-nen-mong.md](phase-0-nen-mong.md) | Giai đoạn 0, tuần 1–2 |
| [phase-1-lich-ca-nhan.md](phase-1-lich-ca-nhan.md) | Giai đoạn 1, tuần 3–6 |
| [phase-2-offline-mobile.md](phase-2-offline-mobile.md) | Giai đoạn 2, tuần 7–10 |
| [phase-3-doanh-nghiep.md](phase-3-doanh-nghiep.md) | Giai đoạn 3, tuần 11–14 |
| [phase-4-admin-v1.md](phase-4-admin-v1.md) | Giai đoạn 4, tuần 15–18 |
| [phase-5-doanh-nghiep-mo-rong.md](phase-5-doanh-nghiep-mo-rong.md) | Giai đoạn 5, tuần 19–24 |
| [backlog.md](backlog.md) | Việc để sau, ý tưởng, tính năng ngoài kế hoạch |
| [progress-log.md](progress-log.md) | Nhật ký tiến độ theo tuần |
| [templates/phase-template.md](templates/phase-template.md) | Mẫu cho giai đoạn mới |

[↑ Về mục lục tài liệu](../README.md)
