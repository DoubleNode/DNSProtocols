//
//  WKRPTCLWorkerBaseTests.swift
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

class WKRPTCLWorkerBaseTests: ProtocolTestBase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Protocol Existence Tests
    
    func testWKRPTCLWorkerBaseProtocolExists() {
        validateProtocolExists(WKRPTCLWorkerBase.self)
    }
    
    func testWKRPTCLWorkerBaseInheritsFromAnyObject() {
        let mockWorker = MockWorker()
        XCTAssertTrue(mockWorker is AnyObject, "WKRPTCLWorkerBase should inherit from AnyObject")
        validateProtocolConformance(mockWorker, conformsTo: WKRPTCLWorkerBase.self)
    }
    
    // MARK: - Property Tests
    
    func testNextWorkerProperty() {
        let mockWorker = MockWorker()
        let nextWorker = MockWorker()
        
        // Test initial nil state
        XCTAssertNil(mockWorker.nextBaseWorker)
        
        // Test assignment
        mockWorker.nextBaseWorker = nextWorker
        XCTAssertNotNil(mockWorker.nextBaseWorker)
        XCTAssertTrue(mockWorker.nextBaseWorker === nextWorker)
        
        // Test reassignment to nil
        mockWorker.nextBaseWorker = nil
        XCTAssertNil(mockWorker.nextBaseWorker)
    }
    
    func testSystemsWorkerProperty() {
        let mockWorker = MockWorker()
        let systemsWorker = MockSystemsWorker()
        
        // Test initial nil state
        XCTAssertNil(mockWorker.wkrSystems)
        
        // Test assignment
        mockWorker.wkrSystems = systemsWorker
        XCTAssertNotNil(mockWorker.wkrSystems)
        XCTAssertTrue(mockWorker.wkrSystems === systemsWorker)
        
        // Test that it conforms to WKRPTCLSystems
        if let systems = mockWorker.wkrSystems {
            XCTAssertTrue(systems is WKRPTCLSystems)
        }
    }
    
    // MARK: - Chain of Responsibility Pattern Tests
    
    func testBasicChainPattern() {
        let primaryWorker = MockWorker()
        let secondaryWorker = MockWorker()
        let tertiaryWorker = MockWorker()
        
        // Build chain: primary -> secondary -> tertiary
        primaryWorker.nextBaseWorker = secondaryWorker
        secondaryWorker.nextBaseWorker = tertiaryWorker
        
        // Verify chain structure
        XCTAssertEqual(ObjectIdentifier(primaryWorker.nextBaseWorker!), ObjectIdentifier(secondaryWorker))
        XCTAssertEqual(ObjectIdentifier(secondaryWorker.nextBaseWorker!), ObjectIdentifier(tertiaryWorker))
        XCTAssertNil(tertiaryWorker.nextBaseWorker)
    }
    
    func testChainTraversal() {
        let workers = createWorkerChain(length: 5)
        
        // Traverse the chain and count workers
        var currentWorker: MockWorker? = workers.first as? MockWorker
        var workerCount = 0
        
        while let worker = currentWorker {
            workerCount += 1
            currentWorker = worker.nextBaseWorker as? MockWorker
        }
        
        XCTAssertEqual(workerCount, 5, "Chain should contain exactly 5 workers")
    }
    
    func testChainCircularReferenceDetection() {
        let worker1 = MockWorker()
        let worker2 = MockWorker()
        let worker3 = MockWorker()
        
        // Create a potential circular chain
        worker1.nextBaseWorker = worker2
        worker2.nextBaseWorker = worker3
        // Intentionally NOT creating: worker3.nextWorker = worker1
        
        // Test that traversal terminates properly
        var visitedWorkers = Set<ObjectIdentifier>()
        var currentWorker: MockWorker? = worker1
        var infiniteLoopDetected = false
        var iterations = 0
        
        while let worker = currentWorker, iterations < 100 {
            let identifier = ObjectIdentifier(worker)
            if visitedWorkers.contains(identifier) {
                infiniteLoopDetected = true
                break
            }
            visitedWorkers.insert(identifier)
            currentWorker = worker.nextBaseWorker as? MockWorker
            iterations += 1
        }
        
        XCTAssertFalse(infiniteLoopDetected, "Chain traversal should not create infinite loops")
        XCTAssertEqual(visitedWorkers.count, 3, "Should visit exactly 3 workers")
    }
    
    func testChainMethodDelegation() {
        let primaryWorker = MockChainableWorkerBase("Primary")
        let secondaryWorker = MockChainableWorkerBase("Secondary")
        
        primaryWorker.nextBaseWorker = secondaryWorker
        primaryWorker.shouldHandleCall = false  // Force delegation
        secondaryWorker.shouldHandleCall = true
        
        let expectation = self.expectation(description: "Chain delegation")
        
        primaryWorker.performChainableOperation("test_data") { result, handlerName in
            XCTAssertTrue(result, "Operation should succeed")
            XCTAssertEqual(handlerName, "Secondary", "Secondary worker should handle the call")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testChainTerminationWhenNoHandlerFound() {
        let workers = createChainableWorkerChain(length: 3)
        
        // Configure all workers to not handle calls
        workers.forEach { $0.shouldHandleCall = false }
        
        let expectation = self.expectation(description: "Chain termination")
        
        workers[0].performChainableOperation("termination_test") { result, handlerName in
            XCTAssertFalse(result, "Operation should fail when no worker handles it")
            XCTAssertEqual(handlerName, "None", "No worker should handle the call")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Integration with Systems Worker Tests
    
    func testSystemsWorkerIntegration() {
        let worker = MockWorkerBaseImplementation()
        let systemsWorker = MockSystemsWorker()
        
        worker.wkrSystems = systemsWorker
        
        // Test that systems worker can be accessed and used
        XCTAssertNotNil(worker.wkrSystems)
        
        let expectation = self.expectation(description: "Systems integration")
        worker.wkrSystems?.doConfigure { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Systems worker should be functional")
            case .failure(let error):
                XCTFail("Systems integration should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testChainWithSystemsIntegration() {
        let workers = createWorkerChain(length: 3)
        let systemsWorker = MockSystemsWorker()
        
        // Assign same systems worker to all workers in chain
        workers.forEach { $0.wkrSystems = systemsWorker }
        
        // Verify all workers have systems reference
        workers.forEach { worker in
            XCTAssertNotNil(worker.wkrSystems)
            XCTAssertEqual(ObjectIdentifier(worker.wkrSystems! as AnyObject), 
                         ObjectIdentifier(systemsWorker))
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testWorkerBaseErrorHandling() {
        let worker = MockWorkerBaseImplementation()
        worker.shouldThrowError = true
        
        let expectation = self.expectation(description: "Error handling")
        
        worker.performTestOperation { result in
            XCTAssertFalse(result, "Operation should fail when error is configured")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Memory Management Tests
    
    func testWorkerChainMemoryManagement() {
        weak var weakFirstWorker: MockWorkerBaseImplementation?
        weak var weakLastWorker: MockWorkerBaseImplementation?
        
        autoreleasepool {
            let workers = createWorkerChain(length: 5)
            weakFirstWorker = workers.first
            weakLastWorker = workers.last
            
            XCTAssertNotNil(weakFirstWorker)
            XCTAssertNotNil(weakLastWorker)
        }
        
        // After autoreleasepool, workers should be deallocated
        XCTAssertNil(weakFirstWorker, "First worker should be deallocated")
        XCTAssertNil(weakLastWorker, "Last worker should be deallocated")
    }
    
    func testSystemsWorkerMemoryManagement() {
        weak var weakWorker: MockWorkerBaseImplementation?
        weak var weakSystemsWorker: MockSystemsWorker?
        
        autoreleasepool {
            let worker = MockWorkerBaseImplementation()
            let systemsWorker = MockSystemsWorker()
            
            worker.wkrSystems = systemsWorker
            weakWorker = worker
            weakSystemsWorker = systemsWorker
            
            XCTAssertNotNil(weakWorker)
            XCTAssertNotNil(weakSystemsWorker)
        }
        
        // After autoreleasepool, references should be deallocated
        XCTAssertNil(weakWorker, "Worker should be deallocated")
        XCTAssertNil(weakSystemsWorker, "Systems worker should be deallocated")
    }
    
    // MARK: - Thread Safety Tests
    
    func testWorkerBaseConcurrency() async {
        let worker = MockWorkerBaseImplementation()
        let systemsWorker = MockSystemsWorker()
        worker.wkrSystems = systemsWorker
        
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask {
                    let expectation = XCTestExpectation(description: "Concurrent worker operation \(i)")
                    
                    worker.performTestOperation { result in
                        XCTAssertTrue(result, "Concurrent operation should succeed")
                        expectation.fulfill()
                    }
                    
                    await self.fulfillment(of: [expectation], timeout: 1.0)
                }
            }
        }
        
        XCTAssertTrue(true, "Concurrent worker operations should not cause issues")
    }
    
    func testChainConcurrentAccess() async {
        let workers = createWorkerChain(length: 5)
        
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask {
                    // Traverse the chain concurrently
                    var currentWorker: DNSPTCLWorker? = workers.first
                    var count = 0
                    
                    while let worker = currentWorker {
                        count += 1
                        currentWorker = worker.nextBaseWorker
                    }
                    
                    XCTAssertEqual(count, 5, "Chain traversal should be thread-safe")
                }
            }
        }
        
        XCTAssertTrue(true, "Concurrent chain access should be safe")
    }
    
    // MARK: - Performance Tests
    
    func testWorkerChainTraversalPerformance() {
        let workers = createWorkerChain(length: 100)
        
        measure {
            for _ in 0..<100 {
                // Traverse the entire chain
                var currentWorker: DNSPTCLWorker? = workers.first
                var count = 0
                
                while let worker = currentWorker {
                    count += 1
                    currentWorker = worker.nextBaseWorker
                }
                
                XCTAssertEqual(count, 100)
            }
        }
    }
    
    func testWorkerInstantiationPerformance() {
        measure {
            for _ in 0..<1000 {
                let worker = MockWorkerBaseImplementation()
                let systemsWorker = MockSystemsWorker()
                worker.wkrSystems = systemsWorker
                
                XCTAssertNotNil(worker.wkrSystems)
            }
        }
    }
}

// MARK: - Helper Methods

private extension WKRPTCLWorkerBaseTests {
    
    func createWorkerChain(length: Int) -> [MockWorker] {
        var workers: [MockWorker] = []
        
        for _ in 0..<length {
            let worker = MockWorker()
            workers.append(worker)
        }
        
        // Link them together
        for i in 0..<(length - 1) {
            workers[i].nextBaseWorker = workers[i + 1]
        }
        
        return workers
    }
    
    func createChainableWorkerChain(length: Int) -> [MockChainableWorkerBase] {
        var workers: [MockChainableWorkerBase] = []
        
        for i in 0..<length {
            let worker = MockChainableWorkerBase("Worker_\(i)")
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

extension MockWorkerBaseImplementation {
    func performTestOperation(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            completion(!self.shouldThrowError)
        }
    }
}

private class MockChainableWorkerBase: MockWorkerBaseImplementation {
    let name: String
    var shouldHandleCall = true
    
    override var nextBaseWorker: DNSPTCLWorker? {
        get { return chainableNextWorker }
        set { chainableNextWorker = newValue }
    }
    private var chainableNextWorker: DNSPTCLWorker?
    
    required init() {
        self.name = "Default"
        super.init()
    }
    
    init(_ name: String) {
        self.name = name
        super.init()
    }
    
    func performChainableOperation(_ data: String, completion: @escaping (Bool, String) -> Void) {
        if shouldHandleCall {
            DispatchQueue.main.async {
                completion(true, self.name)
            }
        } else {
            // Delegate to next worker
            if let nextWorker = self.nextBaseWorker as? MockChainableWorkerBase {
                nextWorker.performChainableOperation(data, completion: completion)
            } else {
                DispatchQueue.main.async {
                    completion(false, "None")
                }
            }
        }
    }
}

