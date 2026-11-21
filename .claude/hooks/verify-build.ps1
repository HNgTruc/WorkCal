#Requires -Version 7.0
<#
.SYNOPSIS
    Stop: build cả solution trước khi Claude kết thúc lượt, nếu code có thay đổi.

.DESCRIPTION
    - Lấy các file code chưa commit (git status) có đuôi .cs, .csproj, .props, .targets,
      .razor, .xaml, .slnx, cùng .editorconfig và global.json (hai file này đổi luật build).
    - Không có file nào, hoặc trạng thái giống lần build thành công trước trong phiên
      → bỏ qua (lượt chỉ sửa docs thì không build).
    - Ngược lại chạy `dotnet build WorkCal.slnx`. Lỗi → thoát mã 2, Claude phải sửa tiếp.
    - Chống lặp vô hạn: nếu Claude đã bị hook này giữ lại (stop_hook_active) mà code
      không đổi gì so với lần build lỗi trước, hook chỉ cảnh báo và cho dừng.
#>
. (Join-Path $PSScriptRoot '_common.ps1')

$TimeoutSec = 840   # dưới mức timeout 900 giây khai báo trong settings.json
$codeExtensions = @('.cs', '.csproj', '.props', '.targets', '.razor', '.xaml', '.slnx')
$codeNames = @('.editorconfig', 'global.json')

$hook = Read-HookInput
$sessionId = if ($hook) { [string]$hook.session_id } else { '' }
$stopHookActive = $hook -and [bool]$hook.stop_hook_active
$root = Get-RepoRoot

# Danh sách file code chưa commit, kèm thời điểm sửa và kích thước để nhận ra thay đổi mới.
$status = & git -C $root -c core.quotepath=false status --porcelain=v1 --untracked-files=all 2>$null
if ($LASTEXITCODE -ne 0) { exit 0 }

$entries = foreach ($line in $status) {
    if ($line.Length -lt 4) { continue }
    $path = $line.Substring(3)
    if ($path.Contains(' -> ')) { $path = $path.Split(' -> ')[-1] }
    $path = $path.Trim('"')
    $name = [System.IO.Path]::GetFileName($path)
    $ext = [System.IO.Path]::GetExtension($path)
    if (-not (($codeExtensions -contains $ext.ToLowerInvariant()) -or ($codeNames -contains $name))) { continue }
    $full = Join-Path $root $path
    if (Test-Path -LiteralPath $full -PathType Leaf) {
        $item = Get-Item -LiteralPath $full
        "$path|$($item.LastWriteTimeUtc.Ticks)|$($item.Length)"
    }
    else {
        "$path|deleted"
    }
}

if (-not $entries) { exit 0 }

$fingerprint = Get-TextHash (($entries | Sort-Object) -join "`n")
$okFile = Get-StateFile $sessionId 'verify-build.ok'
$failFile = Get-StateFile $sessionId 'verify-build.fail'

if ((Test-Path $okFile) -and (Get-Content -LiteralPath $okFile -Raw).Trim() -eq $fingerprint) { exit 0 }

if ($stopHookActive -and (Test-Path $failFile) -and (Get-Content -LiteralPath $failFile -Raw).Trim() -eq $fingerprint) {
    Exit-Warn 'verify-build: build vẫn lỗi và code không đổi sau lần nhắc trước; cho dừng để tránh lặp. Chạy `dotnet build WorkCal.slnx` để xem lỗi.'
}

$result = Invoke-Tool 'dotnet' @('build', 'WorkCal.slnx', '-nologo', '-v:q', '-clp:NoSummary') $root $TimeoutSec

if ($result.TimedOut) {
    Set-Content -LiteralPath $failFile -Value $fingerprint
    Exit-Block "verify-build: dotnet build quá $TimeoutSec giây và đã bị dừng. Kiểm tra máy (Docker, restore) rồi build lại; nếu vẫn chậm, báo chủ dự án."
}

if ($result.ExitCode -eq 0) {
    Set-Content -LiteralPath $okFile -Value $fingerprint
    Remove-Item -LiteralPath $failFile -ErrorAction SilentlyContinue
    exit 0
}

Set-Content -LiteralPath $failFile -Value $fingerprint
$errors = $result.Output -split "`r?`n" | Where-Object { $_ -match '\b(error|warning)\b' } | Select-Object -Unique -First 40
if (-not $errors) { $errors = $result.Output -split "`r?`n" | Select-Object -Last 40 }
Exit-Block ("verify-build: dotnet build WorkCal.slnx lỗi (mã $($result.ExitCode)). Sửa hết lỗi trước khi kết thúc lượt " +
    "(dự án bật TreatWarningsAsErrors).`n" + ($errors -join "`n"))
