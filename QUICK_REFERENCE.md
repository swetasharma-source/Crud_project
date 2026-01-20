# Docker Hub & GitHub Actions - Quick Reference Card

## 🎯 3-Step Setup (10-15 minutes)

### Step 1️⃣: Docker Hub (2 minutes)
```
1. https://hub.docker.com/signup
2. Create account
3. Settings → Security → New Access Token
   Name: github-actions
   Permissions: Read & Write
4. 📋 COPY TOKEN (won't show again!)
```

### Step 2️⃣: GitHub Secrets (3 minutes)
```
1. https://github.com/swetasharma-source/Crud_project/settings/secrets/actions
2. New Repository Secret:
   Name: DOCKER_USERNAME
   Value: swetasharma
3. New Repository Secret:
   Name: DOCKER_PASSWORD
   Value: <paste token from Step 1>
```

### Step 3️⃣: Test (2-5 minutes)
```
1. Push to main:
   git commit --allow-empty -m "Trigger: CI/CD"
   git push origin main

2. Monitor:
   https://github.com/swetasharma-source/Crud_project/actions

3. Verify on Docker Hub:
   https://hub.docker.com/r/swetasharma/secure-crud-app
```

---

## 📊 What Happens After Setup

```
You push code → GitHub Actions triggers → Docker image built
→ Logs into Docker Hub → Pushes image with tags → Tests run
→ Success/Failure notification → Image ready for deployment
```

---

## 🐳 Docker Hub URLs

- **Hub Home**: https://hub.docker.com
- **Your Profile**: https://hub.docker.com/u/swetasharma
- **Repository**: https://hub.docker.com/r/swetasharma/secure-crud-app
- **Settings**: https://hub.docker.com/settings/account

---

## 🔄 GitHub Actions URLs

- **Actions Dashboard**: https://github.com/swetasharma-source/Crud_project/actions
- **Settings/Secrets**: https://github.com/swetasharma-source/Crud_project/settings/secrets/actions
- **Workflow File**: .github/workflows/ci-cd.yml

---

## ✅ Success Indicators

- [ ] DOCKER_USERNAME secret visible in GitHub
- [ ] DOCKER_PASSWORD secret visible in GitHub
- [ ] Workflow runs automatically on push
- [ ] Images appear on Docker Hub
- [ ] Tags show: `latest` and commit SHA

---

## 🆘 Common Issues & Fixes

| Issue | Solution |
|-------|----------|
| "Secrets not found" | Verify Settings → Secrets, both present |
| "Login failed" | Check token not expired, regenerate if needed |
| "Build takes too long" | First build is slower, subsequent faster |
| "No images on Docker Hub" | Check Actions logs for push errors |

---

## 📚 Full Documentation

See: `DOCKER_HUB_GITHUB_ACTIONS_SETUP.md` in repository

---

**Status**: Ready to deploy! 🚀
