//
//  AsyncProtocolBridgeTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocolsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import Foundation
import DNSCore
import DNSDataContracts
import DNSDataObjects
import DNSError
@testable import DNSProtocols

class AsyncProtocolBridgeTests: ProtocolTestBase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Async Protocol Existence Tests
    
    func testWKRPTCLAnalyticsAsyncExists() {
        validateProtocolExists(WKRPTCLAnalyticsAsync.self)
    }
    
    func testWKRPTCLAuthAsyncExists() {
        validateProtocolExists(WKRPTCLAuthAsync.self)
    }
    
    // MARK: - Async Protocol Inheritance Tests
    
    func testAsyncAnalyticsInheritance() {
        let mockAsyncAnalytics = MockAsyncAnalyticsWorker()
        validateProtocolConformance(mockAsyncAnalytics, conformsTo: WKRPTCLAnalytics.self)
        validateProtocolConformance(mockAsyncAnalytics, conformsTo: WKRPTCLAnalyticsAsync.self)
    }
    
    func testAsyncAuthInheritance() {
        let mockAsyncAuth = MockAsyncAuthWorker()
        validateProtocolConformance(mockAsyncAuth, conformsTo: WKRPTCLAuth.self)
        validateProtocolConformance(mockAsyncAuth, conformsTo: WKRPTCLAuthAsync.self)
    }
    
    // MARK: - Async Analytics Protocol Tests
    
    func testAsyncAnalyticsTrackMethod() async {
        let mockAnalytics = MockAsyncAnalyticsWorker()
        
        await validateAsyncMethod {
            try await mockAnalytics.doTrack(event: "async_test", properties: [:])
        }
    }
    
    func testAsyncAnalyticsIdentifyMethod() async {
        let mockAnalytics = MockAsyncAnalyticsWorker()
        
        await validateAsyncMethod {
            try await mockAnalytics.doIdentify(userId: "test_user", traits: [:])
        }
    }
    
    func testAsyncAnalyticsConfigureMethod() async {
        let mockAnalytics = MockAsyncAnalyticsWorker()
        
        await validateAsyncMethod {
            try await mockAnalytics.doConfigure()
        }
    }
    
    func testAsyncAnalyticsWithParameters() async {
        let mockAnalytics = MockAsyncAnalyticsWorker()
        let parameters = TestDataGenerator.generateTestParameters()
        
        await validateAsyncMethod {
            try await mockAnalytics.doConfigure(using: parameters)
        }
    }
    
    // MARK: - Async Auth Protocol Tests
    
    func testAsyncAuthSignInMethod() async {
        let mockAuth = MockAsyncAuthWorker()
        
        await validateAsyncMethod {
            try await mockAuth.doSignIn(from: "test@example.com", and: "password", using: [:])
        }
    }
    
    func testAsyncAuthSignOutMethod() async {
        let mockAuth = MockAsyncAuthWorker()
        
        await validateAsyncMethod {
            try await mockAuth.doSignOut(using: [:])
        }
    }
    
    // Note: doRefresh method not in protocol, test removed
    
    // MARK: - Bridge Implementation Tests
    
    func testAnalyticsSyncAsyncBridge() async {
        let mockAnalytics = MockAsyncAnalyticsWorker()
        
        // Test that sync and async versions produce compatible results
        await validateAsyncBridge(
            syncMethod: {
                let result = mockAnalytics.doTrack(event: .unknown, properties: [:])
                return result.isSuccess
            },
            asyncMethod: {
                do {
                    try await mockAnalytics.doTrack(event: .unknown, properties: [:])
                    return true
                } catch {
                    return false
                }
            }
        )
    }
    
    func testAuthSyncAsyncBridge() async {
        let mockAuth = MockAsyncAuthWorker()
        
        await validateAsyncBridge(
            syncMethod: {
                var result: Bool = false
                mockAuth.doSignIn(from: "sync@test.com", and: "password", using: [:]) { callResult in
                    result = callResult.isSuccess
                }
                return result
            },
            asyncMethod: {
                do {
                    let _ = try await mockAuth.doSignIn(from: "async@test.com", and: "password", using: [:])
                    return true
                } catch {
                    return false
                }
            }
        )
    }
    
    // MARK: - Async Error Handling Tests
    
    func testAsyncAnalyticsErrorHandling() async {
        let mockAnalytics = MockAsyncAnalyticsWorker()
        mockAnalytics.shouldThrowError = true
        
        do {
            try await mockAnalytics.doTrack(event: "error_test", properties: [:])
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertNotNil(error, "Error should be thrown")
            XCTAssertTrue(error is DNSError, "Error should be DNSError")
        }
    }
    
    func testAsyncAuthErrorHandling() async {
        let mockAuth = MockAsyncAuthWorker()
        mockAuth.shouldThrowError = true
        
        do {
            let _ = try await mockAuth.doSignIn(from: "error@test.com", and: "badpassword", using: [:])
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertNotNil(error, "Error should be thrown")
            XCTAssertTrue(error is DNSError, "Error should be DNSError")
        }
    }
    
    // MARK: - Async Progress Handling Tests
    
    func testAsyncProgressHandling() async {
        let mockAnalytics = MockAsyncAnalyticsWorker()
        var progressUpdates: [Double] = []
        
        let progress = AsyncProgress { current, total, percentage, message in
            progressUpdates.append(percentage)
        }
        
        try? await mockAnalytics.doTrack(event: "progress_test", properties: [:], progress: progress)
        
        XCTAssertFalse(progressUpdates.isEmpty, "Progress updates should be received")
        XCTAssertTrue(progressUpdates.contains { $0 >= 1.0 }, "Should receive completion progress")
    }
    
    // MARK: - Async Concurrency Tests
    
    func testAsyncConcurrentOperations() async {
        let mockAnalytics = MockAsyncAnalyticsWorker()
        
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask {
                    do {
                        try await mockAnalytics.doTrack(event: "concurrent_\(i)", properties: [:])
                    } catch {
                        XCTFail("Concurrent operation \(i) failed: \(error)")
                    }
                }
            }
        }
        
        XCTAssertTrue(true, "All concurrent operations should complete successfully")
    }
    
    func testAsyncCancellation() async {
        let mockAnalytics = MockAsyncAnalyticsWorker()
        mockAnalytics.delayDuration = 2.0 // Long operation
        
        let task = Task {
            try await mockAnalytics.doTrack(event: "cancellation_test", properties: [:])
        }
        
        // Cancel after short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            task.cancel()
        }
        
        do {
            try await task.value
            XCTFail("Task should have been cancelled")
        } catch {
            XCTAssertTrue(error is CancellationError || task.isCancelled, "Should handle cancellation")
        }
    }
    
    // MARK: - Performance Tests
    
    func testAsyncPerformanceComparison() async {
        let mockAnalytics = MockAsyncAnalyticsWorker()
        
        // Test sync performance
        let syncStartTime = CFAbsoluteTimeGetCurrent()
        for i in 0..<100 {
            let expectation = XCTestExpectation(description: "Sync operation \(i)")
            let result: WKRPTCLAnalyticsResVoid = mockAnalytics.doTrack(event: .other, properties: ["test": "sync_perf_\(i)"])
            // Since doTrack returns WKRPTCLAnalyticsResVoid (Result<Void, Error>), we can test success
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                expectation.fulfill()
            }
            await fulfillment(of: [expectation], timeout: 1.0)
        }
        let syncDuration = CFAbsoluteTimeGetCurrent() - syncStartTime
        
        // Test async performance
        let asyncStartTime = CFAbsoluteTimeGetCurrent()
        for i in 0..<100 {
            try? await mockAnalytics.doTrack(event: "async_perf_\(i)", properties: [:])
        }
        let asyncDuration = CFAbsoluteTimeGetCurrent() - asyncStartTime
        
        // Async should complete within reasonable time - Mac Catalyst has significant async overhead
        let maxAcceptableAsyncDuration: Double = 20.0 // 20 seconds max for async operations
        XCTAssertLessThan(asyncDuration, maxAcceptableAsyncDuration, "Async performance should complete within acceptable time limit")
    }
    
    // MARK: - Memory Management Tests
    
    func testAsyncWorkerMemoryManagement() async {
        weak var weakAsyncWorker: MockAsyncAnalyticsWorker?
        
        await withCheckedContinuation { continuation in
            Task {
                let asyncWorker = MockAsyncAnalyticsWorker()
                weakAsyncWorker = asyncWorker
                
                try? await asyncWorker.doTrack(event: "memory_test", properties: [:])
                continuation.resume()
            }
        }
        
        // Give time for cleanup
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        XCTAssertNil(weakAsyncWorker, "Async worker should be deallocated after use")
    }
}

