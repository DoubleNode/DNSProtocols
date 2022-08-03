//
//  WKRPTCLBeacons.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLBeaconsRtnABeacon = [DAOBeacon]
public typealias WKRPTCLBeaconsRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLBeaconsResABeacon = Result<WKRPTCLBeaconsRtnABeacon, Error>
public typealias WKRPTCLBeaconsResVoid = Result<WKRPTCLBeaconsRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLBeaconsBlkABeacon = (WKRPTCLBeaconsResABeacon) -> Void

public protocol WKRPTCLBeacons: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLBeacons? { get }
    var systemsWorker: WKRPTCLSystems { get }

    init()
    func register(nextWorker: WKRPTCLBeacons,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doLoadBeacons(in place: DAOPlace,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLBeaconsBlkABeacon?)
    func doLoadBeacons(in place: DAOPlace,
                       for activity: DAOActivity,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLBeaconsBlkABeacon?)
    func doRangeBeacons(named uuids: [UUID],
                        for processKey: String,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLBeaconsBlkABeacon?)
    func doStopRangeBeacons(for processKey: String) -> WKRPTCLBeaconsResVoid

    // MARK: - Worker Logic (Shortcuts) -
    func doLoadBeacons(in place: DAOPlace,
                       with block: WKRPTCLBeaconsBlkABeacon?)
    func doLoadBeacons(in place: DAOPlace,
                       for activity: DAOActivity,
                       with block: WKRPTCLBeaconsBlkABeacon?)
    func doRangeBeacons(named uuids: [UUID],
                        for processKey: String,
                        with block: WKRPTCLBeaconsBlkABeacon?)
}
