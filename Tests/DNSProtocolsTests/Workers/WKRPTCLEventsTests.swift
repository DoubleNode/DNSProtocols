//
//  WKRPTCLEventsTests.swift
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

class WKRPTCLEventsTests: ProtocolTestBase {
    
    func testWKRPTCLEventsProtocolExists() {
        validateProtocolExists(WKRPTCLEvents.self)
    }
    
    func testWKRPTCLEventsInheritsFromWorkerBase() {
        let mockEvents = MockEventsWorker()
        validateProtocolConformance(mockEvents, conformsTo: WKRPTCLWorkerBase.self)
        validateProtocolConformance(mockEvents, conformsTo: WKRPTCLEvents.self)
    }
    
    func testEventsTypeAliases() {
        validateTypeAlias(WKRPTCLEventsRtnAEvent.self, aliasName: "WKRPTCLEventsRtnAEvent")
        validateTypeAlias(WKRPTCLEventsRtnEvent.self, aliasName: "WKRPTCLEventsRtnEvent")
        validateTypeAlias(WKRPTCLEventsRtnVoid.self, aliasName: "WKRPTCLEventsRtnVoid")
        validateTypeAlias(WKRPTCLEventsBlkAEvent.self, aliasName: "WKRPTCLEventsBlkAEvent")
        validateTypeAlias(WKRPTCLEventsBlkEvent.self, aliasName: "WKRPTCLEventsBlkEvent")
        validateTypeAlias(WKRPTCLEventsBlkVoid.self, aliasName: "WKRPTCLEventsBlkVoid")
    }
    
