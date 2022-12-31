//
//  WKRPTCLEvents.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLEventsRtnAEvent = [DAOEvent]
public typealias WKRPTCLEventsRtnEvent = DAOEvent
public typealias WKRPTCLEventsRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLEventsResAEvent = Result<WKRPTCLEventsRtnAEvent, Error>
public typealias WKRPTCLEventsResEvent = Result<WKRPTCLEventsRtnEvent, Error>
public typealias WKRPTCLEventsResVoid = Result<WKRPTCLEventsRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLEventsBlkAEvent = (WKRPTCLEventsResAEvent) -> Void
public typealias WKRPTCLEventsBlkEvent = (WKRPTCLEventsResEvent) -> Void
public typealias WKRPTCLEventsBlkVoid = (WKRPTCLEventsResVoid) -> Void

public protocol WKRPTCLEvents: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLEvents? { get }
    var wkrSystems: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLEvents,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doLike(_ event: DAOEvent,
                for place: DAOPlace,
                with progress: DNSPTCLProgressBlock?,
                and block: WKRPTCLEventsBlkVoid?)
    func doLoadEvents(with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLEventsBlkAEvent?)
    func doLoadEvents(for place: DAOPlace,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLEventsBlkAEvent?)
    func doRemove(_ event: DAOEvent,
                  for place: DAOPlace,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLEventsBlkVoid?)
    func doUpdate(_ event: DAOEvent,
                  for place: DAOPlace,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLEventsBlkVoid?)
    func doUnlike(_ event: DAOEvent,
                  for place: DAOPlace,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLEventsBlkVoid?)
    func doUnview(_ event: DAOEvent,
                  for place: DAOPlace,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLEventsBlkVoid?)
    func doView(_ event: DAOEvent,
                for place: DAOPlace,
                with progress: DNSPTCLProgressBlock?,
                and block: WKRPTCLEventsBlkVoid?)

    // MARK: - Worker Logic (Shortcuts) -
    func doLike(_ event: DAOEvent,
                for place: DAOPlace,
                with block: WKRPTCLEventsBlkVoid?)
    func doLoadEvents(with block: WKRPTCLEventsBlkAEvent?)
    func doLoadEvents(for place: DAOPlace,
                             with block: WKRPTCLEventsBlkAEvent?)
    func doRemove(_ event: DAOEvent,
                  for place: DAOPlace,
                  with block: WKRPTCLEventsBlkVoid?)
    func doUpdate(_ event: DAOEvent,
                  for place: DAOPlace,
                  with block: WKRPTCLEventsBlkVoid?)
    func doUnlike(_ event: DAOEvent,
                  for place: DAOPlace,
                  with block: WKRPTCLEventsBlkVoid?)
    func doUnview(_ event: DAOEvent,
                  for place: DAOPlace,
                  with block: WKRPTCLEventsBlkVoid?)
    func doView(_ event: DAOEvent,
                for place: DAOPlace,
                with block: WKRPTCLEventsBlkVoid?)
}
