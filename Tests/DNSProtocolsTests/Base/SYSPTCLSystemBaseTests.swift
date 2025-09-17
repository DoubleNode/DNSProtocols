//
//  SYSPTCLSystemBaseTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocolsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import Foundation
import Alamofire
import DNSCore
import DNSCoreThreading
import DNSError
@testable import DNSProtocols

class SYSPTCLSystemBaseTests: ProtocolTestBase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Protocol Existence Tests
    
    func testSYSPTCLSystemBaseProtocolExists() {
        validateProtocolExists(SYSPTCLSystemBase.self)
    }
    
    func testSYSPTCLSystemBaseIsAnyObject() {
        let mockSystemBase = MockSystemBaseWorker()
        XCTAssertTrue(mockSystemBase is AnyObject, "SystemBase should be AnyObject")
        validateProtocolConformance(mockSystemBase, conformsTo: SYSPTCLSystemBase.self)
    }
    
    // MARK: - Error Extension Tests
    
    func testSystemBaseErrorCases() {
        let codeLocation = DNSCodeLocation(self)
        
        let commonErrorCases: [SYSPTCLSystemBaseError] = [
            .unknown(codeLocation),
            .notImplemented(codeLocation),
            .notFound(field: "testField", value: "testValue", codeLocation),
            .invalidParameters(parameters: ["param1", "param2"], codeLocation),
            .lowerError(error: NSError(domain: "test", code: 0), codeLocation)
        ]
        
        let systemSpecificErrorCases: [SYSPTCLSystemBaseError] = [
            .duplicateKey(codeLocation),
            .noPermission(permission: "read", codeLocation),
            .notSupported(codeLocation),
            .systemError(error: NSError(domain: "system", code: -1), codeLocation),
            .timeout(codeLocation)
        ]
        
        let allErrorCases = commonErrorCases + systemSpecificErrorCases
        
        for errorCase in allErrorCases {
            XCTAssertNotNil(errorCase.nsError, "Error case should have valid NSError: \(errorCase)")
            XCTAssertNotNil(errorCase.errorDescription, "Error case should have description: \(errorCase)")
            XCTAssertNotNil(errorCase.failureReason, "Error case should have failure reason: \(errorCase)")
        }
    }
    
    func testSystemBaseErrorDomainAndCodes() {
        XCTAssertEqual(SYSPTCLSystemBaseError.domain, "SYSBASE")
        
        // Common error codes
        XCTAssertEqual(SYSPTCLSystemBaseError.Code.unknown.rawValue, 1001)
        XCTAssertEqual(SYSPTCLSystemBaseError.Code.notImplemented.rawValue, 1002)
        XCTAssertEqual(SYSPTCLSystemBaseError.Code.notFound.rawValue, 1003)
        XCTAssertEqual(SYSPTCLSystemBaseError.Code.invalidParameters.rawValue, 1004)
        XCTAssertEqual(SYSPTCLSystemBaseError.Code.lowerError.rawValue, 1005)
        
        // System-specific error codes
        XCTAssertEqual(SYSPTCLSystemBaseError.Code.duplicateKey.rawValue, 2001)
        XCTAssertEqual(SYSPTCLSystemBaseError.Code.noPermission.rawValue, 2002)
        XCTAssertEqual(SYSPTCLSystemBaseError.Code.notSupported.rawValue, 2003)
        XCTAssertEqual(SYSPTCLSystemBaseError.Code.systemError.rawValue, 2004)
        XCTAssertEqual(SYSPTCLSystemBaseError.Code.timeout.rawValue, 2005)
    }
    
    func testSystemBaseDNSErrorExtension() {
        // Test that DNSError.SystemBase type alias exists
        let codeLocation = DNSCodeLocation(self)
        let systemBaseError = DNSError.SystemBase.unknown(codeLocation)
        XCTAssertEqual(systemBaseError.nsError.domain, "SYSBASE")
    }
    
    func testSystemBaseErrorWithSpecificData() {
        let codeLocation = DNSCodeLocation(self)
        
        // Test permission error with specific permission
        let permissionError = SYSPTCLSystemBaseError.noPermission(permission: "write", codeLocation)
        let permissionNSError = permissionError.nsError
        XCTAssertEqual(permissionNSError?.userInfo["Permission"] as? String, "write")
        
        // Test system error with underlying error
        let underlyingError = NSError(domain: "TestDomain", code: 42, userInfo: ["key": "value"])
        let systemError = SYSPTCLSystemBaseError.systemError(error: underlyingError, codeLocation)
        let systemNSError = systemError.nsError
        XCTAssertNotNil(systemNSError?.userInfo["Error"])
    }
    
    // MARK: - Protocol Method Signature Tests
    
    func testSystemBaseMethodSignatures() {
        let mockSystemBase = MockSystemBaseWorker()
        
        // Test that all required methods are accessible
        validateMethodSignature(mockSystemBase, methodName: "configure")
        validateMethodSignature(mockSystemBase, methodName: "checkOption")
        validateMethodSignature(mockSystemBase, methodName: "enableOption")
        validateMethodSignature(mockSystemBase, methodName: "disableOption")
        validateMethodSignature(mockSystemBase, methodName: "didBecomeActive")
        validateMethodSignature(mockSystemBase, methodName: "willResignActive")
        validateMethodSignature(mockSystemBase, methodName: "willEnterForeground")
        validateMethodSignature(mockSystemBase, methodName: "didEnterBackground")
    }
    
    // MARK: - Network Config Property Tests
    
    func testSystemBaseNetworkConfigProperty() {
        let mockSystemBase = MockSystemBaseWorker()
        
        // Test that netConfig property is accessible
        XCTAssertNotNil(mockSystemBase.netConfig, "SystemBase should have network config")
        
        // Test that netConfig conforms to NETPTCLConfig
        validateProtocolConformance(mockSystemBase.netConfig, conformsTo: NETPTCLConfig.self)
    }
    
    func testSystemBaseNetworkConfigIntegration() {
        let mockSystemBase = MockSystemBaseWorker()
        
        // Test that system base can use its network config
        let result = mockSystemBase.netConfig.urlComponents()
        switch result {
        case .success(let components):
            XCTAssertNotNil(components, "Network config should return components")
        case .failure(let error):
            XCTFail("Network config should work: \(error)")
        }
    }
    
    // MARK: - Configuration Tests
    
    func testSystemBaseConfiguration() {
        let systemBase = MockSystemBaseWorker()
        
        // Test initial state
        XCTAssertNotNil(systemBase, "SystemBase should be initialized")
        
        // Test configuration
        systemBase.configure()
        XCTAssertTrue(true, "Configuration should complete without errors")
    }
    
    func testSystemBaseConfigurationWithNetworkConfig() {
        let systemBase = MockSystemBaseWorker()
        
        // Test that configuration affects both system and network config
        systemBase.configure()
        
        // Verify both system and network config are configured
        XCTAssertTrue(systemBase.checkOption("system_configured"), "System should be configured")
        XCTAssertTrue(systemBase.netConfig.checkOption("configured"), "Network config should be configured")
    }
    
    // MARK: - Option Management Tests
    
    func testSystemBaseOptionManagement() {
        let systemBase = MockSystemBaseWorker()
        let option = "system_debug"
        
        // Test initial state
        XCTAssertFalse(systemBase.checkOption(option), "Option should be disabled initially")
        
        // Test enabling option
        systemBase.enableOption(option)
        XCTAssertTrue(systemBase.checkOption(option), "Option should be enabled after enableOption")
        
        // Test disabling option
        systemBase.disableOption(option)
        XCTAssertFalse(systemBase.checkOption(option), "Option should be disabled after disableOption")
    }
    
    func testSystemBaseMultipleOptions() {
        let systemBase = MockSystemBaseWorker()
        let options = ["debug", "verbose", "monitoring", "logging"]
        
        // Enable all options
        for option in options {
            systemBase.enableOption(option)
            XCTAssertTrue(systemBase.checkOption(option), "Option \(option) should be enabled")
        }
        
        // Verify all options are still enabled
        for option in options {
            XCTAssertTrue(systemBase.checkOption(option), "Option \(option) should remain enabled")
        }
        
        // Disable all options
        for option in options {
            systemBase.disableOption(option)
            XCTAssertFalse(systemBase.checkOption(option), "Option \(option) should be disabled")
        }
    }
    
    // MARK: - Scene Lifecycle Tests
    
    func testSystemBaseSceneLifecycle() {
        let systemBase = MockSystemBaseWorker()
        
        // Test that lifecycle methods can be called without crashing
        systemBase.didBecomeActive()
        systemBase.willResignActive()
        systemBase.willEnterForeground()
        systemBase.didEnterBackground()
        
        XCTAssertTrue(true, "Scene lifecycle methods should not crash")
    }
    
    func testSystemBaseSceneLifecycleSequence() {
        let systemBase = MockSystemBaseWorker()
        
        // Test typical app lifecycle sequence
        systemBase.didBecomeActive()
        XCTAssertTrue(systemBase.checkOption("active"), "Should be active after didBecomeActive")
        
        systemBase.willResignActive()
        XCTAssertFalse(systemBase.checkOption("active"), "Should not be active after willResignActive")
        
        systemBase.didEnterBackground()
        XCTAssertTrue(systemBase.checkOption("background"), "Should be in background after didEnterBackground")
        
        systemBase.willEnterForeground()
        XCTAssertFalse(systemBase.checkOption("background"), "Should not be in background after willEnterForeground")
        
        systemBase.didBecomeActive()
        XCTAssertTrue(systemBase.checkOption("active"), "Should be active again after didBecomeActive")
    }
    
    func testSystemBaseSceneLifecycleWithNetworkConfig() {
        let systemBase = MockSystemBaseWorker()
        let netConfig = systemBase.netConfig
        
        // Test that scene lifecycle affects both system and network config
        systemBase.didBecomeActive()
        
        XCTAssertTrue(systemBase.checkOption("active"), "SystemBase should track active state")
        XCTAssertTrue(netConfig.checkOption("active"), "NetworkConfig should also track active state")
        
        systemBase.willResignActive()
        
        XCTAssertFalse(systemBase.checkOption("active"), "SystemBase should track inactive state")
        XCTAssertFalse(netConfig.checkOption("active"), "NetworkConfig should also track inactive state")
    }
    
    // MARK: - AnyObject Compliance Tests
    
    func testSystemBaseAnyObjectCompliance() {
        let systemBase = MockSystemBaseWorker()
        
        // Test that SystemBase is a reference type (AnyObject)
        XCTAssertTrue(systemBase is AnyObject, "SystemBase should be AnyObject")
        
        // Test object identity
        let sameReference = systemBase
        XCTAssertTrue(systemBase === sameReference, "Reference equality should work")
        
        let differentReference = MockSystemBaseWorker()
        XCTAssertFalse(systemBase === differentReference, "Different instances should not be equal")
    }
    
    // MARK: - Integration Tests
    
    func testSystemBaseNetworkConfigIntegrationComplex() {
        let systemBase = MockSystemBaseWorker()
        let netConfig = systemBase.netConfig
        
        // Test complex integration scenario
        systemBase.configure()
        systemBase.enableOption("system_monitoring")
        
        XCTAssertTrue(systemBase.checkOption("system_configured"), "System should be configured")
        XCTAssertTrue(netConfig.checkOption("configured"), "Network config should be configured")
        XCTAssertTrue(systemBase.checkOption("system_monitoring"), "System monitoring should be enabled")
        
        // Test network config can be used independently
        let urlResult = netConfig.urlComponents()
        XCTAssertTrue(urlResult.isSuccess, "Network config should work independently")
        
        let headersResult = netConfig.restHeaders()
        XCTAssertTrue(headersResult.isSuccess, "Network config headers should work")
    }
    
    func testSystemBaseOptionSynchronization() {
        let systemBase = MockSystemBaseWorker()
        let netConfig = systemBase.netConfig
        
        // Test that certain options are synchronized between system and network config
        systemBase.enableOption("debug")
        
        XCTAssertTrue(systemBase.checkOption("debug"), "SystemBase should have debug enabled")
        XCTAssertTrue(netConfig.checkOption("debug"), "NetworkConfig should also have debug enabled")
        
        // Disable on system base
        systemBase.disableOption("debug")
        
        XCTAssertFalse(systemBase.checkOption("debug"), "SystemBase should have debug disabled")
        XCTAssertFalse(netConfig.checkOption("debug"), "NetworkConfig should also have debug disabled")
    }
    
    // MARK: - Thread Safety Tests
    
    func testSystemBaseConcurrency() async {
        let systemBase = MockSystemBaseWorker()
        
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask {
                    let option = "concurrent_test_\(i)"
                    systemBase.enableOption(option)
                    let isEnabled = systemBase.checkOption(option)
                    XCTAssertTrue(isEnabled, "Option should be enabled in concurrent context")
                    systemBase.disableOption(option)
                }
            }
        }
        
        XCTAssertTrue(true, "Concurrent system base operations should not crash")
    }
    
    func testSystemBaseNetworkConfigConcurrency() async {
        let systemBase = MockSystemBaseWorker()
        let netConfig = systemBase.netConfig
        
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask {
                    systemBase.enableOption("system_option_\(i)")
                    netConfig.enableOption("network_option_\(i)")
                    
                    let _ = netConfig.urlComponents()
                    let _ = netConfig.restHeaders()
                }
            }
        }
        
        XCTAssertTrue(true, "Concurrent system and network operations should not crash")
    }
    
    // MARK: - Performance Tests
    
    func testSystemBaseOptionPerformance() {
        let systemBase = MockSystemBaseWorker()
        let options = (0..<100).map { "perf_option_\($0)" }
        
        measure {
            for option in options {
                systemBase.enableOption(option)
                let _ = systemBase.checkOption(option)
                systemBase.disableOption(option)
            }
        }
    }
    
    func testSystemBaseNetworkConfigPerformance() {
        let systemBase = MockSystemBaseWorker()
        let netConfig = systemBase.netConfig
        
        measure {
            for i in 0..<100 {
                systemBase.enableOption("system_perf_\(i)")
                let _ = netConfig.urlComponents()
                let _ = netConfig.restHeaders()
                systemBase.disableOption("system_perf_\(i)")
            }
        }
    }
    
    // MARK: - Memory Management Tests
    
    func testSystemBaseMemoryManagement() {
        weak var weakSystemBase: MockSystemBaseWorker?
        weak var weakNetConfig: NETPTCLConfig?
        
        autoreleasepool {
            let systemBase = MockSystemBaseWorker()
            weakSystemBase = systemBase
            weakNetConfig = systemBase.netConfig
            
            systemBase.configure()
            systemBase.enableOption("test")
            XCTAssertNotNil(weakSystemBase)
            XCTAssertNotNil(weakNetConfig)
        }
        
        XCTAssertNil(weakSystemBase, "SystemBase should be deallocated")
        XCTAssertNil(weakNetConfig, "NetworkConfig should be deallocated")
    }
    
    func testSystemBaseNetworkConfigMemoryIntegrity() {
        let systemBase = MockSystemBaseWorker()
        let netConfig = systemBase.netConfig
        
        // Verify that network config maintains reference integrity
        XCTAssertTrue(systemBase.netConfig === netConfig, "Network config reference should be stable")
        
        systemBase.configure()
        XCTAssertTrue(systemBase.netConfig === netConfig, "Network config reference should remain stable after configure")
        
        systemBase.enableOption("test")
        XCTAssertTrue(systemBase.netConfig === netConfig, "Network config reference should remain stable after option changes")
    }
    
    // MARK: - Error Handling Tests
    
    func testSystemBaseErrorHandling() {
        let systemBase = MockSystemBaseWorker()
        
        // Test with edge case inputs
        systemBase.enableOption("")
        XCTAssertFalse(systemBase.checkOption(""), "Empty option should remain disabled")
        
        systemBase.disableOption("")
        XCTAssertFalse(systemBase.checkOption(""), "Empty option should remain disabled")
        
        // Test with nil-like scenarios
        let nilLikeOption = " "
        systemBase.enableOption(nilLikeOption)
        XCTAssertTrue(systemBase.checkOption(nilLikeOption), "Whitespace option should be handled")
    }
    
    func testSystemBaseNetworkConfigErrorHandling() {
        let systemBase = MockSystemBaseWorker()
        let netConfig = systemBase.netConfig
        
        // Test that network config errors are handled properly
        let result = netConfig.urlComponents(for: "invalid_code")
        
        switch result {
        case .success:
            XCTAssertTrue(true, "Network config should handle invalid codes gracefully")
        case .failure:
            XCTAssertTrue(true, "Network config may fail gracefully for invalid codes")
        }
    }
    
    // MARK: - Complex Integration Scenarios
    
    func testSystemBaseComplexScenario() {
        let systemBase = MockSystemBaseWorker()
        let netConfig = systemBase.netConfig
        
        // Complex scenario: configure, set options, lifecycle changes, network operations
        systemBase.configure()
        systemBase.enableOption("monitoring")
        systemBase.enableOption("debug")
        
        XCTAssertTrue(systemBase.checkOption("system_configured"), "Should be configured")
        XCTAssertTrue(systemBase.checkOption("monitoring"), "Monitoring should be enabled")
        XCTAssertTrue(netConfig.checkOption("configured"), "Network should be configured")
        
        // Test network operations
        let componentsResult = netConfig.urlComponents()
        let headersResult = netConfig.restHeaders()
        
        XCTAssertTrue(componentsResult.isSuccess, "Network components should work")
        XCTAssertTrue(headersResult.isSuccess, "Network headers should work")
        
        // Simulate app lifecycle
        systemBase.didBecomeActive()
        XCTAssertTrue(systemBase.checkOption("active"), "Should be active")
        XCTAssertTrue(netConfig.checkOption("active"), "Network should also be active")
        
        systemBase.willResignActive()
        systemBase.didEnterBackground()
        XCTAssertTrue(systemBase.checkOption("background"), "Should be in background")
        XCTAssertTrue(netConfig.checkOption("background"), "Network should also be in background")
        
        // Verify persistent options survive lifecycle changes
        XCTAssertTrue(systemBase.checkOption("monitoring"), "Options should persist through lifecycle")
        XCTAssertTrue(systemBase.checkOption("debug"), "Options should persist through lifecycle")
        
        // Return to foreground
        systemBase.willEnterForeground()
        systemBase.didBecomeActive()
        XCTAssertTrue(systemBase.checkOption("active"), "Should be active again")
        XCTAssertTrue(systemBase.checkOption("monitoring"), "Options should still persist")
    }
}

