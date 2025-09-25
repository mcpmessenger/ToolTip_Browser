// Dark Mode Content Script for Tooltip Chromium Fork
// This script manages dark mode functionality on web pages

console.log('🔧 TOOLTIP: Dark mode content script loaded');

class DarkModeManager {
  constructor() {
    this.isEnabled = false;
    this.styleId = 'tooltip-dark-mode-style';
    this.init();
  }

  async init() {
    // Get dark mode preference from storage
    const result = await chrome.storage.sync.get(['darkModeEnabled']);
    this.isEnabled = result.darkModeEnabled || false;
    
    if (this.isEnabled) {
      this.enableDarkMode();
    }
    
    // Listen for changes from popup
    chrome.storage.onChanged.addListener((changes, namespace) => {
      if (namespace === 'sync' && changes.darkModeEnabled) {
        this.isEnabled = changes.darkModeEnabled.newValue;
        if (this.isEnabled) {
          this.enableDarkMode();
        } else {
          this.disableDarkMode();
        }
      }
    });
  }

  enableDarkMode() {
    console.log('🔧 TOOLTIP: Enabling dark mode');
    
    // Remove existing dark mode style if present
    this.disableDarkMode();
    
    // Create new style element
    const style = document.createElement('style');
    style.id = this.styleId;
    style.type = 'text/css';
    
    // Get CSS from the extension
    const cssLink = chrome.runtime.getURL('dark_mode.css');
    
    // Load CSS content
    fetch(cssLink)
      .then(response => response.text())
      .then(css => {
        style.textContent = css;
        
        // Insert the style into the document head
        if (document.head) {
          document.head.appendChild(style);
        } else {
          // Fallback: insert at the beginning of body
          document.body.insertBefore(style, document.body.firstChild);
        }
        
        console.log('🔧 TOOLTIP: Dark mode CSS injected successfully');
      })
      .catch(error => {
        console.error('🔧 TOOLTIP: Error loading dark mode CSS:', error);
      });
  }

  disableDarkMode() {
    console.log('🔧 TOOLTIP: Disabling dark mode');
    
    const existingStyle = document.getElementById(this.styleId);
    if (existingStyle) {
      existingStyle.remove();
      console.log('🔧 TOOLTIP: Dark mode CSS removed');
    }
  }
}

// Initialize dark mode manager when DOM is ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => {
    new DarkModeManager();
  });
} else {
  new DarkModeManager();
}
