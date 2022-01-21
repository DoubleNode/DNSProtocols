//
//  PTCLUserIdentity_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCoreThreading
import DNSError
import Foundation

public extension DNSError {
    typealias UserIdentity = PTCLUserIdentityError
}
public enum PTCLUserIdentityError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case unableToJoin(group: String, error: Error, _ codeLocation: DNSCodeLocation)
    case unableToLeave(group: String, error: Error, _ codeLocation: DNSCodeLocation)

    public static let domain = "USERID"
    public enum Code: Int
    {
        case unknown = 1001
        case notImplemented = 1002
        case unableToJoin = 1003
        case unableToLeave = 1004
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
        case .unableToJoin(let group, let error, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Group"] = group
            userInfo["Error"] = error
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unableToJoin.rawValue,
                                userInfo: userInfo)
        case .unableToLeave(let group, let error, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            userInfo["Group"] = group
            userInfo["Error"] = error
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unableToLeave.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return String(format: NSLocalizedString("USERID-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("USERID-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .unableToJoin(let group, let error, _):
            return String(format: NSLocalizedString("USERID-Unable to Join Group%@%@%@", comment: ""),
                          "\(group)",
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.unableToJoin.rawValue))")
        case .unableToLeave(let group, let error, _):
            return String(format: NSLocalizedString("USERID-Unable to Leave Group%@%@%@", comment: ""),
                          "\(group)",
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.unableToLeave.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation),
             .unableToJoin(_, _, let codeLocation),
             .unableToLeave(_, _, let codeLocation):
            return codeLocation.failureReason
        }
    }
}

public protocol PTCLUserIdentity: PTCLProtocolBase {
    var callNextWhen: PTCLProtocol.Call.NextWhen { get }
    var nextWorker: PTCLUserIdentity? { get }
    var systemsStateWorker: PTCLSystemsState? { get }

    init()
    func register(nextWorker: PTCLUserIdentity,
                  for callNextWhen: PTCLProtocol.Call.NextWhen)

    // MARK: - Business Logic / Single Item CRUD

    func doClearIdentity(with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error>
    func doJoin(group: String,
                with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error>
    func doLeave(group: String,
                 with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error>
    func doSetIdentity(using data: [String: Any?],
                       with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error>
}
