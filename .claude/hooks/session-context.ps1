#Requires -Version 7.0
<#
.SYNOPSIS
    SessionStart: đưa bối cảnh ngắn vào đầu phiên Claude Code.

.DESCRIPTION
    In ra stdout (Claude Code đưa vào ngữ cảnh của phiên): task tiếp theo theo
    docs/roadmap/README.md, nhánh git hiện tại, số file chưa commit, và lời nhắc quy tắc làm việc.
    Không chặn gì; lỗi nào cũng bỏ qua và thoát 0.
#>
. (Join-Path $PSScriptRoot '_common.ps1')
$ErrorActionPreference = 'SilentlyContinue'

$null = Read-HookInput
$root = Get-RepoRoot
$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add('Bối cảnh WorkCal (hook session-context):')

$roadmap = Join-Path $root 'docs' 'roadmap' 'README.md'
if (Test-Path -LiteralPath $roadmap) {
    $current = Select-String -LiteralPath $roadmap -Pattern 'task tiếp theo:' -Encoding utf8 | Select-Object -First 1
    if ($current) {
        $text = $current.Line -replace '\[([^\]]+)\]\([^)]+\)', '$1' -replace '\*\*', ''
        $lines.Add("- Roadmap: $($text.Trim())")
    }
}

$branch = (& git -C $root branch --show-current 2>$null)
if ($LASTEXITCODE -eq 0 -and $branch) {
    $changed = @(& git -C $root status --porcelain=v1 2>$null).Count
    $lines.Add("- Nhánh hiện tại: $branch; $changed file chưa commit.")
}

$lines.Add('- Nhắc: đọc task trong docs/roadmap/ và trình kế hoạch trước khi làm; không tự commit hay push; muốn thêm rule, hook, agent, skill thì mô tả và hỏi trước (.claude/rules/working-agreement.md).')
$lines -join "`n" | Write-Output
exit 0
