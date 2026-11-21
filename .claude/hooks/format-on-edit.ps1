#Requires -Version 7.0
<#
.SYNOPSIS
    PostToolUse: tự format file .cs vừa được Claude Code sửa hoặc tạo.

.DESCRIPTION
    Chạy `dotnet format <project> --include <file>` (đủ whitespace, style, analyzer theo
    .editorconfig) trên project gần nhất chứa file. Giới hạn 60 giây.
    Lỗi hoặc quá giờ thì thoát mã 2 để Claude biết và xử lý (chủ dự án chọn chặn,
    2026-11-21). File không phải .cs, nằm ngoài repo hoặc không thuộc project nào thì bỏ qua.
#>
. (Join-Path $PSScriptRoot '_common.ps1')

$TimeoutSec = 60

$hook = Read-HookInput
if ($null -eq $hook -or $null -eq $hook.tool_input) { exit 0 }

$filePath = [string]$hook.tool_input.file_path
if (-not $filePath.EndsWith('.cs', [StringComparison]::OrdinalIgnoreCase)) { exit 0 }
if (-not (Test-Path -LiteralPath $filePath -PathType Leaf)) { exit 0 }

$root = (Resolve-Path -LiteralPath (Get-RepoRoot)).Path
$full = (Resolve-Path -LiteralPath $filePath).Path
$relative = [System.IO.Path]::GetRelativePath($root, $full)
if ($relative.StartsWith('..') -or [System.IO.Path]::IsPathRooted($relative)) { exit 0 }

# Tìm .csproj gần nhất, đi ngược lên tới gốc repo.
$project = $null
$dir = Split-Path -Parent $full
while ($dir -and $dir.Length -ge $root.Length) {
    $found = Get-ChildItem -LiteralPath $dir -Filter '*.csproj' -File -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) { $project = $found.FullName; break }
    $parent = Split-Path -Parent $dir
    if ($parent -eq $dir) { break }
    $dir = $parent
}
if (-not $project) { exit 0 }

$projectRel = [System.IO.Path]::GetRelativePath($root, $project)
$result = Invoke-Tool 'dotnet' @('format', $projectRel, '--include', $relative, '--verbosity', 'quiet') $root $TimeoutSec

if ($result.TimedOut) {
    Exit-Block ("format-on-edit: dotnet format quá $TimeoutSec giây với '$relative' và đã bị dừng. " +
        "Thử dotnet restore hoặc dotnet build $projectRel rồi sửa lại file; nếu vẫn chậm, báo chủ dự án.")
}
if ($result.ExitCode -ne 0) {
    $tail = ($result.Output -split "`r?`n" | Select-Object -Last 30) -join "`n"
    Exit-Block ("format-on-edit: dotnet format lỗi (mã $($result.ExitCode)) với '$relative'.`n$tail")
}
exit 0
