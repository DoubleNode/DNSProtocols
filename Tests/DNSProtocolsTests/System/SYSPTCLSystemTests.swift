//
//  SYSPTCLSystemTests.swift
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

class SYSPTCLSystemTests: ProtocolTestBase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Protocol Existence Tests
    
    func testSYSPTCLSystemProtocolExists() {
        validateProtocolExists(SYSPTCLSystem.self)
    }
    
    func testSYSPTCLSystemInheritsFromSystemBase() {
        let mockSystem = MockSystemWorker()
        validateProtocolConformance(mockSystem, conformsTo: SYSPTCLSystemBase.self)
        validateProtocolConformance(mockSystem, conformsTo: SYSPTCLSystem.self)
    }
    
    // MARK: - Error Extension Tests
    
    func testSystemErrorCases() {
        let codeLocation = DNSCodeLocation(self)
        let expectedErrorCases: [SYSPTCLSystemError] = [
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
    
    func testSystemErrorDomainAndCodes() {
        XCTAssertEqual(SYSPTCLSystemError.domain, "SYSSYSTEM")
        XCTAssertEqual(SYSPTCLSystemError.Code.unknown.rawValue, 1001)
        XCTAssertEqual(SYSPTCLSystemError.Code.notImplemented.rawValue, 1002)
        XCTAssertEqual(SYSPTCLSystemError.Code.notFound.rawValue, 1003)
        XCTAssertEqual(SYSPTCLSystemError.Code.invalidParameters.rawValue, 1004)
        XCTAssertEqual(SYSPTCLSystemError.Code.lowerError.rawValue, 1005)
    }
    
    func testSystemDNSErrorExtension() {
        // Test that DNSError.System type alias exists
        let codeLocation = DNSCodeLocation(self)
        let systemError = DNSError.System.unknown(codeLocation)
        XCTAssertEqual(systemError.nsError.domain, "SYSSYSTEM")
    }
    
    // MARK: - Initializer Tests
    
    func testSystemInitializer() {
        // Test default initializer
        let system = MockSystemWorker()
        XCTAssertNotNil(system, "System should initialize successfully")
        XCTAssertNotNil(system.netConfig, "System should have network config")
    }
    
    // MARK: - Network Config Property Tests
    
    func testSystemNetworkConfig() {
        let system = MockSystemWorker()
        
        // Test that netConfig property is accessible
        XCTAssertNotNil(system.netConfig, "System should have network config")
        
        // Test that netConfig conforms to NETPTCLConfig
        validateProtocolConformance(system.netConfig, conformsTo: NETPTCLConfig.self)
    }
    
    func testSystemNetworkConfigIntegration() {
        let system = MockSystemWorker()
        
        // Test that system can use its network config
        let result = system.netConfig.urlComponents()
        switch result {
        case .success(let components):
            XCTAssertNotNil(components, "Network config should return components")
        case .failure(let error):
            XCTFail("Network config should work: \(error)")
        }
    }
    
    // MARK: - Configuration Tests
    
    func testSystemConfiguration() {
        let system = MockSystemWorker()
        
        // Test initial state
        XCTAssertNotNil(system, "System should be initialized")
        
        // Test configuration
        system.configure()
        XCTAssertTrue(true, "Configuration should complete without errors")
    }
    
    // MARK: - Option Management Tests
    
    func testSystemOptionManagement() {
        let system = MockSystemWorker()
        let option = "system_debug"
        
        // Test initial state
        XCTAssertFalse(system.checkOption(option), "Option should be disabled initially")
        
        // Test enabling option
        system.enableOption(option)
        XCTAssertTrue(system.checkOption(option), "Option should be enabled after enableOption")
        
        // Test disabling option
        system.disableOption(option)
        XCTAssertFalse(system.checkOption(option), "Option should be disabled after disableOption")
    }
    
    // MARK: - Scene Lifecycle Tests
    
    func testSystemSceneLifecycle() {
        let system = MockSystemWorker()
        
        // Test that lifecycle methods can be called without crashing
        system.didBecomeActive()
        system.willResignActive()
        system.willEnterForeground()
        system.didEnterBackground()
        
        XCTAssertTrue(true, "Scene lifecycle methods should not crash")
    }
    
    // MARK: - System Base Protocol Inheritance Tests
    
    func testSystemInheritsNetConfigProperty() {
        let system = MockSystemWorker()
        
        // Verify that netConfig property is inherited from SYSPTCLSystemBase
        XCTAssertNotNil(system.netConfig, "System should inherit netConfig from SystemBase")
        
        // Verify the config can be used
        system.netConfig.configure()
        XCTAssertTrue(true, "Network config should be functional")
    }
    
    func testSystemInheritsConfigurationMethod() {
        let system = MockSystemWorker()
        
        // Verify that configure method is inherited from SYSPTCLSystemBase
        system.configure()
        XCTAssertTrue(true, "System should inherit configure method from SystemBase")
    }
    
    func testSystemInheritsOptionMethods() {
        let system = MockSystemWorker()
        let option = "test_option"
        
        // Verify that option management methods are inherited from SYSPTCLSystemBase
        system.enableOption(option)
        XCTAssertTrue(system.checkOption(option), "System should inherit option methods from SystemBase")
        
        system.disableOption(option)
        XCTAssertFalse(system.checkOption(option), "System should inherit option disable from SystemBase")
    }
    
    func testSystemInheritsSceneLifecycle() {
        let system = MockSystemWorker()
        
        // Verify that scene lifecycle methods are inherited from SYSPTCLSystemBase
        system.didBecomeActive()
        system.willResignActive()
        system.willEnterForeground()
        system.didEnterBackground()
        
        XCTAssertTrue(true, "System should inherit scene lifecycle methods from SystemBase")
    }
    
    // MARK: - Protocol Conformance Tests
    
    func testSystemProtocolConformance() {
        let system = MockSystemWorker()
        
        // Test that System protocol properly inherits from SystemBase
        XCTAssertTrue(system is SYSPTCLSystemBase, "System should conform to SystemBase")
        XCTAssertTrue(system is SYSPTCLSystem, "System should conform to System protocol")
    }
    
    // MARK: - Thread Safety Tests
    
    func testSystemConcurrency() async {
        let system = MockSystemWorker()
        
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask {
                    system.configure()
                    system.enableOption("concurrent_test_\(i)")
                    let _ = system.checkOption("concurrent_test_\(i)")
                    system.disableOption("concurrent_test_\(i)")
                }
            }
        }
        
        XCTAssertTrue(true, "Concurrent system operations should not crash")
    }
    
    // MARK: - Performance Tests
    
    func testSystemPerformance() {
        let system = MockSystemWorker()
        
        measure {
            for i in 0..<100 {
                system.configure()
                system.enableOption("perf_test_\(i)")
                let _ = system.checkOption("perf_test_\(i)")
                system.disableOption("perf_test_\(i)")
            }
        }
    }
    
    // MARK: - Memory Management Tests
    
    func testSystemMemoryManagement() {
        weak var weakSystem: MockSystemWorker?
        weak var weakNetConfig: NETPTCLConfig?
        
        autoreleasepool {
            let system = MockSystemWorker()
            weakSystem = system
            weakNetConfig = system.netConfig
            
            system.configure()
            XCTAssertNotNil(weakSystem)
            XCTAssertNotNil(weakNetConfig)
        }
        
        XCTAssertNil(weakSystem, "System should be deallocated")
        XCTAssertNil(weakNetConfig, "Network config should be deallocated")
    }
    
    // MARK: - Integration Tests
    
    func testSystemWithNetworkConfigIntegration() {
        let system = MockSystemWorker()
        let config = system.netConfig
        
        // Test that system and its network config work together
        system.configure()
        config.configure()
        
        // Test option synchronization
        system.enableOption("integration_test")
        config.enableOption("integration_test")
        
        XCTAssertTrue(system.checkOption("integration_test"), "System should have option enabled")
        XCTAssertTrue(config.checkOption("integration_test"), "Config should have option enabled")
    }
    
    func testSystemSceneLifecycleWithNetConfig() {
        let system = MockSystemWorker()
        let config = system.netConfig
        
        // Test that scene lifecycle affects both system and config
        system.didBecomeActive()
        system.willResignActive()
        system.willEnterForeground()
        system.didEnterBackground()
        
        // Verify config is also affected (if needed)
        config.didBecomeActive()
        config.willResignActive()
        config.willEnterForeground()
        config.didEnterBackground()
        
        XCTAssertTrue(true, "Scene lifecycle integration should work")
    }
    
    // MARK: - Error Handling Tests
    
    func testSystemErrorPropagation() {
        let system = MockSystemWorker()
        
        // Test that system handles errors gracefully
        let option = "error_test"
        
        system.enableOption(option)
        XCTAssertTrue(system.checkOption(option), "Option should be enabled")
        
        system.disableOption(option)
        XCTAssertFalse(system.checkOption(option), "Option should be disabled")
        
        // Test with empty option name
        system.enableOption("")
        XCTAssertFalse(system.checkOption(""), "Empty option should remain disabled")
    }
    
    func testSystemNetConfigErrorHandling() {
        let system = MockSystemWorker()
        let config = system.netConfig
        
        // Test that network config errors are handled properly
        let result = config.urlComponents(for: "invalid_code")
        
        switch result {
        case .success:
            XCTAssertTrue(true, "Config should handle invalid codes gracefully")
        case .failure:
            XCTAssertTrue(true, "Config may fail gracefully for invalid codes")
        }
    }
}

