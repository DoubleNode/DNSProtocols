//
//  SYSPTCLSystemBase+Error.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError
import Foundation

public extension DNSError {
    typealias SystemBase = SYSPTCLSystemBaseError
}
public enum SYSPTCLSystemBaseError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case duplicateKey(_ codeLocation: DNSCodeLocation)
    case noPermission(permission: String, _ codeLocation: DNSCodeLocation)
    case notFound(_ codeLocation: DNSCodeLocation)
    case notSupported(_ codeLocation: DNSCodeLocation)
    case systemError(error: Error, _ codeLocation: DNSCodeLocation)
    case timeout(_ codeLocation: DNSCodeLocation)

    public static let domain = "SYSBASE"
    public enum Code: Int {
        case unknown = 1001
        case notImplemented = 1002
        case duplicateKey = 1003
        case noPermission = 1004
        case notFound = 1005
        case notSupported = 1006
        case systemError = 1007
        case timeout = 1008
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
        case .duplicateKey(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.duplicateKey.rawValue,
                                userInfo: userInfo)
        case .noPermission(let permission, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            userInfo["Permission"] = permission
            return NSError.init(domain: Self.domain,
                                code: Self.Code.noPermission.rawValue,
                                userInfo: userInfo)
        case .notFound(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notFound.rawValue,
                                userInfo: userInfo)
        case .notSupported(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notSupported.rawValue,
                                userInfo: userInfo)
        case .systemError(let error, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            userInfo["Error"] = error
            return NSError.init(domain: Self.domain,
                                code: Self.Code.systemError.rawValue,
                                userInfo: userInfo)
        case .timeout(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.timeout.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return String(format: NSLocalizedString("SYSBASE-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("SYSBASE-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .duplicateKey:
            return String(format: NSLocalizedString("SYSBASE-Duplicate Key%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.duplicateKey.rawValue))")
        case .noPermission(let permission, _):
            return String(format: NSLocalizedString("SYSBASE-No Permission%@%@", comment: ""),
                          "\(permission as CVarArg)",
                          " (\(Self.domain):\(Self.Code.noPermission.rawValue))")
        case .notFound:
            return String(format: NSLocalizedString("SYSBASE-Not Found%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notFound.rawValue))")
        case .notSupported:
            return String(format: NSLocalizedString("SYSBASE-Not Supported%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notSupported.rawValue))")
        case .systemError(let error, _):
            return String(format: NSLocalizedString("SYSBASE-System Error%@%@", comment: ""),
                          "\(error as CVarArg)",
                          " (\(Self.domain):\(Self.Code.systemError.rawValue))")
        case .timeout:
            return String(format: NSLocalizedString("SYSBASE-Timeout%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.timeout.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation),
             .duplicateKey(let codeLocation),
             .noPermission(_, let codeLocation),
             .notFound(let codeLocation),
             .notSupported(let codeLocation),
             .systemError(_, let codeLocation),
             .timeout(let codeLocation):
            return codeLocation.failureReason
        }
    }
}
