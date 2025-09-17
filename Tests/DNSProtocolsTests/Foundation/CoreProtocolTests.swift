//
//  CoreProtocolTests.swift
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
import DNSDataObjects
@testable import DNSProtocols

class CoreProtocolTests: ProtocolTestBase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Core Protocol Existence Tests
    
    func testDNSPTCLWorkerProtocolExists() {
        validateProtocolExists(DNSPTCLWorker.self)
        
        // Test that protocol can be used as a type constraint
        func testWorkerFunction<T: DNSPTCLWorker>(_ worker: T) -> Bool {
            return true
        }
        
        let mockWorker = MockWorker()
        XCTAssertTrue(testWorkerFunction(mockWorker), "DNSPTCLWorker should work as type constraint")
    }
    
    func testWKRPTCLWorkerBaseProtocolExists() {
        validateProtocolExists(WKRPTCLWorkerBase.self)
        
        // Test that the protocol has required properties
        let mockWorkerBase = MockWorkerBase()
        XCTAssertNotNil(type(of: mockWorkerBase.netConfig), "WKRPTCLWorkerBase should have netConfig property")
        XCTAssertNotNil(type(of: mockWorkerBase.netRouter), "WKRPTCLWorkerBase should have netRouter property")
    }
    
    // MARK: - Core Enum Tests
    
    func testDNSPTCLCallEnumStructure() {
        // Test that DNSPTCLCall enum exists and has required nested types
        validateProtocolExists(DNSPTCLCall.self)
        validateProtocolExists(DNSPTCLCall.NextWhen.self)
        validateProtocolExists(DNSPTCLCall.Result.self)
    }
    
    func testDNSPTCLCallNextWhenCases() {
        // Test all NextWhen cases
        let nextWhenCases: [DNSPTCLCall.NextWhen] = [
            .always,
            .whenError,
            .whenNotFound,
            .whenUnhandled
        ]
        
        XCTAssertEqual(nextWhenCases.count, 4, "NextWhen should have 4 cases")
        
        // Test each case can be used in switch statement
        for nextWhen in nextWhenCases {
            switch nextWhen {
            case .always:
                XCTAssertTrue(true, "Always case should be accessible")
            case .whenError:
                XCTAssertTrue(true, "WhenError case should be accessible")
            case .whenNotFound:
                XCTAssertTrue(true, "WhenNotFound case should be accessible")
            case .whenUnhandled:
                XCTAssertTrue(true, "WhenUnhandled case should be accessible")
            }
        }
    }
    
    func testDNSPTCLCallResultCases() {
        // Test all Result cases
        let testError = NSError(domain: "test", code: 1, userInfo: nil)
        let resultCases: [DNSPTCLCall.Result] = [
            .completed,
            .error,
            .failure(testError),
            .notFound,
            .unhandled
        ]
        
        XCTAssertEqual(resultCases.count, 5, "Result should have 5 cases")
        
        // Test each case can be used in switch statement
        for result in resultCases {
            switch result {
            case .completed:
                XCTAssertTrue(true, "Completed case should be accessible")
            case .error:
                XCTAssertTrue(true, "Error case should be accessible")
            case .failure(let error):
                XCTAssertNotNil(error, "Failure case should carry error")
            case .notFound:
                XCTAssertTrue(true, "NotFound case should be accessible")
            case .unhandled:
                XCTAssertTrue(true, "Unhandled case should be accessible")
            }
        }
    }
    
    // MARK: - Core Struct Tests
    
    func testDNSPTCLDeletedStatesEnum() {
        validateProtocolExists(DNSPTCLDeletedStates.self)
        
        // Test all cases with raw values
        XCTAssertEqual(DNSPTCLDeletedStates.unknown.rawValue, "unknown")
        XCTAssertEqual(DNSPTCLDeletedStates.queued.rawValue, "queued")
        XCTAssertEqual(DNSPTCLDeletedStates.ready.rawValue, "ready")
        XCTAssertEqual(DNSPTCLDeletedStates.done.rawValue, "done")
    }
    
    func testDNSPTCLDeletedStatusStructure() {
        validateProtocolExists(DNSPTCLDeletedStatus.self)
        validateProtocolExists(DNSPTCLDeletedStatus.Counts.self)
        
        let deletedStatus = DNSPTCLDeletedStatus()
        
        // Test that struct has required properties
        XCTAssertNotNil(deletedStatus.done, "DeletedStatus should have done counts")
        XCTAssertNotNil(deletedStatus.queued, "DeletedStatus should have queued counts")
        XCTAssertNotNil(deletedStatus.ready, "DeletedStatus should have ready counts")
        
        // Test Counts structure
        let counts = DNSPTCLDeletedStatus.Counts()
        XCTAssertEqual(counts.total, 0, "Counts should initialize with zero total")
        XCTAssertEqual(counts.last24hrs, 0, "Counts should initialize with zero last24hrs")
        XCTAssertEqual(counts.last3days, 0, "Counts should initialize with zero last3days")
        XCTAssertEqual(counts.last7days, 0, "Counts should initialize with zero last7days")
        XCTAssertEqual(counts.last14days, 0, "Counts should initialize with zero last14days")
        XCTAssertEqual(counts.last21days, 0, "Counts should initialize with zero last21days")
    }
    
    func testDNSPTCLDeletedAccountStructure() {
        validateProtocolExists(DNSPTCLDeletedAccount.self)
        
        let deletedAccount = DNSPTCLDeletedAccount()
        
        // Test default values
        XCTAssertEqual(deletedAccount.accountId, "", "AccountId should default to empty string")
        XCTAssertEqual(deletedAccount.deviceId, "", "DeviceId should default to empty string")
        XCTAssertNil(deletedAccount.purgedTime, "PurgedTime should default to nil")
        XCTAssertNotNil(deletedAccount.queuedTime, "QueuedTime should have a default value")
        XCTAssertEqual(deletedAccount.state, .unknown, "State should default to unknown")
        XCTAssertNotNil(deletedAccount.stateTime, "StateTime should have a default value")
        
        // Test that properties can be modified
        var modifiableAccount = deletedAccount
        modifiableAccount.accountId = "test_account_id"
        modifiableAccount.deviceId = "test_device_id"
        modifiableAccount.state = .queued
        
        XCTAssertEqual(modifiableAccount.accountId, "test_account_id")
        XCTAssertEqual(modifiableAccount.deviceId, "test_device_id")
        XCTAssertEqual(modifiableAccount.state, .queued)
    }
    
    // MARK: - Protocol Inheritance Tests
    
    func testWorkerProtocolInheritance() {
        // Test that WKRPTCLWorkerBase inherits from DNSPTCLWorker
        let mockWorkerBase = MockWorkerBase()
        
        // Should conform to both protocols
        validateProtocolConformance(mockWorkerBase, conformsTo: DNSPTCLWorker.self)
        validateProtocolConformance(mockWorkerBase, conformsTo: WKRPTCLWorkerBase.self)
        
        // Should be usable as either type
        let asWorker: DNSPTCLWorker = mockWorkerBase
        let asWorkerBase: WKRPTCLWorkerBase = mockWorkerBase
        
        XCTAssertNotNil(asWorker, "Should be usable as DNSPTCLWorker")
        XCTAssertNotNil(asWorkerBase, "Should be usable as WKRPTCLWorkerBase")
    }
    
    // MARK: - Protocol Property Tests
    
    func testDNSPTCLWorkerTypeAlias() {
        // Test that DNSPTCLWorker has Call typealias
        XCTAssertTrue(DNSPTCLWorker.Call.self == DNSPTCLCall.self, "Call typealias should reference DNSPTCLCall")
    }
    
    func testWKRPTCLWorkerBaseStaticProperties() {
        // Test that static xlt property exists
        XCTAssertNotNil(MockWorkerBase.xlt, "WKRPTCLWorkerBase should have static xlt property")
        XCTAssertTrue(MockWorkerBase.xlt is DNSDataTranslation, "xlt should be DNSDataTranslation type")
    }
    
    func testWKRPTCLWorkerBaseInstanceProperties() {
        let mockWorkerBase = MockWorkerBase()
        
        // Test required instance properties
        XCTAssertNotNil(mockWorkerBase.netConfig, "Should have netConfig property")
        XCTAssertNotNil(mockWorkerBase.netRouter, "Should have netRouter property")
        
        // Test that properties can be set
        let newConfig = MockNetConfig()
        let newRouter = MockNetRouter()
        
        mockWorkerBase.netConfig = newConfig
        mockWorkerBase.netRouter = newRouter
        
        XCTAssertTrue(mockWorkerBase.netConfig is MockNetConfig, "netConfig should be settable")
        XCTAssertTrue(mockWorkerBase.netRouter is MockNetRouter, "netRouter should be settable")
    }
    
    // MARK: - Protocol Method Tests
    
    func testWKRPTCLWorkerBaseRequiredMethods() {
        let mockWorkerBase = MockWorkerBase()
        
        // Test configure method exists and can be called
        XCTAssertNoThrow(mockWorkerBase.configure(), "configure method should execute without throwing")
        
        // Test option methods exist and can be called
        XCTAssertNoThrow(mockWorkerBase.enableOption("testOption"), "enableOption should execute without throwing")
        XCTAssertNoThrow(mockWorkerBase.disableOption("testOption"), "disableOption should execute without throwing")
        XCTAssertTrue(mockWorkerBase.checkOption("testOption") is Bool, "checkOption should return Bool")
        
        // Test lifecycle methods exist and can be called
        XCTAssertNoThrow(mockWorkerBase.didBecomeActive(), "didBecomeActive should execute without throwing")
        XCTAssertNoThrow(mockWorkerBase.willResignActive(), "willResignActive should execute without throwing")
        XCTAssertNoThrow(mockWorkerBase.willEnterForeground(), "willEnterForeground should execute without throwing")
        XCTAssertNoThrow(mockWorkerBase.didEnterBackground(), "didEnterBackground should execute without throwing")
    }
    
    func testWKRPTCLWorkerBaseAnalyticsMethods() {
        let mockWorkerBase = MockWorkerBase()
        let testObject = DAOBaseObject()
        let testData: DNSDataDictionary = ["test": "data"]
        
        // Test analytics method with progress block
        let expectation1 = expectation(description: "Analytics with progress")
        let progressBlock: DNSPTCLProgressBlock = { current, total, percent, message in
            // Progress callback
        }
        let completionBlock1: WKRPTCLWorkerBaseBlkAAnalyticsData = { result in
            expectation1.fulfill()
        }
        
        XCTAssertNoThrow(mockWorkerBase.doAnalytics(for: testObject, using: testData, with: progressBlock, and: completionBlock1), 
                        "doAnalytics with progress should execute without throwing")
        
        // Test analytics method without progress block
        let expectation2 = expectation(description: "Analytics without progress")
        let completionBlock2: WKRPTCLWorkerBaseBlkAAnalyticsData = { result in
            expectation2.fulfill()
        }
        
        XCTAssertNoThrow(mockWorkerBase.doAnalytics(for: testObject, using: testData, and: completionBlock2),
                        "doAnalytics without progress should execute without throwing")
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    // MARK: - Protocol Compatibility Tests
    
    func testProtocolCompatibilityWithAnyObject() {
        // Test that WKRPTCLWorkerBase inherits from AnyObject
        let mockWorkerBase = MockWorkerBase()
        XCTAssertTrue(mockWorkerBase is AnyObject, "WKRPTCLWorkerBase should inherit from AnyObject")
        
        // Test reference semantics
        let reference1 = mockWorkerBase
        let reference2 = mockWorkerBase
        XCTAssertTrue(reference1 === reference2, "Should have reference equality")
    }
    
    // MARK: - Protocol Error Handling Integration
    
    func testProtocolErrorIntegration() {
        // Test that protocols work with DNSError system
        let analyticsError = DNSError.Analytics.invalidParameters(parameters: [], DNSCodeLocation(self))
        
        let resultBlock: DNSPTCLResultBlock = { result in
            switch result {
            case .failure(let error):
                if let analyticsError = error as? WKRPTCLAnalyticsError {
                    XCTAssertEqual(analyticsError.nsError.domain, "WKRANALYTICS")
                    return "error_handled"
                }
                return "unknown_error"
            default:
                return "success"
            }
        }
        
        let result = resultBlock(.failure(analyticsError))
        XCTAssertEqual(result as? String, "error_handled", "DNSError should integrate with protocol results")
    }
    
    // MARK: - Memory Management Tests
    
    func testProtocolMemoryManagement() {
        weak var weakWorkerBase: MockWorkerBase?
        
        autoreleasepool {
            let workerBase = MockWorkerBase()
            weakWorkerBase = workerBase
            XCTAssertNotNil(weakWorkerBase, "Worker should exist in memory")
            
            // Test that protocol usage doesn't create retain cycles
            let _: WKRPTCLWorkerBase = workerBase
            let _: DNSPTCLWorker = workerBase
            let _: AnyObject = workerBase
        }
        
        XCTAssertNil(weakWorkerBase, "Worker should be deallocated when no strong references remain")
    }
    
    // MARK: - Thread Safety Tests
    
    func testProtocolThreadSafety() async {
        let mockWorkerBase = MockWorkerBase()
        
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<50 {
                group.addTask {
                    mockWorkerBase.configure()
                    mockWorkerBase.enableOption("option\(i)")
                    let _ = mockWorkerBase.checkOption("option\(i)")
                    mockWorkerBase.disableOption("option\(i)")
                }
            }
        }
        
        XCTAssertTrue(true, "Concurrent protocol usage should not cause crashes")
    }
    
    // MARK: - Performance Tests
    
    func testProtocolInstantiationPerformance() {
        measure {
            for _ in 0..<1000 {
                let workerBase = MockWorkerBase()
                workerBase.configure()
            }
        }
    }
    
    func testProtocolMethodInvocationPerformance() {
        let mockWorkerBase = MockWorkerBase()
        let testObject = DAOBaseObject()
        let testData: DNSDataDictionary = ["test": "data"]
        
        measure {
            for _ in 0..<100 {
                mockWorkerBase.doAnalytics(for: testObject, using: testData, and: nil)
                mockWorkerBase.enableOption("testOption")
                let _ = mockWorkerBase.checkOption("testOption")
                mockWorkerBase.disableOption("testOption")
            }
        }
    }
}

