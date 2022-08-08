//
//  WKRPTCLAppEvents.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLAppEventsRtnAAppEvent = [DAOAppEvent]

// Protocol Result Types
public typealias WKRPTCLAppEventsResAAppEvent = Result<WKRPTCLAppEventsRtnAAppEvent, Error>

// Protocol Block Types
public typealias WKRPTCLAppEventsBlkAAppEvent = (WKRPTCLAppEventsResAAppEvent) -> Void

public protocol WKRPTCLAppEvents: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLAppEvents? { get }
    var wkrSystems: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLAppEvents,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doLoadAppEvents(with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAppEventsBlkAAppEvent?)

    // MARK: - Worker Logic (Shortcuts) -
    func doLoadAppEvents(with block: WKRPTCLAppEventsBlkAAppEvent?)
}
