//
//  WKRPTCLAlertsTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocolsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import Foundation
import Combine
import DNSCore
import DNSDataObjects
import DNSError
@testable import DNSProtocols

class WKRPTCLAlertsTests: ProtocolTestBase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Protocol Existence Tests
    
    func testWKRPTCLAlertsProtocolExists() {
        validateProtocolExists(WKRPTCLAlerts.self)
    }
    
    func testWKRPTCLAlertsInheritsFromWorkerBase() {
        let mockAlerts = MockAlertsWorker()
        validateProtocolConformance(mockAlerts, conformsTo: WKRPTCLWorkerBase.self)
        validateProtocolConformance(mockAlerts, conformsTo: WKRPTCLAlerts.self)
    }
    
    // MARK: - Type Alias Tests
    
    func testAlertsTypeAliases() {
        // Test return type aliases exist
        validateTypeAlias(WKRPTCLAlertsRtnAAlert.self, aliasName: "WKRPTCLAlertsRtnAAlert")
        
        // Test publisher type aliases exist
        validateTypeAlias(WKRPTCLAlertsPubAAlert.self, aliasName: "WKRPTCLAlertsPubAAlert")
        
        // Test future type aliases exist
        validateTypeAlias(WKRPTCLAlertsFutAAlert.self, aliasName: "WKRPTCLAlertsFutAAlert")
    }
    
    func testAlertsPublisherCreation() {
        // Test that alert publishers can be created and used
        let mockAlerts = MockAlertsWorker()
        let publisher = mockAlerts.doLoadAlerts()
        
        XCTAssertNotNil(publisher, "Publisher should be created")
        
        let expectation = self.expectation(description: "Publisher completion")
        var cancellables = Set<AnyCancellable>()
        
        publisher
            .sink(
                receiveCompletion: { completion in
                    expectation.fulfill()
                },
                receiveValue: { alerts in
                    XCTAssertNotNil(alerts, "Alerts should be provided")
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Error Extension Tests
    
    func testAlertsErrorCases() {
        let codeLocation = DNSCodeLocation(self)
        let expectedErrorCases: [WKRPTCLAlertsError] = [
            .unknown(codeLocation),
            .notImplemented(codeLocation),
            .notFound(field: "id", value: "test", codeLocation),
            .invalidParameters(parameters: ["param1"], codeLocation)
        ]
        
        for errorCase in expectedErrorCases {
            XCTAssertNotNil(errorCase.errorString, "Error case should have error string")
            XCTAssertNotNil(errorCase.nsError, "Error case should convert to NSError")
        }
    }
    
    func testAlertsDNSErrorConversion() {
        let codeLocation = DNSCodeLocation(self)
        let alertsError = WKRPTCLAlertsError.unknown(codeLocation)
        let dnsError = DNSError.Alerts.unknown(codeLocation)
        
        XCTAssertEqual(alertsError.nsError.domain, dnsError.nsError.domain)
        XCTAssertEqual(alertsError.nsError.code, dnsError.nsError.code)
    }
    
    // MARK: - Protocol Method Signature Tests
    
    func testAlertsMethodSignatures() {
        let mockAlerts = MockAlertsWorker()
        
        // Test that all required methods are accessible
        validateMethodSignature(mockAlerts, methodName: "doLoadAlerts")
    }
    
    // MARK: - Alert Load Methods
    
    func testLoadAlertsMethod() {
        let mockAlerts = MockAlertsWorker()
        let expectation = self.expectation(description: "Load alerts completion")
        var cancellables = Set<AnyCancellable>()
        
        mockAlerts.doLoadAlerts()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        XCTAssertTrue(true, "Load alerts should complete")
                    case .failure(let error):
                        XCTFail("Load alerts should not fail: \(error)")
                    }
                    expectation.fulfill()
                },
                receiveValue: { alerts in
                    XCTAssertNotNil(alerts, "Loaded alerts should not be nil")
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoadAlertsForPlaceMethod() {
        let mockAlerts = MockAlertsWorker()
        let expectation = self.expectation(description: "Load alerts for place completion")
        let testPlace = DAOPlace()
        var cancellables = Set<AnyCancellable>()
        
        mockAlerts.doLoadAlerts(for: testPlace)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        XCTAssertTrue(true, "Load alerts for place should complete")
                    case .failure(let error):
                        XCTFail("Load alerts for place should not fail: \(error)")
                    }
                    expectation.fulfill()
                },
                receiveValue: { alerts in
                    XCTAssertNotNil(alerts, "Loaded alerts should not be nil")
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoadAlertsForSectionMethod() {
        let mockAlerts = MockAlertsWorker()
        let expectation = self.expectation(description: "Load alerts for section completion")
        let testSection = DAOSection()
        var cancellables = Set<AnyCancellable>()
        
        mockAlerts.doLoadAlerts(for: testSection)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        XCTAssertTrue(true, "Load alerts for section should complete")
                    case .failure(let error):
                        XCTFail("Load alerts for section should not fail: \(error)")
                    }
                    expectation.fulfill()
                },
                receiveValue: { alerts in
                    XCTAssertNotNil(alerts, "Loaded alerts should not be nil")
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Progress Block Tests
    
    func testAlertsWithProgress() {
        let mockAlerts = MockAlertsWorker()
        let expectation = self.expectation(description: "Alerts with progress completion")
        let progressExpectation = self.expectation(description: "Progress callback")
        var cancellables = Set<AnyCancellable>()
        
        let progressBlock = MockProtocolFactory.createMockProgressBlock()
        
        mockAlerts.doLoadAlerts(with: progressBlock)
            .sink(
                receiveCompletion: { completion in
                    expectation.fulfill()
                },
                receiveValue: { alerts in
                    XCTAssertNotNil(alerts, "Alerts should be provided")
                }
            )
            .store(in: &cancellables)
        
        // Simulate progress
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            progressExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
    
    // MARK: - Chain of Responsibility Tests
    
    func testAlertsWorkerChaining() {
        let primaryAlerts = MockAlertsWorker()
        let nextAlerts = MockAlertsWorker()
        
        primaryAlerts.nextWorker = nextAlerts
        
        // Test that chaining works
        XCTAssertNotNil(primaryAlerts.nextWorker)
        
        if let chainedWorker = primaryAlerts.nextWorker as? MockAlertsWorker {
            XCTAssertEqual(ObjectIdentifier(chainedWorker), ObjectIdentifier(nextAlerts))
        } else {
            XCTFail("Chained alerts worker should be accessible")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testAlertsErrorHandling() {
        let mockAlerts = MockAlertsWorker()
        mockAlerts.shouldFail = true
        let expectation = self.expectation(description: "Alerts error handling")
        var cancellables = Set<AnyCancellable>()
        
        mockAlerts.doLoadAlerts()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        XCTFail("Should fail with error")
                    case .failure(let error):
                        XCTAssertNotNil(error, "Error should be provided")
                    }
                    expectation.fulfill()
                },
                receiveValue: { alerts in
                    XCTFail("Should not receive value on error")
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Integration Tests
    
    func testAlertsWithSystemsWorker() {
        let alerts = MockAlertsWorker()
        let systems = MockSystemsWorker()
        
        alerts.wkrSystems = systems
        
        // Test that systems integration works
        XCTAssertNotNil(alerts.wkrSystems)
        
        let expectation = self.expectation(description: "Alerts with systems")
        var cancellables = Set<AnyCancellable>()
        
        alerts.doLoadAlerts()
            .sink(
                receiveCompletion: { completion in
                    expectation.fulfill()
                },
                receiveValue: { alerts in
                    XCTAssertNotNil(alerts, "Alerts should be provided")
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
}

// MARK: - Mock Alerts Worker Implementation

private class MockAlertsWorker: MockWorkerBaseImplementation, WKRPTCLAlerts {
    var shouldFail = false
    var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    // MARK: - WKRPTCLAlerts Conformance
    var nextWorker: WKRPTCLAlerts? {
        get { return nextBaseWorker as? WKRPTCLAlerts }
        set { nextBaseWorker = newValue }
    }
    
    func register(nextWorker: WKRPTCLAlerts, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.nextWorker = nextWorker
        self.callNextWhen = callNextWhen
    }
    
    // MARK: - Alert Methods (Publisher-based)
    
    func doLoadAlerts(for place: DAOPlace, with progress: DNSPTCLProgressBlock?) -> WKRPTCLAlertsPubAAlert {
        return createAlertsPublisher()
    }
    
    func doLoadAlerts(for section: DAOSection, with progress: DNSPTCLProgressBlock?) -> WKRPTCLAlertsPubAAlert {
        return createAlertsPublisher()
    }
    
    func doLoadAlerts(with progress: DNSPTCLProgressBlock?) -> WKRPTCLAlertsPubAAlert {
        return createAlertsPublisher()
    }
    
    func doLoadAlerts(for place: DAOPlace) -> WKRPTCLAlertsPubAAlert {
        return doLoadAlerts(for: place, with: nil)
    }
    
    func doLoadAlerts(for section: DAOSection) -> WKRPTCLAlertsPubAAlert {
        return doLoadAlerts(for: section, with: nil)
    }
    
    func doLoadAlerts() -> WKRPTCLAlertsPubAAlert {
        return doLoadAlerts(with: nil)
    }
    
    // MARK: - Helper Methods
    
    private func createAlertsPublisher() -> WKRPTCLAlertsPubAAlert {
        if shouldFail {
            return Fail(error: WKRPTCLAlertsError.unknown(DNSCodeLocation(self)))
                .eraseToAnyPublisher()
        } else {
            let alerts: [DAOAlert] = [DAOAlert(), DAOAlert()]
            return Just(alerts)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}

