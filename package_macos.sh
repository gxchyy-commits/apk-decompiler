#!/bin/bash

# APK Decompiler - Complete macOS Build and Package Script
# This script builds a standalone executable and creates distribution packages

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_OUTPUT_DIR="${SCRIPT_DIR}/build_output"
DIST_DIR="${BUILD_OUTPUT_DIR}/dist"
VERSION=$(date +%Y%m%d_%H%M%S)
APP_NAME="apk-decompiler"

# Functions
print_header() {
    echo -e "\n${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

check_requirements() {
    print_header "STEP 1: Checking Requirements"
    
    # Check Python
    if ! command -v python3 &> /dev/null; then
        print_error "Python 3 not found"
        echo "Please install Python 3 from: https://www.python.org/downloads/macos/"
        exit 1
    fi
    
    PYTHON_VERSION=$(python3 --version)
    print_success "Found: $PYTHON_VERSION"
    
    # Check pip
    if ! command -v pip3 &> /dev/null; then
        print_error "pip3 not found"
        exit 1
    fi
    
    print_success "pip3 is available"
    
    # Check if in correct directory
    if [ ! -f "$SCRIPT_DIR/apk_decompiler.py" ]; then
        print_error "apk_decompiler.py not found in $SCRIPT_DIR"
        exit 1
    fi
    
    print_success "All requirements satisfied"
}

install_dependencies() {
    print_header "STEP 2: Installing Dependencies"
    
    print_info "Installing runtime dependencies..."
    pip3 install -q -r "$SCRIPT_DIR/requirements.txt"
    print_success "Runtime dependencies installed"
    
    print_info "Installing build tools..."
    pip3 install -q PyInstaller==6.1.0
    print_success "Build tools installed"
}

clean_build() {
    print_header "STEP 3: Cleaning Previous Builds"
    
    if [ -d "$BUILD_OUTPUT_DIR" ]; then
        rm -rf "$BUILD_OUTPUT_DIR"
        print_success "Cleaned old build artifacts"
    fi
    
    # Clean local build artifacts
    rm -rf "$SCRIPT_DIR/build" "$SCRIPT_DIR/dist" "$SCRIPT_DIR"/*.spec
    print_success "Cleaned local artifacts"
    
    # Create directories
    mkdir -p "$DIST_DIR"
    print_success "Created output directories"
}

build_executable() {
    print_header "STEP 4: Building macOS Executable"
    
    print_info "Running PyInstaller..."
    
    cd "$SCRIPT_DIR"
    
    pyinstaller \
        --onefile \
        --windowed \
        --name "$APP_NAME" \
        --osx-bundle-identifier "com.apkdecompiler.app" \
        --icon=None \
        --distpath "$DIST_DIR" \
        --buildpath "$BUILD_OUTPUT_DIR/build" \
        --specpath "$BUILD_OUTPUT_DIR" \
        --hidden-import=androguard \
        --hidden-import=androguard.core \
        --hidden-import=androguard.core.dex \
        --hidden-import=androguard.core.apk \
        --hidden-import=androguard.decompiler \
        --hidden-import=androguard.decompiler.decompiler \
        --hidden-import=colorama \
        --hidden-import=tqdm \
        --hidden-import=pycparser \
        --collect-all androguard \
        apk_decompiler.py 2>&1 | grep -v "WARNING" || true
    
    if [ -f "$DIST_DIR/$APP_NAME" ]; then
        chmod +x "$DIST_DIR/$APP_NAME"
        print_success "Executable created: $DIST_DIR/$APP_NAME"
    else
        print_error "Failed to create executable"
        exit 1
    fi
}

verify_executable() {
    print_header "STEP 5: Verifying Executable"
    
    if ! "$DIST_DIR/$APP_NAME" -h > /dev/null 2>&1; then
        print_error "Executable test failed"
        exit 1
    fi
    
    print_success "Executable verified and working"
    
    # Get file size
    SIZE=$(du -sh "$DIST_DIR/$APP_NAME" | cut -f1)
    print_info "Executable size: $SIZE"
}

create_wrapper_script() {
    print_header "STEP 6: Creating Convenience Wrapper"
    
    WRAPPER="$DIST_DIR/apk-decompiler"
    
    cat > "$WRAPPER" << 'EOF'
#!/bin/bash
# APK Decompiler Wrapper Script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXECUTABLE="${SCRIPT_DIR}/apk-decompiler-bin"

if [ ! -f "$EXECUTABLE" ]; then
    EXECUTABLE="${SCRIPT_DIR}/apk-decompiler"
fi

exec "$EXECUTABLE" "$@"
EOF
    
    chmod +x "$WRAPPER"
    print_success "Wrapper script created"
}

create_readme() {
    print_header "STEP 7: Creating Documentation"
    
    README="$DIST_DIR/README.txt"
    
    cat > "$README" << 'EOF'
╔════════════════════════════════════════════════════════════╗
║           APK Decompiler for macOS - Executable            ║
║                                                            ║
║  A comprehensive tool for extracting and decompiling      ║
║  all contents of Android APK files                         ║
╚════════════════════════════════════════════════════════════╝

QUICK START
───────────────────────────────────────────────────────────

1. Make executable (if needed):
   chmod +x apk-decompiler

2. Run decompiler:
   ./apk-decompiler your_app.apk

3. Check output:
   ls -la decompiled_your_app_*/

USAGE EXAMPLES
───────────────────────────────────────────────────────────

Basic usage:
  ./apk-decompiler app.apk

Custom output directory:
  ./apk-decompiler app.apk -o ~/my_output

Verbose mode (detailed logs):
  ./apk-decompiler app.apk -v

Show help:
  ./apk-decompiler -h

INSTALLATION OPTIONS
───────────────────────────────────────────────────────────

Option 1 - Run from current directory:
  chmod +x apk-decompiler
  ./apk-decompiler your_app.apk

Option 2 - Move to Applications folder:
  cp apk-decompiler /Applications/
  # Now run from anywhere: /Applications/apk-decompiler app.apk

Option 3 - Add to PATH:
  cp apk-decompiler /usr/local/bin/
  # Now run globally: apk-decompiler app.apk

OUTPUT
──────────────���────────────────────────────────────────────

The decompiler creates a directory with:
  - java_source/      → Decompiled Java code
  - manifest/         → AndroidManifest.xml + metadata
  - resources/        → All app resources (images, strings, etc)
  - dex/              → Raw DEX files
  - analysis/         → Class structure reports
  - raw_apk/          → Complete extracted APK
  - SUMMARY.json      → Decompilation summary

SYSTEM REQUIREMENTS
───────────────────────────────────────────────────────────

- macOS 10.13 or later
- Intel or Apple Silicon (M1/M2/M3)
- 2GB+ RAM (4GB+ recommended for large APKs)
- 500MB+ free disk space

FEATURES
───────────────────────────────────────────────────────────

✓ Full APK decompilation
✓ DEX to Java source conversion
✓ AndroidManifest.xml extraction
✓ Resource extraction (images, layouts, strings, native libs)
✓ Multi-DEX support
✓ Code analysis and reporting
✓ Comprehensive error handling

TROUBLESHOOTING
───────────────────────────────────────────────────────────

Error: "Permission denied"
  Solution: chmod +x apk-decompiler

Error: "File is not a valid APK"
  Solution: Ensure the file has .apk extension and is valid

Error: "Decompilation failed"
  Solution: Try with -v flag for detailed error messages

Large APKs are slow:
  This is normal. Large apps can take 1-5 minutes.

MORE HELP
───────────────────────────────────────────────────────────

Run with -h flag:
  ./apk-decompiler -h

View documentation:
  - Check SUMMARY.json in the output folder
  - Visit: https://github.com/gxchyy-commits/apk-decompiler

LICENSE
───────────────────────────────────────────────────────────

MIT License - Free for personal and educational use
For commercial use, see LICENSE file

═══════════════════════════════════════════════════════════

Happy decompiling! 🎉
EOF
    
    print_success "README created: $README"
}

create_installer_script() {
    print_header "STEP 8: Creating Installation Script"
    
    INSTALLER="$BUILD_OUTPUT_DIR/install.sh"
    
    cat > "$INSTALLER" << 'EOF'
#!/bin/bash

# APK Decompiler Installation Script

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

echo -e "\n${YELLOW}════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}  APK Decompiler - macOS Installation${NC}"
echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}\n"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXECUTABLE="$SCRIPT_DIR/dist/apk-decompiler"

if [ ! -f "$EXECUTABLE" ]; then
    print_error "Executable not found at $EXECUTABLE"
    exit 1
fi

# Make executable
chmod +x "$EXECUTABLE"
print_success "Made executable"

# Installation options
echo -e "\n${YELLOW}Select installation option:${NC}"
echo "1) Run from current directory (no installation)"
echo "2) Copy to /Applications/ (global access)"
echo "3) Add to /usr/local/bin (global command)"
echo "4) Exit"

read -p "Enter choice (1-4): " choice

case $choice in
    1)
        print_info "Executable ready to use:"
        echo "  $EXECUTABLE your_app.apk"
        ;;
    2)
        cp "$EXECUTABLE" /Applications/apk-decompiler
        chmod +x /Applications/apk-decompiler
        print_success "Installed to /Applications/apk-decompiler"
        echo "  Run: /Applications/apk-decompiler your_app.apk"
        ;;
    3)
        sudo cp "$EXECUTABLE" /usr/local/bin/apk-decompiler
        sudo chmod +x /usr/local/bin/apk-decompiler
        print_success "Installed to /usr/local/bin/apk-decompiler"
        echo "  Run: apk-decompiler your_app.apk"
        ;;
    4)
        print_info "Aborted"
        exit 0
        ;;
    *)
        print_error "Invalid choice"
        exit 1
        ;;
