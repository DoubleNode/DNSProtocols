//
//  WKRPTCLBeacons.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import DNSDataObjects
import DNSError
import Foundation

public extension DNSError {
    typealias Beacons = WKRPTCLBeaconsError
}
public enum WKRPTCLBeaconsError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

    public static let domain = "WKRBEACONS"
    public enum Code: Int {
        case unknown = 1001
        case notImplemented = 1002
    }
    
    public var nsError: NSError! {
        switch self {
        case .unknown(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        case .notImplemented(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notImplemented.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return String(format: NSLocalizedString("WKRBEACONS-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRBEACONS-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation):
            return codeLocation.failureReason
        }
    }
}

// Protocol Return Types
public typealias WKRPTCLBeaconsRtnABeacon = [DAOBeacon]

// Protocol Result Types
public typealias WKRPTCLBeaconsResABeacon = Result<WKRPTCLBeaconsRtnABeacon, Error>

// Protocol Block Types
public typealias WKRPTCLBeaconsBlkABeacon = (WKRPTCLBeaconsResABeacon) -> Void

public protocol WKRPTCLBeacons: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLBeacons? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLBeacons,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doLoadBeacons(in center: DAOCenter,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLBeaconsBlkABeacon?) throws
    func doLoadBeacons(in center: DAOCenter,
                       for activity: DAOActivity,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLBeaconsBlkABeacon?) throws
    func doRangeBeacons(named uuids: [UUID],
                        for processKey: String,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLBeaconsBlkABeacon?) throws
    func doStopRangeBeacons(for processKey: String) throws

    // MARK: - Worker Logic (Shortcuts) -
    func doLoadBeacons(in center: DAOCenter,
                       with block: WKRPTCLBeaconsBlkABeacon?) throws
    func doLoadBeacons(in center: DAOCenter,
                       for activity: DAOActivity,
                       with block: WKRPTCLBeaconsBlkABeacon?) throws
    func doRangeBeacons(named uuids: [UUID],
                        for processKey: String,
                        with block: WKRPTCLBeaconsBlkABeacon?) throws
}
