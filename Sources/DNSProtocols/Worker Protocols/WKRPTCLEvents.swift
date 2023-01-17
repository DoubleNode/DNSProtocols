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
public typealias WKRPTCLEventsRtnMeta = DNSMetadata
public typealias WKRPTCLEventsRtnAPlace = [DAOPlace]
public typealias WKRPTCLEventsRtnPricing = DAOPricing
public typealias WKRPTCLEventsRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLEventsResAEvent = Result<WKRPTCLEventsRtnAEvent, Error>
public typealias WKRPTCLEventsResEvent = Result<WKRPTCLEventsRtnEvent, Error>
public typealias WKRPTCLEventsResMeta = Result<WKRPTCLEventsRtnMeta, Error>
public typealias WKRPTCLEventsResAPlace = Result<WKRPTCLEventsRtnAPlace, Error>
public typealias WKRPTCLEventsResPricing = Result<WKRPTCLEventsRtnPricing, Error>
public typealias WKRPTCLEventsResVoid = Result<WKRPTCLEventsRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLEventsBlkAEvent = (WKRPTCLEventsResAEvent) -> Void
public typealias WKRPTCLEventsBlkEvent = (WKRPTCLEventsResEvent) -> Void
public typealias WKRPTCLEventsBlkMeta = (WKRPTCLEventsResMeta) -> Void
public typealias WKRPTCLEventsBlkAPlace = (WKRPTCLEventsResAPlace) -> Void
public typealias WKRPTCLEventsBlkPricing = (WKRPTCLEventsResPricing) -> Void
public typealias WKRPTCLEventsBlkVoid = (WKRPTCLEventsResVoid) -> Void

public protocol WKRPTCLEvents: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLEvents? { get }
    var wkrSystems: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLEvents,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doLoadCurrentEvents(with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLEventsBlkAPlace?)
    func doLoadEvents(for event: DAOEvent,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLEventsBlkAEvent?)
    func doLoadPricing(for place: DAOPlace,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLEventsBlkPricing?)
    func doReact(with reaction: DNSReactionType,
                 to event: DAOEvent,
                 for place: DAOPlace,
                 with progress: DNSPTCLProgressBlock?,
                 and block: WKRPTCLEventsBlkMeta?)
    func doRemove(_ event: DAOEvent,
                  for place: DAOPlace,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLEventsBlkVoid?)
    func doRemove(_ eventDay: DAOEventDay,
                  for event: DAOEvent,
                  and place: DAOPlace,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLEventsBlkVoid?)
    func doUnreact(with reaction: DNSReactionType,
                   to event: DAOEvent,
                   for place: DAOPlace,
                   with progress: DNSPTCLProgressBlock?,
                   and block: WKRPTCLEventsBlkMeta?)
    func doUpdate(_ event: DAOEvent,
                  for place: DAOPlace,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLEventsBlkVoid?)
    func doUpdate(_ eventDay: DAOEventDay,
                  for event: DAOEvent,
                  and place: DAOPlace,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLEventsBlkVoid?)
    func doUpdate(_ pricing: DAOPricing,
                  for event: DAOEvent,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLEventsBlkVoid?)
    func doView(_ event: DAOEvent,
                for place: DAOPlace,
                with progress: DNSPTCLProgressBlock?,
                and block: WKRPTCLEventsBlkMeta?)

    // MARK: - Worker Logic (Shortcuts) -
    func doLoadCurrentEvents(with block: WKRPTCLEventsBlkAPlace?)
    func doLoadEvents(for place: DAOPlace,
                      with block: WKRPTCLEventsBlkAEvent?)
    func doLoadPricing(for event: DAOEvent,
                       with block: WKRPTCLEventsBlkPricing?)
    func doReact(with reaction: DNSReactionType,
                 to event: DAOEvent,
                 for place: DAOPlace,
                 with block: WKRPTCLEventsBlkMeta?)
    func doRemove(_ event: DAOEvent,
                  for place: DAOPlace,
                  with block: WKRPTCLEventsBlkVoid?)
    func doRemove(_ eventDay: DAOEventDay,
                  for event: DAOEvent,
                  and place: DAOPlace,
                  with block: WKRPTCLEventsBlkVoid?)
    func doUnreact(with reaction: DNSReactionType,
                   to event: DAOEvent,
                   for place: DAOPlace,
                   with block: WKRPTCLEventsBlkMeta?)
    func doUpdate(_ event: DAOEvent,
                  for place: DAOPlace,
                  with block: WKRPTCLEventsBlkVoid?)
    func doUpdate(_ eventDay: DAOEventDay,
                  for event: DAOEvent,
                  and place: DAOPlace,
                  with block: WKRPTCLEventsBlkVoid?)
    func doUpdate(_ pricing: DAOPricing,
                  for event: DAOEvent,
                  with block: WKRPTCLEventsBlkVoid?)
    func doView(_ event: DAOEvent,
                for place: DAOPlace,
                with block: WKRPTCLEventsBlkMeta?)
}