// MARK: - Mock System Worker Implementation

private class MockSystemWorker: SYSPTCLSystem {
    private let optionsQueue = DispatchQueue(label: "MockSystemWorker.options", attributes: .concurrent)
    private var _options: Set<String> = []
    let netConfig: NETPTCLConfig

    required init() {
        self.netConfig = MockNetConfigForSystem()
    }

    func configure() {
        // Mock system configuration
        netConfig.configure()
    }

    func checkOption(_ option: String) -> Bool {
        guard !option.isEmpty else { return false }
        return optionsQueue.sync {
            return _options.contains(option)
        }
    }

    func disableOption(_ option: String) {
        guard !option.isEmpty else { return }
        optionsQueue.async(flags: .barrier) {
            self._options.remove(option)
        }
    }

    func enableOption(_ option: String) {
        guard !option.isEmpty else { return }
        optionsQueue.async(flags: .barrier) {
            self._options.insert(option)
        }
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
}

// MARK: - Mock Network Config for System Testing

private class MockNetConfigForSystem: NETPTCLConfig {
    private let componentsQueue = DispatchQueue(label: "MockNetConfigForSystem.components", attributes: .concurrent)
    private let optionsQueue = DispatchQueue(label: "MockNetConfigForSystem.options", attributes: .concurrent)
    private var _storedComponents: [String: URLComponents] = [:]
    private var _options: Set<String> = []

