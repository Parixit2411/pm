$ErrorActionPreference = "Stop"

$RootDir = Split-Path -Parent $PSScriptRoot
Set-Location $RootDir

$ImageName = "pm-app"
$ContainerName = "pm-app"
$Port = "8000"

if (-not (Test-Path ".env")) {
  Write-Error "Missing .env in project root"
}

docker info 1>$null 2>$null
if ($LASTEXITCODE -ne 0) {
  Write-Error "Docker is not running. Start Docker Desktop and retry."
}

docker build -t $ImageName .
cmd /c "docker rm -f $ContainerName >nul 2>&1"
docker run -d `
  --name $ContainerName `
  -p "${Port}:8000" `
  --env-file .env `
  $ImageName | Out-Null

if ($LASTEXITCODE -ne 0) {
  Write-Error "Failed to start container $ContainerName"
}

Write-Host "Started http://localhost:${Port}"
