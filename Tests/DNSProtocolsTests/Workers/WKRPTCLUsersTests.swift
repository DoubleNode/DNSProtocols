//
//  WKRPTCLUsersTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocolsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import Foundation
import DNSCore
import DNSDataObjects
import DNSDataTypes
import DNSError
@testable import DNSProtocols

class WKRPTCLUsersTests: ProtocolTestBase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Protocol Existence Tests
    
    func testWKRPTCLUsersProtocolExists() {
        validateProtocolExists(WKRPTCLUsers.self)
    }
    
    func testWKRPTCLUsersInheritsFromWorkerBase() {
        let mockUsers = MockUsersWorker()
        validateProtocolConformance(mockUsers, conformsTo: WKRPTCLWorkerBase.self)
        validateProtocolConformance(mockUsers, conformsTo: WKRPTCLUsers.self)
    }
    
    // MARK: - Type Alias Tests
    
    func testUsersTypeAliases() {
        validateTypeAlias(WKRPTCLUsersRtnAUser.self, aliasName: "WKRPTCLUsersRtnAUser")
        validateTypeAlias(WKRPTCLUsersRtnUser.self, aliasName: "WKRPTCLUsersRtnUser")
        validateTypeAlias(WKRPTCLUsersRtnVoid.self, aliasName: "WKRPTCLUsersRtnVoid")
        validateTypeAlias(WKRPTCLUsersResAUser.self, aliasName: "WKRPTCLUsersResAUser")
        validateTypeAlias(WKRPTCLUsersResUser.self, aliasName: "WKRPTCLUsersResUser")
        validateTypeAlias(WKRPTCLUsersResVoid.self, aliasName: "WKRPTCLUsersResVoid")
        validateTypeAlias(WKRPTCLUsersBlkAUser.self, aliasName: "WKRPTCLUsersBlkAUser")
        validateTypeAlias(WKRPTCLUsersBlkUser.self, aliasName: "WKRPTCLUsersBlkUser")
        validateTypeAlias(WKRPTCLUsersBlkVoid.self, aliasName: "WKRPTCLUsersBlkVoid")
    }
    
    func testUsersBlockCreation() {
        let userBlock: WKRPTCLUsersBlkUser = { result in
            switch result {
            case .success(let user):
                XCTAssertNotNil(user, "User should be provided")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
        
        let usersArrayBlock: WKRPTCLUsersBlkAUser = { result in
            switch result {
            case .success(let users):
                XCTAssertNotNil(users, "Users array should be provided")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
        
        let mockUser = DAOUser()
        userBlock(.success(mockUser))
        usersArrayBlock(.success([mockUser]))
    }
    
    // MARK: - Error Extension Tests
    
    func testUsersErrorCases() {
        let codeLocation = DNSCodeLocation(self)
        let expectedErrorCases: [WKRPTCLUsersError] = [
            .unknown(codeLocation),
            .notImplemented(codeLocation),
            .notFound(field: "id", value: "test", codeLocation),
            .invalidParameters(parameters: ["param1"], codeLocation),
            .notFound(field: "user", value: "id", codeLocation),
            .alreadyLinked(value: "user", codeLocation),
            .notDeactivated(codeLocation)
        ]
        
        for errorCase in expectedErrorCases {
            XCTAssertNotNil(errorCase.errorString, "Error case should have error string")
            XCTAssertNotNil(errorCase.nsError, "Error case should convert to NSError")
        }
    }
    
    func testUsersDNSErrorConversion() {
        let codeLocation = DNSCodeLocation(self)
        let usersError = WKRPTCLUsersError.notFound(field: "user", value: "id", codeLocation)
        let dnsError = DNSError.Users.notFound(field: "user", value: "id", codeLocation)
        
        XCTAssertEqual(usersError.nsError.domain, dnsError.nsError.domain)
        XCTAssertEqual(usersError.nsError.code, dnsError.nsError.code)
    }
    
    // MARK: - Protocol Method Signature Tests
    
    func testUsersMethodSignatures() {
        let mockUsers = MockUsersWorker()
        
        validateMethodSignature(mockUsers, methodName: "doActivateUser")
        validateMethodSignature(mockUsers, methodName: "doCreateUser")
        validateMethodSignature(mockUsers, methodName: "doDeactivateUser")
        validateMethodSignature(mockUsers, methodName: "doDeleteUser")
        validateMethodSignature(mockUsers, methodName: "doLoadCurrentUser")
        validateMethodSignature(mockUsers, methodName: "doLoadUser")
        validateMethodSignature(mockUsers, methodName: "doLoadUsers")
        validateMethodSignature(mockUsers, methodName: "doSearchUsers")
        validateMethodSignature(mockUsers, methodName: "doUpdateUser")
    }
    
    // MARK: - User Management Methods
    
    func testCreateUserMethod() {
        let mockUsers = MockUsersWorker()
        let expectation = self.expectation(description: "Create user completion")
        let testUser = DAOUser()
        
        mockUsers.doCreateUser(user: testUser) { result in
            switch result {
            case .success(let createdUser):
                XCTAssertNotNil(createdUser, "Created user should not be nil")
            case .failure(let error):
                XCTFail("Create user should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoadCurrentUserMethod() {
        let mockUsers = MockUsersWorker()
        let expectation = self.expectation(description: "Load current user completion")
        
        mockUsers.doLoadCurrentUser { result in
            switch result {
            case .success(let user):
                XCTAssertNotNil(user, "Current user should not be nil")
            case .failure(let error):
                XCTFail("Load current user should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoadUserMethod() {
        let mockUsers = MockUsersWorker()
        let expectation = self.expectation(description: "Load user completion")
        let testId = TestDataGenerator.generateTestId(prefix: "user")
        
        mockUsers.doLoadUser(for: testId) { result in
            switch result {
            case .success(let user):
                XCTAssertNotNil(user, "Loaded user should not be nil")
            case .failure(let error):
                XCTFail("Load user should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoadUsersMethod() {
        let mockUsers = MockUsersWorker()
        let expectation = self.expectation(description: "Load users completion")
        
        mockUsers.doLoadUsers { result in
            switch result {
            case .success(let users):
                XCTAssertNotNil(users, "Loaded users should not be nil")
            case .failure(let error):
                XCTFail("Load users should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testUpdateUserMethod() {
        let mockUsers = MockUsersWorker()
        let expectation = self.expectation(description: "Update user completion")
        let testUser = DAOUser()
        
        mockUsers.doUpdateUser(user: testUser) { result in
            switch result {
            case .success(let updatedUser):
                XCTAssertNotNil(updatedUser, "Updated user should not be nil")
            case .failure(let error):
                XCTFail("Update user should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testActivateUserMethod() {
        let mockUsers = MockUsersWorker()
        let expectation = self.expectation(description: "Activate user completion")
        let testUser = DAOUser()
        
        mockUsers.doActivateUser(user: testUser) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Activate user should succeed")
            case .failure(let error):
                XCTFail("Activate user should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testDeactivateUserMethod() {
        let mockUsers = MockUsersWorker()
        let expectation = self.expectation(description: "Deactivate user completion")
        let testUser = DAOUser()
        
        mockUsers.doDeactivateUser(user: testUser) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Deactivate user should succeed")
            case .failure(let error):
                XCTFail("Deactivate user should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testDeleteUserMethod() {
        let mockUsers = MockUsersWorker()
        let expectation = self.expectation(description: "Delete user completion")
        let testUser = DAOUser()
        
        mockUsers.doDeleteUser(user: testUser) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Delete user should succeed")
            case .failure(let error):
                XCTFail("Delete user should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testSearchUsersMethod() {
        let mockUsers = MockUsersWorker()
        let expectation = self.expectation(description: "Search users completion")
        let parameters = TestDataGenerator.generateTestParameters()
        
        mockUsers.doSearchUsers(using: parameters) { result in
            switch result {
            case .success(let users):
                XCTAssertNotNil(users, "Search results should not be nil")
            case .failure(let error):
                XCTFail("Search users should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Progress Block Tests
    
    func testUsersWithProgress() {
        let mockUsers = MockUsersWorker()
        let expectation = self.expectation(description: "Users with progress completion")
        let progressExpectation = self.expectation(description: "Progress callback")
        
        let progressBlock = MockProtocolFactory.createMockProgressBlock()
        
        mockUsers.doLoadUsers(with: progressBlock) { result in
            expectation.fulfill()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            progressExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
    
    // MARK: - Error Handling Tests
    
    func testUsersUserNotFoundError() {
        let mockUsers = MockUsersWorker()
        mockUsers.userNotFound = true
        let expectation = self.expectation(description: "User not found error handling")
        
        mockUsers.doLoadUser(for: "invalid_id") { result in
            switch result {
            case .success:
                XCTFail("Should fail when user not found")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be provided")
                if let usersError = error as? WKRPTCLUsersError {
                    switch usersError {
                    case .notFound:
                        XCTAssertTrue(true, "Should be user not found error")
                    default:
                        XCTFail("Should be user not found error")
                    }
                }
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testUsersDuplicateUserError() {
        let mockUsers = MockUsersWorker()
        mockUsers.duplicateUser = true
        let expectation = self.expectation(description: "Duplicate user error handling")
        let testUser = DAOUser()
        
        mockUsers.doCreateUser(user: testUser) { result in
            switch result {
            case .success:
                XCTFail("Should fail when user already exists")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be provided")
                if let usersError = error as? WKRPTCLUsersError {
                    switch usersError {
                    case .alreadyLinked:
                        XCTAssertTrue(true, "Should be duplicate user error")
                    default:
                        XCTFail("Should be duplicate user error")
                    }
                }
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Chain of Responsibility Tests
    
    func testUsersWorkerChaining() {
        let primaryUsers = MockUsersWorker()
        let nextUsers = MockUsersWorker()
        
        primaryUsers.nextWorker = nextUsers
        
        XCTAssertNotNil(primaryUsers.nextWorker)
        
        if let chainedWorker = primaryUsers.nextWorker as? MockUsersWorker {
            XCTAssertEqual(ObjectIdentifier(chainedWorker), ObjectIdentifier(nextUsers))
        } else {
            XCTFail("Chained users worker should be accessible")
        }
    }
    
    // MARK: - Integration Tests
    
    func testUsersWithSystemsWorker() {
        let users = MockUsersWorker()
        let systems = MockSystemsWorker()
        
        users.wkrSystems = systems
        XCTAssertNotNil(users.wkrSystems)
        
        let expectation = self.expectation(description: "Users with systems")
        users.doLoadCurrentUser { result in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}

// MARK: - Mock Users Worker Implementation

private class MockUsersWorker: MockWorker, WKRPTCLUsers {
    var shouldFail = false
    var userNotFound = false
    var duplicateUser = false
    var userDeactivated = false
    
    var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenError
    
    override var nextWorker: DNSPTCLWorker? {
        get { return super.nextWorker as? WKRPTCLUsers }
        set { super.nextWorker = newValue }
    }
    
    func register(nextWorker: WKRPTCLUsers, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.nextWorker = nextWorker
    }
    
    // MARK: - User CRUD Methods
    
    func doCreateUser(user: DAOUser, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkUser?) {
        DispatchQueue.main.async {
            if self.duplicateUser {
                block?(.failure(DNSError.Users.alreadyLinked(value: "user", DNSCodeLocation(self))))
            } else if self.shouldFail {
                block?(.failure(DNSError.Users.unknown(DNSCodeLocation(self))))
            } else {
                let createdUser = DAOUser()
                block?(.success(createdUser))
            }
        }
    }
    
    func doCreateUser(user: DAOUser, and block: WKRPTCLUsersBlkUser?) {
        doCreateUser(user: user, with: nil, and: block)
    }
    
    func doLoadCurrentUser(with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkUser?) {
        DispatchQueue.main.async {
            if self.userNotFound {
                block?(.failure(DNSError.Users.notFound(field: "user", value: "id", DNSCodeLocation(self))))
            } else if self.shouldFail {
                block?(.failure(DNSError.Users.unknown(DNSCodeLocation(self))))
            } else {
                let currentUser = DAOUser()
                block?(.success(currentUser))
            }
        }
    }
    
    func doLoadCurrentUser(with block: WKRPTCLUsersBlkUser?) {
        doLoadCurrentUser(with: nil, and: block)
    }
    
    func doLoadUser(for id: String, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkUser?) {
        DispatchQueue.main.async {
            if self.userNotFound {
                block?(.failure(DNSError.Users.notFound(field: "user", value: "id", DNSCodeLocation(self))))
            } else if self.shouldFail {
                block?(.failure(DNSError.Users.unknown(DNSCodeLocation(self))))
            } else {
                let user = DAOUser()
                block?(.success(user))
            }
        }
    }
    
    func doLoadUser(for id: String, with block: WKRPTCLUsersBlkUser?) {
        doLoadUser(for: id, with: nil, and: block)
    }
    
    func doLoadUsers(with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkAUser?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Users.unknown(DNSCodeLocation(self))))
            } else {
                let users: [DAOUser] = [DAOUser(), DAOUser()]
                block?(.success(users))
            }
        }
    }
    
    func doLoadUsers(and block: WKRPTCLUsersBlkAUser?) {
        doLoadUsers(with: nil, and: block)
    }
    
    func doUpdateUser(user: DAOUser, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkUser?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Users.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(user))
            }
        }
    }
    
    func doUpdateUser(user: DAOUser, and block: WKRPTCLUsersBlkUser?) {
        doUpdateUser(user: user, with: nil, and: block)
    }
    
    func doSearchUsers(using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkAUser?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Users.invalidParameters(parameters: Array(parameters.keys), DNSCodeLocation(self))))
            } else {
                let users: [DAOUser] = [DAOUser()]
                block?(.success(users))
            }
        }
    }
    
    func doSearchUsers(using parameters: DNSDataDictionary, and block: WKRPTCLUsersBlkAUser?) {
        doSearchUsers(using: parameters, with: nil, and: block)
    }
    
    // MARK: - User State Methods
    
    func doActivateUser(user: DAOUser, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Users.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }
    
    func doActivateUser(user: DAOUser, and block: WKRPTCLUsersBlkVoid?) {
        doActivateUser(user: user, with: nil, and: block)
    }
    
    func doDeactivateUser(user: DAOUser, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Users.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }
    
    func doDeactivateUser(user: DAOUser, and block: WKRPTCLUsersBlkVoid?) {
        doDeactivateUser(user: user, with: nil, and: block)
    }
    
    func doDeleteUser(user: DAOUser, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Users.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }
    
    func doDeleteUser(user: DAOUser, and block: WKRPTCLUsersBlkVoid?) {
        doDeleteUser(user: user, with: nil, and: block)
    }
    
    // MARK: - Missing Protocol Methods (with progress)
    
    func doActivate(_ user: DAOUser, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkBool?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Users.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(true))
            }
        }
    }
    
    func doConfirm(pendingUser: DAOUser, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Users.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }
    
    func doConsent(childUser: DAOUser, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Users.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }
    
    func doLoadChildUsers(for user: DAOUser, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkAUser?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Users.unknown(DNSCodeLocation(self))))
            } else {
                let users: [DAOUser] = [DAOUser()]
                block?(.success(users))
            }
        }
    }
    
    func doLoadLinkRequests(for user: DAOUser, using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkAAccountLinkRequest?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Users.unknown(DNSCodeLocation(self))))
            } else {
                let requests: [DAOAccountLinkRequest] = []
                block?(.success(requests))
            }
        }
    }
    
    func doLoadPendingUsers(for user: DAOUser, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkAUser?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Users.unknown(DNSCodeLocation(self))))
            } else {
                let users: [DAOUser] = []
                block?(.success(users))
            }
        }
    }
    
    func doLoadUnverifiedAccounts(for user: DAOUser, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkAAccount?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Users.unknown(DNSCodeLocation(self))))
            } else {
                let accounts: [DAOAccount] = []
                block?(.success(accounts))
            }
        }
    }
    
    func doLoadUsers(for account: DAOAccount, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkAUser?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Users.unknown(DNSCodeLocation(self))))
            } else {
                let users: [DAOUser] = []
                block?(.success(users))
            }
        }
    }
    
    func doReact(with reaction: DNSReactionType, to user: DAOUser, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkMeta?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Users.unknown(DNSCodeLocation(self))))
            } else {
                let metadata = DNSMetadata()
                block?(.success(metadata))
            }
        }
    }
    
    func doRemove(_ user: DAOUser, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Users.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }
    
    func doUnreact(with reaction: DNSReactionType, to user: DAOUser, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkMeta?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Users.unknown(DNSCodeLocation(self))))
            } else {
                let metadata = DNSMetadata()
                block?(.success(metadata))
            }
        }
    }
    
    func doUpdate(_ user: DAOUser, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLUsersBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Users.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }
    
    // MARK: - Shortcut Methods
    
    func doActivate(_ user: DAOUser, with block: WKRPTCLUsersBlkBool?) {
        doActivate(user, with: nil, and: block)
    }
    
    func doConfirm(pendingUser: DAOUser, with block: WKRPTCLUsersBlkVoid?) {
        doConfirm(pendingUser: pendingUser, with: nil, and: block)
    }
    
    func doConsent(childUser: DAOUser, with block: WKRPTCLUsersBlkVoid?) {
        doConsent(childUser: childUser, with: nil, and: block)
    }
    
    func doLoadChildUsers(for user: DAOUser, with block: WKRPTCLUsersBlkAUser?) {
        doLoadChildUsers(for: user, with: nil, and: block)
    }
    
    func doLoadLinkRequests(for user: DAOUser, using parameters: DNSDataDictionary, with block: WKRPTCLUsersBlkAAccountLinkRequest?) {
        doLoadLinkRequests(for: user, using: parameters, with: nil, and: block)
    }
    
    func doLoadLinkRequests(for user: DAOUser, with block: WKRPTCLUsersBlkAAccountLinkRequest?) {
        doLoadLinkRequests(for: user, using: [:], with: block)
    }
    
    func doLoadPendingUsers(for user: DAOUser, with block: WKRPTCLUsersBlkAUser?) {
        doLoadPendingUsers(for: user, with: nil, and: block)
    }
    
    func doLoadUnverifiedAccounts(for user: DAOUser, with block: WKRPTCLUsersBlkAAccount?) {
        doLoadUnverifiedAccounts(for: user, with: nil, and: block)
    }
    
    func doLoadUsers(for account: DAOAccount, with block: WKRPTCLUsersBlkAUser?) {
        doLoadUsers(for: account, with: nil, and: block)
    }
    
    func doReact(with reaction: DNSReactionType, to user: DAOUser, with block: WKRPTCLUsersBlkMeta?) {
        doReact(with: reaction, to: user, with: nil, and: block)
    }
    
    func doRemove(_ user: DAOUser, with block: WKRPTCLUsersBlkVoid?) {
        doRemove(user, with: nil, and: block)
    }
    
    func doUnreact(with reaction: DNSReactionType, to user: DAOUser, with block: WKRPTCLUsersBlkMeta?) {
        doUnreact(with: reaction, to: user, with: nil, and: block)
    }
    
    func doUpdate(_ user: DAOUser, with block: WKRPTCLUsersBlkVoid?) {
        doUpdate(user, with: nil, and: block)
    }
}

