# GitHub Actions - How to View & Trigger

## ✅ Problem Fixed!

Your GitHub Actions weren't showing because the `.github/workflows/` folder was in `.gitignore`. This has been fixed and the workflow is now pushed to GitHub.

---

## 🎯 How to Access GitHub Actions

### View Actions Dashboard

**URL**: https://github.com/swetasharma-source/Crud_project/actions

**What you'll see:**
- Workflow runs history
- Status of each run (✓ Success, ✗ Failed, ⟳ Running)
- Timestamps
- Trigger reason (manual or push)

---

## 🚀 How to Trigger Workflows

### Method 1: Automatic Trigger (on Push)

```bash
# Make changes to your code
git add .
git commit -m "Your message"
git push origin main
```

**Result:** Workflow automatically starts in 10-30 seconds

### Method 2: Manual Trigger (Anytime)

1. Go to: https://github.com/swetasharma-source/Crud_project/actions
2. Click on **"CI/CD Pipeline"** workflow name
3. Click **"Run workflow"** dropdown
4. Click **"Run workflow"** button
5. Select **"main"** branch
6. Click **"Run workflow"**

**Result:** Workflow starts immediately

### Method 3: Quick Empty Commit

```bash
git commit --allow-empty -m "Trigger: GitHub Actions"
git push origin main
```

**Result:** Triggers workflow instantly

---

## 📊 Workflow Jobs

Your workflow has 2 jobs:

### Job 1: build-and-push
- Checks out code
- Sets up Docker
- Gets commit SHA
- Logs into Docker Hub (if secrets configured)
- Builds and pushes Docker image
- **Duration**: 2-5 minutes

### Job 2: test
- Depends on: build-and-push
- Starts containers
- Waits for services
- Runs health checks
- Checks logs
- Cleans up
- **Duration**: 1-2 minutes

---

## 📝 What the Logs Show

Click on any job to see detailed logs:

```
✓ Checkout code
✓ Set up Docker Buildx
✓ Get commit SHA
✓ Login to Docker Hub (if secrets exist)
✓ Build and push Docker image
✓ Start services
✓ Wait for services
✓ Run health checks
✓ Cleanup
```

---

## 🔍 Troubleshooting

### "Build-and-push job appears grayed out"
This is normal if Docker Hub secrets aren't configured. The workflow will still run the test job.

### "Test job failed"
- Check logs for specific error
- Usually a timing issue - services need more time to start
- Try increasing sleep time in workflow

### "No 'Run workflow' button visible"
- Go to the workflow file page
- Refresh browser
- Try different browser
- Button appears after first run

---

## 📚 Current Workflow File

Location: `.github/workflows/ci-cd.yml`

Features:
- ✅ Triggers on: push to main, pull requests, manual trigger
- ✅ Handles missing Docker Hub secrets gracefully
- ✅ Verbose logging for debugging
- ✅ Health checks for containers
- ✅ Latest action versions

---

## ✨ Next Steps

1. **Test the workflow manually**:
   - Go to Actions tab
   - Run workflow
   - Watch it execute

2. **Configure Docker Hub secrets** (optional but recommended):
   - Settings → Secrets → Add DOCKER_USERNAME and DOCKER_PASSWORD
   - Next run will push to Docker Hub

3. **Monitor builds**:
   - Each push triggers workflow
   - View status in Actions tab
   - Check logs for details

---

**Status**: ✅ GitHub Actions now visible and ready to use!
