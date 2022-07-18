//
//  WKRPTCLUsers.swift
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
    typealias Users = WKRPTCLUsersError
}
public enum WKRPTCLUsersError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case noAccounts(_ codeLocation: DNSCodeLocation)

    public static let domain = "WKRUSERS"
    public enum Code: Int {
        case unknown = 1001
        case notImplemented = 1002
        case noAccounts = 1003
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
        case .noAccounts(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.noAccounts.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return String(format: NSLocalizedString("WKRUSERS-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRUSERS-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .noAccounts:
            return String(format: NSLocalizedString("WKRUSERS-No Accounts Found%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.noAccounts.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation),
             .noAccounts(let codeLocation):
                return codeLocation.failureReason
       }
    }
}

// Protocol Result Types
//
public typealias WKRPTCLUsersResultBool = Result<Bool, Error>
public typealias WKRPTCLUsersResultUser = Result<DAOUser?, Error>

// Protocol Block Types
//
public typealias WKRPTCLUsersBlockBool = (WKRPTCLUsersResultBool) -> Void
public typealias WKRPTCLUsersBlockUser = (WKRPTCLUsersResultUser) -> Void

public protocol WKRPTCLUsers: WKRPTCLWorkerBase {
    var callNextWhen: WKRPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLUsers? { get }

    init()
    func register(nextWorker: WKRPTCLUsers,
                  for callNextWhen: WKRPTCLWorker.Call.NextWhen)

    // MARK: - Business Logic / Single Item CRUD
    func doLoadCurrentUser(with progress: WKRPTCLProgressBlock?,
                           and block: WKRPTCLUsersBlockUser?) throws
    func doLoadUser(for id: String,
                    with progress: WKRPTCLProgressBlock?,
                    and block: WKRPTCLUsersBlockUser?) throws
    func doRemoveCurrentUser(with progress: WKRPTCLProgressBlock?,
                             and block: WKRPTCLUsersBlockBool?) throws
    func doRemove(_ user: DAOUser,
                  with progress: WKRPTCLProgressBlock?,
                  and block: WKRPTCLUsersBlockBool?) throws
    func doUpdate(_ user: DAOUser,
                  with progress: WKRPTCLProgressBlock?,
                  and block: WKRPTCLUsersBlockBool?) throws
}
