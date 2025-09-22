//
//  WKRPTCLGeoTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocolsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import Foundation
import CoreLocation
import DNSCore
import DNSError
@testable import DNSProtocols

class WKRPTCLGeoTests: ProtocolTestBase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Protocol Existence Tests
    
    func testWKRPTCLGeoProtocolExists() {
        validateProtocolExists(WKRPTCLGeo.self)
    }
    
    func testWKRPTCLGeoInheritsFromWorkerBase() {
        let mockGeo = MockGeoWorker()
        validateProtocolConformance(mockGeo, conformsTo: WKRPTCLWorkerBase.self)
        validateProtocolConformance(mockGeo, conformsTo: WKRPTCLGeo.self)
    }
    
    // MARK: - Type Alias Tests
    
    func testGeoTypeAliases() {
        validateTypeAlias(WKRPTCLGeoRtnStringLocation.self, aliasName: "WKRPTCLGeoRtnStringLocation")
        validateTypeAlias(WKRPTCLGeoRtnVoid.self, aliasName: "WKRPTCLGeoRtnVoid")
        validateTypeAlias(WKRPTCLGeoResStringLocation.self, aliasName: "WKRPTCLGeoResStringLocation")
        validateTypeAlias(WKRPTCLGeoResVoid.self, aliasName: "WKRPTCLGeoResVoid")
        validateTypeAlias(WKRPTCLGeoBlkStringLocation.self, aliasName: "WKRPTCLGeoBlkStringLocation")
    }
    
    func testGeoBlockCreation() {
        let locationBlock: WKRPTCLGeoBlkStringLocation = { result in
            switch result {
            case .success(let location):
                XCTAssertNotNil(location, "Location should be provided")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
        
        let testLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        locationBlock(.success(("San Francisco", testLocation)))
    }
    
    // MARK: - Error Extension Tests
    
    func testGeoErrorCases() {
        let codeLocation = DNSCodeLocation(self)
        let expectedErrorCases: [WKRPTCLGeoError] = [
            .unknown(codeLocation),
            .notImplemented(codeLocation),
            .invalidParameters(parameters: ["param1"], codeLocation),
            .denied(codeLocation),
            .failure(error: NSError(domain: "TestDomain", code: 1, userInfo: nil), codeLocation)
        ]
        
        for errorCase in expectedErrorCases {
            XCTAssertNotNil(errorCase.errorString, "Error case should have error string")
            XCTAssertNotNil(errorCase.nsError, "Error case should convert to NSError")
        }
    }
    
    // MARK: - Location Methods Tests

    func testLocateMethod() {
        let mockGeo = MockGeoWorker()
        let expectation = self.expectation(description: "Locate completion")

        mockGeo.doLocate { result in
            switch result {
            case .success(let (address, location)):
                XCTAssertNotNil(address, "Address should not be nil")
                XCTAssertNotNil(location, "Location should not be nil")
            case .failure(let error):
                XCTFail("Locate should not fail: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testLocateAddressMethod() {
        let mockGeo = MockGeoWorker()
        let expectation = self.expectation(description: "Locate address completion")
        let testAddress = DNSPostalAddress()

        mockGeo.doLocate(testAddress) { result in
            switch result {
            case .success(let (address, location)):
                XCTAssertNotNil(address, "Address should not be nil")
                XCTAssertNotNil(location, "Location should not be nil")
            case .failure(let error):
                XCTFail("Locate address should not fail: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testTrackLocationMethod() {
        let mockGeo = MockGeoWorker()
        let expectation = self.expectation(description: "Track location completion")

        mockGeo.doTrackLocation(for: "testKey") { result in
            switch result {
            case .success(let (address, location)):
                XCTAssertNotNil(address, "Address should not be nil")
                XCTAssertNotNil(location, "Location should not be nil")
            case .failure(let error):
                XCTFail("Track location should not fail: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testStopTrackLocationMethod() {
        let mockGeo = MockGeoWorker()

        let result = mockGeo.doStopTrackLocation(for: "testKey")
        switch result {
        case .success:
            XCTAssertTrue(true, "Stop track location should succeed")
        case .failure(let error):
            XCTFail("Stop track location should not fail: \(error)")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testGeoPermissionDeniedError() {
        let mockGeo = MockGeoWorker()
        mockGeo.permissionDenied = true
        let expectation = self.expectation(description: "Permission denied error handling")

        mockGeo.doLocate { result in
            switch result {
            case .success:
                XCTFail("Should fail when permission denied")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be provided")
                if let geoError = error as? WKRPTCLGeoError {
                    switch geoError {
                    case .denied:
                        XCTAssertTrue(true, "Should be denied error")
                    default:
                        XCTFail("Should be denied error")
                    }
                }
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testGeoServiceDisabledError() {
        let mockGeo = MockGeoWorker()
        mockGeo.serviceDisabled = true
        let expectation = self.expectation(description: "Service disabled error handling")

        mockGeo.doTrackLocation(for: "testKey") { result in
            switch result {
            case .success:
                XCTFail("Should fail when service disabled")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be provided")
                if let geoError = error as? WKRPTCLGeoError {
                    switch geoError {
                    case .denied:
                        XCTAssertTrue(true, "Should be denied error")
                    default:
                        XCTFail("Should be denied error")
                    }
                }
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Chain of Responsibility Tests
    
    func testGeoWorkerChaining() {
        let primaryGeo = MockGeoWorker()
        let nextGeo = MockGeoWorker()
        
        primaryGeo.nextWorker = nextGeo
        
        XCTAssertNotNil(primaryGeo.nextWorker)
        
        if let chainedWorker = primaryGeo.nextWorker as? MockGeoWorker {
            XCTAssertEqual(ObjectIdentifier(chainedWorker), ObjectIdentifier(nextGeo))
        } else {
            XCTFail("Chained geo worker should be accessible")
        }
    }
    
    // MARK: - Integration Tests
    
    func testGeoWithSystemsWorker() {
        let geo = MockGeoWorker()
        let systems = MockSystemsWorker()
        
        geo.wkrSystems = systems
        XCTAssertNotNil(geo.wkrSystems)
        
        let expectation = self.expectation(description: "Geo with systems")
        geo.doLocate { result in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}

// MARK: - Mock Geo Worker Implementation

private class MockGeoWorker: MockWorker, WKRPTCLGeo {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenError
    var shouldFail = false
    var permissionDenied = false
    var serviceDisabled = false
    var locationUnavailable = false

    // MARK: - WKRPTCLGeo Protocol Properties
    var nextWorker: WKRPTCLGeo? {
        get { return nextBaseWorker as? WKRPTCLGeo }
        set { nextBaseWorker = newValue }
    }
    
    func register(nextWorker: WKRPTCLGeo, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.nextWorker = nextWorker
    }

    // MARK: - WKRPTCLGeo Protocol Implementation

    func doLocate(with progress: DNSPTCLProgressBlock?, and block: WKRPTCLGeoBlkStringLocation?) {
        DispatchQueue.main.async {
            if self.permissionDenied {
                block?(.failure(WKRPTCLGeoError.denied(DNSCodeLocation(self))))
            } else if self.shouldFail {
                block?(.failure(WKRPTCLGeoError.unknown(DNSCodeLocation(self))))
            } else {
                let testLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
                block?(.success(("San Francisco, CA", testLocation)))
            }
        }
    }

    func doLocate(_ address: DNSPostalAddress, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLGeoBlkStringLocation?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(WKRPTCLGeoError.unknown(DNSCodeLocation(self))))
            } else {
                let testLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
                block?(.success(("Geocoded Address", testLocation)))
            }
        }
    }

    func doStopTrackLocation(for processKey: String) -> WKRPTCLGeoResVoid {
        if shouldFail {
            return .failure(WKRPTCLGeoError.unknown(DNSCodeLocation(self)))
        } else {
            return .success(())
        }
    }

    func doTrackLocation(for processKey: String, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLGeoBlkStringLocation?) {
        DispatchQueue.main.async {
            if self.serviceDisabled {
                block?(.failure(WKRPTCLGeoError.denied(DNSCodeLocation(self))))
            } else if self.shouldFail {
                block?(.failure(WKRPTCLGeoError.unknown(DNSCodeLocation(self))))
            } else {
                let testLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
                block?(.success(("Tracked Location", testLocation)))
            }
        }
    }

    // MARK: - Shortcut Methods

    func doLocate(with block: WKRPTCLGeoBlkStringLocation?) {
        doLocate(with: nil, and: block)
    }

    func doLocate(_ address: DNSPostalAddress, with block: WKRPTCLGeoBlkStringLocation?) {
        doLocate(address, with: nil, and: block)
    }

    func doTrackLocation(for processKey: String, with block: WKRPTCLGeoBlkStringLocation?) {
        doTrackLocation(for: processKey, with: nil, and: block)
    }
}

