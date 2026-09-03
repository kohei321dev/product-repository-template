[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$docsRoot = Join-Path $repositoryRoot 'docs'
$errors = New-Object System.Collections.Generic.List[string]

$requiredFiles = @(
    'README.md',
    'AGENTS.md',
    'docs/README.md',
    'docs/product.md',
    'docs/requirements.md',
    'docs/architecture.md',
    'docs/security.md',
    'docs/specifications/README.md',
    'docs/decisions/README.md',
    'docs/decisions/TEMPLATE.md',
    'docs/process/development.md',
    'docs/process/documentation.md',
    'docs/process/release.md',
    'docs/operations/README.md',
    'docs/guides/README.md'
)

foreach ($relativePath in $requiredFiles) {
    $absolutePath = Join-Path $repositoryRoot $relativePath
    if (-not (Test-Path -LiteralPath $absolutePath -PathType Leaf)) {
        $errors.Add("Required file is missing: $relativePath")
        continue
    }

    if ((Get-Item -LiteralPath $absolutePath).Length -eq 0) {
        $errors.Add("Required file is empty: $relativePath")
    }
}

if (Test-Path -LiteralPath $docsRoot -PathType Container) {
    $markdownFiles = Get-ChildItem -LiteralPath $docsRoot -Recurse -File -Filter '*.md'
    foreach ($file in $markdownFiles) {
        if ($file.Name -in @('README.md', 'TEMPLATE.md')) {
            continue
        }

        if ($file.Name -notmatch '^[a-z0-9]+(?:-[a-z0-9]+)*\.md$') {
            $relativePath = $file.FullName.Substring($repositoryRoot.Length).TrimStart([char[]]@('\', '/')).Replace('\', '/')
            $errors.Add("Markdown filename must use lowercase kebab-case: $relativePath")
        }
    }
}

$decisionRoot = Join-Path $docsRoot 'decisions'
$decisionIndexPath = Join-Path $decisionRoot 'README.md'
$decisionIndex = ''
if (Test-Path -LiteralPath $decisionIndexPath -PathType Leaf) {
    $decisionIndex = Get-Content -LiteralPath $decisionIndexPath -Raw
}

$decisionFiles = @()
if (Test-Path -LiteralPath $decisionRoot -PathType Container) {
    $decisionFiles = @(
        Get-ChildItem -LiteralPath $decisionRoot -File -Filter '*.md' |
            Where-Object { $_.Name -notin @('README.md', 'TEMPLATE.md') }
    )
}

$seenIds = @{}
$requiredDecisionFields = @(
    'Status',
    'Date',
    'Type',
    'Related Issues',
    'Related Pull Requests',
    'Affected Docs',
    'Supersedes',
    'Superseded By'
)
$allowedStatuses = @('proposed', 'accepted', 'superseded', 'deprecated', 'rejected')

foreach ($file in $decisionFiles) {
    if ($file.Name -notmatch '^(?<id>\d{4})-[a-z0-9]+(?:-[a-z0-9]+)*\.md$') {
        $errors.Add("Decision filename is invalid: docs/decisions/$($file.Name)")
        continue
    }

    $id = $Matches.id
    if ($seenIds.ContainsKey($id)) {
        $errors.Add("Decision ID is duplicated: $id")
    } else {
        $seenIds[$id] = $file.Name
    }

    $content = Get-Content -LiteralPath $file.FullName -Raw
    if ($content -notmatch "(?m)^# DR-${id}: .+") {
        $errors.Add("Decision title must start with '# DR-${id}:': docs/decisions/$($file.Name)")
    }

    foreach ($field in $requiredDecisionFields) {
        if ($content -notmatch "(?m)^- $([regex]::Escape($field)):") {
            $errors.Add("Decision field '$field' is missing: docs/decisions/$($file.Name)")
        }
    }

    $statusMatch = [regex]::Match($content, '(?im)^- Status:\s*(?<status>[^\r\n]+)')
    if ($statusMatch.Success) {
        $status = $statusMatch.Groups['status'].Value.Trim().ToLowerInvariant()
        if ($status -notin $allowedStatuses) {
            $errors.Add("Decision status '$status' is invalid: docs/decisions/$($file.Name)")
        }
    }

    if ($decisionIndex -notmatch [regex]::Escape($file.Name)) {
        $errors.Add("Decision is not listed in docs/decisions/README.md: $($file.Name)")
    }
}

if ($errors.Count -gt 0) {
    foreach ($message in $errors) {
        Write-Host "ERROR: $message"
    }
    exit 1
}

Write-Host "Documentation structure validation passed. Checked $($requiredFiles.Count) required files and $($decisionFiles.Count) decision records."
