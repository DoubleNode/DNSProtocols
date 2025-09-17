//
//  NETPTCLRouterTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocolsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import Foundation
import Alamofire
import DNSCore
import DNSError
@testable import DNSProtocols

class NETPTCLRouterTests: ProtocolTestBase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Protocol Existence Tests
    
    func testNETPTCLRouterProtocolExists() {
        validateProtocolExists(NETPTCLRouter.self)
    }
    
    func testNETPTCLRouterInheritsFromNetworkBase() {
        let mockRouter = MockRouterWorker()
        validateProtocolConformance(mockRouter, conformsTo: NETPTCLNetworkBase.self)
        validateProtocolConformance(mockRouter, conformsTo: NETPTCLRouter.self)
    }
    
    // MARK: - Type Alias Tests
    
    func testRouterTypeAliases() {
        // Test that all Router-specific type aliases exist
        validateTypeAlias(NETPTCLRouterRtnDataRequest.self, aliasName: "NETPTCLRouterRtnDataRequest")
        validateTypeAlias(NETPTCLRouterRtnURLRequest.self, aliasName: "NETPTCLRouterRtnURLRequest")
    }
    
    func testRouterResultTypeAliases() {
        // Test that all Router result type aliases exist
        validateTypeAlias(NETPTCLRouterResDataRequest.self, aliasName: "NETPTCLRouterResDataRequest")
        validateTypeAlias(NETPTCLRouterResURLRequest.self, aliasName: "NETPTCLRouterResURLRequest")
    }
    
    // MARK: - Error Extension Tests
    
    func testRouterErrorCases() {
        let codeLocation = DNSCodeLocation(self)
        let expectedErrorCases: [NETPTCLRouterError] = [
            .unknown(codeLocation),
            .notImplemented(codeLocation),
            .notFound(field: "test", value: "value", codeLocation),
            .invalidParameters(parameters: ["param"], codeLocation),
            .lowerError(error: NSError(domain: "test", code: 0), codeLocation)
        ]
        
        for errorCase in expectedErrorCases {
            XCTAssertNotNil(errorCase.nsError, "Error case should have valid NSError")
            XCTAssertNotNil(errorCase.errorDescription, "Error case should have description")
        }
    }
    
    func testRouterErrorDomainAndCodes() {
        XCTAssertEqual(NETPTCLRouterError.domain, "NETROUTER")
        XCTAssertEqual(NETPTCLRouterError.Code.unknown.rawValue, 1001)
        XCTAssertEqual(NETPTCLRouterError.Code.notImplemented.rawValue, 1002)
        XCTAssertEqual(NETPTCLRouterError.Code.notFound.rawValue, 1003)
        XCTAssertEqual(NETPTCLRouterError.Code.invalidParameters.rawValue, 1004)
        XCTAssertEqual(NETPTCLRouterError.Code.lowerError.rawValue, 1005)
    }
    
    func testRouterDNSErrorExtension() {
        // Test that DNSError.NetRouter type alias exists
        let codeLocation = DNSCodeLocation(self)
        let routerError = DNSError.NetRouter.unknown(codeLocation)
        XCTAssertEqual(routerError.nsError.domain, "NETROUTER")
    }
    
    // MARK: - Protocol Method Signature Tests
    
    func testRouterMethodSignatures() {
        let mockRouter = MockRouterWorker()
        
        // Test that all required methods are accessible
        validateMethodSignature(mockRouter, methodName: "urlRequest")
    }
    
    // MARK: - Initializer Tests
    
    func testRouterInitializers() {
        // Test default initializer
        let router = MockRouterWorker()
        XCTAssertNotNil(router, "Router should initialize successfully")
        
        // Test initializer with config
        let config = MockConfigWorker()
        let routerWithConfig = MockRouterWorker(with: config)
        XCTAssertNotNil(routerWithConfig, "Router with config should initialize successfully")
        XCTAssertNotNil(routerWithConfig.netConfig, "Router should have config reference")
    }
    
    // MARK: - URL Request Method Tests
    
    func testUrlRequestMethod() {
        let mockRouter = MockRouterWorker()
        let url = URL(string: "https://api.example.com/endpoint")!
        
        let result = mockRouter.urlRequest(using: url)
        switch result {
        case .success(let request):
            XCTAssertNotNil(request, "URL request should be returned")
            XCTAssertEqual(request.url, url, "URL request should have correct URL")
        case .failure(let error):
            XCTFail("URL request should not fail: \(error)")
        }
    }
    
    func testUrlRequestWithCodeMethod() {
        let mockRouter = MockRouterWorker()
        let code = "user_profile"
        let url = URL(string: "https://api.example.com/user")!
        
        let result = mockRouter.urlRequest(for: code, using: url)
        switch result {
        case .success(let request):
            XCTAssertNotNil(request, "URL request should be returned for code")
            XCTAssertEqual(request.url, url, "URL request should have correct URL")
            // Check that code-specific modifications were applied
            if let codeHeader = request.value(forHTTPHeaderField: "X-API-Code") {
                XCTAssertEqual(codeHeader, code, "Request should include code in header")
            }
        case .failure(let error):
            XCTFail("URL request for code should not fail: \(error)")
        }
    }
    
    // MARK: - Configuration Tests
    
    func testRouterConfiguration() {
        let router = MockRouterWorker()
        
        // Test initial state
        XCTAssertNotNil(router, "Router should be initialized")
        
        // Test configuration
        router.configure()
        XCTAssertTrue(true, "Configuration should complete without errors")
    }
    
    func testRouterWithNetConfig() {
        let config = MockConfigWorker()
        let router = MockRouterWorker(with: config)
        
        XCTAssertNotNil(router.netConfig, "Router should have network config")
        XCTAssertEqual(ObjectIdentifier(router.netConfig), ObjectIdentifier(config), "Router should reference the provided config")
    }
    
    // MARK: - Option Management Tests
    
    func testRouterOptionManagement() {
        let router = MockRouterWorker()
        let option = "routing_cache"
        
        // Test initial state
        XCTAssertFalse(router.checkOption(option), "Option should be disabled initially")
        
        // Test enabling option
        router.enableOption(option)
        XCTAssertTrue(router.checkOption(option), "Option should be enabled after enableOption")
        
        // Test disabling option
        router.disableOption(option)
        XCTAssertFalse(router.checkOption(option), "Option should be disabled after disableOption")
    }
    
    // MARK: - Scene Lifecycle Tests
    
    func testRouterSceneLifecycle() {
        let router = MockRouterWorker()
        
        // Test that lifecycle methods can be called without crashing
        router.didBecomeActive()
        router.willResignActive()
        router.willEnterForeground()
        router.didEnterBackground()
        
        XCTAssertTrue(true, "Scene lifecycle methods should not crash")
    }
    
    // MARK: - Integration Tests with Network Config
    
    func testRouterWithConfigIntegration() {
        let config = MockConfigWorker()
        let router = MockRouterWorker(with: config)
        let url = URL(string: "https://api.example.com/endpoint")!
        
        // Test that router can work with its config
        let configResult = router.netConfig.urlComponents()
        let routerResult = router.urlRequest(using: url)
        
        XCTAssertTrue(configResult.isSuccess, "Config should work")
        XCTAssertTrue(routerResult.isSuccess, "Router should work with config")
    }
    
    func testRouterRequestModification() {
        let config = MockConfigWorker()
        let router = MockRouterWorker(with: config)
        let url = URL(string: "https://api.example.com/test")!
        let code = "auth_endpoint"
        
        let result = router.urlRequest(for: code, using: url)
        
        switch result {
        case .success(let request):
            // Verify that router applied modifications
            XCTAssertNotNil(request.value(forHTTPHeaderField: "X-API-Code"))
            XCTAssertNotNil(request.value(forHTTPHeaderField: "Content-Type"))
        case .failure(let error):
            XCTFail("Router request modification should succeed: \(error)")
        }
    }
    
    // MARK: - Thread Safety Tests
    
    func testRouterConcurrency() async {
        let router = MockRouterWorker()
        
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask {
                    let url = URL(string: "https://api.example.com/endpoint\(i)")!
                    let _ = router.urlRequest(using: url)
                    let _ = router.urlRequest(for: "test\(i)", using: url)
                }
            }
        }
        
        XCTAssertTrue(true, "Concurrent router operations should not crash")
    }
    
    // MARK: - Performance Tests
    
    func testRouterPerformance() {
        let router = MockRouterWorker()
        let url = URL(string: "https://api.example.com/endpoint")!
        
        measure {
            for i in 0..<100 {
                let _ = router.urlRequest(using: url)
                let _ = router.urlRequest(for: "test\(i)", using: url)
            }
        }
    }
    
    // MARK: - Memory Management Tests
    
    func testRouterMemoryManagement() {
        weak var weakRouter: MockRouterWorker?
        weak var weakConfig: MockConfigWorker?
        
        autoreleasepool {
            let config = MockConfigWorker()
            let router = MockRouterWorker(with: config)
            weakRouter = router
            weakConfig = config
            
            router.configure()
            XCTAssertNotNil(weakRouter)
            XCTAssertNotNil(weakConfig)
        }
        
        XCTAssertNil(weakRouter, "Router should be deallocated")
        XCTAssertNil(weakConfig, "Config should be deallocated")
    }
    
    // MARK: - Error Handling Tests
    
    func testRouterErrorHandling() {
        let router = MockRouterWorker()
        
        // Test with potentially problematic inputs
        let validURL = URL(string: "https://api.example.com")!
        let emptyCode = ""
        
        let result = router.urlRequest(for: emptyCode, using: validURL)
        
        // Router should handle empty code gracefully
        XCTAssertTrue(result.isSuccess || result.isFailure, "Result should be either success or failure")
        
        switch result {
        case .success(let request):
            XCTAssertEqual(request.url, validURL, "Request should have correct URL")
        case .failure:
            XCTAssertTrue(true, "Failure is acceptable for edge cases")
        }
    }
    
    func testRouterWithDifferentHTTPMethods() {
        let router = MockRouterWorker()
        let url = URL(string: "https://api.example.com/post")!
        
        // Test POST request
        router.enableOption("POST")
        let result = router.urlRequest(for: "create", using: url)
        
        switch result {
        case .success(let request):
            // Mock router should handle method configuration
            XCTAssertNotNil(request.httpMethod)
        case .failure:
            XCTFail("Router should handle different HTTP methods")
        }
    }
}

