<a id="top"></a>

# Deploy

[← guides](README.md) · [Mục lục tài liệu](../README.md)

> Bản nháp, hoàn thiện ở [P4-11](../roadmap/phase-4-admin-v1.md#p4-11) sau khi chọn nơi chạy.

## Mục lục

- [Thành phần cần chạy](#thanh-phan)
- [Hai phương án](#phuong-an)
- [Biến môi trường](#bien)
- [Pipeline](#pipeline)
- [Phát hành app client](#client)

<a id="thanh-phan"></a>
## Thành phần cần chạy

WorkCal.Api (kèm Hangfire server và SignalR), WorkCal.Admin, WorkCal.Mcp (v1.1), SQL Server, Redis, Firebase (FCM), máy chủ SMTP.

<a id="phuong-an"></a>
## Hai phương án

| Phương án | Thành phần | Ưu | Nhược |
| --- | --- | --- | --- |
| Azure | App Service (API, Admin, MCP), Azure SQL, Azure Cache for Redis, Key Vault | Có ưu đãi cho sinh viên, ít việc vận hành | Phụ thuộc Azure |
| VPS + Docker | Một máy Linux, `docker compose` với Caddy làm HTTPS | Rẻ, kiểm soát hết | Tự lo backup, cập nhật |

<a id="bien"></a>
## Biến môi trường

| Biến | Ý nghĩa |
| --- | --- |
| `ConnectionStrings__Default` | Chuỗi kết nối SQL Server |
| `ConnectionStrings__Redis` | Chuỗi kết nối Redis |
| `Jwt__SigningKey` | Khóa ký JWT (≥ 32 byte, ngẫu nhiên) |
| `Fcm__CredentialsJson` | Service account Firebase |
| `Smtp__Host`, `Smtp__User`, `Smtp__Password` | Gửi email |
| `Admin__AllowedIps` | (tùy chọn) IP được vào `/platform` |

Không đặt giá trị thật trong `appsettings.Production.json`; xem [threat-model.md](../security/threat-model.md#bi-mat).

<a id="pipeline"></a>
## Pipeline

[`.github/workflows/deploy.yml`](../../.github/workflows/deploy.yml) chạy khi tạo tag `v*`:

1. Build và test (giống CI).
2. Xuất script migration idempotent, chạy trên CSDL production ([migrations.md](../database/migrations.md)).
3. Publish và deploy API, Admin, MCP.
4. Gọi `/health`, lỗi thì quay về bản trước.

<a id="client"></a>
## Phát hành app client

- Desktop: gói MSIX hoặc zip đính kèm GitHub Release.
- Android: APK ký bằng keystore lưu trong GitHub Secrets; có thể đưa lên Google Play sau.
- iOS: cần tài khoản Apple Developer, build trên macOS runner; để sau v1.0 nếu chưa có.

[↑ Về đầu trang](#top)
