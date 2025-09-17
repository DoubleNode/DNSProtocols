//
//  TypeAliasValidationTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocolsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import Foundation
import DNSCore
import DNSError
import DNSDataObjects
@testable import DNSProtocols

class TypeAliasValidationTests: ProtocolTestBase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Core Protocol Type Aliases
    
    func testDNSPTCLCallBlockTypeAlias() {
        validateTypeAlias(DNSPTCLCallBlock.self, aliasName: "DNSPTCLCallBlock")
        
        // Test that call block can be created and invoked
        let callBlock: DNSPTCLCallBlock = { 
            return "test_result"
        }
        
        let result = callBlock()
        XCTAssertNotNil(result, "Call block should return a result")
        XCTAssertEqual(result as? String, "test_result", "Call block should return expected value")
    }
    
    func testDNSPTCLCallResultBlockTypeAlias() {
        validateTypeAlias(DNSPTCLCallResultBlock.self, aliasName: "DNSPTCLCallResultBlock")
        
        // Test that call result block can be created and invoked
        let callResultBlock: DNSPTCLCallResultBlock = { resultBlock in
            resultBlock?(.completed)
            return "call_completed"
        }
        
        let mockResultBlock: DNSPTCLResultBlock = { result in
            XCTAssertTrue(true, "Result callback executed")
            return nil
        }
        
        let result = callResultBlock(mockResultBlock)
        XCTAssertNotNil(result, "Call result block should return a value")
    }
    
    func testDNSPTCLProgressBlockTypeAlias() {
        validateTypeAlias(DNSPTCLProgressBlock.self, aliasName: "DNSPTCLProgressBlock")
        
        // Test progress block functionality
        var progressCallCount = 0
        let progressBlock: DNSPTCLProgressBlock = { currentStep, totalSteps, percentCompleted, statusText in
            progressCallCount += 1
            XCTAssertGreaterThanOrEqual(currentStep, 0, "Current step should be non-negative")
            XCTAssertGreaterThan(totalSteps, 0, "Total steps should be positive")
            XCTAssertGreaterThanOrEqual(percentCompleted, 0.0, "Percent completed should be non-negative")
            XCTAssertLessThanOrEqual(percentCompleted, 1.0, "Percent completed should not exceed 100%")
            XCTAssertFalse(statusText.isEmpty, "Status text should not be empty")
        }
        
        // Test various progress scenarios
        progressBlock(0, 100, 0.0, "Starting")
        progressBlock(25, 100, 0.25, "25% Complete")
        progressBlock(50, 100, 0.5, "Half Way")
        progressBlock(100, 100, 1.0, "Completed")
        
        XCTAssertEqual(progressCallCount, 4, "Progress block should have been called 4 times")
    }
    
    func testDNSPTCLResultBlockTypeAlias() {
        validateTypeAlias(DNSPTCLResultBlock.self, aliasName: "DNSPTCLResultBlock")
        
        // Test all result types
        let resultBlock: DNSPTCLResultBlock = { result in
            switch result {
            case .completed:
                return "success"
            case .error:
                return "error"
            case .failure(let error):
                return "failure: \(error.localizedDescription)"
            case .notFound:
                return "not_found"
            case .unhandled:
                return "unhandled"
            }
        }
        
        // Test each result type
        XCTAssertEqual(resultBlock(.completed) as? String, "success")
        XCTAssertEqual(resultBlock(.error) as? String, "error")
        XCTAssertEqual(resultBlock(.notFound) as? String, "not_found")
        XCTAssertEqual(resultBlock(.unhandled) as? String, "unhandled")
        
        let testError = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "test error"])
        let failureResult = resultBlock(.failure(testError)) as? String
        XCTAssertTrue(failureResult?.contains("failure: test error") == true, "Failure result should contain error description")
    }
    
    // MARK: - Worker Base Protocol Type Aliases
    
    func testWKRPTCLWorkerBaseReturnTypeAliases() {
        validateTypeAlias(WKRPTCLWorkerBaseRtnAAnalyticsData.self, aliasName: "WKRPTCLWorkerBaseRtnAAnalyticsData")
        
        // Test that return type can be created and used
        let analyticsData: WKRPTCLWorkerBaseRtnAAnalyticsData = []
        XCTAssertNotNil(analyticsData, "Analytics data return type should be instantiable")
        XCTAssertTrue(analyticsData.isEmpty, "Empty analytics data array should be valid")
        
        // Test with actual data
        let testData = DAOAnalyticsData()
        let populatedData: WKRPTCLWorkerBaseRtnAAnalyticsData = [testData]
        XCTAssertEqual(populatedData.count, 1, "Analytics data array should contain one item")
    }
    
    func testWKRPTCLWorkerBaseResultTypeAliases() {
        validateTypeAlias(WKRPTCLWorkerBaseResAAnalyticsData.self, aliasName: "WKRPTCLWorkerBaseResAAnalyticsData")
        
        // Test success result
        let successResult: WKRPTCLWorkerBaseResAAnalyticsData = .success([])
        switch successResult {
        case .success(let data):
            XCTAssertTrue(data.isEmpty, "Success result should contain empty array")
        case .failure:
            XCTFail("Success result should not be failure")
        }
        
        // Test failure result
        let testError = NSError(domain: "test", code: 1, userInfo: nil)
        let failureResult: WKRPTCLWorkerBaseResAAnalyticsData = .failure(testError)
        switch failureResult {
        case .success:
            XCTFail("Failure result should not be success")
        case .failure(let error):
            XCTAssertEqual(error as NSError, testError, "Failure result should contain expected error")
        }
    }
    
    func testWKRPTCLWorkerBaseBlockTypeAliases() {
        validateTypeAlias(WKRPTCLWorkerBaseBlkAAnalyticsData.self, aliasName: "WKRPTCLWorkerBaseBlkAAnalyticsData")
        
        var blockCallCount = 0
        let analyticsBlock: WKRPTCLWorkerBaseBlkAAnalyticsData = { result in
            blockCallCount += 1
            switch result {
            case .success(let data):
                XCTAssertNotNil(data, "Success result data should not be nil")
            case .failure(let error):
                XCTAssertNotNil(error, "Failure result error should not be nil")
            }
        }
        
        // Test with success result
        analyticsBlock(.success([]))
        XCTAssertEqual(blockCallCount, 1, "Block should have been called once")
        
        // Test with failure result
        analyticsBlock(.failure(NSError(domain: "test", code: 1, userInfo: nil)))
        XCTAssertEqual(blockCallCount, 2, "Block should have been called twice")
    }
    
    // MARK: - Protocol Type Compatibility Tests
    
    func testTypeAliasCompatibilityWithFoundationTypes() {
        // Test that our type aliases work with Foundation types
        let progressBlock: DNSPTCLProgressBlock = { current, total, percent, status in
            // Test parameter types are correct
            XCTAssertTrue(current is Int64, "Current should be Int64")
            XCTAssertTrue(total is Int64, "Total should be Int64")
            XCTAssertTrue(percent is Double, "Percent should be Double")
            XCTAssertTrue(status is String, "Status should be String")
        }
        
        progressBlock(Int64(10), Int64(100), Double(0.1), String("Testing"))
    }
    
    func testTypeAliasCompatibilityWithDNSError() {
        let resultBlock: DNSPTCLResultBlock = { result in
            switch result {
            case .failure(let error):
                // Test that DNSError can be used with result block
                if let analyticsError = error as? WKRPTCLAnalyticsError {
                    XCTAssertNotNil(analyticsError.nsError.domain, "DNSError should have domain")
                    XCTAssertNotEqual(analyticsError.nsError.code, 0, "DNSError should have error code")
                }
                return "dns_error_handled"
            default:
                return nil
            }
        }
        
        let dnsError = DNSError.Analytics.unknown(DNSCodeLocation(self))
        let result = resultBlock(.failure(dnsError))
        XCTAssertEqual(result as? String, "dns_error_handled", "DNSError should be compatible with result block")
    }
    
    // MARK: - Type Alias Chain Integration Tests
    
    func testTypeAliasChainCompatibility() {
        // Test that type aliases work together in chain patterns
        let callResultBlock: DNSPTCLCallResultBlock = { resultBlock in
            let progressBlock: DNSPTCLProgressBlock = { current, total, percent, status in
                // Progress updated
            }
            
            // Simulate some work with progress
            progressBlock(1, 3, 0.33, "Step 1")
            progressBlock(2, 3, 0.66, "Step 2")
            progressBlock(3, 3, 1.0, "Complete")
            
            // Complete with result
            resultBlock?(.completed)
            
            return "chain_completed"
        }
        
        var finalResult: DNSPTCLWorker.Call.Result?
        let resultBlock: DNSPTCLResultBlock = { result in
            finalResult = result
            return nil
        }
        
        let chainResult = callResultBlock(resultBlock)
        XCTAssertEqual(chainResult as? String, "chain_completed", "Chain should complete successfully")
        XCTAssertNotNil(finalResult, "Final result should be provided")
    }
    
    // MARK: - Memory Management Tests
    
    func testTypeAliasMemoryManagement() {
        // Test that we can create and use a DNSPTCLProgressBlock
        let progressBlock: DNSPTCLProgressBlock = { current, total, percentage, status in
            // This closure should be callable and have the correct signature
            XCTAssertGreaterThanOrEqual(current, 0, "Current progress should be non-negative")
            XCTAssertGreaterThanOrEqual(total, 0, "Total progress should be non-negative")
            XCTAssertGreaterThanOrEqual(percentage, 0.0, "Percentage should be non-negative")
            XCTAssertNotNil(status, "Status should not be nil")
        }

        // Test the block can be called with valid parameters
        progressBlock(50, 100, 0.5, "Test progress")

        // Test that the block can be assigned to a variable and called
        let anotherBlock = progressBlock
        anotherBlock(25, 100, 0.25, "Another test")

        // Verify the type alias is working correctly
        XCTAssertTrue(type(of: progressBlock) == DNSPTCLProgressBlock.self, "Block should have correct type")

        // Test memory behavior by ensuring blocks can be assigned and reassigned
        var mutableBlock: DNSPTCLProgressBlock? = progressBlock
        XCTAssertNotNil(mutableBlock, "Block should be assignable")

        mutableBlock = nil
        XCTAssertNil(mutableBlock, "Block reference should be nil after assignment")
    }
    
    // MARK: - Thread Safety Tests
    
    func testTypeAliasThreadSafety() async {
        let progressBlock: DNSPTCLProgressBlock = { _, _, _, _ in }
        
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<100 {
                group.addTask {
                    progressBlock(Int64(i), 100, Double(i)/100.0, "Step \(i)")
                }
            }
        }
        
        XCTAssertTrue(true, "Concurrent type alias usage should not cause crashes")
    }
    
    // MARK: - Performance Tests
    
    func testTypeAliasCreationPerformance() {
        measure {
            for _ in 0..<1000 {
                let _: DNSPTCLProgressBlock = { _, _, _, _ in }
                let _: DNSPTCLResultBlock = { _ in return nil }
                let _: DNSPTCLCallBlock = { return nil }
            }
        }
    }
    
    func testTypeAliasInvocationPerformance() {
        let progressBlock: DNSPTCLProgressBlock = { _, _, _, _ in }
        let resultBlock: DNSPTCLResultBlock = { _ in return nil }
        let callBlock: DNSPTCLCallBlock = { return nil }
        
        measure {
            for i in 0..<1000 {
                progressBlock(Int64(i), 1000, Double(i)/1000.0, "Progress")
                let _ = resultBlock(.completed)
                let _ = callBlock()
            }
        }
    }
}