//
//  WKRPTCLGeo.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

// Protocol Return Types
public typealias WKRPTCLGeoRtnString = String
public typealias WKRPTCLGeoRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLGeoResString = Result<WKRPTCLGeoRtnString, Error>
public typealias WKRPTCLGeoResVoid = Result<WKRPTCLGeoRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLGeoBlkString = (WKRPTCLGeoResString) -> Void

public protocol WKRPTCLGeo: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLGeo? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLGeo,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doLocate(with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLGeoBlkString?)
    func doStopTrackLocation(for processKey: String) -> WKRPTCLGeoResVoid
    func doTrackLocation(for processKey: String,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLGeoBlkString?)

    // MARK: - Worker Logic (Shortcuts) -
    func doLocate(with block: WKRPTCLGeoBlkString?)
    func doTrackLocation(for processKey: String,
                         with block: WKRPTCLGeoBlkString?)
}
