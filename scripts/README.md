# scripts

[← README gốc](../README.md)

## Mục đích
Script PowerShell 7 dùng khi phát triển và trong CI. Chạy từ gốc repo bằng `pwsh`.

## Nội dung chính
| File | Vai trò | Trạng thái |
| --- | --- | --- |
| [check-readme.ps1](check-readme.ps1) | Báo thư mục thiếu `README.md` hoặc README thiếu mục `## Mục đích`; mã thoát 1 nếu có lỗi | Đã có (P0-05) |
| `seed-demo-data.ps1` | Tạo dữ liệu demo | Làm khi có API đủ dùng |
| `export-openapi.ps1` | Xuất OpenAPI ra `docs/api/openapi.json` | Làm ở [P0-12](../docs/roadmap/phase-0-nen-mong.md#p0-12) |

## Cách chạy / test
```powershell
pwsh scripts/check-readme.ps1
```

## Quy ước và lưu ý
- Script yêu cầu PowerShell 7 (`#Requires -Version 7.0`); Windows PowerShell 5.1 không chạy được.
- `check-readme.ps1` bỏ qua `bin/`, `obj/`, `.git/`, `.vs/`, `.vscode/`, `.idea/`, `node_modules/`, `TestResults/` và thư mục `*/Resources/Images`. Thêm ngoại lệ thì sửa hai mảng `$skipNames`, `$skipSuffixes` ở đầu script và ghi lý do vào đây.

## Cập nhật lần cuối
2026-11-21 – tạo thư mục, thêm check-readme.ps1 (P0-05).