    func testLoadEventsMethod() {
        let mockEvents = MockEventsWorker()
        let expectation = self.expectation(description: "Load events completion")
        
        mockEvents.doLoadCurrentEvents { result in
            switch result {
            case .success(let events):
                XCTAssertNotNil(events, "Events should not be nil")
            case .failure(let error):
                XCTFail("Load events should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testUpdateEventMethod() {
        let mockEvents = MockEventsWorker()
        let expectation = self.expectation(description: "Update event completion")
        let testEvent = DAOEvent()
        let testPlace = DAOPlace()

        mockEvents.doUpdate(testEvent, for: testPlace) { result in
            switch result {
            case .success:
                // Successfully updated
                break
            case .failure(let error):
                XCTFail("Update event should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testEventsWorkerChaining() {
        let primaryEvents = MockEventsWorker()
        let nextEvents = MockEventsWorker()
        
        primaryEvents.nextWorker = nextEvents
        XCTAssertNotNil(primaryEvents.nextWorker)
    }
}

private class MockEventsWorker: MockWorker, WKRPTCLEvents {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenError
    var shouldFail = false

    // MARK: - WKRPTCLEvents Protocol Conformance
    var nextWorker: WKRPTCLEvents? {
        get { return nextBaseWorker as? WKRPTCLEvents }
        set { nextBaseWorker = newValue }
    }

    func register(nextWorker: WKRPTCLEvents, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.nextWorker = nextWorker
    }

    // MARK: - Worker Logic (Public) -
    func doLoadCurrentEvents(with progress: DNSPTCLProgressBlock?, and block: WKRPTCLEventsBlkAPlace?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Events.unknown(DNSCodeLocation(self))))
            } else {
                let places: [DAOPlace] = [DAOPlace(), DAOPlace()]
                block?(.success(places))
            }
        }
    }

    func doLoadEvents(for place: DAOPlace, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLEventsBlkAEvent?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Events.unknown(DNSCodeLocation(self))))
            } else {
                let events: [DAOEvent] = [DAOEvent(), DAOEvent()]
                block?(.success(events))
            }
        }
    }

    func doLoadPricing(for event: DAOEvent, and place: DAOPlace, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLEventsBlkPricing?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Events.unknown(DNSCodeLocation(self))))
            } else {
                let pricing = DAOPricing()
                block?(.success(pricing))
            }
        }
    }

    func doReact(with reaction: DNSReactionType, to event: DAOEvent, for place: DAOPlace, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLEventsBlkMeta?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Events.unknown(DNSCodeLocation(self))))
            } else {
                let meta = DNSMetadata()
                block?(.success(meta))
            }
        }
    }

    func doRemove(_ event: DAOEvent, for place: DAOPlace, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLEventsBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Events.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }

    func doRemove(_ eventDay: DAOEventDay, for event: DAOEvent, and place: DAOPlace, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLEventsBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Events.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }

    func doUnreact(with reaction: DNSReactionType, to event: DAOEvent, for place: DAOPlace, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLEventsBlkMeta?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Events.unknown(DNSCodeLocation(self))))
            } else {
                let meta = DNSMetadata()
                block?(.success(meta))
            }
        }
    }

    func doUpdate(_ event: DAOEvent, for place: DAOPlace, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLEventsBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Events.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }

    func doUpdate(_ eventDay: DAOEventDay, for event: DAOEvent, and place: DAOPlace, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLEventsBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Events.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }

    func doUpdate(_ pricing: DAOPricing, for event: DAOEvent, and place: DAOPlace, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLEventsBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Events.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }

    func doView(_ event: DAOEvent, for place: DAOPlace, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLEventsBlkMeta?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(DNSError.Events.unknown(DNSCodeLocation(self))))
            } else {
                let meta = DNSMetadata()
                block?(.success(meta))
            }
        }
    }

    // MARK: - Worker Logic (Shortcuts) -
    func doLoadCurrentEvents(with block: WKRPTCLEventsBlkAPlace?) {
        doLoadCurrentEvents(with: nil, and: block)
    }

    func doLoadEvents(for place: DAOPlace, with block: WKRPTCLEventsBlkAEvent?) {
        doLoadEvents(for: place, with: nil, and: block)
    }

    func doLoadPricing(for event: DAOEvent, and place: DAOPlace, with block: WKRPTCLEventsBlkPricing?) {
        doLoadPricing(for: event, and: place, with: nil as DNSPTCLProgressBlock?, and: block)
    }

    func doReact(with reaction: DNSReactionType, to event: DAOEvent, for place: DAOPlace, with block: WKRPTCLEventsBlkMeta?) {
        doReact(with: reaction, to: event, for: place, with: nil as DNSPTCLProgressBlock?, and: block)
    }

    func doRemove(_ event: DAOEvent, for place: DAOPlace, with block: WKRPTCLEventsBlkVoid?) {
        doRemove(event, for: place, with: nil as DNSPTCLProgressBlock?, and: block)
    }

    func doRemove(_ eventDay: DAOEventDay, for event: DAOEvent, and place: DAOPlace, with block: WKRPTCLEventsBlkVoid?) {
        doRemove(eventDay, for: event, and: place, with: nil as DNSPTCLProgressBlock?, and: block)
    }

    func doUnreact(with reaction: DNSReactionType, to event: DAOEvent, for place: DAOPlace, with block: WKRPTCLEventsBlkMeta?) {
        doUnreact(with: reaction, to: event, for: place, with: nil as DNSPTCLProgressBlock?, and: block)
    }

    func doUpdate(_ event: DAOEvent, for place: DAOPlace, with block: WKRPTCLEventsBlkVoid?) {
        doUpdate(event, for: place, with: nil as DNSPTCLProgressBlock?, and: block)
    }

    func doUpdate(_ eventDay: DAOEventDay, for event: DAOEvent, and place: DAOPlace, with block: WKRPTCLEventsBlkVoid?) {
        doUpdate(eventDay, for: event, and: place, with: nil as DNSPTCLProgressBlock?, and: block)
    }

    func doUpdate(_ pricing: DAOPricing, for event: DAOEvent, and place: DAOPlace, with block: WKRPTCLEventsBlkVoid?) {
        doUpdate(pricing, for: event, and: place, with: nil as DNSPTCLProgressBlock?, and: block)
    }

    func doView(_ event: DAOEvent, for place: DAOPlace, with block: WKRPTCLEventsBlkMeta?) {
        doView(event, for: place, with: nil as DNSPTCLProgressBlock?, and: block)
    }
}
