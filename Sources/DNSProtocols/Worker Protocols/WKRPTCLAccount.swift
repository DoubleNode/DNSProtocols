//
//  WKRPTCLAccount.swift
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
    typealias Account = WKRPTCLAccountError
}
public enum WKRPTCLAccountError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

    public static let domain = "WKRACCOUNT"
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
            return String(format: NSLocalizedString("WKRACCOUNT-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRACCOUNT-Not Implemented%@", comment: ""),
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
public typealias WKRPTCLAccountRtnAccount = DAOAccount?
public typealias WKRPTCLAccountRtnBool = Bool

// Protocol Result Types
public typealias WKRPTCLAccountResAccount = Result<WKRPTCLAccountRtnAccount, Error>
public typealias WKRPTCLAccountResBool = Result<WKRPTCLAccountRtnBool, Error>

// Protocol Block Types
public typealias WKRPTCLAccountBlkAccount = (WKRPTCLAccountResAccount) -> Void
public typealias WKRPTCLAccountBlkBool = (WKRPTCLAccountResBool) -> Void

public protocol WKRPTCLAccount: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLAccount? { get }
    var systemsWorker: WKRPTCLSystems? { get }
    
    init()
    func register(nextWorker: WKRPTCLAccount,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)
    
    // MARK: - Worker Logic (Public) -
    func doLoadAccount(for user: DAOUser,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLAccountBlkAccount?) throws
    func doUpdate(account: DAOAccount,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLAccountBlkBool?) throws
    
    // MARK: - Worker Logic (Shortcuts) -
    func doLoadAccount(for user: DAOUser,
                       with block: WKRPTCLAccountBlkAccount?) throws
    func doUpdate(account: DAOAccount,
                  with block: WKRPTCLAccountBlkBool?) throws
}
