#include <gtest/gtest.h>
#include <memory>
#include <chrono>
#include <thread>

// NaviGrab includes
#include "chromium_playwright/browser_control.h"
#include "chromium_playwright/screenshot_capture.h"
#include "chromium_playwright/proactive_scraping.h"

using namespace chromium_playwright;

class ChromiumFreshIntegrationTest : public ::testing::Test {
protected:
    void SetUp() override {
        // Initialize NaviGrab components
        browser_control_ = CreateBrowserControl();
        screenshot_capture_ = CreateScreenshotCapture();
        scraper_ = CreateScraper();
        
        // Create test context
        context_id_ = browser_control_->NewContext();
        context_ = browser_control_->GetContext(context_id_);
        
        ASSERT_NE(context_, nullptr) << "Failed to create browser context";
    }
    
    void TearDown() override {
        if (context_id_ > 0) {
            browser_control_->CloseContext(context_id_);
        }
    }
    
    std::unique_ptr<BrowserControl> browser_control_;
    std::unique_ptr<ScreenshotCapture> screenshot_capture_;
    std::unique_ptr<Scraper> scraper_;
    
    int context_id_ = 0;
    std::unique_ptr<BrowserContext> context_;
};

TEST_F(ChromiumFreshIntegrationTest, BrowserControlIntegration) {
    // Test browser context creation
    EXPECT_GT(context_id_, 0) << "Context ID should be positive";
    EXPECT_NE(context_, nullptr) << "Context should not be null";
    
    // Test page creation
    auto page_id = context_->NewPage();
    EXPECT_GT(page_id, 0) << "Page ID should be positive";
    
    auto page = context_->GetPage(page_id);
    EXPECT_NE(page, nullptr) << "Page should not be null";
    
    // Test page navigation
    std::string test_url = "https://example.com";
    bool navigation_success = page->Goto(test_url);
    EXPECT_TRUE(navigation_success) << "Navigation should succeed";
    
    // Test page properties
    std::string current_url = page->Url();
    std::string page_title = page->Title();
    
    EXPECT_FALSE(current_url.empty()) << "URL should not be empty";
    EXPECT_FALSE(page_title.empty()) << "Title should not be empty";
}

TEST_F(ChromiumFreshIntegrationTest, ScreenshotCaptureIntegration) {
    // Create a test page
    auto page_id = context_->NewPage();
    auto page = context_->GetPage(page_id);
    
    // Navigate to test page
    page->Goto("https://example.com");
    
    // Test screenshot capture
    ScreenshotOptions options;
    options.path = "test_screenshot.png";
    options.full_page = true;
    options.type = "png";
    
    auto result = screenshot_capture_->CapturePage(*page, options);
    
    EXPECT_TRUE(result.success) << "Screenshot capture should succeed";
    EXPECT_FALSE(result.file_path.empty()) << "File path should not be empty";
    EXPECT_FALSE(result.image_data.empty()) << "Image data should not be empty";
}

TEST_F(ChromiumFreshIntegrationTest, ProactiveScrapingIntegration) {
    // Test scraping configuration
    ScrapingConfig config;
    config.start_url = "https://example.com";
    config.max_depth = 2;
    config.take_screenshots = true;
    config.extract_data = true;
    config.page_timeout = std::chrono::milliseconds(5000);
    
    // Start scraping session
    int session_id = scraper_->StartScraping(config);
    EXPECT_GT(session_id, 0) << "Session ID should be positive";
    
    // Wait for scraping to complete
    std::this_thread::sleep_for(std::chrono::seconds(2));
    
    // Check if scraping is running
    bool is_scraping = scraper_->IsScraping(session_id);
    EXPECT_TRUE(is_scraping) << "Scraping should be running";
    
    // Get scraping results
    auto results = scraper_->GetScrapingResults(session_id);
    EXPECT_FALSE(results.empty()) << "Results should not be empty";
    
    // Stop scraping
    bool stop_success = scraper_->StopScraping(session_id);
    EXPECT_TRUE(stop_success) << "Stop scraping should succeed";
}

