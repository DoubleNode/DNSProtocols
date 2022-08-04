//
//  NETPTCLNetworkBase+Error.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError
import Foundation

public extension DNSError {
    typealias NetworkBase = NETPTCLNetworkBaseError
}
public enum NETPTCLNetworkBaseError: DNSError {
    // Common Errors
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case notFound(field: String, value: String, _ codeLocation: DNSCodeLocation)
    case invalidParameters(parameters: [String], _ codeLocation: DNSCodeLocation)
    // Domain-Specific Errors
    case noConnection(_ codeLocation: DNSCodeLocation)
    case dataError(_ codeLocation: DNSCodeLocation)
    case invalidUrl(_ codeLocation: DNSCodeLocation)
    case networkError(error: Error, _ codeLocation: DNSCodeLocation)
    case serverError(statusCode: Int, _ codeLocation: DNSCodeLocation)
    case unauthorized(_ codeLocation: DNSCodeLocation)
    case forbidden(_ codeLocation: DNSCodeLocation)
    case upgradeClient(message: String, _ codeLocation: DNSCodeLocation)
    case adminRequired(_ codeLocation: DNSCodeLocation)

    public static let domain = "NETBASE"
    public enum Code: Int {
        // Common Errors
        case unknown = 1001
        case notImplemented = 1002
        case notFound = 1003
        case invalidParameters = 1004
        // Domain-Specific Errors
        case noConnection = 2001
        case dataError = 2002
        case invalidUrl = 2003
        case networkError = 2004
        case serverError = 2005
        case unauthorized = 2006
        case forbidden = 2007
        case upgradeClient = 2008
        case adminRequired = 2009
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
        case .noConnection(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.noConnection.rawValue,
                                userInfo: userInfo)
        case .dataError(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.dataError.rawValue,
                                userInfo: userInfo)
        case .invalidUrl(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.invalidUrl.rawValue,
                                userInfo: userInfo)
        case .networkError(let error, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Error"] = error
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.networkError.rawValue,
                                userInfo: userInfo)
        case .serverError(let statusCode, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["StatusCode"] = statusCode
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.serverError.rawValue,
                                userInfo: userInfo)
        case .unauthorized(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unauthorized.rawValue,
                                userInfo: userInfo)
        case .forbidden(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.forbidden.rawValue,
                                userInfo: userInfo)
        case .upgradeClient(let message, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Message"] = message
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.upgradeClient.rawValue,
                                userInfo: userInfo)
        case .adminRequired(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.adminRequired.rawValue,
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
            return String(format: NSLocalizedString("NETBASE-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("NETBASE-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .notFound(let field, let value, _):
            return String(format: NSLocalizedString("NETBASE-Not Found(%@=\"%@\")%@", comment: ""),
                          "\(field)", "\(value)",
                          "(\(Self.domain):\(Self.Code.notFound.rawValue))")
        case .invalidParameters(let parameters, _):
            let parametersString = parameters.reduce("") { $0 + ($0.isEmpty ? "" : ", ") + $1 }
            return String(format: NSLocalizedString("NETBASE-Invalid Parameters(%@)%@", comment: ""),
                          "\(parametersString)",
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
            // Domain-Specific Errors
        case .noConnection:
            return String(format: NSLocalizedString("NETBASE-No Connection%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.noConnection.rawValue))")
        case .dataError:
            return String(format: NSLocalizedString("NETBASE-Data Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.dataError.rawValue))")
        case .invalidUrl:
            return String(format: NSLocalizedString("NETBASE-Invalid URL%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.invalidUrl.rawValue))")
        case .networkError(let error, _):
            return String(format: NSLocalizedString("NETBASE-Network Error%@%@", comment: ""),
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.networkError.rawValue))")
        case .serverError(let statusCode, _):
            return String(format: NSLocalizedString("NETBASE-Server Error%@%@", comment: ""),
                          "\(statusCode)",
                          " (\(Self.domain):\(Self.Code.serverError.rawValue))")
        case .unauthorized:
            return String(format: NSLocalizedString("NETBASE-Unauthorized%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unauthorized.rawValue))")
        case .forbidden:
            return String(format: NSLocalizedString("NETBASE-Forbidden%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.forbidden.rawValue))")
        case .upgradeClient(let message, _):
            return String(format: NSLocalizedString("NETBASE-UpgradeClient%@%@", comment: ""),
                          message,
                          " (\(Self.domain):\(Self.Code.upgradeClient.rawValue))")
        case .adminRequired:
            return String(format: NSLocalizedString("NETBASE-AdminRequired%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.adminRequired.rawValue))")
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
             .noConnection(let codeLocation),
             .dataError(let codeLocation),
             .invalidUrl(let codeLocation),
             .networkError(_, let codeLocation),
             .serverError(_, let codeLocation),
             .unauthorized(let codeLocation),
             .forbidden(let codeLocation),
             .upgradeClient(_, let codeLocation),
             .adminRequired(let codeLocation):
            return codeLocation.failureReason
        }
    }
}