esac

echo ""
EOF
    
    chmod +x "$INSTALLER"
    print_success "Installation script created: $INSTALLER"
}

create_distributions() {
    print_header "STEP 9: Creating Distribution Packages"
    
    cd "$BUILD_OUTPUT_DIR"
    
    # Create ZIP
    print_info "Creating ZIP archive..."
    ZIPFILE="apk-decompiler-macos-${VERSION}.zip"
    zip -q -r "$ZIPFILE" dist/ README.txt install.sh
    
    if [ -f "$ZIPFILE" ]; then
        SIZE=$(du -sh "$ZIPFILE" | cut -f1)
        print_success "ZIP created: $ZIPFILE ($SIZE)"
    fi
    
    # Create TAR.GZ
    print_info "Creating TAR.GZ archive..."
    TARGZFILE="apk-decompiler-macos-${VERSION}.tar.gz"
    tar -czf "$TARGZFILE" -C "$BUILD_OUTPUT_DIR" dist/ README.txt install.sh 2>/dev/null
    
    if [ -f "$TARGZFILE" ]; then
        SIZE=$(du -sh "$TARGZFILE" | cut -f1)
        print_success "TAR.GZ created: $TARGZFILE ($SIZE)"
    fi
}

create_summary() {
    print_header "STEP 10: Creating Summary Report"
    
    SUMMARY="$BUILD_OUTPUT_DIR/BUILD_SUMMARY.txt"
    
    cat > "$SUMMARY" << EOF
╔════════════════════════════════════════════════════════════╗
║         APK DECOMPILER - BUILD COMPLETE ✓                  ║
╚════════════════════════════════════════════════════════════╝

Build Information
─────────────────────────────────────────────────────────────
Build Date: $(date)
Build Version: $VERSION
Build Directory: $BUILD_OUTPUT_DIR

Output Files
─────────────────────────────────────────────────────────────
1. Executable: dist/apk-decompiler
2. Documentation: dist/README.txt
3. Installation Script: install.sh
4. Distribution ZIP: apk-decompiler-macos-${VERSION}.zip
5. Distribution TAR.GZ: apk-decompiler-macos-${VERSION}.tar.gz

Quick Start
─────────────────────────────────────────────────────────────

Option 1 - Use immediately (no installation):
  chmod +x dist/apk-decompiler
  ./dist/apk-decompiler your_app.apk

Option 2 - Run installation script:
  chmod +x install.sh
  ./install.sh

Option 3 - Manual installation:
  # Copy to Applications
  cp dist/apk-decompiler /Applications/apk-decompiler
  chmod +x /Applications/apk-decompiler

  # Or add to PATH
  cp dist/apk-decompiler /usr/local/bin/
  chmod +x /usr/local/bin/apk-decompiler

Distribution
─────────────────────────────────────────────────────────────

To share with others:
  1. Send the ZIP file: apk-decompiler-macos-${VERSION}.zip
  2. Recipient extracts it and runs: ./install.sh
  3. Or manually copies the executable to their system

System Requirements
─────────────────────────────────────────────────────────────
- macOS 10.13 or later
- Intel or Apple Silicon (M1/M2/M3)
- 2GB+ RAM (4GB+ recommended)
- 500MB+ free disk space

Features
─────────────────────────────────────────────────────────────
✓ Full APK decompilation
✓ DEX to Java source conversion
✓ AndroidManifest.xml extraction
✓ Resource extraction
✓ Multi-DEX support
✓ Code analysis and reporting
✓ Standalone - no Python needed!

Support
─────────────────────────────────────────────────────────────
- GitHub: https://github.com/gxchyy-commits/apk-decompiler
- Documentation: See dist/README.txt

═══════════════════════════════════════════════════════════
EOF
    
    print_success "Summary report created: $SUMMARY"
}

