# workflows

[← .github](../README.md)

## Mục đích
Workflow GitHub Actions của repo.

## Nội dung chính
| File | Vai trò |
| --- | --- |
| [ci.yml](ci.yml) | Chạy khi mở/cập nhật PR vào `main` và khi push lên `main`. Job `build-test` (restore, build cả solution, test, lưu kết quả TRX), `check-readme` (`scripts/check-readme.ps1`), `commitlint` (commit trong PR và tiêu đề PR theo Conventional Commits, có `Refs:`) |
| `deploy.yml` | Deploy khi tạo tag; làm ở giai đoạn 4 |

## Cách chạy / test
CI tự chạy trên GitHub. Chạy tương đương trên máy:
```powershell
dotnet build WorkCal.slnx -c Release
dotnet test WorkCal.slnx -c Release
pwsh scripts/check-readme.ps1
```

## Quy ước và lưu ý
- Chạy trên `ubuntu-latest`: integration test (Testcontainers) cần Docker chạy container Linux. Project WPF build được nhờ biến `EnableWindowsTargeting=true`; project Mobile cần workload `maui-android` và Android SDK API 36, cài ở đầu job.
- Job `commitlint` bỏ qua PR của Dependabot; cấu hình ở [commitlint.config.mjs](../../commitlint.config.mjs).
- Ba job `build-test`, `check-readme`, `commitlint` là status check bắt buộc của `main`. Đổi tên job thì phải cập nhật lại branch protection.
- Version action được Dependabot nâng hàng tuần ([dependabot.yml](../dependabot.yml)).

## Cập nhật lần cuối
2026-11-21 – tạo thư mục, thêm ci.yml (P0-04).
