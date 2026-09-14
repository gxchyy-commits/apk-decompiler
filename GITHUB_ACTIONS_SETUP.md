# GitHub Actions Setup Instructions

## Overview

This document explains how to set up GitHub Actions to automatically build the macOS executable for the APK Decompiler.

## What is GitHub Actions?

GitHub Actions is a CI/CD platform that runs on GitHub's servers. It can automatically:
- Build your code
- Run tests
- Create executables
- Publish releases

## Setting Up Automatic Builds

### Step 1: Create the Workflows Directory

GitHub Actions workflows must be placed in `.github/workflows/` directory.

### Step 2: Add the Build Workflow

Copy the workflow file to the correct location:

```bash
mkdir -p .github/workflows
cp build_macos_workflow.yml .github/workflows/build-macos.yml
```

### Step 3: Commit and Push

```bash
git add .github/workflows/build-macos.yml
git commit -m "Add GitHub Actions workflow for macOS builds"
git push origin main
```

### Step 4: Watch the Build

1. Go to your GitHub repository: https://github.com/gxchyy-commits/apk-decompiler
2. Click on the **Actions** tab
3. You should see the workflow running
4. Wait for it to complete (usually 5-10 minutes)

## Workflow Triggers

The workflow builds automatically on:

- **Push to main branch** - Every time you push code
- **Push to develop branch** - For development versions
- **Push git tags** - When you create a release tag (v1.0, v1.1, etc.)
- **Pull requests to main** - For validating PRs
- **Manual trigger** - Click "Run workflow" in Actions tab

## How to Use

### Automatic Build on Push

Every time you push to the main branch, the workflow runs automatically:

```bash
git add .
git commit -m "Your changes"
git push origin main
```

Then:
1. Go to Actions tab
2. Watch the build progress
3. Download the executable when complete

### Manual Build Trigger

To build manually without pushing code:

1. Go to **Actions** tab
2. Click **Build macOS Executable** on the left
3. Click **Run workflow** button
4. Select the branch
5. Click green **Run workflow** button

### Create a Release

To create an official release with the executable:

```bash
# Create a git tag
git tag v1.0.0
git push origin v1.0.0
```

This will:
1. Build the executable
2. Create a GitHub Release
3. Upload all files to the release

## Downloading the Executable

### Method 1: From Artifacts (Any Build)

1. Go to **Actions** tab
2. Click the workflow run you want
3. Scroll down to **Artifacts** section
4. Download **apk-decompiler-macos-executable**
5. Extract and use: `chmod +x apk-decompiler && ./apk-decompiler app.apk`

### Method 2: From Releases (Tagged Builds)

1. Go to **Releases** section (right sidebar)
2. Find your release (e.g., v1.0.0)
3. Download the executable or ZIP file
4. Extract and use

### Method 3: From Latest Workflow

```bash
# Download using GitHub CLI (if installed)
gh run list
gh run download <run-id> -n apk-decompiler-macos-executable
```

## File Outputs

After each successful build, you get:

- **apk-decompiler** - Standalone executable
- **apk-decompiler-macos-YYYYMMDD.zip** - ZIP package
- **apk-decompiler-macos-YYYYMMDD.tar.gz** - TAR.GZ package
- **RELEASE_NOTES.md** - Usage instructions

## Troubleshooting

### Build Failed

Check the **Actions** tab:
1. Click the failed workflow run
2. Click the **build** job
3. Expand the failing step
4. Read the error message
5. Fix and push again

Common issues:
- **Dependencies not installed** - Check requirements.txt
- **Python version issues** - Workflow uses Python 3.11
- **Permission errors** - Check file permissions

### Can't Find Artifacts

1. Verify the workflow completed successfully (green checkmark)
2. Scroll down to "Artifacts" section
3. Download within 90 days (after that, artifacts are deleted)

### Executable Won't Run

After downloading:
```bash
chmod +x apk-decompiler
./apk-decompiler -h
```

If still failing:
1. Verify it's for macOS (x86-64 or ARM64)
2. Check macOS version (10.13+)
3. Try running from terminal to see error message

## Customizing the Workflow

To modify the build process:

1. Edit `.github/workflows/build-macos.yml`
2. Common changes:
   - Python version (line 11)
   - Retention period for artifacts (line 90)
   - Additional build flags (line 27-40)
3. Commit and push
4. Next build uses new configuration

## Advanced: Add More Platforms

To also build for Windows and Linux:

Create `.github/workflows/build-windows.yml` and `.github/workflows/build-linux.yml` following the same pattern.

## Using GitHub CLI (Optional)

For command-line management:

```bash
# Install GitHub CLI from https://cli.github.com

# Login
gh auth login

# List workflow runs
gh run list --repo gxchyy-commits/apk-decompiler

# Download artifact
gh run download <run-id> --repo gxchyy-commits/apk-decompiler

# View workflow file
gh workflow view build-macos.yml --repo gxchyy-commits/apk-decompiler
```

## Continuous Delivery

To automatically release builds:

1. Set up branch protection rules
2. Merge PRs to main triggers build
3. Tag with version numbers
4. Workflow creates release automatically
5. Users download from Releases page

## Next Steps

1. **Set up the workflow:**
   ```bash
   mkdir -p .github/workflows
   cp build_macos_workflow.yml .github/workflows/build-macos.yml
   git add .github/workflows/
   git commit -m "Add GitHub Actions workflow"
   git push origin main
   ```

2. **Watch it build:**
   - Go to Actions tab
   - Wait for build to complete
   - Download the executable

3. **Use it:**
   ```bash
   chmod +x apk-decompiler
   ./apk-decompiler your_app.apk
   ```

That's it! No more manual building needed. GitHub builds it for you! 🚀

---

**Questions?** Check the [GitHub Actions Documentation](https://docs.github.com/en/actions)
