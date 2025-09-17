//
//  WKRPTCLActivitiesTests.swift
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

class WKRPTCLActivitiesTests: ProtocolTestBase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Protocol Existence Tests
    
    func testWKRPTCLActivitiesProtocolExists() {
        validateProtocolExists(WKRPTCLActivities.self)
    }
    
    func testWKRPTCLActivitiesInheritsFromWorkerBase() {
        let mockActivities = MockActivitiesWorker()
        validateProtocolConformance(mockActivities, conformsTo: WKRPTCLWorkerBase.self)
        validateProtocolConformance(mockActivities, conformsTo: WKRPTCLActivities.self)
    }
    
    // MARK: - Type Alias Tests
    
    func testActivitiesTypeAliases() {
        validateTypeAlias(WKRPTCLActivitiesRtnAActivity.self, aliasName: "WKRPTCLActivitiesRtnAActivity")
        validateTypeAlias(WKRPTCLActivitiesRtnActivity.self, aliasName: "WKRPTCLActivitiesRtnActivity")
        validateTypeAlias(WKRPTCLActivitiesRtnVoid.self, aliasName: "WKRPTCLActivitiesRtnVoid")
        validateTypeAlias(WKRPTCLActivitiesBlkAActivity.self, aliasName: "WKRPTCLActivitiesBlkAActivity")
        validateTypeAlias(WKRPTCLActivitiesBlkActivity.self, aliasName: "WKRPTCLActivitiesBlkActivity")
        validateTypeAlias(WKRPTCLActivitiesBlkVoid.self, aliasName: "WKRPTCLActivitiesBlkVoid")
    }
    
    // MARK: - Activity Methods Tests
    
    func testLoadActivitiesMethod() {
        let mockActivities = MockActivitiesWorker()
        let expectation = self.expectation(description: "Load activities completion")
        
        mockActivities.doLoadActivities { result in
            switch result {
            case .success(let activities):
                XCTAssertNotNil(activities, "Activities should not be nil")
            case .failure(let error):
                XCTFail("Load activities should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testCreateActivityMethod() {
        let mockActivities = MockActivitiesWorker()
        let expectation = self.expectation(description: "Create activity completion")
        let testActivity = DAOActivity()
        
        mockActivities.doCreateActivity(activity: testActivity) { result in
            switch result {
            case .success(let createdActivity):
                XCTAssertNotNil(createdActivity, "Created activity should not be nil")
            case .failure(let error):
                XCTFail("Create activity should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testUpdateActivityMethod() {
        let mockActivities = MockActivitiesWorker()
        let expectation = self.expectation(description: "Update activity completion")
        let testActivity = DAOActivity()
        
        mockActivities.doUpdateActivity(activity: testActivity) { result in
            switch result {
            case .success(let updatedActivity):
                XCTAssertNotNil(updatedActivity, "Updated activity should not be nil")
            case .failure(let error):
                XCTFail("Update activity should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testDeleteActivityMethod() {
        let mockActivities = MockActivitiesWorker()
        let expectation = self.expectation(description: "Delete activity completion")
        let testActivity = DAOActivity()
        
        mockActivities.doDeleteActivity(activity: testActivity) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Delete activity should succeed")
            case .failure(let error):
                XCTFail("Delete activity should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Chain of Responsibility Tests
    
    func testActivitiesWorkerChaining() {
        let primaryActivities = MockActivitiesWorker()
        let nextActivities = MockActivitiesWorker()
        
        primaryActivities.nextWorker = nextActivities
        XCTAssertNotNil(primaryActivities.nextWorker)
    }
    
    // MARK: - Integration Tests
    
    func testActivitiesWithSystemsWorker() {
        let activities = MockActivitiesWorker()
        let systems = MockSystemsWorker()
        
        activities.wkrSystems = systems
        XCTAssertNotNil(activities.wkrSystems)
        
        let expectation = self.expectation(description: "Activities with systems")
        activities.doLoadActivities { result in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}

// MARK: - Mock Activities Worker Implementation

private class MockActivitiesWorker: MockWorkerBaseImplementation, WKRPTCLActivities {
    var shouldFail = false
    var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    
    var nextWKRPTCLActivities: WKRPTCLActivities? {
        get { return nextWorker as? WKRPTCLActivities }
        set { nextWorker = newValue }
    }
    
    func register(nextWorker: WKRPTCLActivities, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.nextWorker = nextWorker
        self.callNextWhen = callNextWhen
    }
    
    func doLoadActivities(with progress: DNSPTCLProgressBlock?, and block: WKRPTCLActivitiesBlkAActivity?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Activities.unknown(DNSCodeLocation(self))))
            } else {
                let activities: [DAOActivity] = [DAOActivity(), DAOActivity()]
                block?(.success(activities))
            }
        }
    }
    
    func doLoadActivities(and block: WKRPTCLActivitiesBlkAActivity?) {
        doLoadActivities(with: nil, and: block)
    }
    
    func doCreateActivity(activity: DAOActivity, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLActivitiesBlkActivity?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Activities.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(activity))
            }
        }
    }
    
    func doCreateActivity(activity: DAOActivity, and block: WKRPTCLActivitiesBlkActivity?) {
        doCreateActivity(activity: activity, with: nil, and: block)
    }
    
    func doUpdateActivity(activity: DAOActivity, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLActivitiesBlkActivity?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Activities.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(activity))
            }
        }
    }
    
    func doUpdateActivity(activity: DAOActivity, and block: WKRPTCLActivitiesBlkActivity?) {
        doUpdateActivity(activity: activity, with: nil, and: block)
    }
    
    func doDeleteActivity(activity: DAOActivity, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLActivitiesBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Activities.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }
    
    func doDeleteActivity(activity: DAOActivity, and block: WKRPTCLActivitiesBlkVoid?) {
        doDeleteActivity(activity: activity, with: nil, and: block)
    }
    
    // MARK: - Missing Protocol Methods
    
    func doLoadActivities(for place: DAOPlace, using activityTypes: [DAOActivityType], with progress: DNSPTCLProgressBlock?, and block: WKRPTCLActivitiesBlkAActivity?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Activities.unknown(DNSCodeLocation(self))))
            } else {
                let activities: [DAOActivity] = [DAOActivity(), DAOActivity()]
                block?(.success(activities))
            }
        }
    }
    
    func doLoadActivities(for place: DAOPlace, using activityTypes: [DAOActivityType], with block: WKRPTCLActivitiesBlkAActivity?) {
        doLoadActivities(for: place, using: activityTypes, with: nil, and: block)
    }
    
    func doUpdate(_ activities: [DAOActivity], for place: DAOPlace, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLActivitiesBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Activities.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }
    
    func doUpdate(_ activities: [DAOActivity], for place: DAOPlace, with block: WKRPTCLActivitiesBlkVoid?) {
        doUpdate(activities, for: place, with: nil, and: block)
    }
}

