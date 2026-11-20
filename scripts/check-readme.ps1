#Requires -Version 7.0
<#
.SYNOPSIS
    Kiểm tra mọi thư mục trong repo có README.md và README có mục "## Mục đích".

.DESCRIPTION
    Quét đệ quy từ gốc repo. Bỏ qua thư mục sinh ra khi build hoặc của công cụ
    (bin, obj, .git, .vs, node_modules, TestResults...) và thư mục tài nguyên thuần
    (*/Resources/Images). Báo từng thư mục vi phạm; trả mã thoát 1 nếu có vi phạm.
    Dùng ở hook .claude (P0-06) và job check-readme trong CI (P0-04).

.PARAMETER Path
    Gốc repo cần quét. Mặc định là thư mục cha của scripts/.

.EXAMPLE
    pwsh scripts/check-readme.ps1
#>
[CmdletBinding()]
param(
    [string]$Path = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'

# Tên thư mục bỏ qua ở mọi cấp, cùng toàn bộ thư mục con
$skipNames = @('.git', '.vs', '.vscode', '.idea', 'bin', 'obj', 'node_modules', 'TestResults')
# Thư mục tài nguyên thuần (đường dẫn tương đối kết thúc bằng chuỗi này) được miễn
$skipSuffixes = @('Resources/Images')

$root = (Resolve-Path -LiteralPath $Path).Path
$problems = [System.Collections.Generic.List[string]]::new()
$checked = 0

function Get-RelativePath([string]$fullName) {
    $rel = [System.IO.Path]::GetRelativePath($root, $fullName).Replace('\', '/')
    if ($rel -eq '.') { return '(gốc repo)' }
    return $rel
}

function Test-Folder([System.IO.DirectoryInfo]$dir) {
    $script:checked++
    $label = Get-RelativePath $dir.FullName
    $readme = Join-Path $dir.FullName 'README.md'

    if (-not (Test-Path -LiteralPath $readme -PathType Leaf)) {
        $problems.Add("${label}: thiếu README.md")
    }
    else {
        $text = Get-Content -LiteralPath $readme -Raw -Encoding utf8
        if ([string]::IsNullOrWhiteSpace($text)) {
            $problems.Add("${label}: README.md rỗng")
        }
        elseif ($text -notmatch '(?m)^##\s+Mục đích\s*$') {
            $problems.Add("${label}: README.md thiếu mục '## Mục đích'")
        }
    }

    foreach ($child in $dir.GetDirectories()) {
        if ($skipNames -contains $child.Name) { continue }
        $childRel = Get-RelativePath $child.FullName
        if ($skipSuffixes | Where-Object { $childRel.EndsWith($_) }) { continue }
        Test-Folder $child
    }
}

Test-Folder ([System.IO.DirectoryInfo]::new($root))

if ($problems.Count -gt 0) {
    foreach ($p in $problems) {
        if ($env:GITHUB_ACTIONS -eq 'true') { Write-Host "::error::$p" } else { Write-Host "LỖI  $p" }
    }
    Write-Host "Có $($problems.Count) thư mục vi phạm trên tổng $checked thư mục đã quét."
    exit 1
}

Write-Host "OK: $checked thư mục đều có README.md với mục '## Mục đích'."