// MARK: - Mock Implementations

private class MockWorkerBase: MockWorker {
    override var netConfig: NETPTCLConfig {
        get { return _mockNetConfig }
        set { _mockNetConfig = newValue }
    }
    private var _mockNetConfig: NETPTCLConfig = MockNetConfig()
    
    override var netRouter: NETPTCLRouter {
        get { return _mockNetRouter }
        set { _mockNetRouter = newValue }
    }
    private var _mockNetRouter: NETPTCLRouter = MockNetRouter()
    
    override func configure() {
        super.configure()
    }
    
    override func checkOption(_ option: String) -> Bool {
        return false
    }
    
    override func disableOption(_ option: String) {
        // Mock implementation
    }
    
    override func enableOption(_ option: String) {
        // Mock implementation
    }
    
    override func didBecomeActive() {
        // Mock implementation
    }
    
    override func willResignActive() {
        // Mock implementation
    }
    
    override func willEnterForeground() {
        // Mock implementation
    }
    
    override func didEnterBackground() {
        // Mock implementation
    }
    
    override func doAnalytics(for object: DAOBaseObject, using data: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLWorkerBaseBlkAAnalyticsData?) {
        // Mock implementation
        DispatchQueue.main.async {
            block?(.success([]))
        }
    }
    
    override func doAnalytics(for object: DAOBaseObject, using data: DNSDataDictionary, and block: WKRPTCLWorkerBaseBlkAAnalyticsData?) {
        doAnalytics(for: object, using: data, with: nil, and: block)
    }
}

