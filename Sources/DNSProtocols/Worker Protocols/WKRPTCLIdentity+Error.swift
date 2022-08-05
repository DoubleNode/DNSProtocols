//
//  WKRPTCLIdentity+Error.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError
import Foundation

public extension DNSError {
    typealias Identity = WKRPTCLIdentityError
}
public enum WKRPTCLIdentityError: DNSError {
    // Common Errors
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case notFound(field: String, value: String, _ codeLocation: DNSCodeLocation)
    case invalidParameters(parameters: [String], _ codeLocation: DNSCodeLocation)
    // Domain-Specific Errors
    case unableToJoin(group: String, error: Error, _ codeLocation: DNSCodeLocation)
    case unableToLeave(group: String, error: Error, _ codeLocation: DNSCodeLocation)

    public static let domain = "WKRIDENTITY"
    public enum Code: Int {
        // Common Errors
        case unknown = 1001
        case notImplemented = 1002
        case notFound = 1003
        case invalidParameters = 1004
        // Domain-Specific Errors
        case unableToJoin = 2001
        case unableToLeave = 2002
    }

    public var nsError: NSError! {
        switch self {
            // Common Errors
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
        case .notFound(let field, let value, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["field"] = field
            userInfo["value"] = value
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notFound.rawValue,
                                userInfo: userInfo)
        case .invalidParameters(let parameters, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            userInfo["Parameters"] = parameters
            return NSError.init(domain: Self.domain,
                                code: Self.Code.invalidParameters.rawValue,
                                userInfo: userInfo)
            // Domain-Specific Errors
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
            // Common Errors
        case .unknown:
            return String(format: NSLocalizedString("WKRIDENTITY-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRIDENTITY-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .notFound(let field, let value, _):
            return String(format: NSLocalizedString("WKRIDENTITY-Not Found(%@=\"%@\")%@", comment: ""),
                          "\(field)", "\(value)",
                          "(\(Self.domain):\(Self.Code.notFound.rawValue))")
        case .invalidParameters(let parameters, _):
            let parametersString = parameters.reduce("") { $0 + ($0.isEmpty ? "" : ", ") + $1 }
            return String(format: NSLocalizedString("WKRIDENTITY-Invalid Parameters(%@)%@", comment: ""),
                          "\(parametersString)",
                          " (\(Self.domain):\(Self.Code.invalidParameters.rawValue))")
            // Domain-Specific Errors
        case .unableToJoin(let group, let error, _):
            return String(format: NSLocalizedString("WKRIDENTITY-Unable to Join Group%@%@%@", comment: ""),
                          "\(group)",
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.unableToJoin.rawValue))")
        case .unableToLeave(let group, let error, _):
            return String(format: NSLocalizedString("WKRIDENTITY-Unable to Leave Group%@%@%@", comment: ""),
                          "\(group)",
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.unableToLeave.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
            // Common Errors
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation),
             .notFound(_, _, let codeLocation),
             .invalidParameters(_, let codeLocation),
            // Domain-Specific Errors
             .unableToJoin(_, _, let codeLocation),
             .unableToLeave(_, _, let codeLocation):
            return codeLocation.failureReason
        }
    }
}
