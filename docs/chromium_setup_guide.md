# Chromium Fork Setup Guide for Windows

## Prerequisites

### 1. System Requirements
- **OS**: Windows 10/11 (64-bit)
- **RAM**: 16GB+ recommended (8GB minimum)
- **Storage**: 100GB+ free space
- **CPU**: Multi-core processor (8+ cores recommended)

### 2. Required Software
- **Visual Studio 2022** (Community Edition or higher)
- **Git** (latest version)
- **Python 3.11+** (for build tools)
- **Node.js** (for some build tools)

## Step 1: Install Prerequisites

### Install Visual Studio 2022
1. Download Visual Studio 2022 Community from Microsoft
2. During installation, select:
   - Desktop development with C++
   - Windows 10/11 SDK (latest version)
   - CMake tools for C++
   - Git for Windows

### Install Git
```powershell
# Download and install Git from https://git-scm.com/
# Or use winget
winget install Git.Git
```

### Install Python
```powershell
# Download Python 3.11+ from python.org
# Or use winget
winget install Python.Python.3.11
```

### Install Node.js
```powershell
# Download from nodejs.org
# Or use winget
winget install OpenJS.NodeJS
```

## Step 2: Set Up Environment Variables

### Add to System PATH
- `C:\Program Files\Git\bin`
- `C:\Program Files\Python311`
- `C:\Program Files\Python311\Scripts`
- `C:\Program Files\nodejs`

### Set Environment Variables
```powershell
# Set in System Environment Variables
setx DEPOT_TOOLS_WIN_TOOLCHAIN 0
setx GYP_MSVS_VERSION 2022
setx GYP_MSVS_OVERRIDE_PATH "C:\Program Files\Microsoft Visual Studio\2022\Community"
```

## Step 3: Install Depot Tools

```powershell
# Navigate to C:\
cd C:\

# Create chromium directory
mkdir chromium
cd chromium

# Clone depot_tools
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

# Add depot_tools to PATH
setx PATH "%PATH%;C:\chromium\depot_tools"
```

## Step 4: Download Chromium Source

```powershell
# Navigate to chromium directory
cd C:\chromium

# Create src directory
mkdir src
cd src

# Configure git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Fetch Chromium source (this will take 1-2 hours)
fetch --nohooks chromium

# Install additional dependencies
gclient sync

# Run hooks
gclient runhooks
```

## Step 5: Build Configuration

```powershell
# Navigate to src directory
cd C:\chromium\src

# Generate build files
gn gen out/Default --args="is_debug=false is_component_build=false"

# Build Chromium (this will take 2-4 hours)
autoninja -C out/Default chrome
```

## Step 6: Verify Installation

```powershell
# Test the build
C:\chromium\src\out\Default\chrome.exe --version
```

## Troubleshooting

### Common Issues

1. **Out of Memory Error**
   - Close other applications
   - Increase virtual memory
   - Use `autoninja -C out/Default chrome -j 4` (limit parallel jobs)

2. **Git Authentication Issues**
   - Set up Git credentials
   - Use personal access token if needed

3. **Build Failures**
   - Ensure all prerequisites are installed
   - Check Visual Studio installation
   - Verify environment variables

4. **Network Issues**
   - Use VPN if needed
   - Check firewall settings
   - Ensure stable internet connection

### Performance Tips

1. **Use SSD Storage**: Chromium build is I/O intensive
2. **Close Other Applications**: Free up RAM and CPU
3. **Use Incremental Builds**: Only rebuild changed components
4. **Parallel Builds**: Use `-j` flag to control parallel jobs

## Next Steps

Once Chromium is successfully built, we can:
1. Create our custom fork branch
2. Implement tooltip functionality
3. Add AI integration
4. Set up development workflow

## File Structure After Setup

```
C:\chromium\
├── depot_tools\          # Build tools
├── src\                  # Chromium source code
│   ├── chrome\          # Chrome browser code
│   ├── content\         # Content layer
│   ├── ui\              # UI components
│   └── out\             # Build output
│       └── Default\     # Default build
└── our_fork\            # Our custom modifications
```

## Build Commands Reference

```powershell
# Clean build
gn clean out/Default
autoninja -C out/Default chrome

# Debug build
gn gen out/Debug --args="is_debug=true"
autoninja -C out/Debug chrome

# Release build
gn gen out/Release --args="is_debug=false is_component_build=false"
autoninja -C out/Release chrome

# Run Chrome
C:\chromium\src\out\Default\chrome.exe

# Update source
gclient sync
```