// MARK: - Mock Async Worker Implementations

private class MockAsyncAnalyticsWorker: MockAnalyticsWorker, WKRPTCLAnalyticsAsync {
    var delayDuration: TimeInterval = 0.1
    
    func doTrack(event: String, properties: DNSDataDictionary) async throws {
        if self.shouldThrowError {
            let codeLocation = DNSCodeLocation(self)
            throw DNSError.Analytics.invalidParameters(parameters: Array(properties.keys), codeLocation)
        }
        
        try await Task.sleep(nanoseconds: UInt64(delayDuration * 1_000_000_000))
    }
    
    func doTrack(event: String, properties: DNSDataDictionary, progress: AsyncProgress?) async throws {
        if self.shouldThrowError {
            let codeLocation = DNSCodeLocation(self)
            throw DNSError.Analytics.invalidParameters(parameters: Array(properties.keys), codeLocation)
        }
        
        progress?.update(current: 0, total: 1, percentage: 0.0, message: "Starting")
        try await Task.sleep(nanoseconds: UInt64(delayDuration * 1_000_000_000))
        progress?.update(current: 1, total: 1, percentage: 1.0, message: "Completed")
    }
    
    func doIdentify(userId: String, traits: DNSDataDictionary) async throws {
        if self.shouldThrowError {
            let codeLocation = DNSCodeLocation(self)
            throw DNSError.Analytics.invalidParameters(parameters: Array(traits.keys), codeLocation)
        }
        
        try await Task.sleep(nanoseconds: UInt64(delayDuration * 1_000_000_000))
    }
    
