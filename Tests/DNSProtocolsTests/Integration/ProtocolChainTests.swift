//
//  ProtocolChainTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocolsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import Foundation
import Combine
import DNSCore
import DNSDataContracts
import DNSError
@testable import DNSProtocols

class ProtocolChainTests: ProtocolTestBase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Chain of Responsibility Pattern Tests
    
    func testBasicWorkerChaining() {
        let primaryWorker = MockChainableWorker("Primary")
        let secondaryWorker = MockChainableWorker("Secondary")
        let tertiaryWorker = MockChainableWorker("Tertiary")
        
        // Build the chain
        primaryWorker.nextBaseWorker = secondaryWorker
        secondaryWorker.nextBaseWorker = tertiaryWorker
        
        // Verify chain structure
        XCTAssertEqual(primaryWorker.name, "Primary")
        XCTAssertEqual((primaryWorker.nextBaseWorker as? MockChainableWorker)?.name, "Secondary")
        XCTAssertEqual((secondaryWorker.nextBaseWorker as? MockChainableWorker)?.name, "Tertiary")
        XCTAssertNil(tertiaryWorker.nextBaseWorker)
    }
    
    func testChainTraversal() {
        let workers = createWorkerChain(length: 5)
        let firstWorker = workers.first!
        
        // Traverse the chain and collect names
        var chainNames: [String] = []
        var currentWorker: DNSPTCLWorker? = firstWorker
        
        while let worker = currentWorker {
            if let mockWorker = worker as? MockChainableWorker {
                chainNames.append(mockWorker.name)
            }
            if let baseWorker = worker as? WKRPTCLWorkerBase {
                currentWorker = baseWorker.nextBaseWorker
            } else {
                currentWorker = nil
            }
        }
        
        XCTAssertEqual(chainNames.count, 5)
        XCTAssertEqual(chainNames[0], "Worker_0")
        XCTAssertEqual(chainNames[4], "Worker_4")
    }
    
    func testChainMethodCallPropagation() {
        let primaryWorker = MockChainableWorker("Primary")
        let secondaryWorker = MockChainableWorker("Secondary")
        
        primaryWorker.nextBaseWorker = secondaryWorker
        primaryWorker.shouldHandleCall = false // Force delegation to next
        secondaryWorker.shouldHandleCall = true
        
        let expectation = self.expectation(description: "Chain call propagation")
        
        primaryWorker.performOperation("test_data") { result, handlerName in
            XCTAssertEqual(handlerName, "Secondary", "Secondary worker should handle the call")
            XCTAssertTrue(result, "Operation should succeed")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testChainFallthrough() {
        let workers = createWorkerChain(length: 3)
        
        // Configure first two workers to not handle calls
        (workers[0] as? MockChainableWorker)?.shouldHandleCall = false
        (workers[1] as? MockChainableWorker)?.shouldHandleCall = false
        (workers[2] as? MockChainableWorker)?.shouldHandleCall = true
        
        let expectation = self.expectation(description: "Chain fallthrough")
        
        workers[0].performOperation("fallthrough_test") { result, handlerName in
            XCTAssertEqual(handlerName, "Worker_2", "Final worker should handle the call")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testChainTermination() {
        let workers = createWorkerChain(length: 3)
        
        // Configure all workers to not handle calls
        workers.forEach { worker in
            (worker as? MockChainableWorker)?.shouldHandleCall = false
        }
        
        let expectation = self.expectation(description: "Chain termination")
        
        workers[0].performOperation("termination_test") { result, handlerName in
            XCTAssertFalse(result, "Operation should fail when no worker handles it")
            XCTAssertEqual(handlerName, "None", "No worker should handle the call")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Systems Worker Integration Tests
    
    func testSystemsWorkerInChain() {
        let primaryWorker = MockChainableWorker("Primary")
        let systemsWorker = MockSystemsWorker()
        
        primaryWorker.wkrSystems = systemsWorker
        
        XCTAssertNotNil(primaryWorker.wkrSystems)
        XCTAssertTrue(primaryWorker.wkrSystems is WKRPTCLSystems)
    }
    
    func testChainWithSystemsIntegration() {
        let workers = createWorkerChain(length: 3)
        let systemsWorker = MockSystemsWorker()
        
        // Assign systems worker to all workers in chain
        workers.forEach { worker in
            worker.wkrSystems = systemsWorker
        }
        
        // Verify all workers have systems reference
        workers.forEach { worker in
            XCTAssertNotNil(worker.wkrSystems)
            XCTAssertEqual(ObjectIdentifier(worker.wkrSystems as AnyObject), 
                         ObjectIdentifier(systemsWorker))
        }
    }
    
    // MARK: - Error Propagation Tests
    
    func testErrorPropagationThroughChain() {
        let workers = createWorkerChain(length: 3)
        
        // Configure chain to propagate errors
        (workers[0] as? MockChainableWorker)?.shouldThrowError = true
        (workers[1] as? MockChainableWorker)?.shouldHandleCall = false
        (workers[2] as? MockChainableWorker)?.shouldHandleCall = false
        
        let expectation = self.expectation(description: "Error propagation")
        
        workers[0].performOperation("error_test") { result, handlerName in
            XCTAssertFalse(result, "Operation should fail due to error")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Performance Tests
    
    func testChainTraversalPerformance() {
        let workers = createWorkerChain(length: 100)
        
        measure {
            for _ in 0..<100 {
                // Traverse the entire chain
                var currentWorker: DNSPTCLWorker? = workers.first
                var count = 0
                
                while let worker = currentWorker {
                    count += 1
                    if let baseWorker = worker as? WKRPTCLWorkerBase {
                currentWorker = baseWorker.nextBaseWorker
            } else {
                currentWorker = nil
            }
                }
                
                XCTAssertEqual(count, 100)
            }
        }
    }
    
    func testChainOperationPerformance() {
        let workers = createWorkerChain(length: 10)
        
        // Configure all workers to handle calls
        workers.forEach { worker in
            (worker as? MockChainableWorker)?.shouldHandleCall = true
        }
        
        measure {
            let group = DispatchGroup()
            
            for i in 0..<100 {
                group.enter()
                workers[0].performOperation("perf_test_\(i)") { _, _ in
                    group.leave()
                }
            }
            
            group.wait()
        }
    }
    
    // MARK: - Memory Management Tests
    
    func testChainMemoryManagement() {
        weak var weakFirstWorker: MockChainableWorker?
        weak var weakLastWorker: MockChainableWorker?
        
        autoreleasepool {
            let workers = createWorkerChain(length: 5)
            weakFirstWorker = workers.first as? MockChainableWorker
            weakLastWorker = workers.last as? MockChainableWorker
            
            XCTAssertNotNil(weakFirstWorker)
            XCTAssertNotNil(weakLastWorker)
        }
        
        // After autoreleasepool, all workers should be deallocated
        XCTAssertNil(weakFirstWorker, "First worker should be deallocated")
        XCTAssertNil(weakLastWorker, "Last worker should be deallocated")
    }
    
    func testCircularReferenceAvoidance() {
        let worker1 = MockChainableWorker("Worker1")
        let worker2 = MockChainableWorker("Worker2")
        
        // Create potential circular reference
        worker1.nextBaseWorker = worker2
        // Intentionally NOT setting: worker2.nextWorker = worker1
        
        weak var weakWorker1 = worker1
        weak var weakWorker2 = worker2
        
        // Clear strong references
        // In a real scenario, these would go out of scope
        XCTAssertNotNil(weakWorker1)
        XCTAssertNotNil(weakWorker2)
        
        // Test that the chain can be traversed without infinite loops
        var visitedWorkers = Set<ObjectIdentifier>()
        var currentWorker: DNSPTCLWorker? = worker1
        var loopDetected = false
        
        while let worker = currentWorker {
            let identifier = ObjectIdentifier(worker)
            if visitedWorkers.contains(identifier) {
                loopDetected = true
                break
            }
            visitedWorkers.insert(identifier)
            if let baseWorker = worker as? WKRPTCLWorkerBase {
                currentWorker = baseWorker.nextBaseWorker
            } else {
                currentWorker = nil
            }
        }
        
        XCTAssertFalse(loopDetected, "No circular reference should be detected")
        XCTAssertEqual(visitedWorkers.count, 2, "Should visit exactly 2 workers")
    }
}

// MARK: - Helper Methods

private extension ProtocolChainTests {
    
    func createWorkerChain(length: Int) -> [MockChainableWorker] {
        var workers: [MockChainableWorker] = []
        
        for i in 0..<length {
            let worker = MockChainableWorker("Worker_\(i)")
            workers.append(worker)
        }
        
        // Link them together
        for i in 0..<(length - 1) {
            workers[i].nextBaseWorker = workers[i + 1]
        }
        
        return workers
    }
}

// MARK: - Mock Implementations

private class MockChainableWorker: MockWorker {
    let name: String
    var shouldHandleCall = true
    override var shouldThrowError: Bool {
        get { return super.shouldThrowError }
        set { super.shouldThrowError = newValue }
    }
    
    init(_ name: String) {
        self.name = name
        super.init()
    }
    
    required init() {
        self.name = "DefaultWorker"
        super.init()
    }
    
    func performOperation(_ data: String, completion: @escaping (Bool, String) -> Void) {
        if shouldThrowError {
            completion(false, "Error")
            return
        }
        
        if shouldHandleCall {
            completion(true, name)
        } else {
            // Delegate to next worker
            if let nextWorker = self.nextBaseWorker as? MockChainableWorker {
                nextWorker.performOperation(data, completion: completion)
            } else {
                completion(false, "None")
            }
        }
    }
}

private class MockCacheWorker: MockWorker, WKRPTCLCache {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenError
    // MARK: - WKRPTCLCache Conformance
    var nextWorker: WKRPTCLCache? {
        get { return nextBaseWorker as? WKRPTCLCache }
        set { nextBaseWorker = newValue }
    }
    
    required init() {
        super.init()
    }
    
    func register(nextWorker: WKRPTCLCache, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.nextWorker = nextWorker
    }
    
    func doDeleteObject(for id: String, with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubVoid {
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func doDeleteObject(for id: String) -> WKRPTCLCachePubVoid {
        return doDeleteObject(for: id, with: nil)
    }
    
    func doLoadImage(from url: NSURL, for id: String, with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubImage {
        #if canImport(UIKit)
        return Just(UIImage()).setFailureType(to: Error.self).eraseToAnyPublisher()
        #else
        return Just("mock_image" as Any).setFailureType(to: Error.self).eraseToAnyPublisher()
        #endif
    }
    
    func doLoadImage(from url: NSURL, for id: String) -> WKRPTCLCachePubImage {
        return doLoadImage(from: url, for: id, with: nil)
    }
    
    func doReadObject(for id: String, with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubAny {
        return Just("test_value" as Any).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func doReadObject(for id: String) -> WKRPTCLCachePubAny {
        return doReadObject(for: id, with: nil)
    }
    
    func doReadString(for id: String, with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubString {
        return Just("test_string").setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func doReadString(for id: String) -> WKRPTCLCachePubString {
        return doReadString(for: id, with: nil)
    }
    
    func doUpdate(object: Any, for id: String, with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubAny {
        return Just(object).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func doUpdate(object: Any, for id: String) -> WKRPTCLCachePubAny {
        return doUpdate(object: object, for: id, with: nil)
    }
}

private class MockAuthAccessData: WKRPTCLAuthAccessData {
    var accessToken: String = "mock_access_token"
}

private class MockAsyncAuthWorker: MockWorker, WKRPTCLAuth {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenError
    // MARK: - WKRPTCLAuth Conformance
    var nextWorker: WKRPTCLAuth? {
        get { return nextBaseWorker as? WKRPTCLAuth }
        set { nextBaseWorker = newValue }
    }

    required init() {
        super.init()
    }

    func register(nextWorker: WKRPTCLAuth, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.nextWorker = nextWorker
    }

    // MARK: - Worker Logic (Public) -
    func doCheckAuth(using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAuthBlkBoolBoolAccessData?) {
        DispatchQueue.main.async {
            let accessData = MockAuthAccessData()
            block?(.success((true, true, accessData)))
        }
    }

    func doLinkAuth(from username: String, and password: String, using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAuthBlkBoolAccessData?) {
        DispatchQueue.main.async {
            let accessData = MockAuthAccessData()
            block?(.success((true, accessData)))
        }
    }

    func doPasswordResetStart(from username: String?, using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAuthBlkVoid?) {
        DispatchQueue.main.async {
            block?(.success(()))
        }
    }

    func doSignIn(from username: String?, and password: String?, using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAuthBlkBoolAccessData?) {
        DispatchQueue.main.async {
            let accessData = MockAuthAccessData()
            block?(.success((true, accessData)))
        }
    }

    func doSignOut(using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAuthBlkVoid?) {
        DispatchQueue.main.async {
            block?(.success(()))
        }
    }

    func doSignUp(from user: (any DAOUserProtocol)?, and password: String?, using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAuthBlkBoolAccessData?) {
        DispatchQueue.main.async {
            let accessData = MockAuthAccessData()
            block?(.success((true, accessData)))
        }
    }

    // MARK: - Worker Logic (Shortcuts) -
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
        doSignUp(from: user, and: password, using: parameters, with: nil as DNSPTCLProgressBlock?, and: block)
    }
}

private class MockAsyncAnalyticsWorker: MockWorker, WKRPTCLAnalytics {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenError
    // MARK: - WKRPTCLAnalytics Conformance
    var nextWorker: WKRPTCLAnalytics? {
        get { return nextBaseWorker as? WKRPTCLAnalytics }
        set { nextBaseWorker = newValue }
    }
    
    required init() {
        super.init()
    }

    func register(nextWorker: WKRPTCLAnalytics, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.nextWorker = nextWorker
    }

    // MARK: - Auto-Track -
    @discardableResult
    func doAutoTrack(class: String, method: String) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    @discardableResult
    func doAutoTrack(class: String, method: String, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    @discardableResult
    func doAutoTrack(class: String, method: String, properties: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    // MARK: - Group -
    @discardableResult
    func doGroup(groupId: String) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    @discardableResult
    func doGroup(groupId: String, traits: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    @discardableResult
    func doGroup(groupId: String, traits: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    // MARK: - Identify -
    @discardableResult
    func doIdentify(userId: String) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    @discardableResult
    func doIdentify(userId: String, traits: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    @discardableResult
    func doIdentify(userId: String, traits: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    func doIdentify(userId: String, with traits: DNSDataDictionary, and block: WKRPTCLAnalyticsBlkVoid?) {
        DispatchQueue.main.async {
            block?(.success(()))
        }
    }

    func doIdentify(userId: String, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAnalyticsBlkVoid?) {
        DispatchQueue.main.async {
            block?(.success(()))
        }
    }

    func doIdentify(userId: String, with traits: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAnalyticsBlkVoid?) {
        DispatchQueue.main.async {
            block?(.success(()))
        }
    }

    // MARK: - Screen -
    @discardableResult
    func doScreen(screenTitle: String) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    @discardableResult
    func doScreen(screenTitle: String, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    @discardableResult
    func doScreen(screenTitle: String, properties: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    // MARK: - Track -
    @discardableResult
    func doTrack(event: WKRPTCLAnalytics.Events) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    @discardableResult
    func doTrack(event: WKRPTCLAnalytics.Events, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    @discardableResult
    func doTrack(event: WKRPTCLAnalytics.Events, properties: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }
}