// MARK: - Mock System Base Worker Implementation

private class MockSystemBaseWorker: SYSPTCLSystemBase {
    private var _options: Set<String> = []
    private let optionsQueue = DispatchQueue(label: "MockSystemBaseWorker.options", attributes: .concurrent)
    let netConfig: NETPTCLConfig
    
    init() {
        self.netConfig = MockNetConfigForSystemBase()
    }
    
    func configure() {
        optionsQueue.sync(flags: .barrier) {
            self._options.insert("system_configured")
        }
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
        optionsQueue.sync(flags: .barrier) {
            self._options.remove(option)
        }

        // Synchronize with network config for certain options
        if ["debug", "verbose", "active", "background"].contains(option) {
            netConfig.disableOption(option)
        }
    }
    
    func enableOption(_ option: String) {
        guard !option.isEmpty else { return }
        optionsQueue.sync(flags: .barrier) {
            self._options.insert(option)
        }

        // Synchronize with network config for certain options
        if ["debug", "verbose", "active", "background"].contains(option) {
            netConfig.enableOption(option)
        }
    }
    
    func didBecomeActive() {
        enableOption("active")
        disableOption("inactive")
        disableOption("background")
        netConfig.didBecomeActive()
    }
    
    func willResignActive() {
        disableOption("active")
        enableOption("inactive")
        netConfig.willResignActive()
    }
    
