# 🌐 ChromiumFresh - Next-Gen Tooltip Browser

A custom Chromium-based browser with innovative tooltip companion functionality that provides proactive, context-aware tooltips with screenshot previews of interactive web elements.

## 🎯 **Project Vision**

ChromiumFresh integrates advanced tooltip functionality directly into Chromium, creating a next-generation browsing experience where tooltips provide rich, contextual information about web elements before users interact with them.

## ✨ **Key Features**

- **🎯 Proactive Tooltips** - Context-aware tooltips that appear before interaction
- **📸 Screenshot Previews** - Visual previews of what happens when clicking elements
- **🤖 AI Integration** - Intelligent element descriptions and automation suggestions
- **🌙 Dark Mode** - Seamless dark mode support
- **🔧 Native Integration** - Built directly into Chromium for optimal performance

## 🚀 **Quick Start**

### **📚 Documentation**
All project documentation is organized in the **[docs/](docs/)** folder:
- **[📖 Complete Documentation Index](docs/README.md)**
- **[📋 Product Requirements Document](Product%20Requirements%20Document_%20Chromium%20Fork%20with%20Tooltip%20Companion%20Functionality.md)**
- **[🔧 Chromium Setup Guide](docs/chromium_setup_guide.md)**
- **[📊 Build Progress Summary](docs/BUILD_PROGRESS_SUMMARY.md)**

### **🏗️ Building ChromiumFresh**
```bash
# Quick build
.\quick_build.ps1

# Or use the working build script
.\build_working.bat
```

### **🎮 Testing**
```bash
# Test dark mode functionality
.\test_dark_mode_functionality.ps1

# Launch custom Chrome
.\launch_custom_chrome.ps1
```

## 📁 **Repository Structure**

```
ChromiumFresh/
├── docs/                    # 📚 All documentation
│   ├── README.md           # Documentation index
│   ├── Product Requirements Document_ Chromium Fork with Tooltip Companion Functionality.md
│   └── ...                 # All other documentation
├── chrome/                  # 🌐 Chromium fork with tooltip integration
│   └── browser/tooltip/    # Tooltip service implementation
├── src/                     # 🔧 Source code
│   ├── navigrab_simple/    # Web automation library
│   └── chromium_integration/ # Chromium bridge components
├── examples/               # 📝 Example implementations
│   ├── web_automation_demo.cpp
│   ├── tooltip_automation_demo.cpp
│   └── client_side_tooltip_demo.cpp
├── build/                  # 🔨 Build outputs
├── prebuilt_chromium/      # 📦 Prebuilt Chromium binaries
└── README.md              # 📖 This file
```

## 🎯 **Development Status**

- ✅ **Core Tooltip Service** - Implemented and integrated
- ✅ **Dark Mode Support** - Working with CSS injection
- ✅ **Web Automation** - NaviGrab library integrated
- ✅ **Screenshot Capture** - Native screenshot functionality
- 🔄 **AI Integration** - In progress
- 🔄 **Voice Commands** - Planned
- 🔄 **Advanced Tooltips** - Enhanced UI in development

## 🔧 **Technical Stack**

- **Chromium** - Custom fork with tooltip integration
- **C++** - Core implementation
- **CMake** - Build system
- **GN** - Chromium build configuration
- **SQLite** - Local storage
- **AI APIs** - OpenAI, Google Gemini, Anthropic Claude

## 📋 **Requirements**

- Windows 10/11
- Visual Studio 2022
- CMake 3.20+
- Git
- Chromium build dependencies

## 🤝 **Contributing**

1. Read the **[Product Requirements Document](docs/Product%20Requirements%20Document_%20Chromium%20Fork%20with%20Tooltip%20Companion%20Functionality.md)**
2. Check **[Build Progress Summary](docs/BUILD_PROGRESS_SUMMARY.md)** for current status
3. Follow **[Development Strategy Analysis](docs/DEVELOPMENT_STRATEGY_ANALYSIS.md)**
4. Review **[Native Implementation Plan](docs/NATIVE_IMPLEMENTATION_PLAN.md)**

## 📞 **Support**

- **Documentation**: [docs/README.md](docs/README.md)
- **Issues**: Check [CRITICAL_BUILD_BLOCKERS.md](docs/CRITICAL_BUILD_BLOCKERS.md)
- **Debugging**: [SYSTEMATIC_DEBUGGING_GUIDE.md](docs/SYSTEMATIC_DEBUGGING_GUIDE.md)

## 📄 **License**

This project is based on Chromium and follows Chromium's licensing terms.

---

**🌐 ChromiumFresh - The future of intelligent browsing with proactive tooltips**
