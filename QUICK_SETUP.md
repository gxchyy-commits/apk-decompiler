# ⚡ AUTOMATED BUILD SETUP - QUICK GUIDE

## What You Need to Do

Follow these 3 simple steps to enable automatic macOS executable builds:

---

## Step 1: Create the Workflows Directory

In your repository, create the GitHub Actions directory structure:

```bash
mkdir -p .github/workflows
```

---

## Step 2: Move the Workflow File

Move the workflow file to the correct location:

```bash
# From the repository root:
cp build_macos_workflow.yml .github/workflows/build-macos.yml
```

**Or manually:**
1. Create file: `.github/workflows/build-macos.yml`
2. Copy contents from: `build_macos_workflow.yml`
3. Paste into the new file

---

## Step 3: Commit and Push

```bash
git add .github/workflows/build-macos.yml
git commit -m "Enable automated macOS builds with GitHub Actions"
git push origin main
```

---

## 🚀 That's It! Now What?

### The Workflow Will Automatically:

✅ **Build on every push to main branch**
- Builds a standalone macOS executable
- Takes 5-10 minutes
- Uploads to Artifacts

✅ **Create releases** when you tag versions
```bash
git tag v1.0.0
git push origin v1.0.0
```

✅ **Allow manual builds** from GitHub UI
- Go to Actions tab
- Click "Run workflow"

---

## 📥 How to Get Your Executable

### Option 1: From Latest Build (Easiest)

1. Go to your repository: https://github.com/gxchyy-commits/apk-decompiler
2. Click **Actions** tab
3. Click the latest **Build macOS Executable** workflow
4. Scroll down to **Artifacts**
5. Download **apk-decompiler-macos-executable**
6. Extract and use:
   ```bash
   chmod +x apk-decompiler
   ./apk-decompiler your_app.apk
   ```

### Option 2: From Releases (Most Professional)

Create a release tag:
```bash
git tag v1.0.0
git push origin v1.0.0
```

Then:
1. Go to **Releases** on GitHub
2. Download the executable from the release
3. Use it immediately

---

## 📊 What Gets Built

After each successful build, you'll have:

```
Artifacts:
├── apk-decompiler-macos-executable     ← Your executable! 🎯
├── apk-decompiler-macos-zip            ← ZIP package
└── apk-decompiler-macos-targz          ← TAR.GZ package
```

---

## ⏱️ Build Timeline

| Step | Duration |
|------|----------|
| Checkout | 10 sec |
| Setup Python | 20 sec |
| Install Dependencies | 60-90 sec |
| Build Executable | 120-180 sec |
| Upload Artifacts | 30 sec |
| **Total** | **5-10 min** |

---

## 🎯 Usage After Getting Executable

```bash
# Basic usage
chmod +x apk-decompiler
./apk-decompiler your_app.apk

# Custom output
./apk-decompiler app.apk -o ~/my_decompiled_apps

# Verbose mode
./apk-decompiler app.apk -v

# Show help
./apk-decompiler -h
```

---

## ✨ Example Workflow

```bash
# 1. Make changes to code
vim apk_decompiler.py

# 2. Commit and push
git add apk_decompiler.py
git commit -m "Improved decompilation speed"
git push origin main

# 3. GitHub automatically builds

# 4. Download executable from Actions → Artifacts

# 5. Use it!
chmod +x apk-decompiler
./apk-decompiler app.apk
```

---

## 🐛 Troubleshooting

### Can't see Actions tab?

- Make sure `.github/workflows/build-macos.yml` is in the repository
- Refresh the page
- Wait a minute for GitHub to register the workflow

### Build is failing?

1. Click the failed workflow in Actions
2. Click the **build** job
3. Expand the failing step
4. Read the error message
5. Fix and push again

### Artifacts disappeared?

- Artifacts are kept for 90 days
- Create a Release (with git tags) for permanent storage

---

## 📝 Complete Setup Command

Copy and paste this entire command to set up everything:

```bash
# Create directory structure
mkdir -p .github/workflows

# Copy workflow file
cp build_macos_workflow.yml .github/workflows/build-macos.yml

# Commit and push
git add .github/workflows/build-macos.yml
git commit -m "Enable automated macOS builds with GitHub Actions"
git push origin main

echo "✅ Setup complete! Check Actions tab in 1-2 minutes"
```

---

## 🎉 Done!

Your repository is now set up for **automatic executable building**!

**No more manual building needed.** Just:
1. Push code → GitHub builds automatically
2. Download from Artifacts
3. Use immediately!

### Next Steps:

1. **Set up the workflow** (follow 3 steps above)
2. **Watch it build** (Actions tab)
3. **Download the executable** (when ready)
4. **Start decompiling!** 🚀

---

**Questions?** Check:
- GitHub Actions docs: https://docs.github.com/en/actions
- Build workflow file: `build_macos_workflow.yml`
- Setup guide: `GITHUB_ACTIONS_SETUP.md`
