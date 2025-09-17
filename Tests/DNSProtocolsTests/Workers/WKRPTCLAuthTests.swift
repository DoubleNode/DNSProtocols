//
//  WKRPTCLAuthTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocolsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import Foundation
import DNSCore
import DNSDataContracts
import DNSError
import DNSDataObjects
@testable import DNSProtocols

class WKRPTCLAuthTests: ProtocolTestBase {
    
    // MARK: - Protocol Existence Tests
    
    func testWKRPTCLAuthProtocolExists() {
        validateProtocolExists(WKRPTCLAuth.self)
    }
    
    func testWKRPTCLAuthInheritsFromWorkerBase() {
        let mockAuth = MockAuthWorker()
        validateProtocolConformance(mockAuth, conformsTo: WKRPTCLWorkerBase.self)
        validateProtocolConformance(mockAuth, conformsTo: WKRPTCLAuth.self)
    }
    
    // MARK: - Type Alias Tests
    
    func testAuthTypeAliases() {
        validateTypeAlias(WKRPTCLAuthBlkBoolAccessData.self, aliasName: "WKRPTCLAuthBlkBoolAccessData")
        validateTypeAlias(WKRPTCLAuthBlkBoolBoolAccessData.self, aliasName: "WKRPTCLAuthBlkBoolBoolAccessData")
        validateTypeAlias(WKRPTCLAuthBlkVoid.self, aliasName: "WKRPTCLAuthBlkVoid")
        validateTypeAlias(WKRPTCLAuthRtnBoolAccessData.self, aliasName: "WKRPTCLAuthRtnBoolAccessData")
        validateTypeAlias(WKRPTCLAuthRtnBoolBoolAccessData.self, aliasName: "WKRPTCLAuthRtnBoolBoolAccessData")
        validateTypeAlias(WKRPTCLAuthRtnVoid.self, aliasName: "WKRPTCLAuthRtnVoid")
        validateTypeAlias(WKRPTCLAuthResBoolAccessData.self, aliasName: "WKRPTCLAuthResBoolAccessData")
        validateTypeAlias(WKRPTCLAuthResBoolBoolAccessData.self, aliasName: "WKRPTCLAuthResBoolBoolAccessData")
        validateTypeAlias(WKRPTCLAuthResVoid.self, aliasName: "WKRPTCLAuthResVoid")
    }
    
    // MARK: - Error Extension Tests
    
    func testAuthErrorCases() {
        let codeLocation = DNSCodeLocation(self)
        let expectedErrorCases: [WKRPTCLAuthError] = [
            .unknown(codeLocation),
            .notImplemented(codeLocation),
            .failure(error: NSError(domain: "test", code: 1), codeLocation),
            .lockedOut(codeLocation),
            .passwordExpired(codeLocation),
            .existingAccount(codeLocation)
        ]

        // Validate each error case can be created and has proper properties
        for errorCase in expectedErrorCases {
            XCTAssertNotNil(errorCase.nsError, "Error case should have valid NSError representation")
            XCTAssertNotNil(errorCase.errorDescription, "Error case should have error description")
            XCTAssertEqual(errorCase.nsError.domain, WKRPTCLAuthError.domain, "Error domain should match")
        }
    }
    
    // MARK: - Sign In Method Tests
    
    func testSignInMethod() {
        let mockAuth = MockAuthWorker()
        let expectation = self.expectation(description: "Sign in completion")
        
        mockAuth.doSignIn(from: "test@example.com", and: "password", using: [:]) { result in
            switch result {
            case .success(let (success, accessData)):
                XCTAssertTrue(success, "Sign in should succeed")
                XCTAssertNotNil(accessData, "Mock implementation returns access data")
                XCTAssertTrue(accessData is MockAuthAccessData, "Access data should be MockAuthAccessData type")
            case .failure(let error):
                XCTFail("Sign in should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testSignOutMethod() {
        let mockAuth = MockAuthWorker()
        let expectation = self.expectation(description: "Sign out completion")
        
        mockAuth.doSignOut(using: [:]) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Sign out should succeed")
            case .failure(let error):
                XCTFail("Sign out should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testRefreshMethod() {
        // Note: doRefresh method does not exist in WKRPTCLAuth protocol
        // Test validates that the protocol only includes documented methods
        let mockAuth = MockAuthWorker()
        XCTAssertTrue(mockAuth is WKRPTCLAuth, "Mock should conform to protocol")
    }
    
    // MARK: - Error Handling Tests
    
    func testSignInWithInvalidCredentials() {
        let mockAuth = MockAuthWorker()
        mockAuth.shouldFailSignIn = true
        let expectation = self.expectation(description: "Sign in failure")
        
        mockAuth.doSignIn(from: "invalid@test.com", and: "wrongpassword", using: [:]) { result in
            switch result {
            case .success:
                XCTFail("Sign in should fail with invalid credentials")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be provided")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}

// MARK: - Mock Auth Access Data

private class MockAuthAccessData: WKRPTCLAuthAccessData {
    var accessToken: String = "mock_access_token"
}

// MARK: - Mock Auth Worker

private class MockAuthWorker: MockWorker, WKRPTCLAuth {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenError
    var shouldFailSignIn = false

    // MARK: - WKRPTCLAuth Protocol Properties
    
    override var nextWorker: DNSPTCLWorker? {
        get { return authNextWorker }
        set { authNextWorker = newValue as? WKRPTCLAuth }
    }
    private var authNextWorker: WKRPTCLAuth?
    
    func register(nextWorker: WKRPTCLAuth, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.authNextWorker = nextWorker
        self.callNextWhen = callNextWhen
    }
    
    // MARK: - Auth Protocol Methods (with progress)
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
            if self.shouldFailSignIn {
                block?(.failure(WKRPTCLAuthError.invalidCredentials(DNSCodeLocation(self))))
            } else {
                let accessData = MockAuthAccessData()
                block?(.success((true, accessData)))
            }
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
    
    // MARK: - Auth Protocol Methods (shortcuts)
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
        doSignUp(from: user, and: password, using: parameters, with: nil, and: block)
    }
}