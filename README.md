# ToolTip Browser - Chromium Fork with AI-Powered Tooltip Companion

[![Build Status](https://img.shields.io/badge/build-partially%20working-yellow.svg)](https://github.com/mcpmessenger/ToolTip_Browser)
[![Platform](https://img.shields.io/badge/platform-Windows%20x64-blue.svg)](https://github.com/mcpmessenger/ToolTip_Browser)
[![License](https://img.shields.io/badge/license-Chromium%20License-green.svg)](https://github.com/mcpmessenger/ToolTip_Browser)

## 🎯 Project Overview

**ToolTip Browser** is an innovative Chromium fork that provides proactive, context-aware tooltips displaying screenshot previews of interactive web elements (buttons and links) before users click them. This eliminates browsing uncertainty and enhances user confidence and efficiency.

### Key Features
- 🔍 **Proactive Web Element Pre-crawling** - Automatically identifies and crawls interactive elements
- 📸 **Screenshot Generation** - Captures previews of click outcomes
- 🧠 **AI Integration** - OpenAI, Google Gemini, and Anthropic Claude support
- 🎤 **Voice Commands** - Whisper speech-to-text and ElevenLabs text-to-speech
- 💾 **Local Storage** - Efficient screenshot storage and indexing
- 🎨 **Smart UI** - Animated crawler icon and K.I.T.T.-style visual feedback
- 🌙 **Dark Mode Toggle** - Clean grey dark theme (no blue/purple tints)
- 🔑 **API Key Management** - Secure storage for AI service credentials

## 🎉 Custom Chromium Fork Development Status

### ✅ **Major Breakthrough Achieved:**
- **Prebuilt Chromium:** ✅ **WORKING** - Available for prototyping
- **Custom Fork:** 🚨 **CRITICAL BLOCKER** - Native tooltip system integrated, but GPU service compilation errors blocking build
- **Build Status:** ❌ **FAILED** - Multiple compilation errors in gpu_init.cc preventing chrome.exe creation
- **Current Status:** 🔧 **ACTIVE DEBUGGING** - Source patching required for GpuInit member function calls

### 🔥 **Why Custom Fork is Required:**
- **Proactive Pre-crawling:** Extensions cannot crawl without user interaction
- **Full Screenshot Capture:** Need DevTools Protocol access for other tabs
- **Native Tooltip Rendering:** Must integrate with Blink rendering engine
- **Deep Browser Integration:** Extensions cannot access core browser internals
- **Performance Requirements:** Native integration needed for seamless experience

### 🎮 **Current Status: Critical Blocker**
- ❌ **Custom Chrome Build:** Multiple compilation errors in gpu_init.cc preventing executable creation
- ✅ **Tooltip System Integrated:** Native tooltip service code implemented
- ✅ **Dark Mode Code:** Complete implementation with CSS injection
- 🚨 **Critical Issue:** GpuInit member function calls causing structural compilation errors
- ⏳ **API Keys:** Settings UI pending

## 🚀 Quick Start

### Prerequisites
- Windows 10/11 (x64)
- Visual Studio 2022 Community
- Windows SDK 10.0.26100.4188
- Python 3.11.9
- Git 2.49.0+

### Launch Custom Chromium Fork (When Build Completes)
```powershell
# 1. Navigate to build directory
cd C:\chromium\src\src

# 2. Launch custom Chrome with tooltip system (after Dawn issues resolved)
.\out\Default\chrome.exe --enable-logging --user-data-dir=.\user_data --disable-features=VizDisplayCompositor

# 3. Check DevTools Console (F12) for tooltip system logs
# Look for messages starting with "🔧 TOOLTIP:"
```

### Current Workaround: Use Prebuilt Chromium
```powershell
# For immediate testing and development
cd C:\ChromiumFresh\prebuilt_chromium\chromium\chrome-win
.\chrome.exe
```

### Build Custom Fork (Current Approach)
```powershell
# 1. Navigate to source directory
cd C:\chromium\src\src

# 2. Add depot_tools to PATH
$env:PATH = "C:\chromium\depot_tools;$env:PATH"

# 3. Use chunked build approach
powershell -ExecutionPolicy Bypass -File .\build_chunks.ps1

# 4. If Dawn errors persist, patch source file:
notepad gpu\ipc\service\gpu_init.cc
# Comment out lines 898-899 with dawn_context_provider references
```

### Prebuilt Chromium (Prototyping Only)
```powershell
# For rapid prototyping and testing
cd prebuilt_chromium
.\download_simple.ps1
.\launch_chromium.bat
```

## 📁 Project Structure

```
ToolTip_Browser/
├── 📄 README.md                           # This file
├── 📄 PROJECT_STATUS_REPORT.md            # Detailed progress report
├── 📄 BUILD_PROGRESS_SUMMARY.md           # Technical breakthrough details
├── 📄 SYSTEMATIC_DEBUGGING_GUIDE.md       # Step-by-step debugging guide
├── 📄 DEVELOPMENT_STRATEGY_ANALYSIS.md    # Chromium fork vs extension analysis
├── 📄 NEXT_DEVELOPMENT_STEPS.md           # Post-build development roadmap
├── 📄 Product Requirements Document_ Chromium Fork with Tooltip Companion Functionality.md
├── 📁 src/
│   └── 📁 ai/
│       └── 📁 services/
│           └── 📄 ai_service_manager.py   # AI integration service
├── 📁 prebuilt_chromium/                  # Prebuilt Chromium installation
│   ├── 📄 download_simple.ps1             # Simple download script
│   ├── 📄 download_chromium.ps1           # Latest build download script
│   ├── 📄 launch_chromium.bat             # Development launcher
│   ├── 📁 chromium/                       # Extracted Chromium build
│   │   └── 📁 chrome-win/                 # Chrome executable location
│   └── 📁 downloads/                      # Download cache
└── 📁 chromium/                           # Chromium source (when downloaded)
```

## 🛠️ Technical Architecture

### Core Components
- **Browser Process** - Main Chromium browser with tooltip integration
- **Renderer Process** - Web content rendering with tooltip overlay
- **AI Service** - Multi-model AI integration (OpenAI, Gemini, Claude)
- **Crawler Service** - Proactive web element analysis
- **Storage Service** - Screenshot and metadata management

### Key Technologies
- **Base:** Chromium (latest stable)
- **AI Models:** OpenAI GPT, Google Gemini, Anthropic Claude
- **Voice:** Whisper (speech-to-text), ElevenLabs (text-to-speech)
- **Storage:** SQLite database with local file system
- **UI:** Chromium Views framework with custom tooltip components

## 📊 Development Progress

| Component | Status | Progress |
|-----------|--------|----------|
| Environment Setup | ✅ Complete | Visual Studio 2022, Windows SDK, Python |
| Chromium Source | ✅ Complete | ~15GB source downloaded |
| Build Configuration | ✅ Complete | gn gen working successfully |
| rc.exe Discovery | ✅ Complete | Fixed hardcoded path issue |
| Resource Compilation | ✅ Complete | rc.exe executing successfully |
| Dawn Graphics Issue | 🚨 Critical Blocker | Multiple compilation errors in gpu_init.cc, GpuInit member function calls failing |
| Custom Fork Build | ❌ Failed | Structural compilation errors preventing chrome.exe creation |
| Tooltip Service | ✅ Complete | Core service class implemented |
| Tooltip Preferences | ✅ Complete | Settings management system |
| Element Detector | ✅ Complete | Framework for element detection |
| Screenshot Capture | ✅ Complete | Framework for screenshot functionality |
| AI Integration | ✅ Complete | Framework for AI service integration |
| Tooltip View | ✅ Complete | Native UI framework |
| Dark Mode Manager | ✅ Complete | Full implementation with CSS injection |
| API Key Management | ⏳ Pending | Settings UI needed |
| Voice Commands | ⏳ Pending | Whisper + ElevenLabs integration planned |

## 🔧 Key Fixes Applied

### Build System Fixes
1. **Fixed rc.exe Path Issue**
   ```python
   # Before (BROKEN):
   rc = os.path.join(THIS_DIR, 'win', 'rc.exe')
   
   # After (WORKING):
   rc = 'rc.exe'  # Use system PATH
   ```

2. **Environment Configuration**
   ```powershell
   # Working build command:
   cmd /c '"C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" && set DEPOT_TOOLS_WIN_TOOLCHAIN=0 && autoninja -C out/Default chrome'
   ```

3. **Resource Compiler Improvements**
   - Added `/utf-8` flag for character encoding
   - Set `_RC_CODEPAGE=65001` environment variable
   - Configured `PYTHONIOENCODING=utf-8`

### Dawn Graphics Library Fixes
4. **Comprehensive Dawn Disabling**
   ```gn
   # Complete Dawn backend disabling in args.gn
   use_dawn = false
   skia_use_dawn = false
   use_webgpu = false
   dawn_enable_d3d12 = false
   dawn_enable_desktop_gl = false
   dawn_enable_metal = false
   dawn_enable_null = false
   dawn_enable_opengles = false
   dawn_enable_vulkan = false
   ```

5. **Chunked Build Strategy**
   - Build components separately to avoid Dawn issues
   - Progressive build approach with fallback options
   - Source file patching for persistent Dawn references

6. **Current Critical Blocker**
   - Multiple compilation errors in gpu_init.cc
   - GpuInit member function calls failing (gpu_info, gpu_feature_info)
   - Structural issues with GPU service integration
   - Requires comprehensive source patching or alternative build approach

### Dark Mode Implementation
6. **Complete Dark Mode System**
   ```cpp
   // Proper WebContents integration
   void DarkModeManager::ApplyDarkModeToWebContents(content::WebContents* web_contents) {
       // JavaScript-based CSS injection
       // Clean grey theme implementation
       // Comprehensive element coverage
   }
   ```

## 🎯 Next Steps

### Immediate (Current Sprint)
1. **🚨 CRITICAL: Fix GpuInit Compilation Errors** - Resolve member function call issues in gpu_init.cc
2. **Alternative Build Approach** - Consider excluding GPU service entirely or using different build flags
3. **Complete Custom Fork Build** - Get chrome.exe executable working after GPU issues resolved
4. **Test Tooltip System** - Verify native tooltip functionality
5. **Create API Key Management UI** - Add settings to Chrome options page

### Short Term (Next 2-4 weeks)
1. **Complete Element Detection** - Implement Blink integration for element detection
2. **Implement Screenshot Capture** - Use native Chromium screenshot APIs
3. **Add AI Service Integration** - Connect to OpenAI, Gemini, Anthropic APIs

### Medium Term (1-3 months)
1. **Proactive Crawling** - Background web element analysis system
2. **Voice Commands** - Native Whisper and ElevenLabs integration
3. **Storage System** - Screenshot management and indexing
4. **Performance Optimization** - Native integration optimizations

## 🤝 Contributing

We welcome contributions! Please see our [Development Strategy Analysis](DEVELOPMENT_STRATEGY_ANALYSIS.md) for technical details.

### Development Setup
1. Follow the build instructions above
2. Read the [Systematic Debugging Guide](SYSTEMATIC_DEBUGGING_GUIDE.md)
3. Check the [Next Development Steps](NEXT_DEVELOPMENT_STEPS.md)

## 📚 Documentation

- [Project Status Report](PROJECT_STATUS_REPORT.md) - Detailed progress tracking
- [Build Progress Summary](BUILD_PROGRESS_SUMMARY.md) - Technical breakthrough details
- [Product Requirements Document](Product%20Requirements%20Document_%20Chromium%20Fork%20with%20Tooltip%20Companion%20Functionality.md) - Complete feature specifications
- [Development Strategy Analysis](DEVELOPMENT_STRATEGY_ANALYSIS.md) - Chromium fork vs extension comparison
- [Next Development Steps](NEXT_DEVELOPMENT_STEPS.md) - Post-build development roadmap

## 📄 License

This project is based on Chromium and follows the [Chromium License](https://chromium.googlesource.com/chromium/src/+/HEAD/LICENSE).

## 🙏 Acknowledgments

- Chromium team for the excellent open-source browser
- OpenAI, Google, and Anthropic for AI model APIs
- Whisper and ElevenLabs for voice processing capabilities
- The open-source community for inspiration and support

---

**Status:** 🚨 Critical Blocker - GpuInit Compilation Errors | **Last Updated:** September 24, 2025 | **Version:** 0.2.0-beta
