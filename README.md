# Secure-CRUD: Multi-Container CRUD System

A professional-grade, containerized CRUD (Create, Read, Update, Delete) application demonstrating best practices for Docker, security, and automation.

## 📋 Project Overview

Secure-CRUD is a multi-service application that showcases modern DevOps practices:
- **Network Isolation**: Services communicate privately; only Nginx exposes ports
- **Security**: Non-root users, environment-based credentials, Alpine images
- **Automation**: One-command deployment with comprehensive health checks
- **CI/CD**: GitHub Actions pipeline for automated builds and deployments

## 🏗️ System Architecture

```
┌─────────────────────────────────────────┐
│        Host Machine (Port 80)           │
├─────────────────────────────────────────┤
│                                         │
│  ┌──────────────────────────────────┐  │
│  │  Nginx Proxy (Reverse Proxy)     │  │
│  │  - Listens on 0.0.0.0:80         │  │
│  │  - Routes to App service         │  │
│  └──────────────┬───────────────────┘  │
│                 │                       │
│  ┌──────────────▼───────────────────┐  │
│  │  Node.js App (Port 5000)         │  │
│  │  - CRUD API endpoints            │  │
│  │  - Not exposed to host           │  │
│  └──────────────┬───────────────────┘  │
│                 │                       │
│  ┌──────────────▼───────────────────┐  │
│  │  PostgreSQL Database             │  │
│  │  - Data persistence              │  │
│  │  - Not exposed to host           │  │
│  └──────────────────────────────────┘  │
│                                         │
│  Private Docker Network (secure-crud-network)
└─────────────────────────────────────────┘
```

### Services

| Service  | Technology | Role | Port |
|----------|-----------|------|------|
| **proxy** | Nginx Alpine | Reverse proxy & gateway | 80 (host) → 80 (container) |
| **app** | Node.js 18 Alpine | CRUD API server | 5000 (internal only) |
| **database** | PostgreSQL 15 Alpine | Data persistence | 5432 (internal only) |

## 🚀 Quick Start

### Prerequisites

