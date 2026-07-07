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

function Resolve-Python {
  $pythonCommand = Get-Command python -ErrorAction SilentlyContinue
  if ($pythonCommand) {
    return $pythonCommand.Source
  }

  $bundled = "C:\Users\px830\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"
  if (Test-Path $bundled) {
    return $bundled
  }

  throw "Python runtime not found."
}

function Test-NativeCompiler {
  foreach ($name in @("cl", "gcc", "clang", "cc")) {
    if (Get-Command $name -ErrorAction SilentlyContinue) {
      return $true
    }
  }
  return $false
}

$requiredFiles = @(
  "README.md",
  "LICENSE",
  "CHANGELOG.md",
  "CONTRIBUTING.md",
  "SECURITY.md",
  ".github/workflows/ci.yml",
  "proposal/one-page-proposal.md"
)

foreach ($path in $requiredFiles) {
  Assert-True (Test-Path $path) "Missing required file: $path"
}

$readme = Get-Item "README.md"
Assert-True (($readme.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) "README.md must be a normal file, not a symlink."

$readmeText = Get-Content "README.md" -Raw -Encoding UTF8
Assert-True (-not ($readmeText -match "\]\(/")) "README.md contains an absolute local Markdown link."
Assert-True ($readmeText.Contains("MoonForge")) "README.md must mention the project name."

$python = Resolve-Python

$proposalCheck = & $python -c "from pathlib import Path; t=Path('proposal/one-page-proposal.md').read_text(encoding='utf-8'); ok=('\u9879\u76ee\u540d\u79f0' in t and '\u9879\u76ee\u7b80\u4ecb' in t and 'GitHub:' in t and '\u6924' not in t and '\u935a' not in t); print('ok' if ok else 'bad')"
Assert-True ($proposalCheck.Trim() -eq "ok") "Proposal markdown is missing key Chinese headings or still looks garbled."

$pdfPath = Get-ChildItem "output\pdf" -Filter "MoonForge-OSC2026-Proposal.pdf" | Select-Object -First 1
Assert-True ($null -ne $pdfPath) "Proposal PDF not found."

$pageCount = & $python -c "from pathlib import Path; from pypdf import PdfReader; print(len(PdfReader(Path(r'output/pdf/MoonForge-OSC2026-Proposal.pdf')).pages))"
Assert-True ($pageCount.Trim() -eq "1") "Proposal PDF must contain exactly 1 page."

$moonModText = Get-Content "moon.mod" -Raw -Encoding UTF8
Assert-True ($moonModText.Contains('name = "Lyhdsba/moonforge"')) "moon.mod must use the Mooncakes account identity."

moon info | Out-Null
moon fmt --check | Out-Null
moon check | Out-Null

$commitCount = git rev-list --count HEAD
$commitCountInt = [int]$commitCount
Assert-True ($commitCountInt -ge 10 -and $commitCountInt -le 20) "Commit count must stay between 10 and 20."

if (Test-NativeCompiler) {
  moon test | Out-Null
  moon run --target native cmd/main -- list | Out-Null
  Write-Host "native verification: passed"
} else {
  Write-Host "native verification: skipped (no system C compiler found)"
}

Write-Host "acceptance verification passed"