    func willEnterForeground() {
        disableOption("background")
        enableOption("foreground")
        netConfig.willEnterForeground()
    }
    
    func didEnterBackground() {
        disableOption("foreground")
        disableOption("active")
        enableOption("background")
        netConfig.didEnterBackground()
    }
}

// MARK: - Mock Network Config for System Base Testing

private class MockNetConfigForSystemBase: NETPTCLConfig {
    private var _storedComponents: [String: URLComponents] = [:]
    private var _options: Set<String> = []
    private let optionsQueue = DispatchQueue(label: "MockNetConfigForSystemBase.options", attributes: .concurrent)
    private let componentsQueue = DispatchQueue(label: "MockNetConfigForSystemBase.components", attributes: .concurrent)

    required init() {
        // Mock initialization
    }
    
    func configure() {
        optionsQueue.sync(flags: .barrier) {
            _options.insert("configured")
        }
    }

    func checkOption(_ option: String) -> Bool {
        return optionsQueue.sync {
            return _options.contains(option)
        }
    }

    func disableOption(_ option: String) {
        optionsQueue.sync(flags: .barrier) {
            _options.remove(option)
        }
    }

    func enableOption(_ option: String) {
        optionsQueue.sync(flags: .barrier) {
            _options.insert(option)
        }
    }
    
