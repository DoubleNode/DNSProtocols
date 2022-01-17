//
//  PTCLAuthentication.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import DNSDataObjects
import DNSError
import UIKit

public extension DNSError {
    typealias Authentication = PTCLAuthenticationError
}
public enum PTCLAuthenticationError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case failure(error: Error, _ codeLocation: DNSCodeLocation)
    case lockedOut(_ codeLocation: DNSCodeLocation)
    case passwordExpired(_ codeLocation: DNSCodeLocation)

    public static let domain = "AUTH"
    public enum Code: Int
    {
        case unknown = 1001
        case notImplemented = 1002
        case failure = 1003
        case lockedOut = 1004
        case passwordExpired = 1005
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
        case .failure(let error, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Error"] = error
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.failure.rawValue,
                                userInfo: userInfo)
        case .lockedOut(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.lockedOut.rawValue,
                                userInfo: userInfo)
        case .passwordExpired(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.passwordExpired.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return String(format: NSLocalizedString("AUTH-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("AUTH-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .failure(let error, _):
            return String(format: NSLocalizedString("AUTH-SignIn Failure%@%@", comment: ""),
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.failure.rawValue))")
        case .lockedOut:
            return String(format: NSLocalizedString("AUTH-Locked Out%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.lockedOut.rawValue))")
        case .passwordExpired:
            return String(format: NSLocalizedString("AUTH-Password Expired%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.passwordExpired.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation),
             .failure(_, let codeLocation),
             .lockedOut(let codeLocation),
             .passwordExpired(let codeLocation):
            return codeLocation.failureReason
        }
    }
}

public protocol PTCLAuthenticationAccessData { }

public typealias PTCLAuthenticationResultBool =
    Result<Bool, Error>
public typealias PTCLAuthenticationResultBoolAccessData =
    Result<(Bool, PTCLAuthenticationAccessData), Error>
public typealias PTCLAuthenticationResultBoolBoolAccessData =
    Result<(Bool, Bool, PTCLAuthenticationAccessData), Error>

public typealias PTCLAuthenticationBlockVoidBool =
    (PTCLAuthenticationResultBool) -> Void
public typealias PTCLAuthenticationBlockVoidBoolAccessData = (PTCLAuthenticationResultBoolAccessData) -> Void
public typealias PTCLAuthenticationBlockVoidBoolBoolAccessData = (PTCLAuthenticationResultBoolBoolAccessData) -> Void

public protocol PTCLAuthentication: PTCLProtocolBase {
    typealias AccessData = PTCLAuthenticationAccessData
    
    var callNextWhen: PTCLProtocol.Call.NextWhen { get }
    var nextWorker: PTCLAuthentication? { get }

    init()
    func register(nextWorker: PTCLAuthentication,
                  for callNextWhen: PTCLProtocol.Call.NextWhen)

    // MARK: - Business Logic / Single Item CRUD
    func doCheckAuthentication(using parameters: [String: Any],
                               with progress: PTCLProgressBlock?,
                               and block: PTCLAuthenticationBlockVoidBoolBoolAccessData?) throws
    func doSignIn(from username: String?,
                  and password: String?,
                  using parameters: [String: Any],
                  with progress: PTCLProgressBlock?,
                  and block: PTCLAuthenticationBlockVoidBoolAccessData?) throws
    func doSignOut(using parameters: [String: Any],
                   with progress: PTCLProgressBlock?,
                   and block: PTCLAuthenticationBlockVoidBool?) throws
    func doSignUp(from user: DAOUser?,
                  and password: String?,
                  using parameters: [String: Any],
                  with progress: PTCLProgressBlock?,
                  and block: PTCLAuthenticationBlockVoidBoolAccessData?) throws
}
