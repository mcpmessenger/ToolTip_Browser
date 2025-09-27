#include <iostream>
#include <memory>
#include "src/navigrab/navigrab_core.h"
#include "src/navigrab/proactive_scraper.h"

int main() {
    std::cout << "Testing minimal tooltip integration with NaviGrab..." << std::endl;

    // Test NaviGrab core
    auto navigrab = std::make_unique<navigrab::NaviGrabCore>();
    if (navigrab->Initialize()) {
        std::cout << "✅ NaviGrab core initialized successfully" << std::endl;
    } else {
        std::cout << "❌ NaviGrab core initialization failed" << std::endl;
        return 1;
    }

    // Test proactive scraper
    auto scraper = std::make_unique<navigrab::ProactiveScraper>();
    if (scraper->Initialize()) {
        std::cout << "✅ Proactive scraper initialized successfully" << std::endl;
    } else {
        std::cout << "❌ Proactive scraper initialization failed" << std::endl;
        return 1;
    }

    // Test basic scraping
    std::cout << "Testing basic scraping..." << std::endl;
    auto result = scraper->ScrapePage("https://example.com", navigrab::ScrapingDepth::QUICK);
    if (result.success) {
        std::cout << "✅ Scraping successful: " << result.elements.size() << " elements found" << std::endl;
        std::cout << "   - Total elements: " << result.total_elements << std::endl;
        std::cout << "   - Interactive elements: " << result.interactive_elements << std::endl;
        std::cout << "   - Time taken: " << result.duration.count() << "ms" << std::endl;
    } else {
        std::cout << "❌ Scraping failed: " << result.error_message << std::endl;
    }

    std::cout << "Minimal tooltip integration test completed!" << std::endl;
    return 0;
}
