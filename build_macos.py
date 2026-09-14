#!/usr/bin/env python3
"""
PyInstaller build script for creating a macOS executable
Run: pyinstaller build_macos.spec
"""

import PyInstaller.__main__
import os
import sys

# Get the directory of this script
script_dir = os.path.dirname(os.path.abspath(__file__))

# PyInstaller spec for creating macOS app bundle
spec_content = """# -*- mode: python ; coding: utf-8 -*-

block_cipher = None

a = Analysis(
    ['apk_decompiler.py'],
    pathex=[],
    binaries=[],
    datas=[],
    hiddenimports=[
        'androguard',
        'androguard.core',
        'androguard.core.dex',
        'androguard.core.apk',
        'androguard.decompiler',
        'androguard.decompiler.decompiler',
        'colorama',
        'tqdm',
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludedimports=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='apk-decompiler',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)

app = BUNDLE(
    exe,
    name='APK-Decompiler.app',
    icon=None,
    bundle_identifier='com.apkdecompiler.app',
    info_plist={
        'NSPrincipalClass': 'NSApplication',
        'NSHighResolutionCapable': 'True',
    },
)
"""

if __name__ == '__main__':
    # Change to script directory
    os.chdir(script_dir)
    
    # Write spec file
    spec_file = 'apk_decompiler.spec'
    with open(spec_file, 'w') as f:
        f.write(spec_content)
    
    print("Building macOS executable...")
    print("This may take a few minutes...\n")
    
    # Run PyInstaller
    PyInstaller.__main__.run([
        spec_file,
        '--onefile',
        '--windowed',
        '--osx-bundle-identifier=com.apkdecompiler.app',
    ])
    
    print("\n✓ Build complete!")
    print(f"✓ Executable location: dist/APK-Decompiler.app")