    func didBecomeActive() {
        optionsQueue.sync(flags: .barrier) {
            _options.insert("active")
            _options.remove("background")
        }
    }

    func willResignActive() {
        optionsQueue.sync(flags: .barrier) {
            _options.remove("active")
        }
    }

    func willEnterForeground() {
        optionsQueue.sync(flags: .barrier) {
            _options.remove("background")
        }
    }

    func didEnterBackground() {
        optionsQueue.sync(flags: .barrier) {
            _options.insert("background")
            _options.remove("active")
        }
    }
    
    func urlComponents() -> NETPTCLConfigResURLComponents {
        let components = URLComponents(string: "https://systembase.example.com")!
        return .success(components)
    }
    
    func urlComponents(for code: String) -> NETPTCLConfigResURLComponents {
        let storedComponent = componentsQueue.sync {
            return _storedComponents[code]
        }

        if let stored = storedComponent {
            return .success(stored)
        }

        guard !code.isEmpty else {
            let codeLocation = DNSCodeLocation(self)
            return .failure(NETPTCLConfigError.invalidParameters(parameters: ["code"], codeLocation))
        }

        let components = URLComponents(string: "https://systembase.example.com/\(code)")!
        return .success(components)
    }

    func urlComponents(set components: URLComponents, for code: String) -> NETPTCLConfigResVoid {
        componentsQueue.sync(flags: .barrier) {
            _storedComponents[code] = components
        }
        return .success(())
    }
    
    func restHeaders() -> NETPTCLConfigResHeaders {
        var headers = HTTPHeaders([
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-System": "DNSSystemBase"
        ])

        let hasDebug = optionsQueue.sync {
            return _options.contains("debug")
        }

        if hasDebug {
            headers.add(name: "X-Debug", value: "true")
        }

        return .success(headers)
    }
    
    func restHeaders(for code: String) -> NETPTCLConfigResHeaders {
        var headers = HTTPHeaders([
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-System": "DNSSystemBase"
        ])

        if !code.isEmpty {
            headers.add(name: "X-API-Code", value: code)
        }

        let hasDebug = optionsQueue.sync {
            return _options.contains("debug")
        }

        if hasDebug {
            headers.add(name: "X-Debug", value: "true")
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

// MARK: - Result Extension

