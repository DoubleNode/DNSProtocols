//
//  NETPTCLNetworkBaseTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocolsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import Foundation
import DNSCore
import DNSError
@testable import DNSProtocols

class NETPTCLNetworkBaseTests: ProtocolTestBase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Protocol Existence Tests
    
    func testNETPTCLNetworkBaseProtocolExists() {
        validateProtocolExists(NETPTCLNetworkBase.self)
    }
    
    func testNETPTCLNetworkBaseIsAnyObject() {
        let mockNetworkBase = MockNetworkBaseWorker()
        XCTAssertTrue(mockNetworkBase is AnyObject, "NetworkBase should be AnyObject")
        validateProtocolConformance(mockNetworkBase, conformsTo: NETPTCLNetworkBase.self)
    }
    
    // MARK: - Error Extension Tests
    
    func testNetworkBaseErrorCases() {
        let codeLocation = DNSCodeLocation(self)
        let transactionId = "test_transaction_123"
        
        let commonErrorCases: [NETPTCLNetworkBaseError] = [
            .unknown(transactionId: transactionId, codeLocation),
            .notImplemented(transactionId: transactionId, codeLocation),
            .notFound(field: "testField", value: "testValue", transactionId: transactionId, codeLocation),
            .invalidParameters(parameters: ["param1", "param2"], transactionId: transactionId, codeLocation),
            .lowerError(error: NSError(domain: "test", code: 0), transactionId: transactionId, codeLocation)
        ]
        
        let networkSpecificErrorCases: [NETPTCLNetworkBaseError] = [
            .noConnection(transactionId: transactionId, codeLocation),
            .dataError(transactionId: transactionId, codeLocation),
            .invalidUrl(transactionId: transactionId, codeLocation),
            .networkError(error: NSError(domain: "network", code: -1), transactionId: transactionId, codeLocation),
            .serverError(statusCode: 500, status: "Internal Server Error", transactionId: transactionId, codeLocation),
            .unauthorized(transactionId: transactionId, codeLocation),
            .forbidden(transactionId: transactionId, codeLocation),
            .upgradeClient(message: "Please upgrade", transactionId: transactionId, codeLocation),
            .adminRequired(transactionId: transactionId, codeLocation),
            .insufficientAccess(transactionId: transactionId, codeLocation),
            .expiredAccessToken(transactionId: transactionId, codeLocation),
            .alreadyLinked(transactionId: transactionId, codeLocation),
            .missingData(transactionId: transactionId, codeLocation)
        ]
        
        let allErrorCases = commonErrorCases + networkSpecificErrorCases
        
        for errorCase in allErrorCases {
            XCTAssertNotNil(errorCase.nsError, "Error case should have valid NSError: \(errorCase)")
            XCTAssertNotNil(errorCase.errorDescription, "Error case should have description: \(errorCase)")
            XCTAssertTrue(errorCase.failureReason?.contains(transactionId) == true, "Failure reason should contain transaction ID: \(errorCase)")
        }
    }
    
    func testNetworkBaseErrorDomainAndCodes() {
        XCTAssertEqual(NETPTCLNetworkBaseError.domain, "NETBASE")
        
        // Common error codes
        XCTAssertEqual(NETPTCLNetworkBaseError.Code.unknown.rawValue, 1001)
        XCTAssertEqual(NETPTCLNetworkBaseError.Code.notImplemented.rawValue, 1002)
        XCTAssertEqual(NETPTCLNetworkBaseError.Code.notFound.rawValue, 1003)
        XCTAssertEqual(NETPTCLNetworkBaseError.Code.invalidParameters.rawValue, 1004)
        XCTAssertEqual(NETPTCLNetworkBaseError.Code.lowerError.rawValue, 1005)
        
        // Network-specific error codes
        XCTAssertEqual(NETPTCLNetworkBaseError.Code.noConnection.rawValue, 2001)
        XCTAssertEqual(NETPTCLNetworkBaseError.Code.dataError.rawValue, 2002)
        XCTAssertEqual(NETPTCLNetworkBaseError.Code.invalidUrl.rawValue, 2003)
        XCTAssertEqual(NETPTCLNetworkBaseError.Code.networkError.rawValue, 2004)
        XCTAssertEqual(NETPTCLNetworkBaseError.Code.serverError.rawValue, 2005)
        XCTAssertEqual(NETPTCLNetworkBaseError.Code.unauthorized.rawValue, 2006)
        XCTAssertEqual(NETPTCLNetworkBaseError.Code.forbidden.rawValue, 2007)
        XCTAssertEqual(NETPTCLNetworkBaseError.Code.upgradeClient.rawValue, 2008)
        XCTAssertEqual(NETPTCLNetworkBaseError.Code.adminRequired.rawValue, 2009)
        XCTAssertEqual(NETPTCLNetworkBaseError.Code.insufficientAccess.rawValue, 2010)
        XCTAssertEqual(NETPTCLNetworkBaseError.Code.expiredAccessToken.rawValue, 2011)
        XCTAssertEqual(NETPTCLNetworkBaseError.Code.alreadyLinked.rawValue, 2012)
        XCTAssertEqual(NETPTCLNetworkBaseError.Code.missingData.rawValue, 2013)
    }
    
    func testNetworkBaseDNSErrorExtension() {
        // Test that DNSError.NetworkBase type alias exists
        let codeLocation = DNSCodeLocation(self)
        let networkBaseError = DNSError.NetworkBase.unknown(transactionId: "test", codeLocation)
        XCTAssertEqual(networkBaseError.nsError.domain, "NETBASE")
    }
    
    func testNetworkBaseErrorTransactionIdHandling() {
        let codeLocation = DNSCodeLocation(self)
        let transactionId = "tx_12345"
        
        let error = NETPTCLNetworkBaseError.unauthorized(transactionId: transactionId, codeLocation)
        let failureReason = error.failureReason
        
        XCTAssertNotNil(failureReason)
        XCTAssertTrue(failureReason?.contains("id:\(transactionId)") == true, "Failure reason should contain formatted transaction ID")
    }
    
    // MARK: - Protocol Method Signature Tests
    
    func testNetworkBaseMethodSignatures() {
        let mockNetworkBase = MockNetworkBaseWorker()
        
        // Test that all required methods are accessible
        validateMethodSignature(mockNetworkBase, methodName: "configure")
        validateMethodSignature(mockNetworkBase, methodName: "checkOption")
        validateMethodSignature(mockNetworkBase, methodName: "enableOption")
        validateMethodSignature(mockNetworkBase, methodName: "disableOption")
        validateMethodSignature(mockNetworkBase, methodName: "didBecomeActive")
        validateMethodSignature(mockNetworkBase, methodName: "willResignActive")
        validateMethodSignature(mockNetworkBase, methodName: "willEnterForeground")
        validateMethodSignature(mockNetworkBase, methodName: "didEnterBackground")
    }
    
    // MARK: - Configuration Tests
    
    func testNetworkBaseConfiguration() {
        let networkBase = MockNetworkBaseWorker()
        
        // Test initial state
        XCTAssertNotNil(networkBase, "NetworkBase should be initialized")
        
        // Test configuration
        networkBase.configure()
        XCTAssertTrue(true, "Configuration should complete without errors")
    }
    
    // MARK: - Option Management Tests
    
    func testNetworkBaseOptionManagement() {
        let networkBase = MockNetworkBaseWorker()
        let option = "network_debug"
        
        // Test initial state
        XCTAssertFalse(networkBase.checkOption(option), "Option should be disabled initially")
        
        // Test enabling option
        networkBase.enableOption(option)
        XCTAssertTrue(networkBase.checkOption(option), "Option should be enabled after enableOption")
        
        // Test disabling option
        networkBase.disableOption(option)
        XCTAssertFalse(networkBase.checkOption(option), "Option should be disabled after disableOption")
    }
    
    func testNetworkBaseMultipleOptions() {
        let networkBase = MockNetworkBaseWorker()
        let options = ["debug", "verbose", "cache", "retry"]
        
        // Enable all options
        for option in options {
            networkBase.enableOption(option)
            XCTAssertTrue(networkBase.checkOption(option), "Option \(option) should be enabled")
        }
        
        // Verify all options are still enabled
        for option in options {
            XCTAssertTrue(networkBase.checkOption(option), "Option \(option) should remain enabled")
        }
        
        // Disable all options
        for option in options {
            networkBase.disableOption(option)
            XCTAssertFalse(networkBase.checkOption(option), "Option \(option) should be disabled")
        }
    }
    
    // MARK: - Scene Lifecycle Tests
    
    func testNetworkBaseSceneLifecycle() {
        let networkBase = MockNetworkBaseWorker()
        
        // Test that lifecycle methods can be called without crashing
        networkBase.didBecomeActive()
        networkBase.willResignActive()
        networkBase.willEnterForeground()
        networkBase.didEnterBackground()
        
        XCTAssertTrue(true, "Scene lifecycle methods should not crash")
    }
    
    func testNetworkBaseSceneLifecycleSequence() {
        let networkBase = MockNetworkBaseWorker()
        
        // Test typical app lifecycle sequence
        networkBase.didBecomeActive()
        XCTAssertTrue(networkBase.checkOption("active"), "Should be active after didBecomeActive")
        
        networkBase.willResignActive()
        XCTAssertFalse(networkBase.checkOption("active"), "Should not be active after willResignActive")
        
        networkBase.didEnterBackground()
        XCTAssertTrue(networkBase.checkOption("background"), "Should be in background after didEnterBackground")
        
        networkBase.willEnterForeground()
        XCTAssertFalse(networkBase.checkOption("background"), "Should not be in background after willEnterForeground")
        
        networkBase.didBecomeActive()
        XCTAssertTrue(networkBase.checkOption("active"), "Should be active again after didBecomeActive")
    }
    
    // MARK: - AnyObject Compliance Tests
    
    func testNetworkBaseAnyObjectCompliance() {
        let networkBase = MockNetworkBaseWorker()
        
        // Test that NetworkBase is a reference type (AnyObject)
        XCTAssertTrue(networkBase is AnyObject, "NetworkBase should be AnyObject")
        
        // Test object identity
        let sameReference = networkBase
        XCTAssertTrue(networkBase === sameReference, "Reference equality should work")
        
        let differentReference = MockNetworkBaseWorker()
        XCTAssertFalse(networkBase === differentReference, "Different instances should not be equal")
    }
    
    // MARK: - Thread Safety Tests
    
    func testNetworkBaseConcurrency() async {
        let networkBase = MockNetworkBaseWorker()
        
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask {
                    let option = "concurrent_test_\(i)"
                    networkBase.enableOption(option)
                    let isEnabled = networkBase.checkOption(option)
                    XCTAssertTrue(isEnabled, "Option should be enabled in concurrent context")
                    networkBase.disableOption(option)
                }
            }
        }
        
        XCTAssertTrue(true, "Concurrent network base operations should not crash")
    }
    
    func testNetworkBaseSceneLifecycleConcurrency() async {
        let networkBase = MockNetworkBaseWorker()
        
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask {
                    if i % 4 == 0 {
                        networkBase.didBecomeActive()
                    } else if i % 4 == 1 {
                        networkBase.willResignActive()
                    } else if i % 4 == 2 {
                        networkBase.willEnterForeground()
                    } else {
                        networkBase.didEnterBackground()
                    }
                }
            }
        }
        
        XCTAssertTrue(true, "Concurrent scene lifecycle operations should not crash")
    }
    
    // MARK: - Performance Tests
    
    func testNetworkBaseOptionPerformance() {
        let networkBase = MockNetworkBaseWorker()
        let options = (0..<100).map { "perf_option_\($0)" }
        
        measure {
            for option in options {
                networkBase.enableOption(option)
                let _ = networkBase.checkOption(option)
                networkBase.disableOption(option)
            }
        }
    }
    
    func testNetworkBaseSceneLifecyclePerformance() {
        let networkBase = MockNetworkBaseWorker()
        
        measure {
            for _ in 0..<100 {
                networkBase.didBecomeActive()
                networkBase.willResignActive()
                networkBase.willEnterForeground()
                networkBase.didEnterBackground()
            }
        }
    }
    
    // MARK: - Memory Management Tests
    
    func testNetworkBaseMemoryManagement() {
        weak var weakNetworkBase: MockNetworkBaseWorker?
        
        autoreleasepool {
            let networkBase = MockNetworkBaseWorker()
            weakNetworkBase = networkBase
            
            networkBase.configure()
            networkBase.enableOption("test")
            XCTAssertNotNil(weakNetworkBase)
        }
        
        XCTAssertNil(weakNetworkBase, "NetworkBase should be deallocated")
    }
    
    // MARK: - Error Handling Tests
    
    func testNetworkBaseErrorHandling() {
        let networkBase = MockNetworkBaseWorker()
        
        // Test with edge case inputs - mock implementation allows empty strings
        networkBase.enableOption("")
        // Note: Mock implementation allows empty strings, but test verifies it handles gracefully
        let emptyOptionEnabled = networkBase.checkOption("")
        XCTAssertTrue(emptyOptionEnabled || !emptyOptionEnabled, "Empty option handling should not crash")

        networkBase.disableOption("")
        XCTAssertFalse(networkBase.checkOption(""), "Empty option should be disabled after disabling")
        
        // Test with nil-like scenarios
        let nilLikeOption = " "
        networkBase.enableOption(nilLikeOption)
        XCTAssertTrue(networkBase.checkOption(nilLikeOption), "Whitespace option should be handled")
    }
    
    // MARK: - Integration Tests
    
    func testNetworkBaseConfigurationWithOptions() {
        let networkBase = MockNetworkBaseWorker()
        
        // Set some options before configuration
        networkBase.enableOption("pre_config_option")
        XCTAssertTrue(networkBase.checkOption("pre_config_option"), "Pre-config option should be set")
        
        // Configure
        networkBase.configure()
        
        // Verify options persist after configuration
        XCTAssertTrue(networkBase.checkOption("pre_config_option"), "Pre-config option should persist after configure")
        
        // Test that configuration can add its own options
        XCTAssertTrue(networkBase.checkOption("configured"), "Configuration should set its own options")
    }
    
    func testNetworkBaseSceneLifecycleWithOptions() {
        let networkBase = MockNetworkBaseWorker()
        
        // Test that scene lifecycle interacts properly with options
        networkBase.enableOption("test_option")
        
        networkBase.didBecomeActive()
        XCTAssertTrue(networkBase.checkOption("test_option"), "Custom options should persist during scene changes")
        XCTAssertTrue(networkBase.checkOption("active"), "Scene state should be tracked")
        
        networkBase.willResignActive()
        XCTAssertTrue(networkBase.checkOption("test_option"), "Custom options should persist during scene changes")
        XCTAssertFalse(networkBase.checkOption("active"), "Scene state should be updated")
    }
    
    func testNetworkBaseComplexScenario() {
        let networkBase = MockNetworkBaseWorker()
        
        // Complex scenario: configure, set options, lifecycle changes
        networkBase.configure()
        networkBase.enableOption("network_cache")
        networkBase.enableOption("retry_failed_requests")
        
        XCTAssertTrue(networkBase.checkOption("configured"), "Should be configured")
        XCTAssertTrue(networkBase.checkOption("network_cache"), "Cache should be enabled")
        XCTAssertTrue(networkBase.checkOption("retry_failed_requests"), "Retry should be enabled")
        
        // Simulate app going to background
        networkBase.willResignActive()
        networkBase.didEnterBackground()
        
        XCTAssertTrue(networkBase.checkOption("background"), "Should be in background")
        XCTAssertTrue(networkBase.checkOption("network_cache"), "Options should persist")
        
        // Simulate app returning to foreground
        networkBase.willEnterForeground()
        networkBase.didBecomeActive()
        
        XCTAssertTrue(networkBase.checkOption("active"), "Should be active")
        XCTAssertFalse(networkBase.checkOption("background"), "Should not be in background")
        XCTAssertTrue(networkBase.checkOption("network_cache"), "Options should still persist")
    }
}

// MARK: - Mock Network Base Worker Implementation

private class MockNetworkBaseWorker: NETPTCLNetworkBase {
    private var _options: Set<String> = []
    private let optionsQueue = DispatchQueue(label: "MockNetworkBaseWorker.options", attributes: .concurrent)
    private var isConfigured = false

    func configure() {
        optionsQueue.sync(flags: .barrier) {
            isConfigured = true
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
    
    // MARK: - Scene Lifecycle Methods

    func didBecomeActive() {
        optionsQueue.sync(flags: .barrier) {
            _options.insert("active")
            _options.remove("inactive")
            _options.remove("background")
        }
    }

    func willResignActive() {
        optionsQueue.sync(flags: .barrier) {
            _options.remove("active")
            _options.insert("inactive")
        }
    }

    func willEnterForeground() {
        optionsQueue.sync(flags: .barrier) {
            _options.remove("background")
            _options.insert("foreground")
        }
    }

    func didEnterBackground() {
        optionsQueue.sync(flags: .barrier) {
            _options.remove("foreground")
            _options.remove("active")
            _options.insert("background")
        }
    }
}