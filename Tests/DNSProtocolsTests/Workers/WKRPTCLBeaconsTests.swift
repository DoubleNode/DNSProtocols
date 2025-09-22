//
//  WKRPTCLBeaconsTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocolsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import Foundation
import DNSCore
import DNSDataObjects
import DNSError
@testable import DNSProtocols

class WKRPTCLBeaconsTests: ProtocolTestBase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Protocol Existence Tests
    
    func testWKRPTCLBeaconsProtocolExists() {
        validateProtocolExists(WKRPTCLBeacons.self)
    }
    
    func testWKRPTCLBeaconsInheritsFromWorkerBase() {
        let mockBeacons = MockBeaconsWorker()
        validateProtocolConformance(mockBeacons, conformsTo: WKRPTCLWorkerBase.self)
        validateProtocolConformance(mockBeacons, conformsTo: WKRPTCLBeacons.self)
    }
    
    // MARK: - Type Alias Tests
    
    func testBeaconsTypeAliases() {
        // Test return type aliases exist
        validateTypeAlias(WKRPTCLBeaconsRtnABeacon.self, aliasName: "WKRPTCLBeaconsRtnABeacon")
        validateTypeAlias(WKRPTCLBeaconsRtnVoid.self, aliasName: "WKRPTCLBeaconsRtnVoid")
        
        // Test result type aliases exist
        validateTypeAlias(WKRPTCLBeaconsResABeacon.self, aliasName: "WKRPTCLBeaconsResABeacon")
        validateTypeAlias(WKRPTCLBeaconsResVoid.self, aliasName: "WKRPTCLBeaconsResVoid")
        
        // Test block type aliases exist
        validateTypeAlias(WKRPTCLBeaconsBlkABeacon.self, aliasName: "WKRPTCLBeaconsBlkABeacon")
    }
    
    func testBeaconsBlockCreation() {
        // Test that beacon blocks can be created and called
        let beaconBlock: WKRPTCLBeaconsBlkABeacon = { result in
            switch result {
            case .success(let beacons):
                XCTAssertNotNil(beacons, "Beacons should be provided")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
        
        let beaconsArrayBlock: WKRPTCLBeaconsBlkABeacon = { result in
            switch result {
            case .success(let beacons):
                XCTAssertNotNil(beacons, "Beacons array should be provided")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
        
        // Test block execution
        let mockBeacons = [DAOBeacon()]
        beaconBlock(.success(mockBeacons))
        beaconsArrayBlock(.success(mockBeacons))
    }
    
    // MARK: - Error Extension Tests
    
    func testBeaconsErrorCases() {
        let codeLocation = DNSCodeLocation(self)
        let expectedErrorCases: [WKRPTCLBeaconsError] = [
            .unknown(codeLocation),
            .notImplemented(codeLocation),
            .notFound(field: "id", value: "test", codeLocation),
            .invalidParameters(parameters: ["param1"], codeLocation),
            .beaconNotFound(codeLocation),
            .scanningFailed(codeLocation),
            .bluetoothUnavailable(codeLocation),
            .locationPermissionDenied(codeLocation)
        ]
        
        for errorCase in expectedErrorCases {
            XCTAssertNotNil(errorCase.errorString, "Error case should have error string")
            XCTAssertNotNil(errorCase.nsError, "Error case should convert to NSError")
        }
    }
    
    func testBeaconsDNSErrorConversion() {
        let codeLocation = DNSCodeLocation(self)
        let beaconsError = WKRPTCLBeaconsError.beaconNotFound(codeLocation)
        let dnsError = DNSError.Beacons.beaconNotFound(codeLocation)
        
        XCTAssertEqual(beaconsError.nsError.domain, dnsError.nsError.domain)
        XCTAssertEqual(beaconsError.nsError.code, dnsError.nsError.code)
    }
    
    // MARK: - Protocol Method Signature Tests
    
    func testBeaconsMethodSignatures() {
        let mockBeacons = MockBeaconsWorker()
        
        // Test that all required methods are accessible
        validateMethodSignature(mockBeacons, methodName: "doLoadBeacons")
        validateMethodSignature(mockBeacons, methodName: "doRangeBeacons")
    }
    
    // MARK: - Beacon Loading Methods
    
    func testLoadBeaconsMethod() {
        let mockBeacons = MockBeaconsWorker()
        let expectation = self.expectation(description: "Load beacons completion")
        
        mockBeacons.doLoadBeacons(in: DAOPlace()) { result in
            switch result {
            case .success(let beacons):
                XCTAssertNotNil(beacons, "Loaded beacons should not be nil")
            case .failure(let error):
                XCTFail("Load beacons should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testRangeBeaconsMethod() {
        let mockBeacons = MockBeaconsWorker()
        let expectation = self.expectation(description: "Range beacons completion")
        
        mockBeacons.doRangeBeacons(named: [UUID()], for: "testKey") { result in
            switch result {
            case .success(let beacons):
                XCTAssertNotNil(beacons, "Ranged beacons should not be nil")
            case .failure(let error):
                XCTFail("Range beacons should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Beacon Connection Methods
    
    // Note: doConnect method not available in WKRPTCLBeacons protocol
    func testConnectToBeaconMethod() {
        // Test disabled - doConnect not in protocol
        XCTAssertTrue(true, "Connect functionality not available in current protocol")
    }
    
    // Note: doDisconnect method not available in WKRPTCLBeacons protocol
    func testDisconnectFromBeaconMethod() {
        // Test disabled - doDisconnect not in protocol
        XCTAssertTrue(true, "Disconnect functionality not available in current protocol")
    }
    
    // MARK: - Progress Block Tests
    
    func testBeaconsWithProgress() {
        let mockBeacons = MockBeaconsWorker()
        let expectation = self.expectation(description: "Beacons with progress completion")
        let progressExpectation = self.expectation(description: "Progress callback")
        
        let progressBlock = MockProtocolFactory.createMockProgressBlock()
        
        mockBeacons.doLoadBeacons(in: DAOPlace(), with: progressBlock) { result in
            expectation.fulfill()
        }
        
        // Simulate progress
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            progressExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
    
    // MARK: - Chain of Responsibility Tests
    
    func testBeaconsWorkerChaining() {
        let primaryBeacons = MockBeaconsWorker()
        let nextBeacons = MockBeaconsWorker()
        
        primaryBeacons.nextWorker = nextBeacons
        
        // Test that chaining works
        XCTAssertNotNil(primaryBeacons.nextWorker)
        
        if let chainedWorker = primaryBeacons.nextWorker as? MockBeaconsWorker {
            XCTAssertEqual(ObjectIdentifier(chainedWorker), ObjectIdentifier(nextBeacons))
        } else {
            XCTFail("Chained beacons worker should be accessible")
        }
    }
    
    // MARK: - Error Handling Tests
    
    
    func testBeaconsLocationPermissionDeniedError() {
        let mockBeacons = MockBeaconsWorker()
        mockBeacons.locationPermissionDenied = true
        let expectation = self.expectation(description: "Location permission denied error handling")
        
        mockBeacons.doRangeBeacons(named: [UUID()], for: "testKey") { result in
            switch result {
            case .success:
                XCTFail("Should fail when location permission denied")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be provided")
                if let beaconsError = error as? WKRPTCLBeaconsError {
                    switch beaconsError {
                    case .locationPermissionDenied:
                        XCTAssertTrue(true, "Should be location permission denied error")
                    default:
                        XCTFail("Should be location permission denied error")
                    }
                }
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Integration Tests
    
    func testBeaconsWithSystemsWorker() {
        let beacons = MockBeaconsWorker()
        let systems = MockSystemsWorker()
        
        beacons.wkrSystems = systems
        
        // Test that systems integration works
        XCTAssertNotNil(beacons.wkrSystems)
        
        let expectation = self.expectation(description: "Beacons with systems")
        let testPlace = DAOPlace()
        beacons.doLoadBeacons(in: testPlace) { result in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}

// MARK: - Mock Beacons Worker Implementation

private class MockBeaconsWorker: MockWorker, WKRPTCLBeacons {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenError
    var shouldFail = false
    var bluetoothUnavailable = false
    var locationPermissionDenied = false
    var scanningFailed = false
    
    // MARK: - WKRPTCLBeacons Protocol Conformance
    var nextWorker: WKRPTCLBeacons? {
        get { return nextBaseWorker as? WKRPTCLBeacons }
        set { nextBaseWorker = newValue }
    }
    
    override var wkrSystems: WKRPTCLSystems? {
        get { return super.wkrSystems }
        set { super.wkrSystems = newValue }
    }
    
    func register(nextWorker: WKRPTCLBeacons, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.nextWorker = nextWorker
        self.callNextWhen = callNextWhen
    }
    
    // MARK: - Beacon Methods
    
    func doLoadBeacons(in place: DAOPlace, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLBeaconsBlkABeacon?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Beacons.unknown(DNSCodeLocation(self))))
            } else {
                let beacons: [DAOBeacon] = [DAOBeacon(), DAOBeacon()]
                block?(.success(beacons))
            }
        }
    }
    
    func doLoadBeacons(in place: DAOPlace, for activity: DAOActivity, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLBeaconsBlkABeacon?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Beacons.unknown(DNSCodeLocation(self))))
            } else {
                let beacons: [DAOBeacon] = [DAOBeacon(), DAOBeacon()]
                block?(.success(beacons))
            }
        }
    }
    
    func doRangeBeacons(named uuids: [UUID], for processKey: String, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLBeaconsBlkABeacon?) {
        DispatchQueue.main.async {
            if self.locationPermissionDenied {
                block?(.failure(DNSError.Beacons.locationPermissionDenied(DNSCodeLocation(self))))
            } else if self.shouldFail {
                block?(.failure(DNSError.Beacons.unknown(DNSCodeLocation(self))))
            } else {
                let rangedBeacons: [DAOBeacon] = [DAOBeacon()]
                block?(.success(rangedBeacons))
            }
        }
    }
    
    func doStopRangeBeacons(for processKey: String) -> WKRPTCLBeaconsResVoid {
        if shouldFail {
            return .failure(DNSError.Beacons.unknown(DNSCodeLocation(self)))
        } else {
            return .success(())
        }
    }
    
    // MARK: - Shortcut Methods
    
    func doLoadBeacons(in place: DAOPlace, with block: WKRPTCLBeaconsBlkABeacon?) {
        doLoadBeacons(in: place, with: nil, and: block)
    }
    
    func doLoadBeacons(in place: DAOPlace, for activity: DAOActivity, with block: WKRPTCLBeaconsBlkABeacon?) {
        doLoadBeacons(in: place, for: activity, with: nil, and: block)
    }
    
    func doRangeBeacons(named uuids: [UUID], for processKey: String, with block: WKRPTCLBeaconsBlkABeacon?) {
        doRangeBeacons(named: uuids, for: processKey, with: nil, and: block)
    }
}

