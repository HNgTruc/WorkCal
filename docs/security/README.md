# security

[← Mục lục tài liệu](../README.md)

## Mục đích
Các nguy cơ bảo mật của WorkCal và cách chặn; trọng tâm là cách ly dữ liệu giữa các tenant.

## Nội dung chính
| File | Vai trò |
| --- | --- |
| [threat-model.md](threat-model.md) | Danh sách nguy cơ, mức độ, cách chặn, nơi thực thi |
| [tenant-isolation.md](tenant-isolation.md) | Các lớp cách ly tenant và bộ test kiểm chứng |

## Phụ thuộc
Agent rà soát: [`.claude/agents/security-auditor.md`](../../.claude/agents/security-auditor.md). Hook chặn file bí mật: [`.claude/hooks/`](../../.claude/hooks/).
