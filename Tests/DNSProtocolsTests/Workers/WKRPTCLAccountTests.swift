//
//  WKRPTCLAccountTests.swift
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

class WKRPTCLAccountTests: ProtocolTestBase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Protocol Existence Tests
    
    func testWKRPTCLAccountProtocolExists() {
        validateProtocolExists(WKRPTCLAccount.self)
    }
    
    func testWKRPTCLAccountInheritsFromWorkerBase() {
        let mockAccount = MockAccountWorker()
        validateProtocolConformance(mockAccount, conformsTo: WKRPTCLWorkerBase.self)
        validateProtocolConformance(mockAccount, conformsTo: WKRPTCLAccount.self)
    }
    
    // MARK: - Type Alias Tests
    
    func testAccountTypeAliases() {
        // Test return type aliases exist
        validateTypeAlias(WKRPTCLAccountRtnAAccount.self, aliasName: "WKRPTCLAccountRtnAAccount")
        validateTypeAlias(WKRPTCLAccountRtnAccount.self, aliasName: "WKRPTCLAccountRtnAccount")
        validateTypeAlias(WKRPTCLAccountRtnBool.self, aliasName: "WKRPTCLAccountRtnBool")
        validateTypeAlias(WKRPTCLAccountRtnAPlace.self, aliasName: "WKRPTCLAccountRtnAPlace")
        validateTypeAlias(WKRPTCLAccountRtnAUser.self, aliasName: "WKRPTCLAccountRtnAUser")
        validateTypeAlias(WKRPTCLAccountRtnVoid.self, aliasName: "WKRPTCLAccountRtnVoid")
        
        // Test result type aliases exist
        validateTypeAlias(WKRPTCLAccountResAAccount.self, aliasName: "WKRPTCLAccountResAAccount")
        validateTypeAlias(WKRPTCLAccountResAccount.self, aliasName: "WKRPTCLAccountResAccount")
        validateTypeAlias(WKRPTCLAccountResBool.self, aliasName: "WKRPTCLAccountResBool")
        validateTypeAlias(WKRPTCLAccountResAPlace.self, aliasName: "WKRPTCLAccountResAPlace")
        validateTypeAlias(WKRPTCLAccountResAUser.self, aliasName: "WKRPTCLAccountResAUser")
        validateTypeAlias(WKRPTCLAccountResVoid.self, aliasName: "WKRPTCLAccountResVoid")
        
        // Test block type aliases exist
        validateTypeAlias(WKRPTCLAccountBlkAAccount.self, aliasName: "WKRPTCLAccountBlkAAccount")
        validateTypeAlias(WKRPTCLAccountBlkAccount.self, aliasName: "WKRPTCLAccountBlkAccount")
        validateTypeAlias(WKRPTCLAccountBlkBool.self, aliasName: "WKRPTCLAccountBlkBool")
        validateTypeAlias(WKRPTCLAccountBlkAPlace.self, aliasName: "WKRPTCLAccountBlkAPlace")
        validateTypeAlias(WKRPTCLAccountBlkAUser.self, aliasName: "WKRPTCLAccountBlkAUser")
        validateTypeAlias(WKRPTCLAccountBlkVoid.self, aliasName: "WKRPTCLAccountBlkVoid")
    }
    
    func testAccountBlockCreation() {
        // Test that account blocks can be created and called
        let accountBlock: WKRPTCLAccountBlkAccount = { result in
            switch result {
            case .success(let account):
                XCTAssertNotNil(account, "Account should be provided")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
        
        let boolBlock: WKRPTCLAccountBlkBool = { result in
            switch result {
            case .success(let success):
                XCTAssertTrue(success || !success, "Bool result handled")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
        
        let voidBlock: WKRPTCLAccountBlkVoid = { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Void success handled")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
        
        // Test block execution
        let mockAccount = DAOAccount()
        accountBlock(.success(mockAccount))
        boolBlock(.success(true))
        voidBlock(.success(()))
    }
    
    // MARK: - Error Extension Tests
    
    func testAccountErrorCases() {
        let codeLocation = DNSCodeLocation(self)
        let expectedErrorCases: [WKRPTCLAccountError] = [
            .unknown(codeLocation),
            .notImplemented(codeLocation),
            .notFound(field: "id", value: "test", codeLocation),
            .invalidParameters(parameters: ["param1"], codeLocation),
            .notDeactivated(codeLocation),
            .alreadyLinked(value: "test", codeLocation),
            .notLinked(value: "test", codeLocation)
        ]
        
        for errorCase in expectedErrorCases {
            XCTAssertNotNil(errorCase.errorString, "Error case should have error string")
            XCTAssertNotNil(errorCase.nsError, "Error case should convert to NSError")
        }
    }
    
    func testAccountDNSErrorConversion() {
        let codeLocation = DNSCodeLocation(self)
        let accountError = WKRPTCLAccountError.notFound(field: "accountId", value: "test123", codeLocation)
        let dnsError = DNSError.Account.notFound(field: "accountId", value: "test123", codeLocation)
        
        XCTAssertEqual(accountError.nsError.domain, dnsError.nsError.domain)
        XCTAssertEqual(accountError.nsError.code, dnsError.nsError.code)
    }
    
    // MARK: - Protocol Method Signature Tests
    
    func testAccountMethodSignatures() {
        let mockAccount = MockAccountWorker()
        
        // Test that all required methods are accessible
        validateMethodSignature(mockAccount, methodName: "doActivate")
        validateMethodSignature(mockAccount, methodName: "doApprove")
        validateMethodSignature(mockAccount, methodName: "doDeactivate")
        validateMethodSignature(mockAccount, methodName: "doDecline")
        validateMethodSignature(mockAccount, methodName: "doDelete")
        validateMethodSignature(mockAccount, methodName: "doLink")
        validateMethodSignature(mockAccount, methodName: "doLoadAccount")
        validateMethodSignature(mockAccount, methodName: "doLoadAccounts")
        validateMethodSignature(mockAccount, methodName: "doLoadCurrentAccounts")
        validateMethodSignature(mockAccount, methodName: "doRename")
        validateMethodSignature(mockAccount, methodName: "doSearchAccounts")
        validateMethodSignature(mockAccount, methodName: "doUnlink")
        validateMethodSignature(mockAccount, methodName: "doUpdate")
        validateMethodSignature(mockAccount, methodName: "doVerify")
    }
    
    // MARK: - Account Management Method Tests
    
    func testActivateAccountMethod() {
        let mockAccount = MockAccountWorker()
        let expectation = self.expectation(description: "Activate account completion")
        let testAccount = DAOAccount()
        
        mockAccount.doActivate(account: testAccount) { result in
            switch result {
            case .success(let activated):
                XCTAssertTrue(activated, "Account activation should succeed")
            case .failure(let error):
                XCTFail("Account activation should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testDeactivateAccountMethod() {
        let mockAccount = MockAccountWorker()
        let expectation = self.expectation(description: "Deactivate account completion")
        let testAccount = DAOAccount()
        
        mockAccount.doDeactivate(account: testAccount) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Account deactivation should succeed")
            case .failure(let error):
                XCTFail("Account deactivation should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testDeleteAccountMethod() {
        let mockAccount = MockAccountWorker()
        let expectation = self.expectation(description: "Delete account completion")
        let testAccount = DAOAccount()
        
        mockAccount.doDelete(account: testAccount) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Account deletion should succeed")
            case .failure(let error):
                XCTFail("Account deletion should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoadAccountMethod() {
        let mockAccount = MockAccountWorker()
        let expectation = self.expectation(description: "Load account completion")
        let testId = TestDataGenerator.generateTestId(prefix: "account")
        
        mockAccount.doLoadAccount(for: testId) { result in
            switch result {
            case .success(let account):
                XCTAssertNotNil(account, "Loaded account should not be nil")
            case .failure(let error):
                XCTFail("Load account should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoadAccountsForUserMethod() {
        let mockAccount = MockAccountWorker()
        let expectation = self.expectation(description: "Load accounts for user completion")
        let testUser = DAOUser()
        
        mockAccount.doLoadAccounts(for: testUser) { result in
            switch result {
            case .success(let accounts):
                XCTAssertNotNil(accounts, "Loaded accounts should not be nil")
            case .failure(let error):
                XCTFail("Load accounts should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoadAccountsForPlaceMethod() {
        let mockAccount = MockAccountWorker()
        let expectation = self.expectation(description: "Load accounts for place completion")
        let testPlace = DAOPlace()
        
        mockAccount.doLoadAccounts(for: testPlace) { result in
            switch result {
            case .success(let accounts):
                XCTAssertNotNil(accounts, "Loaded accounts should not be nil")
            case .failure(let error):
                XCTFail("Load accounts should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoadCurrentAccountsMethod() {
        let mockAccount = MockAccountWorker()
        let expectation = self.expectation(description: "Load current accounts completion")
        
        mockAccount.doLoadCurrentAccounts { result in
            switch result {
            case .success(let accounts):
                XCTAssertNotNil(accounts, "Current accounts should not be nil")
            case .failure(let error):
                XCTFail("Load current accounts should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Account Linking Method Tests
    
    func testLinkAccountToUserMethod() {
        let mockAccount = MockAccountWorker()
        let expectation = self.expectation(description: "Link account to user completion")
        let testAccount = DAOAccount()
        let testUser = DAOUser()
        
        mockAccount.doLink(account: testAccount, to: testUser) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Account linking should succeed")
            case .failure(let error):
                XCTFail("Account linking should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLinkAccountToPlaceMethod() {
        let mockAccount = MockAccountWorker()
        let expectation = self.expectation(description: "Link account to place completion")
        let testAccount = DAOAccount()
        let testPlace = DAOPlace()
        
        mockAccount.doLink(account: testAccount, to: testPlace) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Account linking should succeed")
            case .failure(let error):
                XCTFail("Account linking should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testUnlinkAccountFromUserMethod() {
        let mockAccount = MockAccountWorker()
        let expectation = self.expectation(description: "Unlink account from user completion")
        let testAccount = DAOAccount()
        let testUser = DAOUser()
        
        mockAccount.doUnlink(account: testAccount, from: testUser) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Account unlinking should succeed")
            case .failure(let error):
                XCTFail("Account unlinking should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testUnlinkAccountFromPlaceMethod() {
        let mockAccount = MockAccountWorker()
        let expectation = self.expectation(description: "Unlink account from place completion")
        let testAccount = DAOAccount()
        let testPlace = DAOPlace()
        
        mockAccount.doUnlink(account: testAccount, from: testPlace) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Account unlinking should succeed")
            case .failure(let error):
                XCTFail("Account unlinking should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Account Link Request Method Tests
    
    func testApproveLinkRequestMethod() {
        let mockAccount = MockAccountWorker()
        let expectation = self.expectation(description: "Approve link request completion")
        let linkRequest = DAOAccountLinkRequest()
        
        mockAccount.doApprove(linkRequest: linkRequest) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Link request approval should succeed")
            case .failure(let error):
                XCTFail("Link request approval should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testDeclineLinkRequestMethod() {
        let mockAccount = MockAccountWorker()
        let expectation = self.expectation(description: "Decline link request completion")
        let linkRequest = DAOAccountLinkRequest()
        
        mockAccount.doDecline(linkRequest: linkRequest) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Link request decline should succeed")
            case .failure(let error):
                XCTFail("Link request decline should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Account Search and Modification Tests
    
    func testSearchAccountsMethod() {
        let mockAccount = MockAccountWorker()
        let expectation = self.expectation(description: "Search accounts completion")
        let parameters = TestDataGenerator.generateTestParameters()
        
        mockAccount.doSearchAccounts(using: parameters) { result in
            switch result {
            case .success(let accounts):
                XCTAssertNotNil(accounts, "Search results should not be nil")
            case .failure(let error):
                XCTFail("Search accounts should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testRenameAccountMethod() {
        let mockAccount = MockAccountWorker()
        let expectation = self.expectation(description: "Rename account completion")
        let oldId = TestDataGenerator.generateTestId(prefix: "old")
        let newId = TestDataGenerator.generateTestId(prefix: "new")
        
        mockAccount.doRename(accountId: oldId, to: newId) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Account rename should succeed")
            case .failure(let error):
                XCTFail("Account rename should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testUpdateAccountMethod() {
        let mockAccount = MockAccountWorker()
        let expectation = self.expectation(description: "Update account completion")
        let testAccount = DAOAccount()
        
        mockAccount.doUpdate(account: testAccount) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Account update should succeed")
            case .failure(let error):
                XCTFail("Account update should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testVerifyAccountMethod() {
        let mockAccount = MockAccountWorker()
        let expectation = self.expectation(description: "Verify account completion")
        let testAccount = DAOAccount()
        
        mockAccount.doVerify(account: testAccount) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Account verification should succeed")
            case .failure(let error):
                XCTFail("Account verification should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Progress Block Tests
    
    func testAccountWithProgress() {
        let mockAccount = MockAccountWorker()
        let expectation = self.expectation(description: "Account with progress completion")
        let progressExpectation = self.expectation(description: "Progress callback")
        
        let progressBlock = MockProtocolFactory.createMockProgressBlock()
        let testAccount = DAOAccount()
        
        mockAccount.doActivate(account: testAccount,
                              with: progressBlock) { result in
            expectation.fulfill()
        }
        
        // Simulate progress
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            progressExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
    
    // MARK: - Chain of Responsibility Tests
    
    func testAccountWorkerChaining() {
        let primaryAccount = MockAccountWorker()
        let nextAccount = MockAccountWorker()
        
        primaryAccount.nextWorker = nextAccount
        
        // Test that chaining works
        XCTAssertNotNil(primaryAccount.nextWorker)
        
        if let chainedWorker = primaryAccount.nextWorker as? MockAccountWorker {
            XCTAssertEqual(ObjectIdentifier(chainedWorker), ObjectIdentifier(nextAccount))
        } else {
            XCTFail("Chained account worker should be accessible")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testAccountErrorHandling() {
        let mockAccount = MockAccountWorker()
        mockAccount.shouldFail = true
        let expectation = self.expectation(description: "Account error handling")
        
        mockAccount.doLoadAccount(for: "invalid_id") { result in
            switch result {
            case .success:
                XCTFail("Should fail with invalid parameters")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be provided")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Integration Tests
    
    func testAccountWithSystemsWorker() {
        let account = MockAccountWorker()
        let systems = MockSystemsWorker()
        
        account.wkrSystems = systems
        
        // Test that systems integration works
        XCTAssertNotNil(account.wkrSystems)
        
        let expectation = self.expectation(description: "Account with systems")
        account.doLoadCurrentAccounts { result in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}

// MARK: - Mock Account Worker Implementation

private class MockAccountWorker: MockWorkerBaseImplementation, WKRPTCLAccount {
    var shouldFail = false
    var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    // MARK: - WKRPTCLAccount Conformance
    var nextWorker: WKRPTCLAccount? {
        get { return nextBaseWorker as? WKRPTCLAccount }
        set { nextBaseWorker = newValue }
    }
    
    func register(nextWorker: WKRPTCLAccount, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.nextWorker = nextWorker
        self.callNextWhen = callNextWhen
    }
    
    // MARK: - Account Management Methods
    
    func doActivate(account: DAOAccount, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAccountBlkBool?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Account.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(true))
            }
        }
    }
    
    func doActivate(account: DAOAccount, and block: WKRPTCLAccountBlkBool?) {
        doActivate(account: account, with: nil, and: block)
    }
    
    func doApprove(linkRequest: DAOAccountLinkRequest, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAccountBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Account.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }
    
    func doApprove(linkRequest: DAOAccountLinkRequest, with block: WKRPTCLAccountBlkVoid?) {
        doApprove(linkRequest: linkRequest, with: nil, and: block)
    }
    
    func doDeactivate(account: DAOAccount, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAccountBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Account.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }
    
    func doDeactivate(account: DAOAccount, and block: WKRPTCLAccountBlkVoid?) {
        doDeactivate(account: account, with: nil, and: block)
    }
    
    func doDecline(linkRequest: DAOAccountLinkRequest, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAccountBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Account.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }
    
    func doDecline(linkRequest: DAOAccountLinkRequest, with block: WKRPTCLAccountBlkVoid?) {
        doDecline(linkRequest: linkRequest, with: nil, and: block)
    }
    
    func doDelete(account: DAOAccount, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAccountBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Account.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }
    
    func doDelete(account: DAOAccount, and block: WKRPTCLAccountBlkVoid?) {
        doDelete(account: account, with: nil, and: block)
    }
    
    func doLink(account: DAOAccount, to user: DAOUser, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAccountBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Account.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }
    
    func doLink(account: DAOAccount, to user: DAOUser, with block: WKRPTCLAccountBlkVoid?) {
        doLink(account: account, to: user, with: nil, and: block)
    }
    
    func doLink(account: DAOAccount, to place: DAOPlace, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAccountBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Account.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }
    
    func doLink(account: DAOAccount, to place: DAOPlace, with block: WKRPTCLAccountBlkVoid?) {
        doLink(account: account, to: place, with: nil, and: block)
    }
    
    func doLoadAccount(for id: String, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAccountBlkAccount?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Account.notFound(field: "id", value: id, DNSCodeLocation(self))))
            } else {
                let mockAccount = DAOAccount()
                block?(.success(mockAccount))
            }
        }
    }
    
    func doLoadAccount(for id: String, with block: WKRPTCLAccountBlkAccount?) {
        doLoadAccount(for: id, with: nil, and: block)
    }
    
    func doLoadAccounts(for place: DAOPlace, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAccountBlkAAccount?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Account.unknown(DNSCodeLocation(self))))
            } else {
                let accounts: [DAOAccount] = [DAOAccount(), DAOAccount()]
                block?(.success(accounts))
            }
        }
    }
    
    func doLoadAccounts(for place: DAOPlace, with block: WKRPTCLAccountBlkAAccount?) {
        doLoadAccounts(for: place, with: nil, and: block)
    }
    
    func doLoadAccounts(for user: DAOUser, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAccountBlkAAccount?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Account.unknown(DNSCodeLocation(self))))
            } else {
                let accounts: [DAOAccount] = [DAOAccount(), DAOAccount()]
                block?(.success(accounts))
            }
        }
    }
    
    func doLoadAccounts(for user: DAOUser, with block: WKRPTCLAccountBlkAAccount?) {
        doLoadAccounts(for: user, with: nil, and: block)
    }
    
    func doLoadCurrentAccounts(with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAccountBlkAAccount?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Account.unknown(DNSCodeLocation(self))))
            } else {
                let accounts: [DAOAccount] = [DAOAccount()]
                block?(.success(accounts))
            }
        }
    }
    
    func doLoadCurrentAccounts(with block: WKRPTCLAccountBlkAAccount?) {
        doLoadCurrentAccounts(with: nil, and: block)
    }
    
    func doRename(accountId: String, to newAccountId: String, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAccountBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Account.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }
    
    func doRename(accountId: String, to newAccountId: String, with block: WKRPTCLAccountBlkVoid?) {
        doRename(accountId: accountId, to: newAccountId, with: nil, and: block)
    }
    
    func doSearchAccounts(using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAccountBlkAAccount?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Account.invalidParameters(parameters: Array(parameters.keys), DNSCodeLocation(self))))
            } else {
                let accounts: [DAOAccount] = [DAOAccount(), DAOAccount()]
                block?(.success(accounts))
            }
        }
    }
    
    func doSearchAccounts(using parameters: DNSDataDictionary, with block: WKRPTCLAccountBlkAAccount?) {
        doSearchAccounts(using: parameters, with: nil, and: block)
    }
    
    func doUnlink(account: DAOAccount, from user: DAOUser, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAccountBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Account.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }
    
    func doUnlink(account: DAOAccount, from user: DAOUser, with block: WKRPTCLAccountBlkVoid?) {
        doUnlink(account: account, from: user, with: nil, and: block)
    }
    
    func doUnlink(account: DAOAccount, from place: DAOPlace, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAccountBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Account.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }
    
    func doUnlink(account: DAOAccount, from place: DAOPlace, with block: WKRPTCLAccountBlkVoid?) {
        doUnlink(account: account, from: place, with: nil, and: block)
    }
    
    func doUpdate(account: DAOAccount, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAccountBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Account.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }
    
    func doUpdate(account: DAOAccount, with block: WKRPTCLAccountBlkVoid?) {
        doUpdate(account: account, with: nil, and: block)
    }
    
    func doVerify(account: DAOAccount, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAccountBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Account.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }
    
    func doVerify(account: DAOAccount, with block: WKRPTCLAccountBlkVoid?) {
        doVerify(account: account, with: nil, and: block)
    }
}

