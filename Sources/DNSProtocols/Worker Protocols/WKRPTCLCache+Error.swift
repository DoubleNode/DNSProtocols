//
//  WKRPTCLCache+Error.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError
import UIKit

public extension DNSError {
    typealias Cache = WKRPTCLCacheError
}
public enum WKRPTCLCacheError: DNSError {
    // Common Errors
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case notFound(field: String, value: String, _ codeLocation: DNSCodeLocation)
    case invalidParameters(parameters: [String], _ codeLocation: DNSCodeLocation)
    case lowerError(error: Error, _ codeLocation: DNSCodeLocation)
    // Domain-Specific Errors
    case createError(error: Error, _ codeLocation: DNSCodeLocation)
    case deleteError(error: Error, _ codeLocation: DNSCodeLocation)
    case readError(error: Error, _ codeLocation: DNSCodeLocation)
    case writeError(error: Error, _ codeLocation: DNSCodeLocation)

    public static let domain = "WKRCACHE"
    public enum Code: Int {
        // Common Errors
        case unknown = 1001
        case notImplemented = 1002
        case notFound = 1003
        case invalidParameters = 1004
        case lowerError = 1005
        // Domain-Specific Errors
        case createError = 2001
        case deleteError = 2002
        case readError = 2003
        case writeError = 2004
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
        case .lowerError(let error, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Error"] = error
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.lowerError.rawValue,
                                userInfo: userInfo)
            // Domain-Specific Errors
        case .createError(let error, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Error"] = error
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.createError.rawValue,
                                userInfo: userInfo)
        case .deleteError(let error, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Error"] = error
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.deleteError.rawValue,
                                userInfo: userInfo)
        case .readError(let error, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Error"] = error
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.readError.rawValue,
                                userInfo: userInfo)
        case .writeError(let error, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Error"] = error
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.writeError.rawValue,
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
            return String(format: NSLocalizedString("WKRCACHE-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRCACHE-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .notFound(let field, let value, _):
            return String(format: NSLocalizedString("WKRCACHE-Not Found%@%@%@", comment: ""),
                          "\(field)", "\(value)",
                          "(\(Self.domain):\(Self.Code.notFound.rawValue))")
        case .invalidParameters(let parameters, _):
            let parametersString = parameters.reduce("") { $0 + ($0.isEmpty ? "" : ", ") + $1 }
            return String(format: NSLocalizedString("WKRCACHE-Invalid Parameters%@%@", comment: ""),
                          "\(parametersString)",
                          " (\(Self.domain):\(Self.Code.invalidParameters.rawValue))")
        case .lowerError(let error, _):
            return String(format: NSLocalizedString("WKRCACHE-Lower Error%@%@", comment: ""),
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.lowerError.rawValue))")
            // Domain-Specific Errors
        case .createError(let error, _):
            return String(format: NSLocalizedString("WKRCACHE-Object Create Error%@%@", comment: ""),
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.createError.rawValue))")
        case .deleteError(let error, _):
            return String(format: NSLocalizedString("WKRCACHE-Object Delete Error%@%@", comment: ""),
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.deleteError.rawValue))")
        case .readError(let error, _):
            return String(format: NSLocalizedString("WKRCACHE-Object Read Error%@%@", comment: ""),
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.readError.rawValue))")
        case .writeError(let error, _):
            return String(format: NSLocalizedString("WKRCACHE-Object Write Error%@%@", comment: ""),
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.writeError.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
            // Common Errors
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation),
             .notFound(_, _, let codeLocation),
             .invalidParameters(_, let codeLocation),
             .lowerError(_, let codeLocation),
            // Domain-Specific Errors
             .createError(_, let codeLocation),
             .deleteError(_, let codeLocation),
             .readError(_, let codeLocation),
             .writeError(_, let codeLocation):
            return codeLocation.failureReason
        }
    }
}
