// Proactive Scraper Demo - Next-Gen Tooltip System
// Fast page analysis with scrape/crawl button functionality

#include <iostream>
#include <memory>
#include <string>
#include <thread>
#include <chrono>

#include "src/navigrab_simple/proactive_scraper.h"

using namespace navigrab;

int main() {
    std::cout << "⚡ NaviGrab Proactive Scraper - Next-Gen Tooltip System" << std::endl;
    std::cout << "=====================================================" << std::endl;
    
    try {
        // Initialize proactive scraper
        std::cout << "\n📦 Initializing Proactive Scraper..." << std::endl;
        auto scraper = CreateProactiveScraper();
        scraper->Initialize();
        std::cout << "✅ Proactive Scraper initialized!" << std::endl;
        
        // Configure scraper settings
        std::cout << "\n⚙️ Configuring scraper settings..." << std::endl;
        scraper->SetIncludeHiddenElements(false);
        scraper->SetIncludeFormData(true);
        scraper->SetIncludePositionData(true);
        scraper->SetMaxElements(500);
        
        std::cout << "✅ Settings configured:" << std::endl;
        std::cout << "   - Include hidden elements: No" << std::endl;
        std::cout << "   - Include form data: Yes" << std::endl;
        std::cout << "   - Include position data: Yes" << std::endl;
        std::cout << "   - Max elements: 500" << std::endl;
        
        // Test with our custom test page
        std::cout << "\n🎯 Loading test page for scraping..." << std::endl;
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
        
        std::cout << "\n🚀 Starting Proactive Scraping..." << std::endl;
        std::cout << "This will:" << std::endl;
        std::cout << "  ⚡ Instantly analyze all page elements" << std::endl;
        std::cout << "  🎯 Identify all clickable elements" << std::endl;
        std::cout << "  📊 Categorize elements by type and function" << std::endl;
        std::cout << "  🧠 Generate data for intelligent tooltips" << std::endl;
        std::cout << "  💾 Cache results for instant tooltip responses" << std::endl;
        
        // Navigate to test page first
        std::cout << "\n🌐 Navigating to test page..." << std::endl;
        auto browser = scraper->automation_->CreateBrowser();
        if (!browser->Launch(test_page_path)) {
            std::cout << "❌ Failed to load test page" << std::endl;
            return 1;
        }
        
        std::cout << "\n📋 Demo Menu - Choose Scraping Type:" << std::endl;
        std::cout << "1. Quick Scrape (Fast, basic data)" << std::endl;
        std::cout << "2. Standard Scrape (Balanced speed/data)" << std::endl;
        std::cout << "3. Deep Scrape (Comprehensive analysis)" << std::endl;
        std::cout << "4. Scrape with Screenshots (Full analysis + images)" << std::endl;
        std::cout << "5. Run All Scraping Types (Complete demo)" << std::endl;
        
        std::cout << "\n🎮 Simulating 'Scrape/Crawl' Button Press..." << std::endl;
        std::cout << "In the actual tooltip system, this would be triggered by:" << std::endl;
        std::cout << "  🔘 Clicking the 'Scrape/Crawl' button in tooltip UI" << std::endl;
        std::cout << "  ⌨️ Keyboard shortcut (e.g., Ctrl+Shift+S)" << std::endl;
        std::cout << "  🤖 Automatic background scraping on page load" << std::endl;
        
        // Run all scraping types for demo
        std::cout << "\n🚀 Running All Scraping Types..." << std::endl;
        
        // 1. Quick Scrape
        std::cout << "\n⚡ 1. Quick Scrape (Fast Analysis)" << std::endl;
        std::cout << "===================================" << std::endl;
        auto quick_result = scraper->QuickScrape(progress_callback);
        
        if (quick_result) {
            std::cout << "✅ Quick scrape completed in " << quick_result->scraping_time.count() << " ms" << std::endl;
            std::cout << "   📊 Found " << quick_result->total_elements << " elements" << std::endl;
            std::cout << "   🎯 " << quick_result->clickable_elements << " clickable elements" << std::endl;
            std::cout << "   📝 " << quick_result->form_elements << " form elements" << std::endl;
            std::cout << "   🔗 " << quick_result->link_elements << " link elements" << std::endl;
        }
        
        // 2. Standard Scrape
        std::cout << "\n📊 2. Standard Scrape (Balanced)" << std::endl;
        std::cout << "================================" << std::endl;
        auto standard_result = scraper->ScrapeCurrentPage(progress_callback);
        
        if (standard_result) {
            std::cout << "✅ Standard scrape completed in " << standard_result->scraping_time.count() << " ms" << std::endl;
            std::cout << "   📊 Found " << standard_result->total_elements << " elements" << std::endl;
            std::cout << "   🎯 " << standard_result->clickable_elements << " clickable elements" << std::endl;
            std::cout << "   📝 " << standard_result->form_elements << " form elements" << std::endl;
            std::cout << "   🔗 " << standard_result->link_elements << " link elements" << std::endl;
        }
        
        // 3. Deep Scrape
        std::cout << "\n🔍 3. Deep Scrape (Comprehensive)" << std::endl;
        std::cout << "==================================" << std::endl;
        auto deep_result = scraper->DeepScrape(progress_callback);
        
        if (deep_result) {
            std::cout << "✅ Deep scrape completed in " << deep_result->scraping_time.count() << " ms" << std::endl;
            std::cout << "   📊 Found " << deep_result->total_elements << " elements" << std::endl;
            std::cout << "   🎯 " << deep_result->clickable_elements << " clickable elements" << std::endl;
            std::cout << "   📝 " << deep_result->form_elements << " form elements" << std::endl;
            std::cout << "   🔗 " << deep_result->link_elements << " link elements" << std::endl;
        }
        
        // 4. Scrape with Screenshots
        std::cout << "\n📸 4. Scrape with Screenshots (Visual Analysis)" << std::endl;
        std::cout << "===============================================" << std::endl;
        auto screenshot_result = scraper->ScrapeWithScreenshots("scraping_results", progress_callback);
        
        if (screenshot_result) {
            std::cout << "✅ Screenshot scrape completed in " << screenshot_result->scraping_time.count() << " ms" << std::endl;
            std::cout << "   📊 Found " << screenshot_result->total_elements << " elements" << std::endl;
            std::cout << "   🎯 " << screenshot_result->clickable_elements << " clickable elements" << std::endl;
            std::cout << "   📝 " << screenshot_result->form_elements << " form elements" << std::endl;
            std::cout << "   🔗 " << screenshot_result->link_elements << " link elements" << std::endl;
            std::cout << "   📸 Screenshots saved to 'scraping_results' folder" << std::endl;
        }
        
        // Display detailed results
        std::cout << "\n📋 Detailed Element Analysis:" << std::endl;
        std::cout << "=============================" << std::endl;
        
        if (standard_result && !standard_result->elements.empty()) {
            std::cout << "\n🎯 Top Clickable Elements:" << std::endl;
            int count = 0;
            for (const auto& element : standard_result->elements) {
                if (element.is_clickable && count < 10) {
                    std::cout << "  " << (count + 1) << ". " << element.tag_name;
                    if (!element.id.empty()) std::cout << "#" << element.id;
                    if (!element.class_name.empty()) std::cout << "." << element.class_name;
                    std::cout << " - " << element.text_content.substr(0, 50);
                    if (element.text_content.length() > 50) std::cout << "...";
                    std::cout << std::endl;
                    count++;
                }
            }
            
            std::cout << "\n📝 Form Elements:" << std::endl;
            for (const auto& field : standard_result->form_fields) {
                std::cout << "  - " << field << std::endl;
            }
            
            std::cout << "\n🔗 Discovered URLs:" << std::endl;
            for (const auto& url : standard_result->discovered_urls) {
                std::cout << "  - " << url << std::endl;
            }
            
            std::cout << "\n🎮 Interactive Elements:" << std::endl;
            for (const auto& element : standard_result->interactive_elements) {
                std::cout << "  - " << element << std::endl;
            }
        }
        
        // Cache demonstration
        std::cout << "\n💾 Cache Performance Test:" << std::endl;
        std::cout << "==========================" << std::endl;
        
        auto start_cache_test = std::chrono::high_resolution_clock::now();
        auto cached_result = scraper->ScrapeCurrentPage(progress_callback);
        auto end_cache_test = std::chrono::high_resolution_clock::now();
        
        auto cache_time = std::chrono::duration_cast<std::chrono::milliseconds>(end_cache_test - start_cache_test);
        std::cout << "✅ Cached result retrieved in " << cache_time.count() << " ms" << std::endl;
        std::cout << "   🚀 " << ((standard_result->scraping_time.count() - cache_time.count()) * 100 / standard_result->scraping_time.count()) << "% faster than original scraping!" << std::endl;
        
        std::cout << "\n🎉 Proactive Scraping Demo Completed!" << std::endl;
        std::cout << "=====================================" << std::endl;
        
        std::cout << "\n💡 Next-Gen Tooltip System Benefits:" << std::endl;
        std::cout << "====================================" << std::endl;
        std::cout << "  ⚡ Instant page understanding - No waiting for user interaction" << std::endl;
        std::cout << "  🎯 Smart tooltip suggestions - Based on comprehensive element analysis" << std::endl;
        std::cout << "  💾 Cached results - Lightning-fast tooltip responses" << std::endl;
        std::cout << "  🔘 Scrape/Crawl button - Manual control for power users" << std::endl;
        std::cout << "  🧠 AI-ready data - Rich context for intelligent automation" << std::endl;
        std::cout << "  📊 Performance optimized - Multiple scraping depths for different needs" << std::endl;
        
        std::cout << "\n🎮 Tooltip Integration Features:" << std::endl;
        std::cout << "================================" << std::endl;
        std::cout << "  🔘 'Scrape/Crawl' button in tooltip UI" << std::endl;
        std::cout << "  ⚡ Automatic background scraping on page load" << std::endl;
        std::cout << "  🎯 Context-aware tooltip suggestions" << std::endl;
        std::cout << "  📸 Visual previews of interactions" << std::endl;
        std::cout << "  🧠 AI-powered automation recommendations" << std::endl;
        std::cout << "  💾 Smart caching for performance" << std::endl;
        
        std::cout << "\n🚀 Ready for ChromiumFresh Integration!" << std::endl;
        std::cout << "=======================================" << std::endl;
        std::cout << "The proactive scraper provides instant page analysis that can be" << std::endl;
        std::cout << "integrated into ChromiumFresh tooltips to create a truly next-gen" << std::endl;
        std::cout << "browsing experience with intelligent automation assistance." << std::endl;
        
    } catch (const std::exception& e) {
        std::cerr << "❌ Error: " << e.what() << std::endl;
        return 1;
    }
    
    return 0;
}

