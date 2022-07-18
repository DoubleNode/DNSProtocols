//
//  PTCLActivityTypes.swift
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
    typealias ActivityTypes = PTCLActivityTypesError
}
public enum PTCLActivityTypesError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

    public static let domain = "ACTTYPES"
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

public typealias PTCLActivityTypesResultBool = Result<Bool, Error>
public typealias PTCLActivityTypesResultVoid = Result<Void, Error>
public typealias PTCLActivityTypesResultArrayActivityType = Result<[DAOActivityType], Error>
public typealias PTCLActivityTypesResultActivityType = Result<DAOActivityType?, Error>

public typealias PTCLActivityTypesBlockVoidBool = (PTCLActivityTypesResultBool) -> Void
public typealias PTCLActivityTypesBlockVoid = (PTCLActivityTypesResultVoid) -> Void
public typealias PTCLActivityTypesBlockVoidArrayActivityType = (PTCLActivityTypesResultArrayActivityType) -> Void
public typealias PTCLActivityTypesBlockVoidActivityType = (PTCLActivityTypesResultActivityType) -> Void

public protocol PTCLActivityTypes: PTCLProtocolBase {
    var callNextWhen: PTCLProtocol.Call.NextWhen { get }
    var nextWorker: PTCLActivityTypes? { get }
    var systemsWorker: PTCLSystems? { get }

    init()
    func register(nextWorker: PTCLActivityTypes,
                  for callNextWhen: PTCLProtocol.Call.NextWhen)

    // MARK: - Business Logic / Single Item CRUD
    func doFavorite(_ activityType: DAOActivityType,
                    for user: DAOUser,
                    with progress: PTCLProgressBlock?,
                    and block: PTCLActivityTypesBlockVoid?) throws
    func doIsFavorited(_ activityType: DAOActivityType,
                       for user: DAOUser,
                       with progress: PTCLProgressBlock?,
                       and block: PTCLActivityTypesBlockVoidBool?) throws
    func doLoadActivityType(for code: String,
                            with progress: PTCLProgressBlock?,
                            and block: PTCLActivityTypesBlockVoidActivityType?) throws
    func doLoadActivityTypes(with progress: PTCLProgressBlock?,
                             and block: PTCLActivityTypesBlockVoidArrayActivityType?) throws
    func doUnfavorite(_ activityType: DAOActivityType,
                      for user: DAOUser,
                      with progress: PTCLProgressBlock?,
                      and block: PTCLActivityTypesBlockVoid?) throws
    func doUpdate(_ activityType: DAOActivityType,
                  with progress: PTCLProgressBlock?,
                  and block: PTCLActivityTypesBlockVoidBool?) throws
}
