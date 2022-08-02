//
//  WKRPTCLActivityTypes.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
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

// Protocol Return Types
public typealias WKRPTCLActivityTypesRtnActivityType = DAOActivityType
public typealias WKRPTCLActivityTypesRtnAActivityType = [DAOActivityType]
public typealias WKRPTCLActivityTypesRtnBool = Bool
public typealias WKRPTCLActivityTypesRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLActivityTypesResActivityType = Result<WKRPTCLActivityTypesRtnActivityType, Error>
public typealias WKRPTCLActivityTypesResAActivityType = Result<WKRPTCLActivityTypesRtnAActivityType, Error>
public typealias WKRPTCLActivityTypesResBool = Result<WKRPTCLActivityTypesRtnBool, Error>
public typealias WKRPTCLActivityTypesResVoid = Result<WKRPTCLActivityTypesRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLActivityTypesBlkActivityType = (WKRPTCLActivityTypesResActivityType) -> Void
public typealias WKRPTCLActivityTypesBlkAActivityType = (WKRPTCLActivityTypesResAActivityType) -> Void
public typealias WKRPTCLActivityTypesBlkBool = (WKRPTCLActivityTypesResBool) -> Void
public typealias WKRPTCLActivityTypesBlkVoid = (WKRPTCLActivityTypesResVoid) -> Void

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
                    and block: WKRPTCLActivityTypesBlkVoid?) throws
    func doIsFavorited(_ activityType: DAOActivityType,
                       for user: DAOUser,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLActivityTypesBlkBool?) throws
    func doLoadActivityType(for code: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLActivityTypesBlkActivityType?) throws
    func doLoadActivityTypes(with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLActivityTypesBlkAActivityType?) throws
    func doUnfavorite(_ activityType: DAOActivityType,
                      for user: DAOUser,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLActivityTypesBlkVoid?) throws
    func doUpdate(_ activityType: DAOActivityType,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLActivityTypesBlkVoid?) throws
    
    // MARK: - Worker Logic (Shortcuts) -
    func doFavorite(_ activityType: DAOActivityType,
                    for user: DAOUser,
                    with block: WKRPTCLActivityTypesBlkVoid?) throws
    func doIsFavorited(_ activityType: DAOActivityType,
                       for user: DAOUser,
                       with block: WKRPTCLActivityTypesBlkBool?) throws
    func doLoadActivityType(for code: String,
                            with block: WKRPTCLActivityTypesBlkActivityType?) throws
    func doLoadActivityTypes(with block: WKRPTCLActivityTypesBlkAActivityType?) throws
    func doUnfavorite(_ activityType: DAOActivityType,
                      for user: DAOUser,
                      with block: WKRPTCLActivityTypesBlkVoid?) throws
    func doUpdate(_ activityType: DAOActivityType,
                  with block: WKRPTCLActivityTypesBlkVoid?) throws
}
