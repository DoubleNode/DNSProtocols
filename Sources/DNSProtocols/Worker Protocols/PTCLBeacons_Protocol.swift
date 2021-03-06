//
//  PTCLBeacons_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import DNSDataObjects
import DNSError
import Foundation

public enum PTCLBeaconsError: Error
{
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
}
extension PTCLBeaconsError: DNSError {
    public static let domain = "BEACONS"
    public enum Code: Int
    {
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

// (beacons: [DAOBeacon], error: Error?)
public typealias PTCLBeaconsBlockVoidArrayDAOBeaconError = ([DAOBeacon], DNSError?) -> Void

public protocol PTCLBeacons_Protocol: PTCLBase_Protocol {
    var callNextWhen: PTCLCallNextWhen { get }
    var nextWorker: PTCLBeacons_Protocol? { get }

    init()
    func register(nextWorker: PTCLBeacons_Protocol,
                  for callNextWhen: PTCLCallNextWhen)

    // MARK: - Business Logic / Single Item CRUD

    func doLoadBeacons(in center: DAOCenter,
                       with progress: PTCLProgressBlock?,
                       and block: PTCLBeaconsBlockVoidArrayDAOBeaconError?) throws
    func doLoadBeacons(in center: DAOCenter,
                       for activity: DAOActivity,
                       with progress: PTCLProgressBlock?,
                       and block: PTCLBeaconsBlockVoidArrayDAOBeaconError?) throws
    func doRangeBeacons(named uuids: [UUID],
                        for processKey: String,
                        with progress: PTCLProgressBlock?,
                        and block: PTCLBeaconsBlockVoidArrayDAOBeaconError?) throws
    func doStopRangeBeacons(for processKey: String) throws
}
