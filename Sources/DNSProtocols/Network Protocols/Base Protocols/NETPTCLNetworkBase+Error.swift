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
    case unknown(transactionId: String, _ codeLocation: DNSCodeLocation)
    case notImplemented(transactionId: String, _ codeLocation: DNSCodeLocation)
    case notFound(field: String, value: String, transactionId: String, _ codeLocation: DNSCodeLocation)
    case invalidParameters(parameters: [String], transactionId: String, _ codeLocation: DNSCodeLocation)
    case lowerError(error: Error, transactionId: String, _ codeLocation: DNSCodeLocation)
    // Domain-Specific Errors
    case noConnection(transactionId: String, _ codeLocation: DNSCodeLocation)
    case dataError(transactionId: String, _ codeLocation: DNSCodeLocation)
    case invalidUrl(transactionId: String, _ codeLocation: DNSCodeLocation)
    case networkError(error: Error, transactionId: String, _ codeLocation: DNSCodeLocation)
    case serverError(statusCode: Int, status: String = "", transactionId: String, _ codeLocation: DNSCodeLocation)
    case unauthorized(transactionId: String, _ codeLocation: DNSCodeLocation)
    case forbidden(transactionId: String, _ codeLocation: DNSCodeLocation)
    case upgradeClient(message: String, transactionId: String, _ codeLocation: DNSCodeLocation)
    case adminRequired(transactionId: String, _ codeLocation: DNSCodeLocation)
    case insufficientAccess(transactionId: String, _ codeLocation: DNSCodeLocation)
    case expiredAccessToken(transactionId: String, _ codeLocation: DNSCodeLocation)
    case alreadyLinked(transactionId: String, _ codeLocation: DNSCodeLocation)
    case missingData(transactionId: String, _ codeLocation: DNSCodeLocation)

    public static let domain = "NETBASE"
    public enum Code: Int {
        // Common Errors
        case unknown = 1001
        case notImplemented = 1002
        case notFound = 1003
        case invalidParameters = 1004
        case lowerError = 1005
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
        case insufficientAccess = 2010
        case expiredAccessToken = 2011
        case alreadyLinked = 2012
        case missingData = 2013
    }

    public var nsError: NSError! {
        switch self {
            // Common Errors
        case .unknown(let transactionId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        case .notImplemented(let transactionId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notImplemented.rawValue,
                                userInfo: userInfo)
        case .notFound(let field, let value, let transactionId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["field"] = field
            userInfo["value"] = value
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notFound.rawValue,
                                userInfo: userInfo)
        case .invalidParameters(let parameters, let transactionId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            userInfo["Parameters"] = parameters
            return NSError.init(domain: Self.domain,
                                code: Self.Code.invalidParameters.rawValue,
                                userInfo: userInfo)
        case .lowerError(let error, let transactionId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Error"] = error
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.lowerError.rawValue,
                                userInfo: userInfo)
            // Domain-Specific Errors
        case .noConnection(let transactionId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.noConnection.rawValue,
                                userInfo: userInfo)
        case .dataError(let transactionId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.dataError.rawValue,
                                userInfo: userInfo)
        case .invalidUrl(let transactionId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.invalidUrl.rawValue,
                                userInfo: userInfo)
        case .networkError(let error, let transactionId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Error"] = error
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.networkError.rawValue,
                                userInfo: userInfo)
        case .serverError(let statusCode, let status, let transactionId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["StatusCode"] = statusCode
            userInfo["Status"] = status
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.serverError.rawValue,
                                userInfo: userInfo)
        case .unauthorized(let transactionId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unauthorized.rawValue,
                                userInfo: userInfo)
        case .forbidden(let transactionId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.forbidden.rawValue,
                                userInfo: userInfo)
        case .upgradeClient(let message, let transactionId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Message"] = message
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.upgradeClient.rawValue,
                                userInfo: userInfo)
        case .adminRequired(let transactionId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.adminRequired.rawValue,
                                userInfo: userInfo)
        case .insufficientAccess(let transactionId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.insufficientAccess.rawValue,
                                userInfo: userInfo)
        case .expiredAccessToken(let transactionId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.expiredAccessToken.rawValue,
                                userInfo: userInfo)
        case .alreadyLinked(let transactionId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.alreadyLinked.rawValue,
                                userInfo: userInfo)
        case .missingData(let transactionId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.missingData.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
            // Common Errors
        case .unknown(let transactionId, _):
            return String(format: NSLocalizedString("NETBASE-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented(let transactionId, _):
            return String(format: NSLocalizedString("NETBASE-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .notFound(let field, let value, let transactionId, _):
            return String(format: NSLocalizedString("NETBASE-Not Found%@%@%@", comment: ""),
                          "\(field)", "\(value)",
                          "(\(Self.domain):\(Self.Code.notFound.rawValue))")
        case .invalidParameters(let parameters, let transactionId, _):
            let parametersString = parameters.reduce("") { $0 + ($0.isEmpty ? "" : ", ") + $1 }
            return String(format: NSLocalizedString("NETBASE-Invalid Parameters%@%@", comment: ""),
                          "\(parametersString)",
                          " (\(Self.domain):\(Self.Code.invalidParameters.rawValue))")
        case .lowerError(let error, let transactionId, _):
            return String(format: NSLocalizedString("NETBASE-Lower Error%@%@", comment: ""),
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.lowerError.rawValue))")
            // Domain-Specific Errors
        case .noConnection(let transactionId, _):
            return String(format: NSLocalizedString("NETBASE-No Connection%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.noConnection.rawValue))")
        case .dataError(let transactionId, _):
            return String(format: NSLocalizedString("NETBASE-Data Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.dataError.rawValue))")
        case .invalidUrl(let transactionId, _):
            return String(format: NSLocalizedString("NETBASE-Invalid URL%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.invalidUrl.rawValue))")
        case .networkError(let error, let transactionId, _):
            return String(format: NSLocalizedString("NETBASE-Network Error%@%@", comment: ""),
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.networkError.rawValue))")
        case .serverError(let statusCode, let status, let transactionId, _):
            return String(format: NSLocalizedString("NETBASE-Server Error%@%@", comment: ""),
                          "\(statusCode)", "\(status)",
                          " (\(Self.domain):\(Self.Code.serverError.rawValue))")
        case .unauthorized(let transactionId, _):
            return String(format: NSLocalizedString("NETBASE-Unauthorized%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unauthorized.rawValue))")
        case .forbidden(let transactionId, _):
            return String(format: NSLocalizedString("NETBASE-Forbidden%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.forbidden.rawValue))")
        case .upgradeClient(let message, let transactionId, _):
            return String(format: NSLocalizedString("NETBASE-UpgradeClient%@%@", comment: ""),
                          message,
                          " (\(Self.domain):\(Self.Code.upgradeClient.rawValue))")
        case .adminRequired(let transactionId, _):
            return String(format: NSLocalizedString("NETBASE-AdminRequired%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.adminRequired.rawValue))")
        case .insufficientAccess(let transactionId, _):
            return String(format: NSLocalizedString("NETBASE-InsufficientAccess%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.insufficientAccess.rawValue))")
        case .expiredAccessToken(let transactionId, _):
            return String(format: NSLocalizedString("NETBASE-ExpiredAccessToken%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.expiredAccessToken.rawValue))")
        case .alreadyLinked(let transactionId, _):
            return String(format: NSLocalizedString("NETBASE-AlreadyLinked%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.alreadyLinked.rawValue))")
        case .missingData(let transactionId, _):
            return String(format: NSLocalizedString("NETBASE-MissingData%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.missingData.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
            // Common Errors
        case .unknown(let transactionId, let codeLocation),
             .notImplemented(let transactionId, let codeLocation),
             .notFound(_, _, let transactionId, let codeLocation),
             .invalidParameters(_, let transactionId, let codeLocation),
             .lowerError(_, let transactionId, let codeLocation),
            // Domain-Specific Errors
             .noConnection(let transactionId, let codeLocation),
             .dataError(let transactionId, let codeLocation),
             .invalidUrl(let transactionId, let codeLocation),
             .networkError(_, let transactionId, let codeLocation),
             .serverError(_, _, let transactionId, let codeLocation),
             .unauthorized(let transactionId, let codeLocation),
             .forbidden(let transactionId, let codeLocation),
             .upgradeClient(_, let transactionId, let codeLocation),
             .adminRequired(let transactionId, let codeLocation),
             .insufficientAccess(let transactionId, let codeLocation),
             .expiredAccessToken(let transactionId, let codeLocation),
             .alreadyLinked(let transactionId, let codeLocation),
             .missingData(let transactionId, let codeLocation):
            return "[id:\(transactionId)] \(codeLocation.failureReason)"
        }
    }
}
