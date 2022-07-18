//
//  PTCLAdmin.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCoreThreading
import DNSDataObjects
import DNSError
import Foundation

public extension DNSError {
    typealias Admin = PTCLAdminError
}
public enum PTCLAdminError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case unauthorized(accountId: String, _ codeLocation: DNSCodeLocation)

    public static let domain = "ADMIN"
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
            return String(format: NSLocalizedString("ADMIN-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("ADMIN-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .unauthorized(let accountId, _):
            return String(format: NSLocalizedString("ADMIN-Unauthorized%@%@", comment: ""),
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

public protocol PTCLAdmin: PTCLProtocolBase {
    var callNextWhen: PTCLProtocol.Call.NextWhen { get }
    var nextWorker: PTCLAdmin? { get }
    var systemsWorker: PTCLSystems? { get }

    init()
    func register(nextWorker: PTCLAdmin,
                  for callNextWhen: PTCLProtocol.Call.NextWhen)

    // MARK: - Business Logic / Single Item CRUD
    func doChange(_ user: DAOUser,
                  to role: DNSUserRole,
                  with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error>
    func doCheckAdmin(with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error>
    func doDenyChangeRequest(for user: DAOUser,
                             with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error>
    func doLoadChangeRequests(with progress: PTCLProgressBlock?) ->
        AnyPublisher<(DAOUserChangeRequest?, [DAOUserChangeRequest]), Error>
    func doLoadTabs(with progress: PTCLProgressBlock?) -> AnyPublisher<[String], Error>
    func doRequestChange(to role: DNSUserRole,
                         with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error>
}