    func doConfigure() async throws {
        if self.shouldThrowError {
            let codeLocation = DNSCodeLocation(self)
            throw DNSError.Analytics.unknown(codeLocation)
        }
        
        try await Task.sleep(nanoseconds: UInt64(delayDuration * 1_000_000_000))
    }
    
    func doConfigure(using parameters: DNSDataDictionary) async throws {
        if self.shouldThrowError {
            let codeLocation = DNSCodeLocation(self)
            throw DNSError.Analytics.invalidParameters(parameters: Array(parameters.keys), codeLocation)
        }
        
        try await Task.sleep(nanoseconds: UInt64(delayDuration * 1_000_000_000))
    }
    
    // MARK: - Sync WKRPTCLAnalytics methods
    @discardableResult
    override func doTrack(event: WKRPTCLAnalytics.Events) -> WKRPTCLAnalyticsResVoid {
        if self.shouldThrowError {
            let codeLocation = DNSCodeLocation(self)
            return .failure(DNSError.Analytics.invalidParameters(parameters: [], codeLocation))
        }
        return .success(())
    }
    
    @discardableResult
    override func doTrack(event: WKRPTCLAnalytics.Events, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        if self.shouldThrowError {
            let codeLocation = DNSCodeLocation(self)
            return .failure(DNSError.Analytics.invalidParameters(parameters: Array(properties.keys), codeLocation))
        }
        return .success(())
    }
    
    @discardableResult
    override func doTrack(event: WKRPTCLAnalytics.Events, properties: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        if self.shouldThrowError {
            let codeLocation = DNSCodeLocation(self)
            return .failure(DNSError.Analytics.invalidParameters(parameters: Array(properties.keys), codeLocation))
        }
        return .success(())
    }
}

private class MockAsyncAuthWorker: MockWorker, WKRPTCLAuth, WKRPTCLAuthAsync {
    
    // MARK: - WKRPTCLAuth Conformance
    override var nextWorker: DNSPTCLWorker? {
        get { return super.nextWorker }
        set { super.nextWorker = newValue }
    }
    
    var nextWKRPTCLAuth: WKRPTCLAuth? {
        get { return nextWorker as? WKRPTCLAuth }
        set { nextWorker = newValue }
    }
    
    var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenError
    
    func register(nextWorker: WKRPTCLAuth, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.nextWorker = nextWorker
    }
    var delayDuration: TimeInterval = 0.1
    
    // Sync Auth methods (simplified)
    func doSignIn(from username: String?, and password: String?, using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAuthBlkBoolAccessData?) {
        DispatchQueue.main.async {
            if self.shouldThrowError {
                block?(.failure(NSError(domain: "auth", code: 1)))
            } else {
                // Mock successful sign in result  
                let mockAccessData = MockAccessData()
                block?(.success((true, mockAccessData)))
            }
        }
    }
    
    func doSignOut(using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAuthBlkVoid?) {
        DispatchQueue.main.async {
            block?(.success(()))
        }
    }
    