TEST_F(ChromiumFreshIntegrationTest, DOMInteractionIntegration) {
    // Create a test page
    auto page_id = context_->NewPage();
    auto page = context_->GetPage(page_id);
    
    // Navigate to test page
    page->Goto("https://example.com");
    
    // Test element finding
    auto locator = page->GetByCss("h1");
    EXPECT_NE(locator, nullptr) << "Locator should not be null";
    
    // Test element properties
    std::string element_text = locator->TextContent();
    EXPECT_FALSE(element_text.empty()) << "Element text should not be empty";
    
    // Test element visibility
    bool is_visible = locator->IsVisible();
    EXPECT_TRUE(is_visible) << "Element should be visible";
    
    // Test element interaction
    bool hover_success = locator->Hover();
    EXPECT_TRUE(hover_success) << "Hover should succeed";
}

TEST_F(ChromiumFreshIntegrationTest, PerformanceIntegration) {
    // Test performance of multiple operations
    auto start_time = std::chrono::high_resolution_clock::now();
    
    // Create multiple pages
    std::vector<int> page_ids;
    for (int i = 0; i < 5; ++i) {
        auto page_id = context_->NewPage();
        page_ids.push_back(page_id);
        
        auto page = context_->GetPage(page_id);
        page->Goto("https://example.com");
    }
    
    auto end_time = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time);
    
    // Performance should be reasonable (less than 5 seconds for 5 pages)
    EXPECT_LT(duration.count(), 5000) << "Page creation and navigation should be fast";
    
    // Cleanup
    for (auto page_id : page_ids) {
        context_->ClosePage(page_id);
    }
}

TEST_F(ChromiumFreshIntegrationTest, ErrorHandlingIntegration) {
    // Test error handling with invalid inputs
    
    // Test invalid context
    auto invalid_context = browser_control_->GetContext(99999);
    EXPECT_EQ(invalid_context, nullptr) << "Invalid context should return null";
    
    // Test invalid page
    auto page_id = context_->NewPage();
    auto page = context_->GetPage(page_id);
    context_->ClosePage(page_id);
    
    // Try to use closed page (should handle gracefully)
    bool navigation_success = page->Goto("https://example.com");
    // This might succeed or fail depending on implementation, but shouldn't crash
    EXPECT_NO_THROW({
        std::string url = page->Url();
        std::string title = page->Title();
    }) << "Closed page operations should not throw";
}

TEST_F(ChromiumFreshIntegrationTest, MemoryManagementIntegration) {
    // Test memory management with multiple operations
    
    // Create and destroy multiple contexts
    std::vector<int> context_ids;
    for (int i = 0; i < 10; ++i) {
        auto context_id = browser_control_->NewContext();
        context_ids.push_back(context_id);
        
        auto context = browser_control_->GetContext(context_id);
        auto page_id = context->NewPage();
        auto page = context->GetPage(page_id);
        page->Goto("https://example.com");
    }
    
    // Close all contexts
    for (auto context_id : context_ids) {
        bool close_success = browser_control_->CloseContext(context_id);
        EXPECT_TRUE(close_success) << "Context should close successfully";
    }
    
    // Verify contexts are closed
    for (auto context_id : context_ids) {
        auto context = browser_control_->GetContext(context_id);
        EXPECT_EQ(context, nullptr) << "Closed context should return null";
    }
}

TEST_F(ChromiumFreshIntegrationTest, ConcurrentOperationsIntegration) {
    // Test concurrent operations
    std::vector<std::thread> threads;
    std::vector<bool> results(5, false);
    
    for (int i = 0; i < 5; ++i) {
        threads.emplace_back([this, i, &results]() {
            try {
                auto page_id = context_->NewPage();
                auto page = context_->GetPage(page_id);
                page->Goto("https://example.com");
                
                ScreenshotOptions options;
                options.path = "concurrent_test_" + std::to_string(i) + ".png";
                auto result = screenshot_capture_->CapturePage(*page, options);
                
                results[i] = result.success;
                
                context_->ClosePage(page_id);
            } catch (...) {
                results[i] = false;
            }
        });
    }
    
    // Wait for all threads to complete
    for (auto& thread : threads) {
        thread.join();
    }
    
    // Check results
    for (int i = 0; i < 5; ++i) {
        EXPECT_TRUE(results[i]) << "Concurrent operation " << i << " should succeed";
    }
}

