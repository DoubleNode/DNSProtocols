//
//  WKRPTCLUsers.swift
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

// Protocol Return Types
public typealias WKRPTCLUsersRtnBool = Bool
public typealias WKRPTCLUsersRtnAUser = [DAOUser]
public typealias WKRPTCLUsersRtnUser = DAOUser?

// Protocol Result Types
public typealias WKRPTCLUsersResBool = Result<WKRPTCLUsersRtnBool, Error>
public typealias WKRPTCLUsersResAUser = Result<WKRPTCLUsersRtnAUser, Error>
public typealias WKRPTCLUsersResUser = Result<WKRPTCLUsersRtnUser, Error>

// Protocol Block Types
public typealias WKRPTCLUsersBlkBool = (WKRPTCLUsersResBool) -> Void
public typealias WKRPTCLUsersBlkAUser = (WKRPTCLUsersResAUser) -> Void
public typealias WKRPTCLUsersBlkUser = (WKRPTCLUsersResUser) -> Void

public protocol WKRPTCLUsers: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLUsers? { get }

    init()
    func register(nextWorker: WKRPTCLUsers,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doLoadCurrentUser(with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLUsersBlkUser?) throws
    func doLoadUser(for id: String,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLUsersBlkUser?) throws
    func doLoadUsers(for account: DAOAccount,
                     with progress: DNSPTCLProgressBlock?,
                     and block: WKRPTCLUsersBlkAUser?) throws
    func doRemoveCurrentUser(with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLUsersBlkBool?) throws
    func doRemove(_ user: DAOUser,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLUsersBlkBool?) throws
    func doUpdate(_ user: DAOUser,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLUsersBlkBool?) throws

    // MARK: - Worker Logic (Shortcuts) -
    func doLoadCurrentUser(with block: WKRPTCLUsersBlkUser?) throws
    func doLoadUser(for id: String,
                    with progress: WKRPTCLUsersBlkUser?) throws
    func doLoadUsers(for account: DAOAccount,
                     with block: WKRPTCLUsersBlkAUser?) throws
    func doRemoveCurrentUser(with block: WKRPTCLUsersBlkBool?) throws
    func doRemove(_ user: DAOUser,
                  with block: WKRPTCLUsersBlkBool?) throws
    func doUpdate(_ user: DAOUser,
                  with block: WKRPTCLUsersBlkBool?) throws
}
