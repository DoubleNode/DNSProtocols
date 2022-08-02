//
//  WKRPTCLBeaconDist.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLBeaconDistRtnABeaconDistance = [DNSBeaconDistance]

// Protocol Result Types
public typealias WKRPTCLBeaconDistResABeaconDistance = Result<WKRPTCLBeaconDistRtnABeaconDistance, Error>

// Protocol Block Types
public typealias WKRPTCLBeaconDistBlkABeaconDistance = (WKRPTCLBeaconDistResABeaconDistance) -> Void

public protocol WKRPTCLBeaconDist: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLBeaconDist? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLBeaconDist,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doLoadBeaconDistances(with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLBeaconDistBlkABeaconDistance?)

    // MARK: - Worker Logic (Shortcuts) -
    func doLoadBeaconDistances(with block: WKRPTCLBeaconDistBlkABeaconDistance?)
}
