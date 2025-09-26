#include <gtest/gtest.h>
#include <memory>
#include <chrono>
#include <thread>

// NaviGrab includes
#include "chromium_playwright/browser_control.h"
#include "chromium_playwright/screenshot_capture.h"
#include "chromium_playwright/proactive_scraping.h"
#include "chromium_playwright/storage_integration.h"
#include "chromium_playwright/api_layer.h"

using namespace chromium_playwright;

class NaviGrabIntegrationTest : public ::testing::Test {
protected:
    void SetUp() override {
        // Initialize all NaviGrab components
        browser_control_ = CreateBrowserControl();
        screenshot_capture_ = CreateScreenshotCapture();
        scraper_ = CreateScraper();
        storage_ = CreateStorageManager();
        api_layer_ = CreateAPILayer();
        
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
    std::unique_ptr<StorageManager> storage_;
    std::unique_ptr<APILayer> api_layer_;
    
    int context_id_ = 0;
    std::unique_ptr<BrowserContext> context_;
};

TEST_F(NaviGrabIntegrationTest, CompleteWorkflowIntegration) {
    // Test complete NaviGrab workflow
    
    // 1. Create page and navigate
    auto page_id = context_->NewPage();
    auto page = context_->GetPage(page_id);
    
    std::string test_url = "https://example.com";
    bool navigation_success = page->Goto(test_url);
    EXPECT_TRUE(navigation_success) << "Navigation should succeed";
    
    // 2. Take screenshot
    ScreenshotOptions screenshot_options;
    screenshot_options.path = "workflow_test_screenshot.png";
    screenshot_options.full_page = true;
    
    auto screenshot_result = screenshot_capture_->CapturePage(*page, screenshot_options);
    EXPECT_TRUE(screenshot_result.success) << "Screenshot should succeed";
    
    // 3. Start scraping session
    ScrapingConfig scraping_config;
    scraping_config.start_url = test_url;
    scraping_config.max_depth = 2;
    scraping_config.take_screenshots = true;
    scraping_config.extract_data = true;
    
    int session_id = scraper_->StartScraping(scraping_config);
    EXPECT_GT(session_id, 0) << "Scraping session should start";
    
    // 4. Wait for scraping to complete
    std::this_thread::sleep_for(std::chrono::seconds(2));
    
    // 5. Get scraping results
    auto results = scraper_->GetScrapingResults(session_id);
    EXPECT_FALSE(results.empty()) << "Should have scraping results";
    
    // 6. Store data
    for (const auto& page_data : results) {
        std::string storage_id = storage_->StoreScrapedPageData(page_data);
        EXPECT_FALSE(storage_id.empty()) << "Data should be stored successfully";
        
        // Verify data can be retrieved
        auto retrieved_data = storage_->RetrieveScrapedPageData(storage_id);
        EXPECT_TRUE(retrieved_data.has_value()) << "Data should be retrievable";
        EXPECT_EQ(retrieved_data->url, page_data.url) << "Retrieved URL should match";
    }
    
    // 7. Stop scraping
    bool stop_success = scraper_->StopScraping(session_id);
    EXPECT_TRUE(stop_success) << "Scraping should stop successfully";
}

TEST_F(NaviGrabIntegrationTest, ScreenshotCaptureIntegration) {
    // Test screenshot capture with different options
    
    auto page_id = context_->NewPage();
    auto page = context_->GetPage(page_id);
    page->Goto("https://example.com");
    
    // Test PNG screenshot
    ScreenshotOptions png_options;
    png_options.path = "test_png.png";
    png_options.type = "png";
    png_options.full_page = true;
    
    auto png_result = screenshot_capture_->CapturePage(*page, png_options);
    EXPECT_TRUE(png_result.success) << "PNG screenshot should succeed";
    EXPECT_FALSE(png_result.image_data.empty()) << "PNG data should not be empty";
    
    // Test JPEG screenshot
    ScreenshotOptions jpeg_options;
    jpeg_options.path = "test_jpeg.jpg";
    jpeg_options.type = "jpeg";
    jpeg_options.quality = 80;
    jpeg_options.full_page = false;
    
    auto jpeg_result = screenshot_capture_->CapturePage(*page, jpeg_options);
    EXPECT_TRUE(jpeg_result.success) << "JPEG screenshot should succeed";
    EXPECT_FALSE(jpeg_result.image_data.empty()) << "JPEG data should not be empty";
    
    // Test element screenshot
    auto locator = page->GetByCss("h1");
    if (locator) {
        auto element_result = screenshot_capture_->CaptureElement(*page, "h1", ScreenshotOptions{});
        EXPECT_TRUE(element_result.success) << "Element screenshot should succeed";
    }
}

TEST_F(NaviGrabIntegrationTest, ProactiveScrapingIntegration) {
    // Test comprehensive scraping functionality
    
    ScrapingConfig config;
    config.start_url = "https://example.com";
    config.max_depth = 3;
    config.take_screenshots = true;
    config.extract_data = true;
    config.click_all_buttons = true;
    config.follow_all_links = true;
    config.fill_forms = true;
    
    // Start scraping
    int session_id = scraper_->StartScraping(config);
    EXPECT_GT(session_id, 0) << "Scraping session should start";
    
    // Check session status
    bool is_scraping = scraper_->IsScraping(session_id);
    EXPECT_TRUE(is_scraping) << "Scraping should be active";
    
    // Get active sessions
    auto active_sessions = scraper_->GetActiveSessions();
    EXPECT_FALSE(active_sessions.empty()) << "Should have active sessions";
    EXPECT_TRUE(std::find(active_sessions.begin(), active_sessions.end(), session_id) != active_sessions.end())
        << "Session should be in active sessions list";
    
    // Wait for some progress
    std::this_thread::sleep_for(std::chrono::seconds(3));
    
    // Get results
    auto results = scraper_->GetScrapingResults(session_id);
    EXPECT_FALSE(results.empty()) << "Should have scraping results";
    
    // Verify result structure
    for (const auto& page_data : results) {
        EXPECT_FALSE(page_data.url.empty()) << "Page URL should not be empty";
        EXPECT_FALSE(page_data.title.empty()) << "Page title should not be empty";
        EXPECT_GT(page_data.timestamp.time_since_epoch().count(), 0) << "Timestamp should be valid";
    }
    
    // Stop scraping
    bool stop_success = scraper_->StopScraping(session_id);
    EXPECT_TRUE(stop_success) << "Scraping should stop successfully";
    
    // Verify session is no longer active
    is_scraping = scraper_->IsScraping(session_id);
    EXPECT_FALSE(is_scraping) << "Scraping should not be active after stop";
}

TEST_F(NaviGrabIntegrationTest, StorageIntegration) {
    // Test storage functionality
    
    // Create test data
    ScrapedPageData test_data;
    test_data.url = "https://test.example.com";
    test_data.title = "Test Page";
    test_data.timestamp = std::chrono::system_clock::now();
    test_data.extracted_data["test_key"] = "test_value";
    test_data.screenshot_paths.push_back("test_screenshot.png");
    
    // Store data
    std::string storage_id = storage_->StoreScrapedPageData(test_data);
    EXPECT_FALSE(storage_id.empty()) << "Storage ID should not be empty";
    
    // Verify data exists
    bool exists = storage_->ScrapedPageDataExists(storage_id);
    EXPECT_TRUE(exists) << "Data should exist after storage";
    
    // Retrieve data
    auto retrieved_data = storage_->RetrieveScrapedPageData(storage_id);
    EXPECT_TRUE(retrieved_data.has_value()) << "Data should be retrievable";
    
    if (retrieved_data) {
        EXPECT_EQ(retrieved_data->url, test_data.url) << "Retrieved URL should match";
        EXPECT_EQ(retrieved_data->title, test_data.title) << "Retrieved title should match";
        EXPECT_EQ(retrieved_data->extracted_data["test_key"], "test_value") << "Retrieved data should match";
    }
    
    // Test batch operations
    std::vector<ScrapedPageData> batch_data;
    for (int i = 0; i < 5; ++i) {
        ScrapedPageData data;
        data.url = "https://test" + std::to_string(i) + ".example.com";
        data.title = "Test Page " + std::to_string(i);
        data.timestamp = std::chrono::system_clock::now();
        batch_data.push_back(data);
    }
    
    auto batch_ids = storage_->StoreScrapedPageDataBatch(batch_data);
    EXPECT_EQ(batch_ids.size(), batch_data.size()) << "All batch data should be stored";
    
    // Retrieve batch data
    auto retrieved_batch = storage_->RetrieveScrapedPageDataBatch(batch_ids);
    EXPECT_EQ(retrieved_batch.size(), batch_data.size()) << "All batch data should be retrievable";
    
    // Test session management
    int test_session_id = 123;
    auto session_data = storage_->FindScrapedPageData(test_session_id);
    // This might be empty depending on implementation, but shouldn't crash
    EXPECT_NO_THROW({
        auto count = session_data.size();
    }) << "Session data query should not throw";
}

TEST_F(NaviGrabIntegrationTest, APILayerIntegration) {
    // Test API layer functionality
    
    // Initialize API layer
    APIConfig config;
    config.endpoint = "localhost:8080";
    config.max_connections = 10;
    
    bool init_success = api_layer_->Initialize(config);
    EXPECT_TRUE(init_success) << "API layer should initialize";
    
    // Test request handling
    APIRequest request;
    request.id = "test_request_1";
    request.method = "test_method";
    request.parameters["test_param"] = "test_value";
    
    // Register a test handler
    api_layer_->RegisterRequestHandler("test_method", 
        [](const APIRequest& req) -> APIResponse {
            APIResponse response;
            response.id = req.id;
            response.success = true;
            response.data["echo"] = req.parameters.at("test_param");
            return response;
        });
    
    // Send request
    auto future_response = api_layer_->SendRequest(request);
    
    // Wait for response (with timeout)
    auto status = future_response.wait_for(std::chrono::seconds(5));
    EXPECT_EQ(status, std::future_status::ready) << "Response should be ready";
    
    if (status == std::future_status::ready) {
        auto response = future_response.get();
        EXPECT_TRUE(response.success) << "Response should be successful";
        EXPECT_EQ(response.data["echo"], "test_value") << "Response data should match";
    }
    
    // Test event handling
    bool event_received = false;
    api_layer_->RegisterEventHandler(APIEvent::CONNECTION_ESTABLISHED, 
        [&event_received](const std::map<std::string, std::string>& data) {
            event_received = true;
        });
    
    // Emit test event
    api_layer_->EmitEvent(APIEvent::CONNECTION_ESTABLISHED, {{"test", "value"}});
    
    // Give some time for event processing
    std::this_thread::sleep_for(std::chrono::milliseconds(100));
    
    EXPECT_TRUE(event_received) << "Event should be received";
}

TEST_F(NaviGrabIntegrationTest, ErrorHandlingIntegration) {
    // Test error handling across all components
    
    // Test invalid context operations
    auto invalid_context = browser_control_->GetContext(99999);
    EXPECT_EQ(invalid_context, nullptr) << "Invalid context should return null";
    
    // Test invalid page operations
    auto page_id = context_->NewPage();
    auto page = context_->GetPage(page_id);
    context_->ClosePage(page_id);
    
    // Operations on closed page should handle gracefully
    EXPECT_NO_THROW({
        bool nav_result = page->Goto("https://example.com");
        std::string url = page->Url();
        std::string title = page->Title();
    }) << "Closed page operations should not throw";
    
    // Test invalid scraping session
    auto invalid_results = scraper_->GetScrapingResults(99999);
    EXPECT_TRUE(invalid_results.empty()) << "Invalid session should return empty results";
    
    bool stop_invalid = scraper_->StopScraping(99999);
    EXPECT_FALSE(stop_invalid) << "Stopping invalid session should fail gracefully";
    
    // Test invalid storage operations
    auto invalid_data = storage_->RetrieveScrapedPageData("invalid_id");
    EXPECT_FALSE(invalid_data.has_value()) << "Invalid storage ID should return null";
    
    bool invalid_exists = storage_->ScrapedPageDataExists("invalid_id");
    EXPECT_FALSE(invalid_exists) << "Invalid storage ID should not exist";
}

TEST_F(NaviGrabIntegrationTest, PerformanceIntegration) {
    // Test performance with multiple concurrent operations
    
    const int num_operations = 10;
    std::vector<std::thread> threads;
    std::vector<bool> results(num_operations, false);
    
    auto start_time = std::chrono::high_resolution_clock::now();
    
    for (int i = 0; i < num_operations; ++i) {
        threads.emplace_back([this, i, &results]() {
            try {
                // Create page and navigate
                auto page_id = context_->NewPage();
                auto page = context_->GetPage(page_id);
                page->Goto("https://example.com");
                
                // Take screenshot
                ScreenshotOptions options;
                options.path = "perf_test_" + std::to_string(i) + ".png";
                auto screenshot_result = screenshot_capture_->CapturePage(*page, options);
                
                // Start scraping
                ScrapingConfig config;
                config.start_url = "https://example.com";
                config.max_depth = 1;
                int session_id = scraper_->StartScraping(config);
                
                // Wait briefly
                std::this_thread::sleep_for(std::chrono::milliseconds(100));
                
                // Get results
                auto scraping_results = scraper_->GetScrapingResults(session_id);
                
                // Store data
                if (!scraping_results.empty()) {
                    std::string storage_id = storage_->StoreScrapedPageData(scraping_results[0]);
                    results[i] = !storage_id.empty();
                }
                
                // Cleanup
                scraper_->StopScraping(session_id);
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
    
    auto end_time = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time);
    
    // Check results
    int success_count = 0;
    for (bool result : results) {
        if (result) success_count++;
    }
    
    EXPECT_GT(success_count, num_operations / 2) << "At least half of operations should succeed";
    EXPECT_LT(duration.count(), 10000) << "Operations should complete within 10 seconds";
    
    std::cout << "Performance test: " << success_count << "/" << num_operations 
              << " operations succeeded in " << duration.count() << "ms" << std::endl;
}