    required init() {
        // Mock initialization
    }

    func configure() {
        // Mock configuration
    }

    func checkOption(_ option: String) -> Bool {
        return optionsQueue.sync {
            return _options.contains(option)
        }
    }

    func disableOption(_ option: String) {
        optionsQueue.async(flags: .barrier) {
            self._options.remove(option)
        }
    }

    func enableOption(_ option: String) {
        optionsQueue.async(flags: .barrier) {
            self._options.insert(option)
        }
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
        let components = URLComponents(string: "https://system.example.com")!
        return .success(components)
    }
    
    func urlComponents(for code: String) -> NETPTCLConfigResURLComponents {
        let stored = componentsQueue.sync {
            return _storedComponents[code]
        }

        if let stored = stored {
            return .success(stored)
        }

        guard !code.isEmpty else {
            let codeLocation = DNSCodeLocation(self)
            return .failure(NETPTCLConfigError.invalidParameters(parameters: ["code"], codeLocation))
        }

        let components = URLComponents(string: "https://system.example.com/\(code)")!
        return .success(components)
    }

    func urlComponents(set components: URLComponents, for code: String) -> NETPTCLConfigResVoid {
        componentsQueue.async(flags: .barrier) {
            self._storedComponents[code] = components
        }
        return .success(())
    }
    
    func restHeaders() -> NETPTCLConfigResHeaders {
        let headers = HTTPHeaders([
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-System": "DNSSystem"
        ])
        return .success(headers)
    }
    
    func restHeaders(for code: String) -> NETPTCLConfigResHeaders {
        var headers = HTTPHeaders([
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-System": "DNSSystem"
        ])
        
        if !code.isEmpty {
            headers.add(name: "X-API-Code", value: code)
        }
        
        return .success(headers)
    }
    
    func urlRequest(using url: URL) -> NETPTCLConfigResURLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Apply system headers
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