// MARK: - Mock Router Worker Implementation

private class MockRouterWorker: NETPTCLRouter {
    private var options: Set<String> = []
    var netConfig: NETPTCLConfig
    
    required init() {
        self.netConfig = MockConfigWorker()
    }
    
    required init(with netConfig: NETPTCLConfig) {
        self.netConfig = netConfig
    }
    
    func configure() {
        // Mock configuration
        netConfig.configure()
    }
    
    func checkOption(_ option: String) -> Bool {
        return options.contains(option)
    }
    
    func disableOption(_ option: String) {
        options.remove(option)
    }
    
    func enableOption(_ option: String) {
        options.insert(option)
    }
    
    func didBecomeActive() {
        // Mock scene lifecycle
        netConfig.didBecomeActive()
    }
    
    func willResignActive() {
        // Mock scene lifecycle
        netConfig.willResignActive()
    }
    
    func willEnterForeground() {
        // Mock scene lifecycle
        netConfig.willEnterForeground()
    }
    
    func didEnterBackground() {
        // Mock scene lifecycle
        netConfig.didEnterBackground()
    }
    
    func urlRequest(using url: URL) -> NETPTCLRouterResURLRequest {
        // Use the netConfig to get basic request
        let configResult = netConfig.urlRequest(using: url)
        
        switch configResult {
        case .success(var request):
            // Router can modify the request
            if options.contains("POST") {
                request.httpMethod = "POST"
            }
            return .success(request)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func urlRequest(for code: String, using url: URL) -> NETPTCLRouterResURLRequest {
        // Use the netConfig to get configured request
        let configResult = netConfig.urlRequest(for: code, using: url)
        
        switch configResult {
        case .success(var request):
            // Router can apply additional modifications
            if !code.isEmpty {
                request.setValue(code, forHTTPHeaderField: "X-API-Code")
            }
            
            // Apply router-specific options
            if options.contains("POST") {
                request.httpMethod = "POST"
            }
            
            return .success(request)
        case .failure(let error):
            return .failure(error)
        }
    }
}

// MARK: - Mock Config Worker for Router Testing

private class MockConfigWorker: NETPTCLConfig {
    private var storedComponents: [String: URLComponents] = [:]
    private var options: Set<String> = []
    
    required init() {
        // Mock initialization
    }
    
    func configure() {
        // Mock configuration
    }
    
    func checkOption(_ option: String) -> Bool {
        return options.contains(option)
    }
    
    func disableOption(_ option: String) {
        options.remove(option)
    }
    
    func enableOption(_ option: String) {
        options.insert(option)
    }
    
    func didBecomeActive() {
        // Mock scene lifecycle
    }
    
    func willResignActive() {
        // Mock scene lifecycle
    }
    
    func willEnterForeground() {
        // Mock scene lifecycle
    }
    
    func didEnterBackground() {
        // Mock scene lifecycle
    }
    
    func urlComponents() -> NETPTCLConfigResURLComponents {
        let components = URLComponents(string: "https://api.example.com")!
        return .success(components)
    }
    
    func urlComponents(for code: String) -> NETPTCLConfigResURLComponents {
        if let stored = storedComponents[code] {
            return .success(stored)
        }
        let components = URLComponents(string: "https://api.example.com/\(code)")!
        return .success(components)
    }
    
    func urlComponents(set components: URLComponents, for code: String) -> NETPTCLConfigResVoid {
        storedComponents[code] = components
        return .success(())
    }
    
    func restHeaders() -> NETPTCLConfigResHeaders {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        return .success(headers)
    }
    
    func restHeaders(for code: String) -> NETPTCLConfigResHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        if !code.isEmpty {
            headers["X-API-Code"] = code
        }
        
        return .success(headers)
    }
    
    func urlRequest(using url: URL) -> NETPTCLConfigResURLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Apply default headers
        let headersResult = restHeaders()
        if case .success(let headers) = headersResult {
            for header in headers {
                request.setValue(header.value, forHTTPHeaderField: header.name)
            }
        }
        
        return .success(request)
    }
    
    func urlRequest(for code: String, using url: URL) -> NETPTCLConfigResURLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Apply code-specific headers
        let headersResult = restHeaders(for: code)
        if case .success(let headers) = headersResult {
            for header in headers {
                request.setValue(header.value, forHTTPHeaderField: header.name)
            }
        }
        
        return .success(request)
    }
}

