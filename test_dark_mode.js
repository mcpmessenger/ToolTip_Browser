// Simple test script to verify dark mode functionality
// This can be run in Chrome's developer console

console.log("🔧 TOOLTIP: Testing Dark Mode Functionality");

// Test 1: Check if dark mode manager is accessible
try {
  // In a real implementation, this would be accessed through the tooltip service
  console.log("🔧 TOOLTIP: Dark mode manager should be accessible through TooltipService");
  console.log("🔧 TOOLTIP: Use: TooltipService::GetInstance()->GetDarkModeManager()");
} catch (error) {
  console.error("🔧 TOOLTIP: Error accessing dark mode manager:", error);
}

// Test 2: Simulate dark mode CSS injection
const darkModeCSS = `
/* Tooltip Dark Mode - Clean Grey Theme */
* {
  background-color: #2d2d2d !important;
  color: #e0e0e0 !important;
}

/* Text elements */
p, span, div, h1, h2, h3, h4, h5, h6, a, li, td, th {
  color: #e0e0e0 !important;
}

/* Links */
a {
  color: #4a9eff !important;
}

a:visited {
  color: #8a6bb8 !important;
}

a:hover {
  color: #6bb6ff !important;
}

/* Form elements */
input, textarea, select, button {
  background-color: #3d3d3d !important;
  color: #e0e0e0 !important;
  border: 1px solid #555 !important;
}

input:focus, textarea:focus, select:focus {
  border-color: #4a9eff !important;
  outline: none !important;
}

/* Buttons */
button {
  background-color: #404040 !important;
  border: 1px solid #555 !important;
}

button:hover {
  background-color: #4a4a4a !important;
}

button:active {
  background-color: #353535 !important;
}

/* Tables */
table {
  background-color: #2d2d2d !important;
}

th {
  background-color: #3d3d3d !important;
}

tr:nth-child(even) {
  background-color: #333 !important;
}

/* Code blocks */
code, pre {
  background-color: #1e1e1e !important;
  color: #d4d4d4 !important;
}

/* Scrollbars */
::-webkit-scrollbar {
  background-color: #2d2d2d !important;
}

::-webkit-scrollbar-thumb {
  background-color: #555 !important;
}

::-webkit-scrollbar-thumb:hover {
  background-color: #666 !important;
}

/* Images - reduce brightness slightly */
img {
  opacity: 0.9 !important;
}

/* Remove any blue/purple tints from existing styles */
* {
  filter: none !important;
}
`;

// Test 3: Inject dark mode CSS into current page
function injectDarkMode() {
  console.log("🔧 TOOLTIP: Injecting dark mode CSS...");
  
  // Remove existing dark mode style if present
  const existingStyle = document.getElementById('tooltip-dark-mode');
  if (existingStyle) {
    existingStyle.remove();
    console.log("🔧 TOOLTIP: Removed existing dark mode style");
  }
  
  // Create new style element
  const style = document.createElement('style');
  style.id = 'tooltip-dark-mode';
  style.textContent = darkModeCSS;
  document.head.appendChild(style);
  
  console.log("🔧 TOOLTIP: Dark mode CSS injected successfully!");
  console.log("🔧 TOOLTIP: Page should now be in dark mode");
}

// Test 4: Remove dark mode CSS
function removeDarkMode() {
  console.log("🔧 TOOLTIP: Removing dark mode CSS...");
  
  const existingStyle = document.getElementById('tooltip-dark-mode');
  if (existingStyle) {
    existingStyle.remove();
    console.log("🔧 TOOLTIP: Dark mode CSS removed successfully!");
    console.log("🔧 TOOLTIP: Page should now be in light mode");
  } else {
    console.log("🔧 TOOLTIP: No dark mode CSS found to remove");
  }
}

// Test 5: Toggle dark mode
function toggleDarkMode() {
  const existingStyle = document.getElementById('tooltip-dark-mode');
  if (existingStyle) {
    removeDarkMode();
  } else {
    injectDarkMode();
  }
}

console.log("🔧 TOOLTIP: Dark mode test functions available:");
console.log("🔧 TOOLTIP: - injectDarkMode() - Enable dark mode");
console.log("🔧 TOOLTIP: - removeDarkMode() - Disable dark mode");
console.log("🔧 TOOLTIP: - toggleDarkMode() - Toggle dark mode");
console.log("🔧 TOOLTIP: - darkModeCSS - The CSS string used for dark mode");

// Auto-inject dark mode for testing
console.log("🔧 TOOLTIP: Auto-injecting dark mode for testing...");
injectDarkMode();

