//
//  WKRPTCLUserIdentity.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCoreThreading
import DNSError
import Foundation

public extension DNSError {
    typealias UserIdentity = WKRPTCLUserIdentityError
}
public enum WKRPTCLUserIdentityError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case unableToJoin(group: String, error: Error, _ codeLocation: DNSCodeLocation)
    case unableToLeave(group: String, error: Error, _ codeLocation: DNSCodeLocation)

    public static let domain = "WKRUSERID"
    public enum Code: Int {
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
            return String(format: NSLocalizedString("WKRUSERID-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRUSERID-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .unableToJoin(let group, let error, _):
            return String(format: NSLocalizedString("WKRUSERID-Unable to Join Group%@%@%@", comment: ""),
                          "\(group)",
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.unableToJoin.rawValue))")
        case .unableToLeave(let group, let error, _):
            return String(format: NSLocalizedString("WKRUSERID-Unable to Leave Group%@%@%@", comment: ""),
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

// Protocol Return Types
public typealias WKRPTCLUserIdentityRtnVoid = Void

// Protocol Publisher Types
public typealias WKRPTCLUserIdentityPubVoid = AnyPublisher<WKRPTCLUserIdentityRtnVoid, Error>

public protocol WKRPTCLUserIdentity: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLUserIdentity? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLUserIdentity,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doClearIdentity(with progress: DNSPTCLProgressBlock?) -> WKRPTCLUserIdentityPubVoid
    func doJoin(group: String,
                with progress: DNSPTCLProgressBlock?) -> WKRPTCLUserIdentityPubVoid
    func doLeave(group: String,
                 with progress: DNSPTCLProgressBlock?) -> WKRPTCLUserIdentityPubVoid
    func doSetIdentity(using data: [String: Any?],
                       with progress: DNSPTCLProgressBlock?) -> WKRPTCLUserIdentityPubVoid

    // MARK: - Worker Logic (Shortcuts) -
    func doClearIdentity() -> WKRPTCLUserIdentityPubVoid
    func doJoin(group: String) -> WKRPTCLUserIdentityPubVoid
    func doLeave(group: String) -> WKRPTCLUserIdentityPubVoid
    func doSetIdentity(using data: [String: Any?]) -> WKRPTCLUserIdentityPubVoid
}
