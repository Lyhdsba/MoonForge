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

function Get-InterfaceDigest {
  $paths = @("pkg.generated.mbti", "cmd/main/pkg.generated.mbti")
  $parts = @()
  foreach ($path in $paths) {
    Assert-True (Test-Path $path) "Missing generated interface file: $path"
    $parts += (Get-FileHash $path -Algorithm SHA256).Hash
  }
  return ($parts -join "|")
}

$requiredFiles = @(
  "README.md",
  "LICENSE",
  "CHANGELOG.md",
  "CONTRIBUTING.md",
  "SECURITY.md",
  ".github/workflows/ci.yml",
  ".github/workflows/publish.yml",
  "docs/official-requirements.md",
  "docs/source-attribution.md",
  "docs/acceptance-checklist.md",
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
Assert-True ($readmeText.Contains("moonforge stats")) "README.md must document the stats command."

$python = Resolve-Python

$proposalCheck = & $python -c "from pathlib import Path; t=Path('proposal/one-page-proposal.md').read_text(encoding='utf-8'); ok=('\u9879\u76ee\u540d\u79f0' in t and '\u9879\u76ee\u7b80\u4ecb' in t and 'GitHub:' in t and '\u6924' not in t and '\u935a' not in t); print('ok' if ok else 'bad')"
Assert-True ($proposalCheck.Trim() -eq "ok") "Proposal markdown is missing key Chinese headings or still looks garbled."

$pdfPath = Get-ChildItem "output\pdf" -Filter "MoonForge-OSC2026-Proposal.pdf" | Select-Object -First 1
Assert-True ($null -ne $pdfPath) "Proposal PDF not found."

$pageCount = & $python -c "from pathlib import Path; from pypdf import PdfReader; print(len(PdfReader(Path(r'output/pdf/MoonForge-OSC2026-Proposal.pdf')).pages))"
Assert-True ($pageCount.Trim() -eq "1") "Proposal PDF must contain exactly 1 page."

$moonModText = Get-Content "moon.mod" -Raw -Encoding UTF8
Assert-True ($moonModText.Contains('name = "Lyhdsba/moonforge"')) "moon.mod must use the Mooncakes account identity."

moon version --all | Out-Null
moon check --fmt --deny-warn --target native | Out-Null
moon info | Out-Null
$firstDigest = Get-InterfaceDigest
moon info | Out-Null
$secondDigest = Get-InterfaceDigest
Assert-True ($firstDigest -eq $secondDigest) "moon info output is not stable across consecutive runs."
moon check --deny-warn --target native | Out-Null

$commitCount = git rev-list --count HEAD
$commitCountInt = [int]$commitCount
Assert-True ($commitCountInt -ge 15) "Commit history should show sustained public development."

$moonBitLines = [int](& $python scripts/count_moonbit_lines.py)
Assert-True ($moonBitLines -ge 1600) "Tracked MoonBit source should stay above the expanded acceptance baseline."

$originHead = [string](git ls-remote --symref origin HEAD)
Assert-True (($originHead -match "refs/heads/main")) "GitHub remote default branch must be main."

$shortlog = git shortlog -sne --all
Assert-True ($shortlog -match "Lyhdsba <2749233024@qq.com>") "Expected repository owner identity missing from commit history."

if ((git remote) -contains "gitlink") {
  $gitlinkHead = [string](git ls-remote --symref gitlink HEAD)
  Assert-True (($gitlinkHead -match "refs/heads/main")) "GitLink remote default branch must be main."
}

if (Test-NativeCompiler) {
  moon test --deny-warn --target native | Out-Null
  moon run --target native cmd/main -- stats | Out-Null
  Write-Host "native verification: passed"
} else {
  Write-Host "native verification: skipped (no system C compiler found)"
}

Write-Host "acceptance verification passed"
