// Website Explorer Demo - Next-Gen Tooltip System
// Automatically explores all links and buttons, taking screenshots after each interaction

#include <iostream>
#include <memory>
#include <string>
#include <thread>
#include <chrono>

#include "src/navigrab_simple/website_explorer.h"

using namespace navigrab;

int main() {
    std::cout << "🌐 NaviGrab Website Explorer - Next-Gen Tooltip System" << std::endl;
    std::cout << "====================================================" << std::endl;
    
    try {
        // Initialize website explorer
        std::cout << "\n📦 Initializing Website Explorer..." << std::endl;
        auto explorer = CreateWebsiteExplorer();
        explorer->Initialize();
        std::cout << "✅ Website Explorer initialized!" << std::endl;
        
        // Configure exploration settings
        std::cout << "\n⚙️ Configuring exploration settings..." << std::endl;
        explorer->SetMaxDepth(2);           // Explore 2 levels deep
        explorer->SetMaxPages(10);          // Limit to 10 pages
        explorer->SetScreenshotDelay(1500); // 1.5 second delay between screenshots
        explorer->SetNavigationDelay(2000); // 2 second delay for navigation
        explorer->SetFollowExternalLinks(false); // Don't follow external links
        explorer->SetTakeScreenshots(true); // Take screenshots
        explorer->SetExploreForms(true);    // Explore form elements
        
        std::cout << "✅ Settings configured:" << std::endl;
        std::cout << "   - Max depth: 2 levels" << std::endl;
        std::cout << "   - Max pages: 10" << std::endl;
        std::cout << "   - Screenshot delay: 1.5 seconds" << std::endl;
        std::cout << "   - Navigation delay: 2 seconds" << std::endl;
        std::cout << "   - Follow external links: No" << std::endl;
        std::cout << "   - Take screenshots: Yes" << std::endl;
        std::cout << "   - Explore forms: Yes" << std::endl;
        
        // Test with our custom test page
        std::cout << "\n🎯 Testing with our custom test page..." << std::endl;
        std::string test_page_path = "file:///" + std::filesystem::current_path().string() + "/test_automation_page.html";
        std::replace(test_page_path.begin(), test_page_path.end(), '\\', '/');
        
        std::cout << "Test page: " << test_page_path << std::endl;
        
        // Create progress callback
        auto progress_callback = [](const std::string& message, int current, int total) {
            if (total > 0) {
                int percentage = (current * 100) / total;
                std::cout << "[" << percentage << "%] " << message << std::endl;
            } else {
                std::cout << "[INFO] " << message << std::endl;
            }
        };
        
        // Explore current page only (since it's a local file)
        std::cout << "\n🚀 Starting website exploration..." << std::endl;
        std::cout << "This will:" << std::endl;
        std::cout << "  ✅ Discover all clickable elements (links, buttons, forms)" << std::endl;
        std::cout << "  ✅ Click each element and take a screenshot" << std::endl;
        std::cout << "  ✅ Capture the state after each interaction" << std::endl;
        std::cout << "  ✅ Generate a comprehensive map of the page" << std::endl;
        std::cout << "  ✅ Save all results for next-gen tooltip system" << std::endl;
        
        explorer->ExploreCurrentPage("exploration_results", progress_callback);
        
        // Get and display results
        const auto& results = explorer->GetResults();
        
        std::cout << "\n🎉 Website Exploration Completed!" << std::endl;
        std::cout << "=================================" << std::endl;
        
        std::cout << "\n📊 Exploration Results:" << std::endl;
        std::cout << "  🌐 Base URL: " << results.base_url << std::endl;
        std::cout << "  📄 Pages Explored: " << results.total_pages_explored << std::endl;
        std::cout << "  🎯 Elements Discovered: " << results.discovered_elements.size() << std::endl;
        std::cout << "  📸 Screenshots Taken: " << results.total_screenshots_taken << std::endl;
        std::cout << "  ⏱️ Exploration Time: " << results.exploration_time.count() << " ms" << std::endl;
        
        std::cout << "\n🔍 Discovered Elements:" << std::endl;
        std::cout << "=======================" << std::endl;
        
        for (size_t i = 0; i < results.discovered_elements.size(); ++i) {
            const auto& element = results.discovered_elements[i];
            std::cout << "\n" << (i + 1) << ". Element Details:" << std::endl;
            std::cout << "   🎯 Selector: " << element.selector << std::endl;
            std::cout << "   🏷️ Tag: " << element.tag_name << std::endl;
            std::cout << "   📝 Text: " << element.text_content.substr(0, 50) << 
                         (element.text_content.length() > 50 ? "..." : "") << std::endl;
            std::cout << "   🔗 Href: " << element.href << std::endl;
            std::cout << "   🆔 ID: " << element.id << std::endl;
            std::cout << "   🎨 Class: " << element.class_name << std::endl;
            std::cout << "   🎭 Role: " << element.role << std::endl;
            std::cout << "   📸 Screenshot: " << element.screenshot_path << std::endl;
            std::cout << "   ✅ Visited: " << (element.is_visited ? "Yes" : "No") << std::endl;
        }
        
        std::cout << "\n📁 Generated Files:" << std::endl;
        std::cout << "===================" << std::endl;
        
        for (const auto& screenshot_path : results.screenshot_paths) {
            std::cout << "  📸 " << screenshot_path << std::endl;
        }
        
        std::cout << "\n💡 Next-Gen Tooltip System Benefits:" << std::endl;
        std::cout << "=====================================" << std::endl;
        std::cout << "  🧠 Complete page understanding - Every clickable element mapped" << std::endl;
        std::cout << "  📸 Visual state capture - Screenshots after each interaction" << std::endl;
        std::cout << "  🎯 Smart tooltips - AI can suggest actions based on element analysis" << std::endl;
        std::cout << "  🔄 Automated testing - Complete interaction coverage" << std::endl;
        std::cout << "  📊 Analytics ready - Data for user behavior analysis" << std::endl;
        std::cout << "  🚀 Performance optimized - Only explore what's needed" << std::endl;
        
        std::cout << "\n🎮 Tooltip Integration Features:" << std::endl;
        std::cout << "================================" << std::endl;
        std::cout << "  🤖 AI-powered suggestions based on element type and context" << std::endl;
        std::cout << "  📸 Visual preview of what happens when element is clicked" << std::endl;
        std::cout << "  🎯 Smart automation - One-click form filling, navigation" << std::endl;
        std::cout << "  📊 User guidance - Show all available actions for any element" << std::endl;
        std::cout << "  🔍 Accessibility enhanced - Describe elements for screen readers" << std::endl;
        std::cout << "  ⚡ Performance insights - Show loading times and interactions" << std::endl;
        
        std::cout << "\n🚀 Ready for ChromiumFresh Integration!" << std::endl;
        std::cout << "=======================================" << std::endl;
        std::cout << "The website explorer has created a comprehensive map of your test page." << std::endl;
        std::cout << "This data can now be integrated into ChromiumFresh tooltips to provide:" << std::endl;
        std::cout << "  • Intelligent automation suggestions" << std::endl;
        std::cout << "  • Visual previews of interactions" << std::endl;
        std::cout << "  • Complete page understanding" << std::endl;
        std::cout << "  • Enhanced user experience" << std::endl;
        
        std::cout << "\n📁 Check the 'exploration_results' folder for:" << std::endl;
        std::cout << "  📸 All captured screenshots" << std::endl;
        std::cout << "  📄 exploration_results.txt - Complete analysis" << std::endl;
        std::cout << "  🎯 Element mapping data for tooltip integration" << std::endl;
        
    } catch (const std::exception& e) {
        std::cerr << "❌ Error: " << e.what() << std::endl;
        return 1;
    }
    
    return 0;
}

