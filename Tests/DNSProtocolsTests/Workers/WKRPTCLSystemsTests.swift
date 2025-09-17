//
//  WKRPTCLSystemsTests.swift
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

class WKRPTCLSystemsTests: ProtocolTestBase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Protocol Existence Tests
    
    func testWKRPTCLSystemsProtocolExists() {
        validateProtocolExists(WKRPTCLSystems.self)
    }
    
    func testWKRPTCLSystemsInheritsFromWorkerBase() {
        let mockSystems = MockSystemsWorker()
        validateProtocolConformance(mockSystems, conformsTo: WKRPTCLWorkerBase.self)
        validateProtocolConformance(mockSystems, conformsTo: WKRPTCLSystems.self)
    }
    
    // MARK: - Type Alias Tests
    
    func testSystemsTypeAliases() {
        validateTypeAlias(WKRPTCLSystemsRtnASystem.self, aliasName: "WKRPTCLSystemsRtnASystem")
        validateTypeAlias(WKRPTCLSystemsRtnSystem.self, aliasName: "WKRPTCLSystemsRtnSystem")
        validateTypeAlias(WKRPTCLSystemsRtnVoid.self, aliasName: "WKRPTCLSystemsRtnVoid")
        validateTypeAlias(WKRPTCLSystemsResASystem.self, aliasName: "WKRPTCLSystemsResASystem")
        validateTypeAlias(WKRPTCLSystemsResSystem.self, aliasName: "WKRPTCLSystemsResSystem")
        validateTypeAlias(WKRPTCLSystemsBlkASystem.self, aliasName: "WKRPTCLSystemsBlkASystem")
        validateTypeAlias(WKRPTCLSystemsBlkSystem.self, aliasName: "WKRPTCLSystemsBlkSystem")
    }
    
    func testSystemsBlockCreation() {
        let systemBlock: WKRPTCLSystemsBlkSystem = { result in
            switch result {
            case .success(let system):
                XCTAssertNotNil(system, "System should be provided")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
        
        let mockSystem = DAOSystem()
        systemBlock(.success(mockSystem))
    }
    
    // MARK: - Error Extension Tests
    
    func testSystemsErrorCases() {
        let codeLocation = DNSCodeLocation(self)
        let expectedErrorCases: [WKRPTCLSystemsError] = [
            .unknown(codeLocation),
            .notImplemented(codeLocation),
            .notFound(field: "id", value: "test", codeLocation),
            .invalidParameters(parameters: ["param1"], codeLocation),
            .systemUnavailable(codeLocation),
            .configurationError(codeLocation)
        ]
        
        for errorCase in expectedErrorCases {
            XCTAssertNotNil(errorCase.errorString, "Error case should have error string")
            XCTAssertNotNil(errorCase.nsError, "Error case should convert to NSError")
        }
    }
    
    // MARK: - Protocol Method Signature Tests
    
    func testSystemsMethodSignatures() {
        let mockSystems = MockSystemsWorker()
        
        validateMethodSignature(mockSystems, methodName: "doLoadSystem")
        validateMethodSignature(mockSystems, methodName: "doLoadSystems")
        validateMethodSignature(mockSystems, methodName: "doUpdateSystemStatus")
        validateMethodSignature(mockSystems, methodName: "doCheckSystemHealth")
    }
    
    // MARK: - System Management Methods
    
    func testLoadSystemMethod() {
        let mockSystems = MockSystemsWorker()
        let expectation = self.expectation(description: "Load system completion")
        let testId = TestDataGenerator.generateTestId(prefix: "system")
        
        mockSystems.doLoadSystem(for: testId) { result in
            switch result {
            case .success(let system):
                XCTAssertNotNil(system, "Loaded system should not be nil")
            case .failure(let error):
                XCTFail("Load system should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoadSystemsMethod() {
        let mockSystems = MockSystemsWorker()
        let expectation = self.expectation(description: "Load systems completion")
        
        mockSystems.doLoadSystems { result in
            switch result {
            case .success(let systems):
                XCTAssertNotNil(systems, "Loaded systems should not be nil")
            case .failure(let error):
                XCTFail("Load systems should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    
    // MARK: - Chain of Responsibility Tests
    
    func testSystemsWorkerChaining() {
        let primarySystems = MockSystemsWorker()
        let nextSystems = MockSystemsWorker()
        
        primarySystems.nextWorker = nextSystems
        
        XCTAssertNotNil(primarySystems.nextWorker)
        
        if let chainedWorker = primarySystems.nextWorker as? MockSystemsWorker {
            XCTAssertEqual(ObjectIdentifier(chainedWorker), ObjectIdentifier(nextSystems))
        } else {
            XCTFail("Chained systems worker should be accessible")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testSystemsUnavailableError() {
        let mockSystems = MockSystemsWorkerWithValidation()
        let expectation = self.expectation(description: "System unavailable error handling")

        // Test error handling by providing invalid ID
        mockSystems.doLoadSystem(for: "") { result in
            switch result {
            case .success:
                XCTFail("Should fail when system unavailable")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be provided")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }
}

// MARK: - Mock Systems Worker Implementation

// Using MockSystemsWorker from ProtocolTestHelpers.swift

// Custom mock for testing error handling
private class MockSystemsWorkerWithValidation: MockSystemsWorker {
    override func doLoadSystem(for id: String, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLSystemsBlkSystem?) {
        if id.isEmpty {
            let error = DNSError.Systems.notFound(field: "id", value: id, DNSCodeLocation(self))
            DispatchQueue.main.async {
                block?(.failure(error))
            }
        } else {
            super.doLoadSystem(for: id, with: progress, and: block)
        }
    }
}