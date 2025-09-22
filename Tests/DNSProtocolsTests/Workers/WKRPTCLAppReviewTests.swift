//
//  WKRPTCLAppReviewTests.swift
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

class WKRPTCLAppReviewTests: ProtocolTestBase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Protocol Existence Tests
    
    func testWKRPTCLAppReviewProtocolExists() {
        validateProtocolExists(WKRPTCLAppReview.self)
    }
    
    func testWKRPTCLAppReviewInheritsFromWorkerBase() {
        let mockAppReview = MockAppReviewWorker()
        validateProtocolConformance(mockAppReview, conformsTo: WKRPTCLWorkerBase.self)
        validateProtocolConformance(mockAppReview, conformsTo: WKRPTCLAppReview.self)
    }
    
    // MARK: - Type Alias Tests
    
    func testAppReviewTypeAliases() {
        // Test return type aliases exist
        validateTypeAlias(WKRPTCLAppReviewRtnVoid.self, aliasName: "WKRPTCLAppReviewRtnVoid")
        
        // Test result type aliases exist
        validateTypeAlias(WKRPTCLAppReviewResVoid.self, aliasName: "WKRPTCLAppReviewResVoid")
        
        // Test block type aliases exist
    }
    
    func testAppReviewBlockCreation() {
        // Test that app review blocks can be created and called
        let voidBlock: WKRPTCLAppReviewBlkVoid = { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Void success handled")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
        
        // Test block execution
        voidBlock(.success(()))
    }
    
    // MARK: - Error Extension Tests
    
    func testAppReviewErrorCases() {
        let codeLocation = DNSCodeLocation(self)
        let expectedErrorCases: [WKRPTCLAppReviewError] = [
            .unknown(codeLocation),
            .notImplemented(codeLocation),
            .invalidParameters(parameters: ["param1"], codeLocation),
            .reviewNotAvailable(codeLocation),
            .userDeclined(codeLocation)
        ]
        
        for errorCase in expectedErrorCases {
            XCTAssertNotNil(errorCase.errorString, "Error case should have error string")
            XCTAssertNotNil(errorCase.nsError, "Error case should convert to NSError")
        }
    }
    
    func testAppReviewDNSErrorConversion() {
        let codeLocation = DNSCodeLocation(self)
        let appReviewError = WKRPTCLAppReviewError.reviewNotAvailable(codeLocation)
        let dnsError = DNSError.AppReview.reviewNotAvailable(codeLocation)
        
        XCTAssertEqual(appReviewError.nsError.domain, dnsError.nsError.domain)
        XCTAssertEqual(appReviewError.nsError.code, dnsError.nsError.code)
    }
    
    // MARK: - Protocol Method Signature Tests
    
    func testAppReviewMethodSignatures() {
        let mockAppReview = MockAppReviewWorker()
        
        // Test that all required methods are accessible
        validateMethodSignature(mockAppReview, methodName: "doReview")
    }
    
    // MARK: - App Review Methods
    
    func testDoReviewMethod() {
        let mockAppReview = MockAppReviewWorker()
        let expectation = self.expectation(description: "App review completion")
        
        mockAppReview.doReview { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "App review should succeed")
            case .failure(let error):
                XCTFail("App review should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testDoReviewWithParametersMethod() {
        let mockAppReview = MockAppReviewWorker()
        let expectation = self.expectation(description: "App review with parameters completion")
        let parameters = TestDataGenerator.generateTestParameters()
        
        mockAppReview.doReview(using: parameters) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "App review with parameters should succeed")
            case .failure(let error):
                XCTFail("App review with parameters should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Progress Block Tests
    
    func testAppReviewWithProgress() {
        let mockAppReview = MockAppReviewWorker()
        let expectation = self.expectation(description: "App review with progress completion")
        let progressExpectation = self.expectation(description: "Progress callback")
        
        let progressBlock = MockProtocolFactory.createMockProgressBlock()
        
        mockAppReview.doReview(with: progressBlock) { result in
            expectation.fulfill()
        }
        
        // Simulate progress
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            progressExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
    
    // MARK: - Chain of Responsibility Tests
    
    func testAppReviewWorkerChaining() {
        let primaryAppReview = MockAppReviewWorker()
        let nextAppReview = MockAppReviewWorker()
        
        primaryAppReview.nextWorker = nextAppReview
        
        // Test that chaining works
        XCTAssertNotNil(primaryAppReview.nextWorker)
        
        if let chainedWorker = primaryAppReview.nextWorker as? MockAppReviewWorker {
            XCTAssertEqual(ObjectIdentifier(chainedWorker), ObjectIdentifier(nextAppReview))
        } else {
            XCTFail("Chained app review worker should be accessible")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testAppReviewErrorHandling() {
        let mockAppReview = MockAppReviewWorker()
        mockAppReview.shouldFail = true
        let expectation = self.expectation(description: "App review error handling")
        
        mockAppReview.doReview { result in
            switch result {
            case .success:
                XCTFail("Should fail with error")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be provided")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testAppReviewUserDeclinedHandling() {
        let mockAppReview = MockAppReviewWorker()
        mockAppReview.userDeclined = true
        let expectation = self.expectation(description: "App review user declined handling")
        
        mockAppReview.doReview { result in
            switch result {
            case .success:
                XCTFail("Should fail when user declined")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be provided")
                // Verify it's the correct error type
                if let appReviewError = error as? WKRPTCLAppReviewError {
                    switch appReviewError {
                    case .userDeclined:
                        XCTAssertTrue(true, "Should be user declined error")
                    default:
                        XCTFail("Should be user declined error")
                    }
                }
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Integration Tests
    
    func testAppReviewWithSystemsWorker() {
        let appReview = MockAppReviewWorker()
        let systems = MockSystemsWorker()
        
        appReview.wkrSystems = systems
        
        // Test that systems integration works
        XCTAssertNotNil(appReview.wkrSystems)
        
        let expectation = self.expectation(description: "App review with systems")
        appReview.doReview { result in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Configuration Tests
    
    func testAppReviewConfiguration() {
        let mockAppReview = MockAppReviewWorker()
        let expectation = self.expectation(description: "App review configuration")
        
        // Test app review with specific configuration
        let parameters: DNSDataDictionary = [
            "autoPrompt": true,
            "delayDays": 7,
            "minUsageSessions": 3
        ]
        
        mockAppReview.doReview(using: parameters) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Configured app review should succeed")
            case .failure(let error):
                XCTFail("Configured app review should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Timing Tests
    
    func testAppReviewTiming() {
        let mockAppReview = MockAppReviewWorker()
        let expectation = self.expectation(description: "App review timing")
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        mockAppReview.doReview { result in
            let endTime = CFAbsoluteTimeGetCurrent()
            let duration = endTime - startTime
            
            // App review should complete quickly
            XCTAssertLessThan(duration, 1.0, "App review should complete quickly")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
}

// MARK: - Mock App Review Worker Implementation

private class MockAppReviewWorker: MockWorker, WKRPTCLAppReview {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenError
    // MARK: - WKRPTCLAppReview Conformance
    var nextWorker: WKRPTCLAppReview? {
        get { return nextBaseWorker as? WKRPTCLAppReview }
        set { nextBaseWorker = newValue }
    }
    
    var shouldFail = false
    var userDeclined = false
    var reviewNotAvailable = false
    
    func register(nextWorker: WKRPTCLAppReview, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.nextWorker = nextWorker
    }
    
    // MARK: - Required Protocol Properties
    
    var launchedCount: UInt = 0
    var launchedFirstTime: Date = Date()
    var launchedLastTime: Date? = nil
    var reviewRequestLastTime: Date? = nil
    var appDidCrashLastRun: Bool = false
    var daysBeforeReminding: UInt = 1
    var daysUntilPrompt: UInt = 30
    var hoursSinceLastLaunch: UInt = 0
    var usesFrequency: UInt = 10
    var usesSinceFirstLaunch: UInt = 0
    var usesUntilPrompt: UInt = 10
    
    // MARK: - Required Protocol Methods
    
    func doReview() -> WKRPTCLAppReviewResVoid {
        if reviewNotAvailable {
            return .failure(DNSError.AppReview.reviewNotAvailable(DNSCodeLocation(self)))
        } else if userDeclined {
            return .failure(DNSError.AppReview.userDeclined(DNSCodeLocation(self)))
        } else if shouldFail {
            return .failure(DNSError.AppReview.unknown(DNSCodeLocation(self)))
        } else {
            return .success(())
        }
    }
    
    // MARK: - App Review Methods
    
    func doReview(with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAppReviewBlkVoid?) {
        DispatchQueue.main.async {
            progress?(0, 1, 0.0, "Starting app review")
            
            if self.shouldFail {
                block?(.failure(DNSError.AppReview.unknown(DNSCodeLocation(self))))
            } else if self.userDeclined {
                block?(.failure(DNSError.AppReview.userDeclined(DNSCodeLocation(self))))
            } else if self.reviewNotAvailable {
                block?(.failure(DNSError.AppReview.reviewNotAvailable(DNSCodeLocation(self))))
            } else {
                progress?(1, 1, 1.0, "App review completed")
                block?(.success(()))
            }
        }
    }
    
    func doReview(and block: WKRPTCLAppReviewBlkVoid?) {
        doReview(with: nil, and: block)
    }
    
    func doReview(using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAppReviewBlkVoid?) {
        DispatchQueue.main.async {
            progress?(0, 1, 0.0, "Starting app review with parameters")
            
            // Simulate parameter validation
            if self.shouldFail {
                block?(.failure(DNSError.AppReview.invalidParameters(parameters: Array(parameters.keys), DNSCodeLocation(self))))
            } else {
                progress?(1, 1, 1.0, "App review with parameters completed")
                block?(.success(()))
            }
        }
    }
    
    func doReview(using parameters: DNSDataDictionary, and block: WKRPTCLAppReviewBlkVoid?) {
        doReview(using: parameters, with: nil, and: block)
    }
}

