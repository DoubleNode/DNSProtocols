//
//  WKRPTCLActivities.swift
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
    typealias Activities = WKRPTCLActivitiesError
}
public enum WKRPTCLActivitiesError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

    public static let domain = "WKRACTIVITIES"
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
            return String(format: NSLocalizedString("WKRACTIVITIES-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRACTIVITIES-Not Implemented%@", comment: ""),
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
public typealias WKRPTCLActivitiesRtnActivity = DAOActivity?
public typealias WKRPTCLActivitiesRtnAActivity = [DAOActivity]
public typealias WKRPTCLActivitiesRtnBool = Bool

// Protocol Result Types
public typealias WKRPTCLActivitiesResActivity = Result<WKRPTCLActivitiesRtnActivity, Error>
public typealias WKRPTCLActivitiesResAActivity = Result<WKRPTCLActivitiesRtnAActivity, Error>
public typealias WKRPTCLActivitiesResBool = Result<WKRPTCLActivitiesRtnBool, Error>

// Protocol Block Types
public typealias WKRPTCLActivitiesBlkActivity = (WKRPTCLActivitiesResActivity) -> Void
public typealias WKRPTCLActivitiesBlkAActivity = (WKRPTCLActivitiesResAActivity) -> Void
public typealias WKRPTCLActivitiesBlkBool = (WKRPTCLActivitiesResBool) -> Void

public protocol WKRPTCLActivities: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLActivities? { get }
    var systemsWorker: WKRPTCLSystems? { get }
    
    init()
    func register(nextWorker: WKRPTCLActivities,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)
    
    // MARK: - Worker Logic (Public) -
    func doLoadActivities(for center: DAOCenter,
                          using activityTypes: [DAOActivityType],
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLActivitiesBlkAActivity?) throws
    func doUpdate(_ activities: [DAOActivity],
                  for center: DAOCenter,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLActivitiesBlkBool?) throws
    
    // MARK: - Worker Logic (Shortcuts) -
    func doLoadActivities(for center: DAOCenter,
                          using activityTypes: [DAOActivityType],
                          with block: WKRPTCLActivitiesBlkAActivity?) throws
    func doUpdate(_ activities: [DAOActivity],
                  for center: DAOCenter,
                  with block: WKRPTCLActivitiesBlkBool?) throws
}
