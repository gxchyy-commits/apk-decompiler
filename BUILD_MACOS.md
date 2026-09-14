# Building macOS Executable

This guide explains how to build a standalone macOS executable for the APK Decompiler.

## What is Included

The macOS executable is a self-contained application that requires NO Python installation on the user's system. Just download, run, and decompile!

## Building on macOS

### Prerequisites

- macOS 10.13 or later
- Python 3.7+ (download from python.org or use Homebrew)
- Command line tools (Xcode)

### Quick Build

```bash
# Navigate to repository
cd apk-decompiler

# Make the build script executable
chmod +x build_macos.sh

# Run the build script
./build_macos.sh
```

The script will:
1. ✓ Check Python installation
2. ✓ Install all dependencies
3. ✓ Install PyInstaller
4. ✓ Build the macOS executable
5. ✓ Create `dist/apk-decompiler` executable

### Build Time

- First build: 3-5 minutes (installs dependencies)
- Subsequent builds: 1-2 minutes

## Using the Built Executable

### Option 1: Run from current directory

```bash
chmod +x dist/apk-decompiler
./dist/apk-decompiler your_app.apk
```

### Option 2: Move to Applications folder

```bash
# Copy to Applications (optional)
cp dist/apk-decompiler /Applications/apk-decompiler

# Now you can run from anywhere
apk-decompiler your_app.apk
```

### Option 3: Add to PATH

```bash
# Move to a directory in your PATH
cp dist/apk-decompiler /usr/local/bin/apk-decompiler

# Verify installation
which apk-decompiler

# Now use globally
apk-decompiler app.apk -o ~/decompiled
```

## Full Usage

```bash
# Basic decompilation
./dist/apk-decompiler app.apk

# Custom output directory
./dist/apk-decompiler app.apk -o ~/my_decompiled_app

# Verbose mode
./dist/apk-decompiler app.apk -v

# Show help
./dist/apk-decompiler -h
```

## Creating a Launcher Script

Create a convenient launcher script at `~/.local/bin/apk-decompiler`:

```bash
#!/bin/bash
/Applications/apk-decompiler "$@"
```

Then:
```bash
chmod +x ~/.local/bin/apk-decompiler
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Now run from anywhere:
```bash
apk-decompiler any_file.apk
```

## Distributing the Executable

### Package as ZIP

```bash
cd dist
zip -r apk-decompiler-macos.zip apk-decompiler
```

Then share `apk-decompiler-macos.zip` with others.

### For Apple Silicon (M1/M2/M3) Macs

The build script automatically detects your architecture. If you need to build for a specific architecture:

```bash
# Force x86-64 build (Intel)
arch -x86_64 ./build_macos.sh

# Force ARM64 build (Apple Silicon)
arch -arm64 ./build_macos.sh
```

### Universal Binary (Intel + Apple Silicon)

To create a universal binary that works on all Macs:

```bash
# Requires building on both architectures or using GitHub Actions
# See CI/CD documentation for automated universal builds
```

## Troubleshooting

### Error: "command not found: python3"

Install Python 3 from https://www.python.org/downloads/macos/ or use Homebrew:

```bash
brew install python3
```

### Error: "PyInstaller not found"

Install build requirements:

```bash
pip3 install -r requirements-build.txt
```

### Error: "Permission denied" when running executable

Make sure the executable has execute permissions:

```bash
chmod +x dist/apk-decompiler
```

### App launches but closes immediately

Run from terminal to see error messages:

```bash
./dist/apk-decompiler app.apk
```

### "File not found" error for APK

Use absolute path:

```bash
./dist/apk-decompiler /full/path/to/your/app.apk
```

Or ensure APK is in current directory:

```bash
ls -la app.apk
./dist/apk-decompiler app.apk
```

## Verifying the Build

After building, verify the executable works:

```bash
# Show help
./dist/apk-decompiler -h

# Check version (if implemented)
./dist/apk-decompiler --version

# Test with sample APK (if available)
./dist/apk-decompiler test.apk -o test_output
```

## Advanced Options

### Building with Custom Icon

```bash
# Replace with your icon
cp your_icon.icns resources/
./build_macos.sh
```

### Building Single Archive

The default `-o/--onefile` creates a self-extracting executable. To build unpacked:

Edit `build_macos.sh` and remove `--onefile` flag.

### Code Signing (for distribution)

```bash
# Sign the executable
codesign -s - dist/apk-decompiler

# Verify signature
codesign -v dist/apk-decompiler
```

## Performance Notes

- First execution extracts cached libraries (~1 second)
- Subsequent executions are faster
- Large APKs (>500MB) may require more RAM

## System Requirements

- **OS**: macOS 10.13+
- **RAM**: Minimum 2GB (4GB recommended for large APKs)
- **Disk**: 500MB free (for app + extracted APKs)
- **Architecture**: Intel (x86-64) or Apple Silicon (ARM64)

## Creating DMG Installer (Optional)

```bash
# Create DMG for distribution
hdiutil create -volname "APK Decompiler" \
    -srcfolder dist/apk-decompiler \
    -ov -format UDZO \
    apk-decompiler-installer.dmg
```

## Troubleshooting Build Issues

### Issue: "code signature invalid"

```bash
# Re-sign after building
codesign --deep -s - dist/apk-decompiler
```

### Issue: "dyld: Library not loaded"

This shouldn't happen with PyInstaller's bundling. If it does:

1. Delete dist/ and build/
2. Rebuild: `./build_macos.sh`
3. File an issue with the error message

## Cleanup

To remove build artifacts:

```bash
rm -rf build dist *.spec
```

## Next Steps

1. ✓ Build the executable: `./build_macos.sh`
2. ✓ Test it works: `./dist/apk-decompiler -h`
3. ✓ Move to Applications or PATH
4. ✓ Start decompiling!

---

**Happy Building!** 🎉 Your macOS executable is ready to use!
