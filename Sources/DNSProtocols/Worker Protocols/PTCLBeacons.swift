//
//  PTCLBeacons.swift
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
    typealias Beacons = PTCLBeaconsError
}
public enum PTCLBeaconsError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

    public static let domain = "BEACONS"
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
            return String(format: NSLocalizedString("BEACONS-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("BEACONS-Not Implemented%@", comment: ""),
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

public typealias PTCLBeaconsResultArrayBeacon =
    Result<[DAOBeacon], Error>

public typealias PTCLBeaconsBlockVoidArrayBeacon =
    (PTCLBeaconsResultArrayBeacon) -> Void

public protocol PTCLBeacons: PTCLProtocolBase {
    var callNextWhen: PTCLProtocol.Call.NextWhen { get }
    var nextWorker: PTCLBeacons? { get }
    var systemsWorker: PTCLSystems? { get }

    init()
    func register(nextWorker: PTCLBeacons,
                  for callNextWhen: PTCLProtocol.Call.NextWhen)

    // MARK: - Business Logic / Single Item CRUD
    func doLoadBeacons(in center: DAOCenter,
                       with progress: PTCLProgressBlock?,
                       and block: PTCLBeaconsBlockVoidArrayBeacon?) throws
    func doLoadBeacons(in center: DAOCenter,
                       for activity: DAOActivity,
                       with progress: PTCLProgressBlock?,
                       and block: PTCLBeaconsBlockVoidArrayBeacon?) throws
    func doRangeBeacons(named uuids: [UUID],
                        for processKey: String,
                        with progress: PTCLProgressBlock?,
                        and block: PTCLBeaconsBlockVoidArrayBeacon?) throws
    func doStopRangeBeacons(for processKey: String) throws
}