private class MockNetConfig: NETPTCLConfig {
    required init() {
        // Mock implementation of network config
    }
    
    func configure() {
        // Mock configuration
    }
    
    func checkOption(_ option: String) -> Bool {
        return false
    }
    
    func disableOption(_ option: String) {
        // Mock disable option
    }
    
    func enableOption(_ option: String) {
        // Mock enable option
    }
    
    func didBecomeActive() {
        // Mock lifecycle method
    }
    
    func willResignActive() {
        // Mock lifecycle method
    }
    
    func willEnterForeground() {
        // Mock lifecycle method
    }
    
    func didEnterBackground() {
        // Mock lifecycle method
    }
    
    func urlComponents() -> NETPTCLConfigResURLComponents {
        return .success(URLComponents())
    }
    
    func urlComponents(for code: String) -> NETPTCLConfigResURLComponents {
        return .success(URLComponents())
    }
    
    func urlComponents(set components: URLComponents, for code: String) -> NETPTCLConfigResVoid {
        return .success(())
    }
    
    func restHeaders() -> NETPTCLConfigResHeaders {
        return .success(HTTPHeaders())
    }
    
    func restHeaders(for code: String) -> NETPTCLConfigResHeaders {
        return .success(HTTPHeaders())
    }
    
    func urlRequest(using url: URL) -> NETPTCLConfigResURLRequest {
        return .success(URLRequest(url: url))
    }
    
    func urlRequest(for code: String, using url: URL) -> NETPTCLConfigResURLRequest {
        return .success(URLRequest(url: url))
    }
}

private class MockNetRouter: NETPTCLRouter {
    required init() {
        // Mock implementation of network router
    }
    
    required init(with netConfig: NETPTCLConfig) {
        // Mock implementation with config
    }
    
    func configure() {
        // Mock configuration
    }
    
    func checkOption(_ option: String) -> Bool {
        return false
    }
    
    func disableOption(_ option: String) {
        // Mock disable option
    }
    
    func enableOption(_ option: String) {
        // Mock enable option
    }
    
    func didBecomeActive() {
        // Mock lifecycle method
    }
    
    func willResignActive() {
        // Mock lifecycle method
    }
    
    func willEnterForeground() {
        // Mock lifecycle method
    }
    
    func didEnterBackground() {
        // Mock lifecycle method
    }
    
    func urlRequest(using url: URL) -> NETPTCLRouterResURLRequest {
        return .success(URLRequest(url: url))
    }
    
    func urlRequest(for code: String, using url: URL) -> NETPTCLRouterResURLRequest {
        return .success(URLRequest(url: url))
    }
}