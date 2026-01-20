# Secure-CRUD Deployment Script (PowerShell)
# This script automates the deployment of the Multi-Container CRUD System

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Secure-CRUD Deployment Script" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Function to print colored output
function Print-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Green
}

function Print-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Print-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

# Step 1: Check Prerequisites
Print-Status "Checking prerequisites..."

# Check Docker
try {
    $dockerVersion = docker --version
    Print-Status "Docker is installed: $dockerVersion"
} catch {
    Print-Error "Docker is not installed. Please install Docker first."
    exit 1
}

# Check Docker Compose
try {
    $composeVersion = docker-compose --version
    Print-Status "Docker Compose is installed: $composeVersion"
} catch {
    Print-Error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
}

# Check if Docker daemon is running
try {
    docker info | Out-Null
    Print-Status "Docker daemon is running"
} catch {
    Print-Error "Docker daemon is not running. Please start Docker."
    exit 1
}

Write-Host ""

# Step 2: Clean State
Print-Status "Cleaning previous deployment..."
docker-compose down -v 2>&1 | Out-Null
Print-Status "Previous containers and volumes removed"

Write-Host ""

# Step 3: Build & Launch
Print-Status "Building and launching containers..."
docker-compose up --build -d

Write-Host ""

# Step 4: Health Check
Print-Status "Waiting for services to be healthy..."

$MAX_WAIT = 120
$ELAPSED = 0
$INTERVAL = 5

while ($ELAPSED -lt $MAX_WAIT) {
    try {
        # Check if proxy is healthy
        $proxyHealthCheck = docker exec secure-crud-proxy wget --quiet --tries=1 --spider http://localhost/health 2>&1
        if ($LASTEXITCODE -eq 0) {
            Print-Status "Proxy health check: OK"
            
            # Check if app is healthy
            try {
                docker exec secure-crud-app node -e "require('http').get('http://localhost:5000/health', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})" 2>$null
                if ($LASTEXITCODE -eq 0) {
                    Print-Status "App health check: OK"
                    
                    # Check if database is ready
                    docker exec secure-crud-db pg_isready -U postgres 2>$null
                    if ($LASTEXITCODE -eq 0) {
                        Print-Status "Database health check: OK"
                        
                        Write-Host ""
                        Write-Host "==========================================" -ForegroundColor Green
                        Write-Host "[SUCCESS] Application is live at http://localhost" -ForegroundColor Green
                        Write-Host "==========================================" -ForegroundColor Green
                        Write-Host ""
                        Write-Host "Available endpoints:" -ForegroundColor Cyan
                        Write-Host "  - GET  http://localhost/health"
                        Write-Host "  - GET  http://localhost/ (API info)"
                        Write-Host "  - GET  http://localhost/api/tasks"
                        Write-Host "  - POST http://localhost/api/tasks"
                        Write-Host "  - GET  http://localhost/api/tasks/:id"
                        Write-Host "  - PUT  http://localhost/api/tasks/:id"
                        Write-Host "  - DELETE http://localhost/api/tasks/:id"
                        Write-Host ""
                        exit 0
                    }
                }
            } catch {
                # Continue waiting
            }
        }
    } catch {
        # Continue waiting
    }
    
    $ELAPSED += $INTERVAL
    if ($ELAPSED -lt $MAX_WAIT) {
        Print-Status "Waiting for services... (${ELAPSED}s/${MAX_WAIT}s)"
        Start-Sleep -Seconds $INTERVAL
    }
}

Print-Error "Services failed to become healthy within ${MAX_WAIT} seconds"
Write-Host ""
Write-Host "Debug information:"
Write-Host "---"
docker-compose ps
Write-Host "---"
Print-Warning "Run 'docker-compose logs' for more details"
exit 1
