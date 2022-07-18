//
//  WKRPTCLAuthentication.swift
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
    typealias Authentication = WKRPTCLAuthenticationError
}
public enum WKRPTCLAuthenticationError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case failure(error: Error, _ codeLocation: DNSCodeLocation)
    case lockedOut(_ codeLocation: DNSCodeLocation)
    case passwordExpired(_ codeLocation: DNSCodeLocation)
    case invalidParameters(parameters: [String], _ codeLocation: DNSCodeLocation)

    public static let domain = "WKRAUTH"
    public enum Code: Int {
        case unknown = 1001
        case notImplemented = 1002
        case failure = 1003
        case lockedOut = 1004
        case passwordExpired = 1005
        case invalidParameters = 1006
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
        case .invalidParameters(let parameters, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            userInfo["Parameters"] = parameters
            return NSError.init(domain: Self.domain,
                                code: Self.Code.invalidParameters.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return String(format: NSLocalizedString("WKRAUTH-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRAUTH-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .failure(let error, _):
            return String(format: NSLocalizedString("WKRAUTH-SignIn Failure%@%@", comment: ""),
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.failure.rawValue))")
        case .lockedOut:
            return String(format: NSLocalizedString("WKRAUTH-Locked Out%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.lockedOut.rawValue))")
        case .passwordExpired:
            return String(format: NSLocalizedString("WKRAUTH-Password Expired%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.passwordExpired.rawValue))")
        case .invalidParameters(let parameters, _):
            let parametersString = parameters.reduce("") { $0 + ($0.isEmpty ? "" : ", ") + $1 }
            return String(format: NSLocalizedString("WKRAUTH-Invalid Parameters%@%@", comment: ""),
                          "\(parametersString)",
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation),
             .failure(_, let codeLocation),
             .lockedOut(let codeLocation),
             .passwordExpired(let codeLocation),
             .invalidParameters(_, let codeLocation):
            return codeLocation.failureReason
        }
    }
}

public protocol WKRPTCLAuthenticationAccessData { }

// Protocol Result Types
public typealias WKRPTCLAuthenticationResultBoolBoolAccessData = Result<(Bool, Bool, WKRPTCLAuthenticationAccessData), Error>
//
public typealias WKRPTCLAuthenticationResultBool = Result<Bool, Error>
public typealias WKRPTCLAuthenticationResultBoolAccessData = Result<(Bool, WKRPTCLAuthenticationAccessData), Error>

// Protocol Block Types
public typealias WKRPTCLAuthenticationBlockBoolBoolAccessData = (WKRPTCLAuthenticationResultBoolBoolAccessData) -> Void
//
public typealias WKRPTCLAuthenticationBlockBool = (WKRPTCLAuthenticationResultBool) -> Void
public typealias WKRPTCLAuthenticationBlockBoolAccessData = (WKRPTCLAuthenticationResultBoolAccessData) -> Void

public protocol WKRPTCLAuthentication: WKRPTCLWorkerBase {
    typealias AccessData = WKRPTCLAuthenticationAccessData
    
    var callNextWhen: WKRPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLAuthentication? { get }
    var systemsWorker: WKRPTCLSystems? { get }


    init()
    func register(nextWorker: WKRPTCLAuthentication,
                  for callNextWhen: WKRPTCLWorker.Call.NextWhen)

    // MARK: - Business Logic / Single Item CRUD
    func doCheckAuthentication(using parameters: [String: Any],
                               with progress: WKRPTCLProgressBlock?,
                               and block: WKRPTCLAuthenticationBlockBoolBoolAccessData?) throws
    func doSignIn(from username: String?,
                  and password: String?,
                  using parameters: [String: Any],
                  with progress: WKRPTCLProgressBlock?,
                  and block: WKRPTCLAuthenticationBlockBoolAccessData?) throws
    func doSignOut(using parameters: [String: Any],
                   with progress: WKRPTCLProgressBlock?,
                   and block: WKRPTCLAuthenticationBlockBool?) throws
    func doSignUp(from user: DAOUser?,
                  and password: String?,
                  using parameters: [String: Any],
                  with progress: WKRPTCLProgressBlock?,
                  and block: WKRPTCLAuthenticationBlockBoolAccessData?) throws
}
