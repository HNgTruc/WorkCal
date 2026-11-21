#Requires -Version 7.0
# Hàm dùng chung cho các hook Claude Code của WorkCal. Dot-source ở đầu mỗi hook:
#   . (Join-Path $PSScriptRoot '_common.ps1')
# Quy ước mã thoát của Claude Code: 0 = cho qua; 2 = chặn, stderr gửi cho Claude;
# mã khác = lỗi không chặn, stderr hiện cho người dùng.

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8

# Gốc repo: biến CLAUDE_PROJECT_DIR do Claude Code đặt; chạy tay thì lấy theo vị trí script.
function Get-RepoRoot {
    if ($env:CLAUDE_PROJECT_DIR) { return $env:CLAUDE_PROJECT_DIR }
    return (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path
}

# Đọc JSON Claude Code gửi qua stdin. Trả $null nếu stdin rỗng hoặc không phải JSON.
function Read-HookInput {
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) { return $null }
    try { return $raw | ConvertFrom-Json -Depth 20 }
    catch { return $null }
}

# Chặn: in lý do ra stderr (Claude đọc được) và thoát mã 2.
function Exit-Block([string]$message) {
    [Console]::Error.WriteLine($message)
    exit 2
}

# Cảnh báo không chặn: in ra stderr cho người dùng, thoát mã 1.
function Exit-Warn([string]$message) {
    [Console]::Error.WriteLine($message)
    exit 1
}

# Thư mục tạm lưu trạng thái giữa các lần chạy hook trong một phiên (không nằm trong repo).
function Get-StateFile([string]$sessionId, [string]$name) {
    $dir = Join-Path ([System.IO.Path]::GetTempPath()) 'workcal-claude-hooks'
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $id = if ($sessionId) { $sessionId -replace '[^\w-]', '_' } else { 'no-session' }
    return Join-Path $dir "$id.$name"
}

# Băm SHA-256 một chuỗi, dùng để so sánh trạng thái giữa các lượt.
function Get-TextHash([string]$text) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
    return [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData($bytes))
}

# Chạy một tiến trình, gom stdout + stderr, có giới hạn thời gian (giây; 0 = không giới hạn).
# Trả về @{ ExitCode; Output; TimedOut }.
function Invoke-Tool([string]$file, [string[]]$arguments, [string]$workDir, [int]$timeoutSec = 0) {
    $psi = [System.Diagnostics.ProcessStartInfo]::new($file)
    foreach ($a in $arguments) { $psi.ArgumentList.Add($a) }
    $psi.WorkingDirectory = $workDir
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.UseShellExecute = $false
    $psi.StandardOutputEncoding = [System.Text.Encoding]::UTF8
    $psi.StandardErrorEncoding = [System.Text.Encoding]::UTF8

    $proc = [System.Diagnostics.Process]::Start($psi)
    $outTask = $proc.StandardOutput.ReadToEndAsync()
    $errTask = $proc.StandardError.ReadToEndAsync()
    $ms = if ($timeoutSec -gt 0) { $timeoutSec * 1000 } else { -1 }
    $timedOut = -not $proc.WaitForExit($ms)
    if ($timedOut) {
        try { $proc.Kill($true) } catch { }
        $proc.WaitForExit()
    }
    return @{
        ExitCode = if ($timedOut) { -1 } else { $proc.ExitCode }
        Output   = ($outTask.Result + $errTask.Result).Trim()
        TimedOut = $timedOut
    }
}
