#Requires -Version 7.0
<#
.SYNOPSIS
    PreToolUse: chặn Claude Code đọc, sửa hoặc in nội dung file bí mật.

.DESCRIPTION
    File bí mật: .env và .env.* (trừ .env.example), appsettings.Production.json, *.pfx,
    secrets.json (User Secrets). Lệnh `dotnet user-secrets list` cũng bị chặn vì in ra bí mật.
    - Tool file (Read, Edit, MultiEdit, Write, NotebookEdit): kiểm tra đường dẫn file.
    - Grep, Glob: kiểm tra path, glob và pattern tên file.
    - Bash, PowerShell: tìm tên file bí mật trong câu lệnh.
    Đây là lớp thứ hai; lớp thứ nhất là các luật Read(...) trong permissions.deny của
    .claude/settings.json. Khớp thì thoát mã 2 (chặn), ngược lại thoát 0.
#>
. (Join-Path $PSScriptRoot '_common.ps1')

$hook = Read-HookInput
if ($null -eq $hook) { exit 0 }

$toolName = [string]$hook.tool_name
$toolInput = $hook.tool_input
if ($null -eq $toolInput) { exit 0 }

# Tên file (không kể thư mục) có phải file bí mật không.
function Test-SecretName([string]$name) {
    if ([string]::IsNullOrWhiteSpace($name)) { return $false }
    if ($name -ieq '.env.example') { return $false }
    if ($name -imatch '^\.env(\..+)?$') { return $true }
    if ($name -ieq 'appsettings.Production.json') { return $true }
    if ($name -ieq 'secrets.json') { return $true }
    if ($name -ilike '*.pfx') { return $true }
    return $false
}

function Test-SecretPath([string]$path) {
    if ([string]::IsNullOrWhiteSpace($path)) { return $false }
    $name = ($path -replace '\\', '/').TrimEnd('/').Split('/')[-1]
    return Test-SecretName $name
}

# Tìm tên file bí mật trong một đoạn văn bản (câu lệnh shell, mẫu glob).
# Trả về chuỗi khớp đầu tiên, hoặc $null.
function Find-SecretInText([string]$text) {
    if ([string]::IsNullOrWhiteSpace($text)) { return $null }

    # .env, .env.local, .env*... đứng sau dấu phân cách; bỏ qua .env.example
    # và các dạng như process.env.X (không có dấu phân cách trước .env).
    $envPattern = '(?i)(?:^|[\s''"`/\\=:(,;|&<>])(\.env(?:[.*][\w.*-]*)?)(?=$|[\s''"`|;&)<>,])'
    foreach ($m in [regex]::Matches($text, $envPattern)) {
        $hit = $m.Groups[1].Value
        if ($hit -ine '.env.example') { return $hit }
    }

    $others = @(
        '(?i)appsettings\.Production\.json',
        '(?i)[\w*-]\.pfx\b',
        '(?i)\bsecrets\.json\b',
        '(?i)\buser-secrets\s+list\b'
    )
    foreach ($p in $others) {
        $m = [regex]::Match($text, $p)
        if ($m.Success) { return $m.Value }
    }
    return $null
}

$reason = $null
switch -Regex ($toolName) {
    '^(Read|Edit|MultiEdit|Write)$' {
        if (Test-SecretPath ([string]$toolInput.file_path)) { $reason = [string]$toolInput.file_path }
    }
    '^NotebookEdit$' {
        if (Test-SecretPath ([string]$toolInput.notebook_path)) { $reason = [string]$toolInput.notebook_path }
    }
    '^(Grep|Glob)$' {
        if (Test-SecretPath ([string]$toolInput.path)) { $reason = [string]$toolInput.path }
        elseif ($hit = Find-SecretInText ([string]$toolInput.glob)) { $reason = $hit }
        elseif ($toolName -eq 'Glob' -and ($hit = Find-SecretInText ([string]$toolInput.pattern))) { $reason = $hit }
    }
    '^(Bash|PowerShell)$' {
        if ($hit = Find-SecretInText ([string]$toolInput.command)) { $reason = $hit }
    }
}

if ($reason) {
    Exit-Block ("guard-secrets: chặn $toolName vì chạm tới file bí mật '$reason'. " +
        "Không đọc, sửa hay in nội dung .env, appsettings.Production.json, *.pfx, secrets.json " +
        "(CLAUDE.md, mục Bí mật). Cần đổi cấu hình thì sửa .env.example hoặc nhờ chủ dự án tự sửa.")
}
exit 0
