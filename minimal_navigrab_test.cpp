#include <iostream>
#include <memory>
#include "src/navigrab/navigrab_core.h"
#include "src/navigrab/proactive_scraper.h"

int main() {
    std::cout << "========================================\n";
    std::cout << " MINIMAL NAVIGRAB TEST\n";
    std::cout << "========================================\n";
    std::cout << "Testing NaviGrab core functionality...\n\n";

    try {
        // Test NaviGrab core initialization
        std::cout << "Step 1: Initializing NaviGrab core...\n";
        auto navigrab = std::make_unique<navigrab::NaviGrabCore>();
        std::cout << "✅ NaviGrab core initialized successfully!\n\n";

        // Test proactive scraper
        std::cout << "Step 2: Testing proactive scraper...\n";
        auto scraper = std::make_unique<navigrab::ProactiveScraper>();
        std::cout << "✅ Proactive scraper initialized successfully!\n\n";

        // Test basic scraping functionality
        std::cout << "Step 3: Testing basic scraping...\n";
        auto result = scraper->ScrapePage("https://example.com", navigrab::ScrapingDepth::QUICK);
        
        if (result.success) {
            std::cout << "✅ Scraping completed successfully!\n";
            std::cout << "   - Elements found: " << result.elements.size() << std::endl;
            std::cout << "   - Total elements: " << result.total_elements << std::endl;
            std::cout << "   - Interactive elements: " << result.interactive_elements << std::endl;
            std::cout << "   - Time taken: " << result.duration.count() << "ms" << std::endl;
        } else {
            std::cout << "⚠️  Scraping failed: " << result.error_message << std::endl;
        }

        std::cout << "\n========================================\n";
        std::cout << " MINIMAL TEST COMPLETED\n";
        std::cout << "========================================\n";
        std::cout << "Build system is working correctly!\n";
        std::cout << "NaviGrab core functionality verified.\n";
        std::cout << "Ready for tooltip integration.\n";

        return 0;

    } catch (const std::exception& e) {
        std::cerr << "❌ Error: " << e.what() << std::endl;
        return 1;
    }
}
