#include "include/base/base_stubs.h"
#include <iostream>

int main() {
    std::cout << "Testing base stubs..." << std::endl;
    
    // Test basic types
    base::Value value("test");
    std::cout << "Value test: " << value.GetString() << std::endl;
    
    // Test singleton
    auto* singleton = base::Singleton<int>::GetInstance();
    std::cout << "Singleton test: " << singleton << std::endl;
    
    // Test callback
    auto callback = base::BindOnce([]() { return 42; });
    std::cout << "Callback test: " << callback.Run() << std::endl;
    
    std::cout << "Base stubs test completed successfully!" << std::endl;
    return 0;
}
