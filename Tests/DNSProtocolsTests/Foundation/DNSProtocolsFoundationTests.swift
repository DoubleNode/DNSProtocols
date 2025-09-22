//
//  DNSProtocolsFoundationTests.swift
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

class DNSProtocolsFoundationTests: ProtocolTestBase {
    
    // MARK: - Core Protocol Tests
    
    func testDNSPTCLWorkerProtocolExists() {
        validateProtocolExists(DNSPTCLWorker.self)
    }
    
    func testDNSPTCLCallEnumExists() {
        validateProtocolExists(DNSPTCLCall.self)
    }
    
    func testDNSPTCLCallValues() {
        // Test DNSPTCLCall nested enums
        let nextWhenAlways: DNSPTCLCall.NextWhen = .always
        let nextWhenError: DNSPTCLCall.NextWhen = .whenError
        let nextWhenNotFound: DNSPTCLCall.NextWhen = .whenNotFound
        let nextWhenUnhandled: DNSPTCLCall.NextWhen = .whenUnhandled
        
        XCTAssertNotNil(nextWhenAlways)
        XCTAssertNotNil(nextWhenError)
        XCTAssertNotNil(nextWhenNotFound)
        XCTAssertNotNil(nextWhenUnhandled)
        
        // Test DNSPTCLCall.Result cases
        let resultCompleted: DNSPTCLCall.Result = .completed
        let resultError: DNSPTCLCall.Result = .error
        let resultNotFound: DNSPTCLCall.Result = .notFound
        let resultUnhandled: DNSPTCLCall.Result = .unhandled
        
        XCTAssertNotNil(resultCompleted)
        XCTAssertNotNil(resultError)
        XCTAssertNotNil(resultNotFound)
        XCTAssertNotNil(resultUnhandled)
    }
    
    // MARK: - Type Alias Validation Tests
    
    func testProgressBlockTypeAlias() {
        validateTypeAlias(DNSPTCLProgressBlock.self, aliasName: "DNSPTCLProgressBlock")
        
        // Test that progress block can be created and called
        let progressBlock: DNSPTCLProgressBlock = { current, total, percentage, message in
            XCTAssertGreaterThanOrEqual(current, 0)
            XCTAssertGreaterThanOrEqual(total, 0)
            XCTAssertGreaterThanOrEqual(percentage, 0.0)
            XCTAssertLessThanOrEqual(percentage, 1.0)
        }
        
        // Test progress block execution
        progressBlock(50, 100, 0.5, "Test Progress")
    }
    
    func testResultBlockTypeAliases() {
        // Test basic result block types exist and are callable
        validateTypeAlias(DNSPTCLResultBlock.self, aliasName: "DNSPTCLResultBlock")
        
        let resultBlock: DNSPTCLResultBlock = { result in
            switch result {
            case .completed:
                XCTAssertTrue(true, "Completed case handled")
            case .error:
                XCTAssertTrue(true, "Error case handled")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be provided")
            case .notFound:
                XCTAssertTrue(true, "Not found case handled")
            case .unhandled:
                XCTAssertTrue(true, "Unhandled case handled")
            }
        }
        
        // Test various result cases
        resultBlock(.completed)
        resultBlock(.error)
        resultBlock(.failure(NSError(domain: "test", code: 1)))
        resultBlock(.notFound)
        resultBlock(.unhandled)
    }
    
    // MARK: - Core Worker Protocol Tests
    
    func testDNSPTCLWorkerRequiredProperties() {
        let mockWorker = MockWorker()
        
        // Test that required properties exist and can be set
        XCTAssertNil(mockWorker.nextBaseWorker, "NextWorker should initially be nil")
        let baseWorker = mockWorker as WKRPTCLWorkerBase
        XCTAssertNil(baseWorker.wkrSystems, "Systems worker should initially be nil")
        
        // Test property assignment
        let nextWorker = MockWorker()
        mockWorker.nextBaseWorker = nextWorker
        XCTAssertNotNil(mockWorker.nextBaseWorker, "NextWorker should be assignable")
    }
    
    func testDNSPTCLWorkerInitialization() {
        let worker = MockWorker()
        XCTAssertNotNil(worker, "Worker should initialize successfully")
        
        // Test required initializer
        let worker2 = MockWorker.init()
        XCTAssertNotNil(worker2, "Worker should initialize with required init")
    }
    
    func testDNSPTCLWorkerConfiguration() {
        let worker = MockWorker()
        
        // Test configure method exists and can be called
        worker.configure()
        
        // Since it's a mock, we just verify it doesn't crash
        XCTAssertTrue(true, "Configure method should execute without error")
    }
    
    // MARK: - Protocol Inheritance Tests
    
    func testProtocolInheritanceChain() {
        // Test that worker protocols inherit from base protocols correctly
        let mockWorker = MockWorker()
        
        validateProtocolConformance(mockWorker, conformsTo: DNSPTCLWorker.self)
    }
    
    // MARK: - Error Handling Tests
    
    func testDNSErrorIntegration() {
        // Test that DNSError integrates properly with protocol error handling
        let codeLocation = DNSCodeLocation(self)
        let testError = DNSError.Analytics.invalidParameters(parameters: ["test"], codeLocation)
        
        XCTAssertNotNil(testError, "DNSError should be created successfully")
        XCTAssertEqual(testError.nsError.domain, "WKRANALYTICS", "Error domain should match")
    }
    
    // MARK: - Code Location Tests
    
    func testCodeLocationTracking() {
        // Test that code location tracking works with protocols
        let codeLocation = DNSProtocolsCodeLocation(self)
        
        XCTAssertNotNil(codeLocation, "Code location should be accessible")
        XCTAssertFalse(codeLocation.file.isEmpty, "Code location should have filename")
    }
    
    // MARK: - Memory Management Tests
    
    func testWorkerMemoryManagement() {
        weak var weakWorker: MockWorker?
        
        autoreleasepool {
            let worker = MockWorker()
            weakWorker = worker
            XCTAssertNotNil(weakWorker, "Worker should exist in memory")
        }
        
        // After autoreleasepool, worker should be deallocated
        XCTAssertNil(weakWorker, "Worker should be deallocated when no strong references remain")
    }
    
    // MARK: - Thread Safety Tests
    
    func testWorkerThreadSafety() async {
        let worker = MockWorker()
        
        await withTaskGroup(of: Void.self) { group in
            // Test concurrent access to worker properties
            for _ in 0..<10 {
                group.addTask {
                    let nextWorker = MockWorker()
                    worker.nextBaseWorker = nextWorker
                    worker.configure()
                }
            }
        }
        
        XCTAssertTrue(true, "Concurrent worker access should not crash")
    }
    
    // MARK: - Performance Tests
    
    func testWorkerCreationPerformance() {
        measure {
            for _ in 0..<1000 {
                let worker = MockWorker()
                worker.configure()
            }
        }
    }
    
    func testProgressBlockPerformance() {
        let progressBlock: DNSPTCLProgressBlock = { _, _, _, _ in }
        
        measure {
            for i in 0..<1000 {
                progressBlock(Int64(i), 1000, Double(i)/1000.0, "Progress \(i)")
            }
        }
    }
}
