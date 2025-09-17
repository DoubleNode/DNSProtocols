//
//  WKRPTCLGeo.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import CoreLocation
import DNSCore
import Foundation

// Protocol Return Types
public typealias WKRPTCLGeoRtnStringLocation = (String, CLLocation)
public typealias WKRPTCLGeoRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLGeoResStringLocation = Result<WKRPTCLGeoRtnStringLocation, Error>
public typealias WKRPTCLGeoResVoid = Result<WKRPTCLGeoRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLGeoBlkStringLocation = (WKRPTCLGeoResStringLocation) -> Void

public protocol WKRPTCLGeo: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var wkrSystems: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLGeo,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doLocate(with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLGeoBlkStringLocation?)
    func doLocate(_ address: DNSPostalAddress,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLGeoBlkStringLocation?)
    func doStopTrackLocation(for processKey: String) -> WKRPTCLGeoResVoid
    func doTrackLocation(for processKey: String,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLGeoBlkStringLocation?)

    // MARK: - Worker Logic (Shortcuts) -
    func doLocate(with block: WKRPTCLGeoBlkStringLocation?)
    func doLocate(_ address: DNSPostalAddress,
                  with block: WKRPTCLGeoBlkStringLocation?)
    func doTrackLocation(for processKey: String,
                         with block: WKRPTCLGeoBlkStringLocation?)
}
