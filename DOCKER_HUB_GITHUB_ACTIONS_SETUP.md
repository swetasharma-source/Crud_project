# Docker Hub & GitHub Actions Setup Guide

## 🎯 Quick Summary

This guide walks you through setting up Docker Hub integration and enabling GitHub Actions CI/CD for your Secure-CRUD project.

---

## 📋 Setup Steps

### Phase 1: Docker Hub (5 minutes)

#### 1.1 Create Docker Hub Account
- Visit: https://hub.docker.com
- Click "Sign Up"
- Complete registration with:
  - Username: `swetasharma`
  - Email: Your email
  - Password: Strong password
- Verify your email

#### 1.2 Create Public Repository
- Log in to Docker Hub
- Click "Create Repository"
- Configure:
  - **Repository Name**: `secure-crud-app`
  - **Description**: "Multi-container CRUD application"
  - **Visibility**: Public
- Click "Create"

#### 1.3 Generate Access Token
- Go to: Account Settings → Security
- Click "New Access Token"
- Enter:
  - **Token Description**: `github-actions`
  - **Permissions**: Read & Write
- Click "Generate"
- **⚠️ Copy the token immediately** (you won't see it again!)

**Expected Format**: `dckr_pat_xxxxxxxxxxxxxxxxxxxxxx`

---

### Phase 2: GitHub Secrets (3 minutes)

#### 2.1 Add DOCKER_USERNAME Secret
1. Go to: https://github.com/swetasharma-source/Crud_project
2. Click **Settings** tab
3. Left sidebar: **Secrets and variables** → **Actions**
4. Click **New repository secret**
5. Enter:
   - **Name**: `DOCKER_USERNAME`
   - **Secret**: `swetasharma`
6. Click **Add secret**

#### 2.2 Add DOCKER_PASSWORD Secret
1. Click **New repository secret** again
2. Enter:
   - **Name**: `DOCKER_PASSWORD`
   - **Secret**: Paste the token from Phase 1.3
3. Click **Add secret**

**Verification**: 
- Both secrets should appear in the "Repository secrets" list
- Values are hidden (shown as bullets)

---

### Phase 3: Verify GitHub Actions (2 minutes)

#### 3.1 Check Workflow File
The workflow file is already in your repository at `.github/workflows/ci-cd.yml`

It includes:
- ✅ Trigger on push to main branch
- ✅ Docker image build
- ✅ Image tagging (latest + commit SHA)
- ✅ Docker Hub push
- ✅ Container health tests

#### 3.2 Enable GitHub Actions (if needed)
1. Click **Actions** tab in your repository
2. If shown "Enable GitHub Actions", click it
3. (Usually already enabled)

---

## 🚀 Trigger Your First Build

### Option A: Simple Trigger (Recommended)

```bash
# Make a small change and push
cd c:\Users\HP\Crud_project
git pull origin main
echo "# Setup complete" >> SETUP_STATUS.md
git add SETUP_STATUS.md
git commit -m "trigger: GitHub Actions CI/CD pipeline"
git push origin main
```

### Option B: Manual Trigger
1. Go to GitHub Actions tab
2. Select "CI/CD Pipeline" workflow
3. Click "Run workflow"
4. Select "main" branch
5. Click "Run workflow"

---

## 📊 Monitor Your Build

### View Workflow Runs
- URL: https://github.com/swetasharma-source/Crud_project/actions
- You'll see:
  - Workflow name: "CI/CD Pipeline"
  - Status: Running/Success/Failed
  - Duration: Build time

### View Detailed Logs
1. Click on the workflow run
2. Click "build-and-push" job
3. Expand steps to see logs:
   - Checkout code
   - Setup Docker Buildx
   - Login to Docker Hub
   - Build and push image
   - Run tests

### Expected Output Example
```
✓ Checkout code
✓ Set up Docker Buildx
✓ Get commit SHA
✓ Login to Docker Hub
✓ Build and push Docker image
  - Pushed: swetasharma/secure-crud-app:latest
  - Pushed: swetasharma/secure-crud-app:abc1234
✓ Start services
✓ Wait for services
✓ Run health checks
✓ Cleanup
```

---

## ✅ Verify Docker Hub Integration

### Check Pushed Images
1. Go to: https://hub.docker.com/r/swetasharma/secure-crud-app
2. You should see:
   - **latest** tag (most recent)
   - **commit-sha** tags (versioned releases)
   - **Image size**: ~150MB
   - **Layers**: Build history

### Pull Image Locally
```bash
docker pull swetasharma/secure-crud-app:latest
docker run -p 5000:5000 swetasharma/secure-crud-app:latest
```

---

## 🔧 Troubleshooting

### Issue: "Secrets not found" error

**Solution:**
1. Verify secrets are added correctly:
   - Settings → Secrets and variables → Actions
   - Both DOCKER_USERNAME and DOCKER_PASSWORD present
2. Workflow uses correct secret names:
   - `${{ secrets.DOCKER_USERNAME }}`
   - `${{ secrets.DOCKER_PASSWORD }}`

### Issue: "Login to Docker Hub failed"

**Solution:**
1. Verify token is valid:
   - Docker Hub → Account Settings → Security
   - Check token status
2. Regenerate token if expired
3. Update GitHub secret with new token

### Issue: "Docker image push failed"

**Solution:**
1. Verify repository exists on Docker Hub
2. Check Docker username matches secret
3. Check image tags in workflow
4. View GitHub Actions logs for details

### Issue: "Services health check failed"

**Solution:**
1. Check test job logs
2. Verify containers started correctly
3. Check application logs: `docker-compose logs`
4. May need to increase wait time in workflow

---

## 📈 Continuous Integration Workflow

Once set up, your workflow is:

```
1. Local Development
   ↓
2. Commit & Push to GitHub (main branch)
   ↓
3. GitHub Actions Triggered Automatically
   ↓
4. Build Docker Image
   ↓
5. Push to Docker Hub
   ↓
6. Test Containers
   ↓
7. Success/Failure Notification
   ↓
8. Image Available for Deployment
```

---

## 🎯 Common Commands

### View Current Secrets
```bash
# Not recommended to view via CLI (security)
# Use GitHub web interface instead
```

### Rotate Credentials
```bash
# If you ever need to change credentials:
# 1. Generate new Docker Hub token
# 2. Update DOCKER_PASSWORD secret on GitHub
# 3. Next push will use new credentials
```

### Re-run Failed Workflow
```bash
# On GitHub Actions page:
# Click "Re-run failed jobs" or "Re-run all jobs"
# Or make another commit and push
```

---

## 📚 Reference

### Important URLs
- Docker Hub Profile: https://hub.docker.com/u/swetasharma
- Docker Hub Repository: https://hub.docker.com/r/swetasharma/secure-crud-app
- GitHub Repository: https://github.com/swetasharma-source/Crud_project
- GitHub Actions: https://github.com/swetasharma-source/Crud_project/actions

### Environment Variables Used in Workflow
- `DOCKER_USERNAME`: Your Docker Hub username
- `DOCKER_PASSWORD`: Your Docker Hub access token
- `GITHUB_SHA`: Commit SHA (auto-provided by GitHub)

### Docker Image Tags
- `swetasharma/secure-crud-app:latest` - Latest build
- `swetasharma/secure-crud-app:abc1234` - Specific commit

---

## ✨ Success Indicators

You know everything is set up correctly when:

✅ GitHub secrets are visible (DOCKER_USERNAME, DOCKER_PASSWORD)  
✅ Workflow file exists at `.github/workflows/ci-cd.yml`  
✅ First push to main triggers workflow automatically  
✅ Workflow completes successfully (all checks pass)  
✅ Images appear on Docker Hub with correct tags  
✅ Can pull images from Docker Hub with `docker pull`  

---

## 🚀 Next Steps

1. **Monitor your first build**: Actions tab
2. **Verify Docker Hub**: Check repository for new images
3. **Pull and test locally**: `docker pull swetasharma/secure-crud-app:latest`
4. **Set up webhooks** (optional): Deploy on push
5. **Create GitHub releases**: Tag stable versions

---

**Last Updated**: January 20, 2026  
**Status**: Ready for CI/CD Integration