- **Docker**: [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose**: [Install Docker Compose](https://docs.docker.com/compose/install/)
- **Git**: For cloning and version control

### Deploy with One Command

```bash
bash deploy.sh
```

This script will:
1. ✅ Verify Docker & Docker Compose are installed
2. ✅ Clean any previous deployment
3. ✅ Build and launch all containers
4. ✅ Wait for services to be healthy
5. ✅ Display success message with API endpoints

### Access the Application

Once deployed successfully:

```
http://localhost
```

## 📡 API Endpoints

### Health Check
```http
GET http://localhost/health
```

### API Information
```http
GET http://localhost/
```

### Tasks Management

**List all tasks**
```http
GET http://localhost/api/tasks
```

**Get single task**
```http
GET http://localhost/api/tasks/{id}
```

**Create task**
```http
POST http://localhost/api/tasks
Content-Type: application/json

{
  "title": "My Task",
  "description": "Task description"
}
```

**Update task**
```http
PUT http://localhost/api/tasks/{id}
Content-Type: application/json

{
  "title": "Updated Title",
  "description": "Updated description",
  "completed": true
}
```

**Delete task**
```http
DELETE http://localhost/api/tasks/{id}
```

### Example cURL Commands

```bash
# Create a task
curl -X POST http://localhost/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"Learn Docker","description":"Master containerization"}'

# Get all tasks
curl http://localhost/api/tasks

# Get specific task
curl http://localhost/api/tasks/1

# Update task
curl -X PUT http://localhost/api/tasks/1 \
  -H "Content-Type: application/json" \
  -d '{"completed":true}'

# Delete task
curl -X DELETE http://localhost/api/tasks/1
```

## 📁 Project Structure

```
.
├── src/                          # Application source code
│   ├── server.js                 # Main Express application
│   ├── package.json              # Node.js dependencies
│   └── package-lock.json         # Dependency lock file
├── nginx/                        # Nginx configuration
│   └── nginx.conf                # Reverse proxy configuration
├── .github/
│   └── workflows/
│       └── ci-cd.yml             # GitHub Actions pipeline
├── Dockerfile                    # Application container image
├── docker-compose.yml            # Multi-container orchestration
├── deploy.sh                     # Deployment automation script
├── .env                          # Environment variables
├── .env.example                  # Environment variables template
├── .gitignore                    # Git ignore rules
└── README.md                     # This file
```

## ⚙️ Configuration

### Environment Variables

Edit `.env` file to customize your deployment:

```env
# Database Configuration
DB_USER=postgres
DB_PASSWORD=postgres_secure
DB_NAME=crud_db
DB_HOST=database
DB_PORT=5432

# Application Configuration
NODE_ENV=production
PORT=5000
```

**Note:** Keep `.env` file secure and never commit it to version control.

## 🛠️ Development

### Local Setup (Without Docker)

```bash
# Install dependencies
cd src
npm install

# Start application (requires PostgreSQL running locally)
export DB_HOST=localhost
npm start
```

### Build Docker Image

```bash
# Build the application image
docker-compose build

# View built images
docker images
```

### View Logs

```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f app
docker-compose logs -f database
docker-compose logs -f proxy
```

### Stop Services

```bash
# Stop containers (keeps volumes)
docker-compose stop

# Stop and remove containers and volumes
docker-compose down -v
```

## 🔐 Security Features

1. **Non-Root User**: Application runs as `appuser` (UID 1001)
2. **Network Isolation**: Only Nginx is exposed; App and Database are internal
3. **Alpine Images**: Minimal attack surface with Alpine Linux
4. **Environment Variables**: Credentials managed via `.env` file
5. **Health Checks**: Automated service monitoring
6. **Read-Only Config**: Nginx config mounted as read-only

## 🐳 Docker Best Practices Implemented

✅ Multi-stage builds (optimized image size)
✅ Alpine base images (minimal overhead)
✅ Non-root user execution
✅ Health checks for all services
✅ Named volumes for persistence
✅ Explicit port exposure documentation
✅ `.dockerignore` for faster builds
✅ Graceful shutdown handling

## 📦 Production Deployment

### Docker Hub

1. Create Docker Hub account: https://hub.docker.com/
2. Create public repository: `your-username/secure-crud-app`
3. Set GitHub Secrets:
   - `DOCKER_USERNAME`: Your Docker Hub username
   - `DOCKER_PASSWORD`: Your Docker Hub access token

4. Push to main branch - CI/CD will automatically:
   - Build the image
   - Tag with `latest` and commit SHA
   - Push to Docker Hub

### Kubernetes Deployment

The container can be deployed to Kubernetes clusters:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-crud-app
spec:
  containers:
  - name: app
    image: your-username/secure-crud-app:latest
    ports:
    - containerPort: 5000
    env:
    - name: DB_HOST
      value: "database-service"
    - name: DB_USER
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: username
```

## 🚨 Troubleshooting

### "Docker daemon is not running"
```bash
# Start Docker
# macOS: Open Docker.app
# Linux: sudo systemctl start docker
# Windows: Start Docker Desktop
```

### "Port 80 is already in use"
```bash
# Find process using port 80
lsof -i :80  # macOS/Linux
netstat -ano | findstr :80  # Windows

# Stop conflicting service or modify docker-compose.yml port mapping
```

### Application won't start
```bash
# Check logs
docker-compose logs app

# Rebuild containers
docker-compose build --no-cache
docker-compose up -d
```

### Database connection errors
```bash
# Verify database is healthy
docker-compose ps

# Check database logs
docker-compose logs database

# Reset database
docker-compose down -v
docker-compose up -d
```

## 📊 Monitoring

### Container Status
```bash
docker-compose ps
```

### Service Health
```bash
# Check all health statuses
docker-compose ps

# Manual health check
curl http://localhost/health
```

### Resource Usage
```bash
docker stats
```

## 🔄 CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/ci-cd.yml`) automatically:

1. **On Push to Main**:
   - Checks out code
   - Sets up Docker Buildx
   - Logs into Docker Hub
   - Builds Docker image with tags
   - Pushes to Docker Hub

2. **Testing**:
   - Starts containers
   - Waits for services to be healthy
   - Runs health checks
   - Collects logs on failure
   - Cleans up resources

### Workflow Status Badge

Add to your GitHub README:

```markdown
[![CI/CD Pipeline](https://github.com/YOUR-USERNAME/secure-crud/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/YOUR-USERNAME/secure-crud/actions)
```

## 📝 Database Schema

The application automatically creates the `tasks` table:

```sql
CREATE TABLE tasks (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  completed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 📚 Learning Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Express.js Guide](https://expressjs.com/)
- [PostgreSQL Manual](https://www.postgresql.org/docs/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

## ✨ Features

- ✅ **CRUD Operations**: Full Create, Read, Update, Delete functionality
- ✅ **REST API**: JSON-based endpoints
- ✅ **Data Persistence**: PostgreSQL database with named volumes
- ✅ **Reverse Proxy**: Nginx for traffic routing and load balancing
- ✅ **Network Security**: Private Docker network, no direct database access
- ✅ **Health Checks**: Automated service monitoring
- ✅ **One-Command Deployment**: Simple `bash deploy.sh` script
- ✅ **CI/CD Automation**: GitHub Actions pipeline
- ✅ **Docker Best Practices**: Non-root users, Alpine images, security hardening
- ✅ **Production Ready**: Container orchestration with docker-compose

## 🐛 Known Issues & Improvements

- [ ] Add authentication/authorization
- [ ] Implement rate limiting
- [ ] Add request logging
- [ ] Implement caching layer (Redis)
- [ ] Add WebSocket support
- [ ] Implement GraphQL endpoint
- [ ] Add frontend UI
- [ ] Database migrations system

## 📞 Support

For issues and questions:
- Open an [Issue](https://github.com/YOUR-USERNAME/secure-crud/issues)
- Check [Discussions](https://github.com/YOUR-USERNAME/secure-crud/discussions)
- Review documentation in this README

---

**Made with ❤️ | Secure-CRUD v1.0.0**
