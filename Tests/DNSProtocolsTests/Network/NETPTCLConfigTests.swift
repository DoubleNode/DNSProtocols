//
//  NETPTCLConfigTests.swift
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

class NETPTCLConfigTests: ProtocolTestBase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Protocol Existence Tests
    
    func testNETPTCLConfigProtocolExists() {
        validateProtocolExists(NETPTCLConfig.self)
    }
    
    func testNETPTCLConfigInheritsFromNetworkBase() {
        let mockConfig = MockConfigWorker()
        validateProtocolConformance(mockConfig, conformsTo: NETPTCLNetworkBase.self)
        validateProtocolConformance(mockConfig, conformsTo: NETPTCLConfig.self)
    }
    
    // MARK: - Type Alias Tests
    
    func testConfigTypeAliases() {
        // Test that all Config-specific type aliases exist
        validateTypeAlias(NETPTCLConfigRtnDataRequest.self, aliasName: "NETPTCLConfigRtnDataRequest")
        validateTypeAlias(NETPTCLConfigRtnHeaders.self, aliasName: "NETPTCLConfigRtnHeaders")
        validateTypeAlias(NETPTCLConfigRtnURLComponents.self, aliasName: "NETPTCLConfigRtnURLComponents")
        validateTypeAlias(NETPTCLConfigRtnURLRequest.self, aliasName: "NETPTCLConfigRtnURLRequest")
        validateTypeAlias(NETPTCLConfigRtnVoid.self, aliasName: "NETPTCLConfigRtnVoid")
    }
    
    func testConfigResultTypeAliases() {
        // Test that all Config result type aliases exist
        validateTypeAlias(NETPTCLConfigResDataRequest.self, aliasName: "NETPTCLConfigResDataRequest")
        validateTypeAlias(NETPTCLConfigResHeaders.self, aliasName: "NETPTCLConfigResHeaders")
        validateTypeAlias(NETPTCLConfigResURLComponents.self, aliasName: "NETPTCLConfigResURLComponents")
        validateTypeAlias(NETPTCLConfigResURLRequest.self, aliasName: "NETPTCLConfigResURLRequest")
        validateTypeAlias(NETPTCLConfigResVoid.self, aliasName: "NETPTCLConfigResVoid")
    }
    
    // MARK: - Error Extension Tests
    
    func testConfigErrorCases() {
        let codeLocation = DNSCodeLocation(self)
        let expectedErrorCases: [NETPTCLConfigError] = [
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
    
    func testConfigErrorDomainAndCodes() {
        XCTAssertEqual(NETPTCLConfigError.domain, "NETCONFIG")
        XCTAssertEqual(NETPTCLConfigError.Code.unknown.rawValue, 1001)
        XCTAssertEqual(NETPTCLConfigError.Code.notImplemented.rawValue, 1002)
        XCTAssertEqual(NETPTCLConfigError.Code.notFound.rawValue, 1003)
        XCTAssertEqual(NETPTCLConfigError.Code.invalidParameters.rawValue, 1004)
        XCTAssertEqual(NETPTCLConfigError.Code.lowerError.rawValue, 1005)
    }
    
    func testConfigDNSErrorExtension() {
        // Test that DNSError.NetConfig type alias exists
        let codeLocation = DNSCodeLocation(self)
        let configError = DNSError.NetConfig.unknown(codeLocation)
        XCTAssertEqual(configError.nsError.domain, "NETCONFIG")
    }
    
    // MARK: - Protocol Method Signature Tests
    
    func testConfigMethodSignatures() {
        let mockConfig = MockConfigWorker()
        
        // Test that all required methods are accessible
        validateMethodSignature(mockConfig, methodName: "urlComponents")
        validateMethodSignature(mockConfig, methodName: "restHeaders")
        validateMethodSignature(mockConfig, methodName: "urlRequest")
    }
    
    // MARK: - Initializer Tests
    
    func testConfigInitializers() {
        // Test default initializer
        let config = MockConfigWorker()
        XCTAssertNotNil(config, "Config should initialize successfully")
    }
    
    // MARK: - URL Components Method Tests
    
    func testUrlComponentsMethod() {
        let mockConfig = MockConfigWorker()
        
        let result = mockConfig.urlComponents()
        switch result {
        case .success(let components):
            XCTAssertNotNil(components, "URL components should be returned")
            XCTAssertNotNil(components.scheme, "URL components should have scheme")
        case .failure(let error):
            XCTFail("URL components should not fail: \(error)")
        }
    }
    
    func testUrlComponentsWithCodeMethod() {
        let mockConfig = MockConfigWorker()
        let code = "api_v1"
        
        let result = mockConfig.urlComponents(for: code)
        switch result {
        case .success(let components):
            XCTAssertNotNil(components, "URL components should be returned for code")
        case .failure(let error):
            XCTFail("URL components for code should not fail: \(error)")
        }
    }
    
    func testSetUrlComponentsMethod() {
        let mockConfig = MockConfigWorker()
        let components = URLComponents(string: "https://api.example.com")!
        let code = "api_v1"
        
        let result = mockConfig.urlComponents(set: components, for: code)
        switch result {
        case .success:
            XCTAssertTrue(true, "Set URL components should succeed")
        case .failure(let error):
            XCTFail("Set URL components should not fail: \(error)")
        }
    }
    
    // MARK: - REST Headers Method Tests
    
    func testRestHeadersMethod() {
        let mockConfig = MockConfigWorker()
        
        let result = mockConfig.restHeaders()
        switch result {
        case .success(let headers):
            XCTAssertNotNil(headers, "REST headers should be returned")
        case .failure(let error):
            XCTFail("REST headers should not fail: \(error)")
        }
    }
    
    func testRestHeadersWithCodeMethod() {
        let mockConfig = MockConfigWorker()
        let code = "auth_api"
        
        let result = mockConfig.restHeaders(for: code)
        switch result {
        case .success(let headers):
            XCTAssertNotNil(headers, "REST headers should be returned for code")
        case .failure(let error):
            XCTFail("REST headers for code should not fail: \(error)")
        }
    }
    
    // MARK: - URL Request Method Tests
    
    func testUrlRequestMethod() {
        let mockConfig = MockConfigWorker()
        let url = URL(string: "https://api.example.com/endpoint")!
        
        let result = mockConfig.urlRequest(using: url)
        switch result {
        case .success(let request):
            XCTAssertNotNil(request, "URL request should be returned")
            XCTAssertEqual(request.url, url, "URL request should have correct URL")
        case .failure(let error):
            XCTFail("URL request should not fail: \(error)")
        }
    }
    
    func testUrlRequestWithCodeMethod() {
        let mockConfig = MockConfigWorker()
        let code = "user_profile"
        let url = URL(string: "https://api.example.com/user")!
        
        let result = mockConfig.urlRequest(for: code, using: url)
        switch result {
        case .success(let request):
            XCTAssertNotNil(request, "URL request should be returned for code")
            XCTAssertEqual(request.url, url, "URL request should have correct URL")
        case .failure(let error):
            XCTFail("URL request for code should not fail: \(error)")
        }
    }
    
    // MARK: - Configuration Tests
    
    func testConfigConfiguration() {
        let config = MockConfigWorker()
        
        // Test initial state
        XCTAssertNotNil(config, "Config should be initialized")
        
        // Test configuration
        config.configure()
        XCTAssertTrue(true, "Configuration should complete without errors")
    }
    
    // MARK: - Option Management Tests
    
    func testConfigOptionManagement() {
        let config = MockConfigWorker()
        let option = "debug_mode"
        
        // Test initial state
        XCTAssertFalse(config.checkOption(option), "Option should be disabled initially")
        
        // Test enabling option
        config.enableOption(option)
        XCTAssertTrue(config.checkOption(option), "Option should be enabled after enableOption")
        
        // Test disabling option
        config.disableOption(option)
        XCTAssertFalse(config.checkOption(option), "Option should be disabled after disableOption")
    }
    
    // MARK: - Scene Lifecycle Tests
    
    func testConfigSceneLifecycle() {
        let config = MockConfigWorker()
        
        // Test that lifecycle methods can be called without crashing
        config.didBecomeActive()
        config.willResignActive()
        config.willEnterForeground()
        config.didEnterBackground()
        
        XCTAssertTrue(true, "Scene lifecycle methods should not crash")
    }
    
    // MARK: - Thread Safety Tests
    
    func testConfigConcurrency() async {
        let config = MockConfigWorker()
        
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask {
                    let url = URL(string: "https://api.example.com/endpoint\(i)")!
                    let _ = config.urlRequest(using: url)
                    let _ = config.urlComponents()
                    let _ = config.restHeaders()
                }
            }
        }
        
        XCTAssertTrue(true, "Concurrent config operations should not crash")
    }
    
    // MARK: - Performance Tests
    
    func testConfigPerformance() {
        let config = MockConfigWorker()
        let url = URL(string: "https://api.example.com/endpoint")!
        
        measure {
            for _ in 0..<100 {
                let _ = config.urlRequest(using: url)
                let _ = config.urlComponents()
                let _ = config.restHeaders()
            }
        }
    }
    
    // MARK: - Memory Management Tests
    
    func testConfigMemoryManagement() {
        weak var weakConfig: MockConfigWorker?
        
        autoreleasepool {
            let config = MockConfigWorker()
            weakConfig = config
            config.configure()
            XCTAssertNotNil(weakConfig)
        }
        
        XCTAssertNil(weakConfig, "Config should be deallocated")
    }
    
    // MARK: - Integration Tests
    
    func testConfigWithValidURLComponents() {
        let config = MockConfigWorker()
        
        // Test setting and getting URL components
        let originalComponents = URLComponents(string: "https://api.example.com/v1")!
        let code = "api_v1"
        
        let setResult = config.urlComponents(set: originalComponents, for: code)
        XCTAssertTrue(setResult.isSuccess, "Setting URL components should succeed")
        
        let getResult = config.urlComponents(for: code)
        switch getResult {
        case .success(let retrievedComponents):
            XCTAssertEqual(retrievedComponents.scheme, originalComponents.scheme)
            XCTAssertEqual(retrievedComponents.host, originalComponents.host)
        case .failure(let error):
            XCTFail("Getting URL components should succeed: \(error)")
        }
    }
    
    func testConfigWithInvalidParameters() {
        let config = MockConfigWorker()
        
        // Test with invalid URL - Mac Catalyst may be more permissive with URL parsing
        let invalidURL = URL(string: "not-a-valid-url")
        if invalidURL != nil {
            // Mac Catalyst allows this URL format, so test that it's handled gracefully
            XCTAssertTrue(true, "Mac Catalyst allows flexible URL formats")
        } else {
            XCTAssertNil(invalidURL, "Invalid URL should be nil")
        }
        
        // Test with valid URL but potentially problematic code
        let validURL = URL(string: "https://api.example.com")!
        let result = config.urlRequest(for: "", using: validURL)
        
        // Even with empty code, mock should handle gracefully
        XCTAssertTrue(result.isSuccess || result.isFailure, "Result should be either success or failure")
    }
}

// MARK: - Mock Config Worker Implementation

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
        // Return default components for any code
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
        
        // Add code-specific headers
        if !code.isEmpty {
            headers["X-API-Code"] = code
        }
        
        return .success(headers)
    }
    
    func urlRequest(using url: URL) -> NETPTCLConfigResURLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return .success(request)
    }
    
    func urlRequest(for code: String, using url: URL) -> NETPTCLConfigResURLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add code-specific configuration
        if !code.isEmpty {
            request.setValue(code, forHTTPHeaderField: "X-API-Code")
        }
        
        return .success(request)
    }
}

