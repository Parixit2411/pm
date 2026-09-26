$ErrorActionPreference = "Stop"

$ContainerName = "pm-app"

docker info 1>$null 2>$null
if ($LASTEXITCODE -ne 0) {
  Write-Error "Docker is not running. Start Docker Desktop and retry."
}

cmd /c "docker rm -f $ContainerName >nul 2>&1"
Write-Host "Stopped $ContainerName"
