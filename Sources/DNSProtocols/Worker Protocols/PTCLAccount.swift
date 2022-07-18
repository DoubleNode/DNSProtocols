//
//  PTCLAccount.swift
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
    typealias Account = PTCLAccountError
}
public enum PTCLAccountError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

    public static let domain = "ACCOUNT"
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
            return String(format: NSLocalizedString("ACCOUNT-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("ACCOUNT-Not Implemented%@", comment: ""),
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

public typealias PTCLAccountResultAccount = Result<DAOAccount?, Error>
public typealias PTCLAccountResultBool = Result<Bool, Error>

public typealias PTCLAccountBlockVoidAccount = (PTCLAccountResultAccount) -> Void
public typealias PTCLAccountBlockVoidBool = (PTCLAccountResultBool) -> Void

public protocol PTCLAccount: PTCLProtocolBase {
    var callNextWhen: PTCLProtocol.Call.NextWhen { get }
    var nextWorker: PTCLAccount? { get }
    var systemsWorker: PTCLSystems? { get }

    init()
    func register(nextWorker: PTCLAccount,
                  for callNextWhen: PTCLProtocol.Call.NextWhen)

    // MARK: - Business Logic / Single Item CRUD
    func doLoadAccount(for user: DAOUser,
                       with progress: PTCLProgressBlock?,
                       and block: PTCLAccountBlockVoidAccount?) throws
    func doUpdate(account: DAOAccount,
                  with progress: PTCLProgressBlock?,
                  and block: PTCLAccountBlockVoidBool?) throws
}
