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

## 🎉 Major Breakthrough - Build System Working!

### ✅ **What's Working:**
- **rc.exe Discovery** - Fixed hardcoded path issues in Chromium build system
- **Environment Setup** - Visual Studio 2022 properly configured
- **Build Configuration** - `gn gen` successfully generates 27,000+ targets
- **Resource Compiler** - rc.exe now found and executing

### ⚠️ **Current Status:**
- **Build System:** Partially working (major progress made)
- **Remaining Issue:** Resource compiler code page error (RC1205)
- **Next Step:** Resolve character encoding issues for full build completion

## 🚀 Quick Start

### Prerequisites
- Windows 10/11 (x64)
- Visual Studio 2022 Community
- Windows SDK 10.0.26100.4188
- Python 3.11.9
- Git 2.49.0+

### Build Instructions
```powershell
# 1. Clone the repository
git clone https://github.com/mcpmessenger/ToolTip_Browser.git
cd ToolTip_Browser

# 2. Set up Chromium source (if not already present)
# Follow instructions in chromium_setup_guide.md

# 3. Build with working configuration
cmd /c '"C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" && set DEPOT_TOOLS_WIN_TOOLCHAIN=0 && autoninja -C out/Default chrome'
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
| Source Download | ✅ Complete | ~15GB Chromium source downloaded |
| Build Configuration | ✅ Complete | gn gen working successfully |
| rc.exe Discovery | ✅ Complete | Fixed hardcoded path issue |
| Resource Compilation | ⚠️ Partial | rc.exe executing but code page errors |
| Full Build | ❌ In Progress | Waiting for resource compilation fix |
| Tooltip Integration | ⏳ Pending | Ready to begin after build completion |
| AI Service | ⏳ Pending | Architecture planned |
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

## 🎯 Next Steps

### Immediate (Current Sprint)
1. **Resolve RC1205 Error** - Fix resource compiler code page issues
2. **Complete Build** - Get full Chrome build working
3. **Test Basic Functionality** - Verify browser launches correctly

### Short Term (Next 2-4 weeks)
1. **Tooltip Infrastructure** - Implement core tooltip display system
2. **AI Integration** - Add OpenAI, Gemini, and Claude API support
3. **Basic Crawling** - Implement simple web element detection

### Medium Term (1-3 months)
1. **Advanced Crawling** - Proactive background element analysis
2. **Voice Commands** - Whisper and ElevenLabs integration
3. **Storage System** - Screenshot management and indexing

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

**Status:** 🚧 In Active Development | **Last Updated:** September 22, 2025 | **Version:** 0.1.0-alpha
