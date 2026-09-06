[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Nome,

    [string]$Descricao,
    [string]$PacoteJava,
    [string]$GrupoMaven,
    [string]$Destino,
    [string]$Repositorio,
    [switch]$NaoInterativo
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function ConvertTo-Slug([string]$Value) {
    $normalized = $Value.Normalize([Text.NormalizationForm]::FormD)
    $withoutAccents = -join ($normalized.ToCharArray() | Where-Object {
        [Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne
        [Globalization.UnicodeCategory]::NonSpacingMark
    })
    return (($withoutAccents -creplace '([a-z0-9])([A-Z])', '$1-$2').ToLowerInvariant() `
        -replace '[^a-z0-9]+', '-' -replace '^-|-$', '')
}

function ConvertTo-PascalCase([string]$Value) {
    $parts = (ConvertTo-Slug $Value) -split '-'
    return -join ($parts | ForEach-Object {
        if ($_.Length -eq 0) { return }
        $_.Substring(0, 1).ToUpperInvariant() + $_.Substring(1)
    })
}

function Read-Required([string]$Prompt, [string]$CurrentValue) {
    if (-not [string]::IsNullOrWhiteSpace($CurrentValue)) { return $CurrentValue.Trim() }
    if ($NaoInterativo) { throw "O parametro obrigatorio '$Prompt' nao foi informado." }
    do { $answer = Read-Host $Prompt } while ([string]::IsNullOrWhiteSpace($answer))
    return $answer.Trim()
}

function Copy-TemplateDirectory([string]$Source, [string]$Destination, [string[]]$ExcludedDirectories) {
    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    foreach ($item in Get-ChildItem -LiteralPath $Source -Force) {
        if ($item.PSIsContainer) {
            if ($ExcludedDirectories -notcontains $item.Name) {
                Copy-TemplateDirectory $item.FullName (Join-Path $Destination $item.Name) $ExcludedDirectories
            }
        } elseif ($item.Name -notlike 'hs_err_pid*.log') {
            Copy-Item -LiteralPath $item.FullName -Destination (Join-Path $Destination $item.Name)
        }
    }
}

$Nome = Read-Required 'Nome do projeto' $Nome
if ([string]::IsNullOrWhiteSpace($Descricao)) {
    if ($NaoInterativo) { $Descricao = "Aplicacao $Nome" }
    else {
        $Descricao = Read-Host 'Descricao do projeto'
        if ([string]::IsNullOrWhiteSpace($Descricao)) { $Descricao = "Aplicacao $Nome" }
    }
}

$slug = ConvertTo-Slug $Nome
if ([string]::IsNullOrWhiteSpace($slug)) { throw 'O nome precisa conter letras ou numeros.' }

$className = ConvertTo-PascalCase $Nome
if ($className[0] -match '[0-9]') { $className = "App$className" }
$applicationClass = "${className}Application"

if ([string]::IsNullOrWhiteSpace($PacoteJava)) {
    $packageSuffix = $className.Substring(0, 1).ToLowerInvariant() + $className.Substring(1)
    $PacoteJava = "br.com.digidatasistemas.$packageSuffix"
}
if ($PacoteJava -notmatch '^[a-z_][a-z0-9_]*(\.[a-z_][a-z0-9_]*)+$') {
    throw "Pacote Java invalido: '$PacoteJava'. Exemplo: br.com.empresa.meuprojeto"
}
if ([string]::IsNullOrWhiteSpace($GrupoMaven)) {
    $packageParts = $PacoteJava -split '\.'
    $GrupoMaven = ($packageParts[0..($packageParts.Length - 2)] -join '.')
}
if ($GrupoMaven -notmatch '^[a-z_][a-z0-9_]*(\.[a-z_][a-z0-9_]*)+$') {
    throw "Grupo Maven invalido: '$GrupoMaven'. Exemplo: br.com.empresa"
}

$templateRoot = $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($Destino)) {
    $Destino = Join-Path (Split-Path $templateRoot -Parent) $slug
}
$targetRoot = [IO.Path]::GetFullPath($Destino)
$templateFullPath = [IO.Path]::GetFullPath($templateRoot)
if ($targetRoot -eq $templateFullPath -or $targetRoot.StartsWith($templateFullPath + [IO.Path]::DirectorySeparatorChar)) {
    throw 'O destino deve ficar fora da pasta do starter pack.'
}
if (Test-Path -LiteralPath $targetRoot) {
    throw "O destino ja existe: $targetRoot"
}

New-Item -ItemType Directory -Path $targetRoot | Out-Null
try {
    $excludedDirectories = @('node_modules', '.next', 'target', 'dist', 'build', '.git')
    foreach ($folder in @('backend', 'frontend')) {
        Copy-TemplateDirectory (Join-Path $templateRoot $folder) (Join-Path $targetRoot $folder) $excludedDirectories
    }

    $replacements = [ordered]@{
        'br.com.digidatasistemas.starterPackage' = $PacoteJava
        '<groupId>com.digidata</groupId>' = "<groupId>$GrupoMaven</groupId>"
        'StarterPackageApplication' = $applicationClass
        'Starter Package API' = "$Nome API"
        'Starter Package App' = "$Nome App"
        'Starter Package' = $Nome
        'starter_package' = ($slug -replace '-', '_')
        'starter-package' = $slug
        'Tamplete para novos projetos' = $Descricao
        'API REST para autenticação e gerenciamento de usuários, perfis, recursos e permissões.' = $Descricao
    }
    if (-not [string]::IsNullOrWhiteSpace($Repositorio)) {
        # A troca generica de "starter-package" ocorre antes destas entradas.
        $replacements["https://github.com/wagnerlemos94/$slug-api"] = $Repositorio.TrimEnd('/') + '-api'
        $replacements["https://github.com/wagnerlemos94/$slug-app"] = $Repositorio.TrimEnd('/') + '-app'
    }

    $textExtensions = @('.java', '.xml', '.yml', '.yaml', '.json', '.md', '.ts', '.tsx', '.js', '.mjs', '.cjs', '.env', '.properties', '.sql', '.txt')
    Get-ChildItem -LiteralPath $targetRoot -File -Recurse -Force | Where-Object {
        $textExtensions -contains $_.Extension.ToLowerInvariant() -or $_.Name -in @('Dockerfile', 'mvnw', 'mvnw.cmd')
    } | ForEach-Object {
        $content = [IO.File]::ReadAllText($_.FullName)
        $updated = $content
        foreach ($entry in $replacements.GetEnumerator()) {
            $updated = $updated.Replace([string]$entry.Key, [string]$entry.Value)
        }
        if ($updated -ne $content) {
            [IO.File]::WriteAllText($_.FullName, $updated, [Text.UTF8Encoding]::new($false))
        }
    }

    $oldMainPackage = Join-Path $targetRoot 'backend/src/main/java/br/com/digidatasistemas/starterPackage'
    $oldTestPackage = Join-Path $targetRoot 'backend/src/test/java/br/com/digidatasistemas/starterPackage'
    $packagePath = $PacoteJava -replace '\.', [IO.Path]::DirectorySeparatorChar
    $newMainPackage = Join-Path $targetRoot "backend/src/main/java/$packagePath"
    $newTestPackage = Join-Path $targetRoot "backend/src/test/java/$packagePath"

    New-Item -ItemType Directory -Path (Split-Path $newMainPackage -Parent) -Force | Out-Null
    New-Item -ItemType Directory -Path (Split-Path $newTestPackage -Parent) -Force | Out-Null
    Move-Item -LiteralPath $oldMainPackage -Destination $newMainPackage
    Move-Item -LiteralPath $oldTestPackage -Destination $newTestPackage

    Rename-Item -LiteralPath (Join-Path $newMainPackage 'StarterPackageApplication.java') -NewName "$applicationClass.java"
    $testFile = Get-Item -LiteralPath (Join-Path $newTestPackage 'GestaoEscolarApplicationTests.java') -ErrorAction SilentlyContinue
    if ($testFile) {
        $testClass = "${applicationClass}Tests"
        $testContent = [IO.File]::ReadAllText($testFile.FullName).Replace('GestaoEscolarApplicationTests', $testClass)
        [IO.File]::WriteAllText($testFile.FullName, $testContent, [Text.UTF8Encoding]::new($false))
        Rename-Item -LiteralPath $testFile.FullName -NewName "$testClass.java"
    }

    $readme = @(
        "# $Nome"
        ''
        $Descricao
        ''
        'Projeto full stack criado a partir do starter pack, com:'
        ''
        '- `backend/`: Java 21, Spring Boot, PostgreSQL, Flyway e JWT.'
        '- `frontend/`: Next.js, React, TypeScript e Material UI.'
        ''
        '## Executar'
        ''
        'Consulte [backend/README.md](backend/README.md) e [frontend/README.md](frontend/README.md) para configuracao e comandos de cada aplicacao.'
        ''
        '## Identificadores'
        ''
        "- Projeto/pacote: ``$slug``"
        "- Pacote Java: ``$PacoteJava``"
        "- Grupo Maven: ``$GrupoMaven``"
        "- Classe principal: ``$applicationClass``"
        "- Banco sugerido: ``$($slug -replace '-', '_')``"
    ) -join [Environment]::NewLine
    [IO.File]::WriteAllText((Join-Path $targetRoot 'README.md'), $readme, [Text.UTF8Encoding]::new($false))

    Write-Host ''
    Write-Host 'Projeto criado com sucesso:' -ForegroundColor Green
    Write-Host "  Pasta:         $targetRoot"
    Write-Host "  Identificador: $slug"
    Write-Host "  Pacote Java:   $PacoteJava"
    Write-Host "  Classe Java:   $applicationClass"
} catch {
    if (Test-Path -LiteralPath $targetRoot) {
        Remove-Item -LiteralPath $targetRoot -Recurse -Force
    }
    throw
}
