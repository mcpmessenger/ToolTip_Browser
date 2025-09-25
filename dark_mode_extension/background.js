// Background Service Worker for Tooltip Dark Mode Extension

console.log('🔧 TOOLTIP: Dark mode background service worker loaded');

// Initialize default settings
chrome.runtime.onInstalled.addListener(() => {
  console.log('🔧 TOOLTIP: Extension installed, setting default preferences');
  
  chrome.storage.sync.set({
    darkModeEnabled: false
  });
});

// Handle extension icon click
chrome.action.onClicked.addListener((tab) => {
  console.log('🔧 TOOLTIP: Extension icon clicked');
  
  // Toggle dark mode
  chrome.storage.sync.get(['darkModeEnabled'], (result) => {
    const newState = !result.darkModeEnabled;
    
    chrome.storage.sync.set({
      darkModeEnabled: newState
    });
    
    console.log(`🔧 TOOLTIP: Dark mode ${newState ? 'enabled' : 'disabled'}`);
  });
});

// Handle messages from content scripts
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.action === 'toggleDarkMode') {
    chrome.storage.sync.get(['darkModeEnabled'], (result) => {
      const newState = !result.darkModeEnabled;
      
      chrome.storage.sync.set({
        darkModeEnabled: newState
      });
      
      sendResponse({ success: true, enabled: newState });
    });
    
    return true; // Keep message channel open for async response
  }
});
