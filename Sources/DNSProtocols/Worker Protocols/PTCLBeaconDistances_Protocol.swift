//
//  PTCLBeaconDistances_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCoreThreading
import DNSDataObjects
import DNSError
import Foundation

public enum PTCLBeaconDistancesError: Error
{
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
}
extension PTCLBeaconDistancesError: DNSError {
    public static let domain = "BECNDIST"
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
            return String(format: NSLocalizedString("BECNDIST-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("BECNDIST-Not Implemented%@", comment: ""),
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

// (distances: [DAOBeaconDistance], error: Error?)
// swiftlint:disable:next type_name
public typealias PTCLBeaconDistancesBlockVoidArrayDAOBeaconDistanceError = ([DAOBeaconDistance], DNSError?) -> Void

public protocol PTCLBeaconDistances_Protocol: PTCLBase_Protocol {
    var callNextWhen: PTCLCallNextWhen { get }
    var nextWorker: PTCLBeaconDistances_Protocol? { get }

    init()
    init(call callNextWhen: PTCLCallNextWhen,
         nextWorker: PTCLBeaconDistances_Protocol)

    // MARK: - Business Logic / Single Item CRUD

    func doLoadBeaconDistances(with progress: PTCLProgressBlock?,
                               and block: PTCLBeaconDistancesBlockVoidArrayDAOBeaconDistanceError?) throws
}
