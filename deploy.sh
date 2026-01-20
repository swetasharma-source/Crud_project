#!/bin/bash

# Secure-CRUD Deployment Script
# This script automates the deployment of the Multi-Container CRUD System

set -e

echo "=========================================="
echo "Secure-CRUD Deployment Script"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Step 1: Check Prerequisites
print_status "Checking prerequisites..."

# Check Docker
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi
print_status "Docker is installed: $(docker --version)"

# Check Docker Compose
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi
print_status "Docker Compose is installed: $(docker-compose --version)"

# Check if Docker daemon is running
if ! docker info &> /dev/null; then
    print_error "Docker daemon is not running. Please start Docker."
    exit 1
fi
print_status "Docker daemon is running"

echo ""

# Step 2: Clean State
print_status "Cleaning previous deployment..."
docker-compose down -v 2>/dev/null || true
print_status "Previous containers and volumes removed"

echo ""

# Step 3: Build & Launch
print_status "Building and launching containers..."
docker-compose up --build -d

echo ""

# Step 4: Health Check
print_status "Waiting for services to be healthy..."

# Maximum wait time in seconds
MAX_WAIT=120
ELAPSED=0
INTERVAL=5

while [ $ELAPSED -lt $MAX_WAIT ]; do
    # Check if proxy is healthy
    if docker exec secure-crud-proxy wget --quiet --tries=1 --spider http://localhost/health 2>/dev/null; then
        print_status "Proxy health check: OK"
        
        # Check if app is healthy
        if docker exec secure-crud-app node -e "require('http').get('http://localhost:5000/health', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})" 2>/dev/null; then
            print_status "App health check: OK"
            
            # Check if database is ready
            if docker exec secure-crud-db pg_isready -U postgres 2>/dev/null; then
                print_status "Database health check: OK"
                
                echo ""
                echo "=========================================="
                echo -e "${GREEN}[SUCCESS]${NC} Application is live at ${GREEN}http://localhost${NC}"
                echo "=========================================="
                echo ""
                echo "Available endpoints:"
                echo "  - GET  http://localhost/health"
                echo "  - GET  http://localhost/ (API info)"
                echo "  - GET  http://localhost/api/tasks"
                echo "  - POST http://localhost/api/tasks"
                echo "  - GET  http://localhost/api/tasks/:id"
                echo "  - PUT  http://localhost/api/tasks/:id"
                echo "  - DELETE http://localhost/api/tasks/:id"
                echo ""
                exit 0
            fi
        fi
    fi
    
    ELAPSED=$((ELAPSED + INTERVAL))
    if [ $ELAPSED -lt $MAX_WAIT ]; then
        print_status "Waiting for services... (${ELAPSED}s/${MAX_WAIT}s)"
        sleep $INTERVAL
    fi
done

print_error "Services failed to become healthy within ${MAX_WAIT} seconds"
echo ""
echo "Debug information:"
echo "---"
docker-compose ps
echo "---"
print_warning "Run 'docker-compose logs' for more details"
exit 1
