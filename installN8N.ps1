<#
.SYNOPSIS
Script para instalar Docker Desktop y desplegar n8n.
#>

# ---------------------------------------------------------
# 1. Descargar Docker Desktop Installer
# ---------------------------------------------------------
$installerPath = "$env:TEMP\DockerDesktopInstaller.exe"
$downloadUrl = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"

Write-Host "Downloading Docker Desktop. This might take a moment..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath

# ---------------------------------------------------------
# 2. Instalar Docker Desktop
# ---------------------------------------------------------
Write-Host "Installing Docker Desktop (this will take a few minutes)..." -ForegroundColor Cyan
Start-Process -FilePath $installerPath -ArgumentList "install --quiet --accept-license" -Wait -NoNewWindow

# Actualiza las variables de entorno para que el comando 'docker' esté disponible en esta sesión de PowerShell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# ---------------------------------------------------------
# 3. Iniciar Docker Desktop
# ---------------------------------------------------------
Write-Host "Starting Docker Desktop..." -ForegroundColor Cyan
Start-Process -FilePath "C:\Program Files\Docker\Docker\Docker Desktop.exe"

Write-Host "Waiting for the Docker engine to initialize" -ForegroundColor Cyan
$dockerReady = $false
$retryCount = 0

# Health check
while (-not $dockerReady -and $retryCount -lt 40) {
    Start-Sleep -Seconds 5
    try {
        $null = & docker info 2>&1
        if ($LASTEXITCODE -eq 0) { $dockerReady = $true }
    } catch { }
    $retryCount++
    Write-Host "." -NoNewline
}
Write-Host ""

if (-not $dockerReady) {
    Write-Host "WARNING: Docker engine is taking too long or requires a system restart." -ForegroundColor Yellow
    Write-Host "Please RESTART your computer, open PowerShell, and run the following commands manually:" -ForegroundColor Yellow
    Write-Host "docker volume create n8n_data"
    Write-Host "docker run -d --restart unless-stopped --name n8n -p 5678:5678 -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n"
    exit
}

# ---------------------------------------------------------
# 4. Desplegar n8n en Docker
# ---------------------------------------------------------
Write-Host "Docker is running! Deploying the n8n container..." -ForegroundColor Cyan

# Creas un volumen para persistencia de datos de n8n asi no pierdes tus flujos al reiniciar el contenedor
docker volume create n8n_data

# Correr docker en el puerto 5678
docker run -d --restart unless-stopped --name n8n -p 5678:5678 -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n

Write-Host "----------------------------------------------------" -ForegroundColor Green
Write-Host "Deployment Complete!" -ForegroundColor Green
Write-Host "You can access your n8n instance at: http://localhost:5678" -ForegroundColor Green
Write-Host "----------------------------------------------------" -ForegroundColor Green


Remove-Item -Path $installerPath -Force