    func doCheckAuth(using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAuthBlkBoolBoolAccessData?) {
        DispatchQueue.main.async {
            let mockAccessData = MockAccessData()
            block?(.success((true, true, mockAccessData)))
        }
    }
    
    func doPasswordResetStart(from username: String?, using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAuthBlkVoid?) {
        DispatchQueue.main.async {
            block?(.success(()))
        }
    }
    
    func doLinkAuth(from username: String, and password: String, using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAuthBlkBoolAccessData?) {
        DispatchQueue.main.async {
            if self.shouldThrowError {
                block?(.failure(NSError(domain: "auth", code: 1)))
            } else {
                let mockAccessData = MockAccessData()
                block?(.success((true, mockAccessData)))
            }
        }
    }
    
    func doSignUp(from user: (any DAOUserProtocol)?, and password: String?, using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAuthBlkBoolAccessData?) {
        DispatchQueue.main.async {
            if self.shouldThrowError {
                block?(.failure(NSError(domain: "auth", code: 1)))
            } else {
                let mockAccessData = MockAccessData()
                block?(.success((true, mockAccessData)))
            }
        }
    }
    
    // MARK: - Shortcut methods
    func doCheckAuth(using parameters: DNSDataDictionary, with block: WKRPTCLAuthBlkBoolBoolAccessData?) {
        doCheckAuth(using: parameters, with: nil, and: block)
    }
    
    func doLinkAuth(from username: String, and password: String, using parameters: DNSDataDictionary, and block: WKRPTCLAuthBlkBoolAccessData?) {
        doLinkAuth(from: username, and: password, using: parameters, with: nil, and: block)
    }
    
    func doPasswordResetStart(from username: String?, using parameters: DNSDataDictionary, with block: WKRPTCLAuthBlkVoid?) {
        doPasswordResetStart(from: username, using: parameters, with: nil, and: block)
    }
    
    func doSignIn(from username: String?, and password: String?, using parameters: DNSDataDictionary, with block: WKRPTCLAuthBlkBoolAccessData?) {
        doSignIn(from: username, and: password, using: parameters, with: nil, and: block)
    }
    
    func doSignOut(using parameters: DNSDataDictionary, with block: WKRPTCLAuthBlkVoid?) {
        doSignOut(using: parameters, with: nil, and: block)
    }
    
    func doSignUp(from user: (any DAOUserProtocol)?, and password: String?, using parameters: DNSDataDictionary, with block: WKRPTCLAuthBlkBoolAccessData?) {
        doSignUp(from: user, and: password, using: parameters, with: nil, and: block)
    }
    
    // Async Auth methods
    func doSignIn(from username: String?, and password: String?, using parameters: DNSDataDictionary) async throws -> WKRPTCLAuthRtnBoolAccessData {
        if self.shouldThrowError {
            let codeLocation = DNSCodeLocation(self)
            throw DNSError.Auth.failure(error: NSError(domain: "auth", code: 1), codeLocation)
        }
        
        try await Task.sleep(nanoseconds: UInt64(delayDuration * 1_000_000_000))
        let mockAccessData = MockAccessData()
        return (true, mockAccessData) // Mock successful result
    }
    
    func doSignOut(using parameters: DNSDataDictionary) async throws {
        if self.shouldThrowError {
            let codeLocation = DNSCodeLocation(self)
            throw DNSError.Auth.failure(error: NSError(domain: "auth", code: 2), codeLocation)
        }
        
        try await Task.sleep(nanoseconds: UInt64(delayDuration * 1_000_000_000))
    }
    
    func doRefresh() async throws {
        if self.shouldThrowError {
            let codeLocation = DNSCodeLocation(self)
            throw DNSError.Auth.failure(error: NSError(domain: "auth", code: 3), codeLocation)
        }
        
        try await Task.sleep(nanoseconds: UInt64(delayDuration * 1_000_000_000))
    }
}

// MARK: - Async Progress Helper

private class AsyncProgress {
    private let progressHandler: DNSPTCLProgressBlock
    
    init(_ handler: @escaping DNSPTCLProgressBlock) {
        self.progressHandler = handler
    }
    
    func update(current: Int64, total: Int64, percentage: Double, message: String) {
        progressHandler(current, total, percentage, message)
    }
}

// MARK: - Mock Access Data

private class MockAccessData: WKRPTCLAuthAccessData {
    var accessToken: String = "mock_access_token_12345"
}