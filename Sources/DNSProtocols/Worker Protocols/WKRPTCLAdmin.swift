//
//  WKRPTCLAdmin.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCoreThreading
import DNSDataObjects
import DNSError
import Foundation

public extension DNSError {
    typealias Admin = WKRPTCLAdminError
}
public enum WKRPTCLAdminError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case unauthorized(accountId: String, _ codeLocation: DNSCodeLocation)

    public static let domain = "WKRADMIN"
    public enum Code: Int {
        case unknown = 1001
        case notImplemented = 1002
        case unauthorized = 1003
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
        case .unauthorized(let accountId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            userInfo["AccountId"] = accountId
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unauthorized.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return String(format: NSLocalizedString("WKRADMIN-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRADMIN-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .unauthorized(let accountId, _):
            return String(format: NSLocalizedString("WKRADMIN-Unauthorized%@%@", comment: ""),
                          "\(accountId)",
                          " (\(Self.domain):\(Self.Code.unauthorized.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation):
            return codeLocation.failureReason
        case .notImplemented(let codeLocation):
            return codeLocation.failureReason
        case .unauthorized(_, let codeLocation):
            return codeLocation.failureReason
        }
    }
}

// Protocol Return Types
public typealias WKRPTCLAdminRtnAString = [String]
public typealias WKRPTCLAdminRtnBool = Bool
public typealias WKRPTCLAdminRtnUserChangeRequest = (DAOUserChangeRequest?, [DAOUserChangeRequest])

// Protocol Publisher Types
public typealias WKRPTCLAdminPubAString = AnyPublisher<WKRPTCLAdminRtnAString, Error>
public typealias WKRPTCLAdminPubBool = AnyPublisher<WKRPTCLAdminRtnBool, Error>
public typealias WKRPTCLAdminPubUserChangeRequest = AnyPublisher<WKRPTCLAdminRtnUserChangeRequest, Error>

public protocol WKRPTCLAdmin: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLAdmin? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLAdmin,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doChange(_ user: DAOUser,
                  to role: DNSUserRole,
                  with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubBool
    func doCheckAdmin(with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubBool
    func doDenyChangeRequest(for user: DAOUser,
                             with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubBool
    func doLoadChangeRequests(with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubUserChangeRequest
    func doLoadTabs(with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubAString
    func doRequestChange(to role: DNSUserRole,
                         with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubBool

    // MARK: - Worker Logic (Shortcuts) -
    func doChange(_ user: DAOUser,
                  to role: DNSUserRole) -> WKRPTCLAdminPubBool
    func doCheckAdmin() -> WKRPTCLAdminPubBool
    func doDenyChangeRequest(for user: DAOUser) -> WKRPTCLAdminPubBool
    func doLoadChangeRequests() -> WKRPTCLAdminPubUserChangeRequest
    func doLoadTabs() -> WKRPTCLAdminPubAString
    func doRequestChange(to role: DNSUserRole) -> WKRPTCLAdminPubBool
}
