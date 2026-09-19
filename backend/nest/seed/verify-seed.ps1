# Verifica se o hash bcrypt em seed.sql corresponde à senha secret123.
# Uso (PowerShell): a partir de backend/nest/ → .\seed\verify-seed.ps1
# Se ExecutionPolicy bloquear: powershell -ExecutionPolicy Bypass -File .\seed\verify-seed.ps1
# Primeira execução pode baixar bcryptjs no TEMP (precisa de rede).
$ErrorActionPreference = 'Stop'

$Dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SeedFile = Join-Path $Dir 'seed.sql'
$content = Get-Content -Raw $SeedFile
if ($content -notmatch '\$2b\$10\$[A-Za-z0-9./]+') {
  Write-Error 'FALHA: nenhum hash $2b$10$ encontrado em seed.sql'
  exit 1
}
$Hash = $Matches[0]

$WorkDir = Join-Path $env:TEMP ("loja-seed-verify-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $WorkDir | Out-Null
try {
  Push-Location $WorkDir
  npm init -y | Out-Null
  npm install --silent bcryptjs@2.4.3 | Out-Null
  $env:SEED_HASH = $Hash
  node -e @"
const bcrypt = require('bcryptjs');
bcrypt.compare('secret123', process.env.SEED_HASH).then((ok) => {
  if (!ok) {
    console.error('FALHA: hash em seed.sql nao corresponde a secret123');
    process.exit(1);
  }
  console.log('OK: seed.sql verificado (ana/cli -> secret123)');
});
"@
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
finally {
  Pop-Location
  Remove-Item -Recurse -Force $WorkDir -ErrorAction SilentlyContinue
}