print_final_summary() {
    print_header "BUILD COMPLETE! ✅"
    
    echo -e "${GREEN}All files ready in: ${BUILD_OUTPUT_DIR}${NC}\n"
    
    echo "📦 Distribution Packages:"
    echo "  • apk-decompiler-macos-${VERSION}.zip"
    echo "  • apk-decompiler-macos-${VERSION}.tar.gz"
    echo ""
    
    echo "📍 Executable Location:"
    echo "  • dist/apk-decompiler"
    echo ""
    
    echo "🚀 Quick Start:"
    echo "  chmod +x $DIST_DIR/$APP_NAME"
    echo "  $DIST_DIR/$APP_NAME your_app.apk"
    echo ""
    
    echo "📖 For Installation Options:"
    echo "  chmod +x $BUILD_OUTPUT_DIR/install.sh"
    echo "  $BUILD_OUTPUT_DIR/install.sh"
    echo ""
    
    echo "📊 File Information:"
    ls -lh "$DIST_DIR/$APP_NAME" 2>/dev/null | awk '{print "  Executable: " $9 " (" $5 ")"}'
    echo ""
    
    echo "═══════════════════════════════════════════════════════════"
}

# Main execution
main() {
    check_requirements
    install_dependencies
    clean_build
    build_executable
    verify_executable
    create_wrapper_script
    create_readme
    create_installer_script
    create_distributions
    create_summary
    print_final_summary
}

# Run main function
main
