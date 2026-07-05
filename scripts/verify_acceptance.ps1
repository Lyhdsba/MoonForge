$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

function Assert-True {
  param(
    [bool]$Condition,
    [string]$Message
  )
  if (-not $Condition) {
    throw $Message
  }
}

$readme = Get-Item "README.md"
Assert-True (($readme.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) "README.md must be a normal file, not a symlink."

$readmeText = Get-Content "README.md" -Raw -Encoding UTF8
Assert-True (-not ($readmeText -match "\]\(/")) "README.md contains an absolute local Markdown link."

$python = "C:\Users\px830\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"

$proposalCheck = & $python -c "from pathlib import Path; t=Path('proposal/one-page-proposal.md').read_text(encoding='utf-8'); ok=('\u9879\u76ee\u540d\u79f0' in t and '\u9879\u76ee\u7b80\u4ecb' in t and 'GitHub:' in t and '\u6924' not in t and '\u935a' not in t); print('ok' if ok else 'bad')"
Assert-True ($proposalCheck.Trim() -eq "ok") "Proposal markdown is missing key Chinese headings or still looks garbled."

$pdfPath = Get-ChildItem "output\pdf" -Filter "MoonForge-OSC2026-Proposal.pdf" | Select-Object -First 1
Assert-True ($null -ne $pdfPath) "Proposal PDF not found."

$pageCount = & $python -c "from pathlib import Path; from pypdf import PdfReader; print(len(PdfReader(Path(r'output/pdf/MoonForge-OSC2026-Proposal.pdf')).pages))"
Assert-True ($pageCount.Trim() -eq "1") "Proposal PDF must contain exactly 1 page."

$commitCount = git rev-list --count HEAD
$commitCountInt = [int]$commitCount
Assert-True ($commitCountInt -ge 10 -and $commitCountInt -le 20) "Commit count must stay between 10 and 20."

Write-Host "acceptance verification passed"
