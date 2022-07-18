//
//  WKRPTCLActivityTypes.swift
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
    typealias ActivityTypes = WKRPTCLActivityTypesError
}
public enum WKRPTCLActivityTypesError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

    public static let domain = "WKRACTTYPES"
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
            return String(format: NSLocalizedString("ACTTYPES-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("ACTTYPES-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation):
            return codeLocation.failureReason
        case .notImplemented(let codeLocation):
            return codeLocation.failureReason
        }
    }
}

// Protocol Result Types
public typealias WKRPTCLActivityTypesResultArrayActivityType = Result<[DAOActivityType], Error>
//
public typealias WKRPTCLActivityTypesResultBool = Result<Bool, Error>
public typealias WKRPTCLActivityTypesResultVoid = Result<Void, Error>
public typealias WKRPTCLActivityTypesResultActivityType = Result<DAOActivityType?, Error>

// Protocol Block Types
public typealias WKRPTCLActivityTypesBlockArrayActivityType = (WKRPTCLActivityTypesResultArrayActivityType) -> Void
//
public typealias WKRPTCLActivityTypesBlockBool = (WKRPTCLActivityTypesResultBool) -> Void
public typealias WKRPTCLActivityTypesBlockVoid = (WKRPTCLActivityTypesResultVoid) -> Void
public typealias WKRPTCLActivityTypesBlockActivityType = (WKRPTCLActivityTypesResultActivityType) -> Void

public protocol WKRPTCLActivityTypes: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLActivityTypes? { get }
    var systemsWorker: WKRPTCLSystems? { get }
    
    init()
    func register(nextWorker: WKRPTCLActivityTypes,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)
    
    // MARK: - Worker Logic (Public) -
    func doFavorite(_ activityType: DAOActivityType,
                    for user: DAOUser,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLActivityTypesBlockVoid?) throws
    func doIsFavorited(_ activityType: DAOActivityType,
                       for user: DAOUser,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLActivityTypesBlockBool?) throws
    func doLoadActivityType(for code: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLActivityTypesBlockActivityType?) throws
    func doLoadActivityTypes(with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLActivityTypesBlockArrayActivityType?) throws
    func doUnfavorite(_ activityType: DAOActivityType,
                      for user: DAOUser,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLActivityTypesBlockVoid?) throws
    func doUpdate(_ activityType: DAOActivityType,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLActivityTypesBlockBool?) throws
    
    // MARK: - Worker Logic (Shortcuts) -
    func doFavorite(_ activityType: DAOActivityType,
                    for user: DAOUser,
                    with block: WKRPTCLActivityTypesBlockVoid?) throws
    func doIsFavorited(_ activityType: DAOActivityType,
                       for user: DAOUser,
                       with block: WKRPTCLActivityTypesBlockBool?) throws
    func doLoadActivityType(for code: String,
                            with block: WKRPTCLActivityTypesBlockActivityType?) throws
    func doLoadActivityTypes(with block: WKRPTCLActivityTypesBlockArrayActivityType?) throws
    func doUnfavorite(_ activityType: DAOActivityType,
                      for user: DAOUser,
                      with block: WKRPTCLActivityTypesBlockVoid?) throws
    func doUpdate(_ activityType: DAOActivityType,
                  with block: WKRPTCLActivityTypesBlockBool?) throws
}
