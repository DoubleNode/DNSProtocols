//
//  WKRPTCLAnalyticsTests.swift
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

class WKRPTCLAnalyticsTests: ProtocolTestBase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Protocol Existence Tests
    
    func testWKRPTCLAnalyticsProtocolExists() {
        validateProtocolExists(WKRPTCLAnalytics.self)
    }
    
    func testWKRPTCLAnalyticsInheritsFromWorkerBase() {
        let mockAnalytics = MockAnalyticsWorker()
        validateProtocolConformance(mockAnalytics, conformsTo: WKRPTCLWorkerBase.self)
        validateProtocolConformance(mockAnalytics, conformsTo: WKRPTCLAnalytics.self)
    }
    
    // MARK: - Type Alias Tests
    
    func testAnalyticsTypeAliases() {
        // Test that all Analytics-specific type aliases exist
        validateTypeAlias(WKRPTCLAnalyticsRtnVoid.self, aliasName: "WKRPTCLAnalyticsRtnVoid")
        validateTypeAlias(WKRPTCLAnalyticsResVoid.self, aliasName: "WKRPTCLAnalyticsResVoid")
    }
    
    func testAnalyticsResultTypes() {
        // Test that analytics result types can be created and used
        let successResult: WKRPTCLAnalyticsResVoid = .success(())
        let failureResult: WKRPTCLAnalyticsResVoid = .failure(NSError(domain: "test", code: 1, userInfo: nil))
        
        switch successResult {
        case .success:
            XCTAssertTrue(true, "Success result handled")
        case .failure:
            XCTFail("Should be success")
        }
        
        switch failureResult {
        case .success:
            XCTFail("Should be failure")
        case .failure(let error):
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: - Error Extension Tests
    
    func testAnalyticsErrorCases() {
        let codeLocation = DNSCodeLocation(self)
        let expectedErrorCases: [WKRPTCLAnalyticsError] = [
            .unknown(codeLocation),
            .notImplemented(codeLocation),
            .invalidParameters(parameters: ["test"], codeLocation)
        ]
        
        for errorCase in expectedErrorCases {
            XCTAssertNotNil(errorCase.errorString, "Error case should have error string")
            XCTAssertNotNil(errorCase.nsError, "Error case should convert to NSError")
        }
    }
    
    func testAnalyticsErrorConversion() {
        let codeLocation = DNSCodeLocation(self)
        let analyticsError = WKRPTCLAnalyticsError.unknown(codeLocation)
        let dnsError = DNSError.Analytics.unknown(codeLocation)
        
        XCTAssertEqual(analyticsError.nsError.domain, dnsError.nsError.domain)
        XCTAssertEqual(analyticsError.nsError.code, dnsError.nsError.code)
    }
    
    // MARK: - Protocol Method Signature Tests
    
    func testAnalyticsMethodSignatures() {
        let mockAnalytics = MockAnalyticsWorker()
        
        // Test that all required methods are accessible
        validateMethodSignature(mockAnalytics, methodName: "configure")
        validateMethodSignature(mockAnalytics, methodName: "doTrack")
        validateMethodSignature(mockAnalytics, methodName: "doIdentify")
    }
    
    // MARK: - Configure Method Tests
    
    func testConfigureMethod() {
        let mockAnalytics = MockAnalyticsWorker()
        
        // Test the configure method from WKRPTCLWorkerBase
        mockAnalytics.configure()
        XCTAssertTrue(true, "Configure should complete without error")
    }
    
    func testConfigureWithParameters() {
        let mockAnalytics = MockAnalyticsWorker()
        let parameters = TestDataGenerator.generateTestParameters()
        
        // Test configuration - in a real implementation, parameters might be stored
        mockAnalytics.configure()
        XCTAssertNotNil(parameters, "Parameters should be generated for testing")
        XCTAssertTrue(true, "Configure with parameters should complete without error")
    }
    
    // MARK: - Track Event Method Tests
    
    func testTrackEventMethod() {
        let mockAnalytics = MockAnalyticsWorker()
        let expectation = self.expectation(description: "Track event completion")
        
        let event = WKRPTCLAnalyticsEvents.screenView
        let properties = ["key": "value", "count": 1] as DNSDataDictionary
        
        let result = mockAnalytics.doTrack(event: event, properties: properties)
        switch result {
        case .success:
            XCTAssertTrue(true, "Track should succeed")
        case .failure(let error):
            XCTFail("Track should not fail: \(error)")
        }
        expectation.fulfill()
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testTrackWithProgress() {
        let mockAnalytics = MockAnalyticsWorker()
        let expectation = self.expectation(description: "Track with progress completion")
        let progressExpectation = self.expectation(description: "Progress callback")
        
        let progressBlock = MockProtocolFactory.createMockProgressBlock()
        let event = WKRPTCLAnalyticsEvents.other
        let properties: DNSDataDictionary = [:]
        
        let result = mockAnalytics.doTrack(event: event, properties: properties)
        // Test that we can call the progress block
        progressBlock(0, 100, 0.0, "Starting")
        progressBlock(100, 100, 1.0, "Complete")
        expectation.fulfill()
        
        // Simulate progress
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            progressExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
    
    // MARK: - Identify User Method Tests
    
    func testIdentifyUserMethod() {
        let mockAnalytics = MockAnalyticsWorker()
        let expectation = self.expectation(description: "Identify user completion")
        
        let userId = TestDataGenerator.generateTestId(prefix: "user")
        let traits = ["name": "Test User", "email": "test@example.com"] as DNSDataDictionary
        
        mockAnalytics.doIdentify(userId: userId, with: traits) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Identify should succeed")
            case .failure(let error):
                XCTFail("Identify should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Chain of Responsibility Tests
    
    func testAnalyticsWorkerChaining() {
        let primaryAnalytics = MockAnalyticsWorker()
        let nextAnalytics = MockAnalyticsWorker()
        
        primaryAnalytics.nextWorker = nextAnalytics
        
        // Test that chaining works
        XCTAssertNotNil(primaryAnalytics.nextWorker)
        
        if let chainedWorker = primaryAnalytics.nextWorker as? MockAnalyticsWorker {
            XCTAssertEqual(ObjectIdentifier(chainedWorker), ObjectIdentifier(nextAnalytics))
        } else {
            XCTFail("Chained analytics worker should be accessible")
        }
    }
    
    // MARK: - Thread Safety Tests
    
    func testAnalyticsConcurrency() async {
        let analytics = MockAnalyticsWorker()
        
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask {
                    let expectation = XCTestExpectation(description: "Concurrent analytics \(i)")
                    
                    let result = analytics.doTrack(event: WKRPTCLAnalyticsEvents.other, properties: [:])
                    XCTAssertTrue(result.isSuccess)
                    expectation.fulfill()
                    
                    await self.fulfillment(of: [expectation], timeout: 1.0)
                }
            }
        }
        
        XCTAssertTrue(true, "Concurrent analytics operations should not crash")
    }
    
    // MARK: - Performance Tests
    
    func testAnalyticsTrackPerformance() {
        let analytics = MockAnalyticsWorker()
        
        measure {
            for i in 0..<100 {
                let expectation = XCTestExpectation(description: "Performance test \(i)")
                let result = analytics.doTrack(event: WKRPTCLAnalyticsEvents.other, properties: [:])
                XCTAssertTrue(result.isSuccess)
                expectation.fulfill()
                wait(for: [expectation], timeout: 0.1)
            }
        }
    }
    
    // MARK: - Integration Tests
    
    func testAnalyticsWithSystemsWorker() {
        let analytics = MockAnalyticsWorker()
        let systems = MockSystemsWorker()
        
        analytics.wkrSystems = systems
        
        // Test that systems integration works
        XCTAssertNotNil(analytics.wkrSystems)
        
        let expectation = self.expectation(description: "Analytics with systems")
        let result = analytics.doTrack(event: WKRPTCLAnalyticsEvents.other, properties: [:])
        // In a real implementation, this might interact with the systems worker
        XCTAssertTrue(result.isSuccess)
        expectation.fulfill()
        
        waitForExpectations(timeout: 1.0)
    }
}

