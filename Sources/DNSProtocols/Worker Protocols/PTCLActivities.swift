//
//  PTCLActivities.swift
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
    typealias Activities = PTCLActivitiesError
}
public enum PTCLActivitiesError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

    public static let domain = "ACTIVITIES"
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
            return String(format: NSLocalizedString("ACTIVITIES-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("ACTIVITIES-Not Implemented%@", comment: ""),
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

public typealias PTCLActivitiesResultArrayActivity = Result<[DAOActivity], Error>
public typealias PTCLActivitiesResultActivity = Result<DAOActivity?, Error>
public typealias PTCLActivitiesResultBool = Result<Bool, Error>

public typealias PTCLActivitiesBlockVoidArrayActivity = (PTCLActivitiesResultArrayActivity) -> Void
public typealias PTCLActivitiesBlockVoidActivity = (PTCLActivitiesResultActivity) -> Void
public typealias PTCLActivitiesBlockVoidBool = (PTCLActivitiesResultBool) -> Void

public protocol PTCLActivities: PTCLProtocolBase {
    var callNextWhen: PTCLProtocol.Call.NextWhen { get }
    var nextWorker: PTCLActivities? { get }
    var systemsWorker: PTCLSystems? { get }

    init()
    func register(nextWorker: PTCLActivities,
                  for callNextWhen: PTCLProtocol.Call.NextWhen)

    // MARK: - Business Logic / Single Item CRUD
    func doLoadActivities(for center: DAOCenter,
                          using activityTypes: [DAOActivityType],
                          with progress: PTCLProgressBlock?,
                          and block: PTCLActivitiesBlockVoidArrayActivity?) throws
    func doUpdate(_ activities: [DAOActivity],
                  for center: DAOCenter,
                  with progress: PTCLProgressBlock?,
                  and block: PTCLActivitiesBlockVoidBool?) throws
}
