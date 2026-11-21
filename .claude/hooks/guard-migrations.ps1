#Requires -Version 7.0
<#
.SYNOPSIS
    PreToolUse: chặn sửa migration EF Core đã có trên nhánh main.

.DESCRIPTION
    Khớp file nằm trong thư mục Migrations/ (kể cả AppDbContextModelSnapshot.cs). Nếu file
    đã tồn tại trên origin/main (hoặc main khi chưa có remote) thì thoát mã 2: migration đã
    merge không được sửa, muốn đổi schema thì tạo migration mới (rule ef-migrations).
    Snapshot do `dotnet ef` tự cập nhật qua lệnh, không qua tool Edit, nên không bị ảnh hưởng.
    Migration mới chưa lên main vẫn sửa bình thường.
#>
. (Join-Path $PSScriptRoot '_common.ps1')

$hook = Read-HookInput
if ($null -eq $hook -or $null -eq $hook.tool_input) { exit 0 }

$filePath = [string]$hook.tool_input.file_path
if ([string]::IsNullOrWhiteSpace($filePath)) { exit 0 }
$normalized = $filePath -replace '\\', '/'
if ($normalized -notmatch '/Migrations/[^/]+\.cs$') { exit 0 }

$root = Get-RepoRoot
$full = [System.IO.Path]::GetFullPath($normalized)
$relative = [System.IO.Path]::GetRelativePath($root, $full) -replace '\\', '/'
if ($relative.StartsWith('..')) { exit 0 }

foreach ($ref in @('origin/main', 'main')) {
    & git -C $root rev-parse --verify --quiet $ref *> $null
    if ($LASTEXITCODE -ne 0) { continue }
    & git -C $root cat-file -e "${ref}:$relative" *> $null
    if ($LASTEXITCODE -eq 0) {
        Exit-Block ("guard-migrations: '$relative' đã có trên $ref nên không được sửa (rule ef-migrations, " +
            "docs/database/migrations.md). Muốn đổi schema thì tạo migration mới bằng 'dotnet ef migrations add' " +
            "theo skill add-ef-migration.")
    }
    break
}
exit 0
