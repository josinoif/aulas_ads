# Prepara Postgres + schema (se necessário) + seed completo antes de npm run test:e2e
# Uso: a partir de backend/nest/ → .\scripts\e2e-prepare.ps1
$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootCandidate = Resolve-Path (Join-Path $ScriptDir '..')
$ComposeInRoot = Join-Path $RootCandidate 'docker-compose.postgres.yml'

if (Test-Path $ComposeInRoot) {
  $Root = $RootCandidate.Path
  $LojaApi = Join-Path $Root 'loja-api'
} else {
  Write-Error 'ERRO: nao encontrei docker-compose.postgres.yml (rode a partir de backend/nest/).'
  exit 1
}

Set-Location $Root
docker compose -f docker-compose.postgres.yml up -d
Write-Host 'Aguardando Postgres...'
$ready = $false
for ($i = 0; $i -lt 30; $i++) {
  docker exec loja-postgres pg_isready -U loja -d loja 2>$null | Out-Null
  if ($LASTEXITCODE -eq 0) { $ready = $true; break }
  Start-Sleep -Seconds 1
}
if (-not $ready) {
  Write-Error 'Postgres nao ficou ready a tempo.'
  exit 1
}

function Ensure-Schema {
  $hasUsers = (docker exec loja-postgres psql -U loja -d loja -tAc "SELECT to_regclass('public.users')" 2>$null).Trim()
  if ($hasUsers) {
    Write-Host 'Schema OK (tabela users existe).'
    return
  }

  if (-not (Test-Path (Join-Path $LojaApi 'src\app.module.ts'))) {
    Write-Error "ERRO: tabela users ausente e loja-api nao encontrado em $LojaApi"
    Write-Host 'Suba a API manualmente (npm run start:dev) ate o cap. 6+, depois rode este script.'
    exit 1
  }

  $envFile = Join-Path $LojaApi '.env'
  $envExample = Join-Path $Root '.env.example'
  if (-not (Test-Path $envFile) -and (Test-Path $envExample)) {
    Write-Warning "Copie $envExample para $envFile"
  }

  try {
    $null = Invoke-WebRequest -Uri 'http://localhost:3000/health' -UseBasicParsing -TimeoutSec 2
    Write-Error 'ERRO: porta 3000 ocupada (ex.: npm run start:dev ainda rodando). Pare a API antes deste script.'
    exit 1
  } catch {
    # porta livre — esperado
  }

  Write-Host 'Sincronizando schema (API sobe brevemente para o TypeORM criar tabelas)...'
  Push-Location $LojaApi
  try {
    npm run build
    $proc = Start-Process -FilePath 'node' -ArgumentList 'dist/main.js' -PassThru -NoNewWindow
    $up = $false
    for ($i = 0; $i -lt 60; $i++) {
      try {
        $null = Invoke-WebRequest -Uri 'http://localhost:3000/health' -UseBasicParsing -TimeoutSec 1
        $up = $true
        break
      } catch {
        Start-Sleep -Seconds 1
      }
    }
    if (-not $up) {
      Write-Warning 'Health nao respondeu; schema pode estar incompleto.'
    }
    if (-not $proc.HasExited) {
      Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
    }
  }
  finally {
    Pop-Location
  }
  Write-Host 'Schema sincronizado.'
}

Ensure-Schema

Get-Content (Join-Path $Root 'seed\seed.sql') | docker exec -i loja-postgres psql -U loja -d loja
& (Join-Path $Root 'seed\verify-seed.ps1')

Write-Host 'Pronto: Ana/Cli no banco. Em loja-api/: npm run test:e2e'
