# 0001 · Desktop dùng WPF, mobile dùng .NET MAUI, chung Client.Core

[← adr](README.md)

- **Trạng thái:** Đã chấp nhận
- **Ngày:** 2026-11-20

## Bối cảnh
Cần app Windows desktop và app Android/iOS, viết bằng C#, một người làm. Lịch trên desktop cần kéo thả mượt; mobile cần push, quét QR, GPS.

## Các lựa chọn
| Lựa chọn | Ưu | Nhược |
| --- | --- | --- |
| MAUI cho cả desktop và mobile | Một codebase giao diện | Trải nghiệm desktop Windows kém hơn WPF, kéo thả lịch hạn chế |
| WPF + MAUI, chung thư viện client | Desktop tốt nhất, chỉ giao diện viết hai lần | Hai bộ View |
| Avalonia | Chạy cả macOS/Linux | Hệ sinh thái control lịch nhỏ hơn |

## Quyết định
WPF cho desktop, MAUI cho mobile. ViewModel, API client, SQLite và sync nằm chung trong `WorkCal.Client.Core` (CommunityToolkit.Mvvm chạy được ở cả hai).

## Hệ quả
- Logic viết một lần, test một lần trong `WorkCal.Client.Core.Tests`.
- View viết hai lần; giữ View mỏng theo [`.claude/rules/ui-mvvm.md`](../../../.claude/rules/ui-mvvm.md).
- Desktop macOS/Linux để vào [backlog](../../roadmap/backlog.md).
