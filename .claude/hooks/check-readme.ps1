#Requires -Version 7.0
<#
.SYNOPSIS
    Stop: kiểm tra mọi thư mục có README.md với mục "## Mục đích" trước khi Claude kết thúc lượt.

.DESCRIPTION
    Gọi scripts/check-readme.ps1 (cùng script với job check-readme của CI).
    Có vi phạm → thoát mã 2, Claude phải bổ sung README rồi mới kết thúc lượt.
    Chống lặp vô hạn: nếu Claude đã bị hook giữ lại (stop_hook_active) mà danh sách vi phạm
    không đổi, hook chỉ cảnh báo và cho dừng.
#>
. (Join-Path $PSScriptRoot '_common.ps1')

$hook = Read-HookInput
$sessionId = if ($hook) { [string]$hook.session_id } else { '' }
$stopHookActive = $hook -and [bool]$hook.stop_hook_active
$root = Get-RepoRoot
$script = Join-Path $root 'scripts' 'check-readme.ps1'
if (-not (Test-Path -LiteralPath $script -PathType Leaf)) { exit 0 }

$pwshPath = (Get-Process -Id $PID).Path
$result = Invoke-Tool $pwshPath @('-NoProfile', '-File', $script, '-Path', $root) $root 60

$failFile = Get-StateFile $sessionId 'check-readme.fail'
if ($result.ExitCode -eq 0) {
    Remove-Item -LiteralPath $failFile -ErrorAction SilentlyContinue
    exit 0
}

$fingerprint = Get-TextHash $result.Output
if ($stopHookActive -and (Test-Path $failFile) -and (Get-Content -LiteralPath $failFile -Raw).Trim() -eq $fingerprint) {
    Exit-Warn "check-readme: vẫn còn thư mục thiếu README sau lần nhắc trước; cho dừng để tránh lặp.`n$($result.Output)"
}
Set-Content -LiteralPath $failFile -Value $fingerprint
Exit-Block ("check-readme: có thư mục thiếu README.md hoặc README thiếu mục '## Mục đích'. " +
    "Bổ sung theo mẫu (skill write-folder-readme) rồi mới kết thúc lượt.`n$($result.Output)")
