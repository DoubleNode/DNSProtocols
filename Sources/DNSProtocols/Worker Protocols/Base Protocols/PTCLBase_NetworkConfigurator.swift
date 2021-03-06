//
//  PTCLBase_NetworkConfigurator.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Alamofire
import DNSCoreThreading
import DNSError
import Foundation

public enum PTCLBaseNetworkError: Error
{
    case unknown(_ codeLocation: DNSCodeLocation)
    case dataError(_ codeLocation: DNSCodeLocation)
    case invalidUrl(_ codeLocation: DNSCodeLocation)
    case networkError(error: Error, _ codeLocation: DNSCodeLocation)
    case serverError(statusCode: Int, _ codeLocation: DNSCodeLocation)
}
extension PTCLBaseNetworkError: DNSError {
    public static let domain = "NETWORK"
    public enum Code: Int
    {
        case unknown = 1001
        case dataError = 1002
        case invalidUrl = 1003
        case networkError = 1004
        case serverError = 1005
    }

    public var nsError: NSError! {
        switch self {
        case .unknown(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
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
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return NSLocalizedString("NETWORK-Unknown Error", comment: "")
                + " (\(Self.domain):\(Self.Code.unknown.rawValue))"
        case .dataError:
            return NSLocalizedString("NETWORK-Data Error", comment: "")
                + " (\(Self.domain):\(Self.Code.dataError.rawValue))"
        case .invalidUrl:
            return NSLocalizedString("NETWORK-Invalid URL", comment: "")
                + " (\(Self.domain):\(Self.Code.invalidUrl.rawValue))"
        case .networkError(let error, _):
            return String(format: NSLocalizedString("NETWORK-Network Error: %@", comment: ""),
                          error.localizedDescription)
                + " (\(Self.domain):\(Self.Code.networkError.rawValue))"
        case .serverError(let statusCode, _):
            return String(format: NSLocalizedString("NETWORK-Server Error: %@", comment: ""), "\(statusCode)")
                + " (\(Self.domain):\(Self.Code.serverError.rawValue))"
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .dataError(let codeLocation),
             .invalidUrl(let codeLocation),
             .networkError(_, let codeLocation),
             .serverError(_, let codeLocation):
            return codeLocation.failureReason
        }
    }
}

public protocol PTCLBase_NetworkConfigurator: AnyObject
{
    func defaultHeaders() -> HTTPHeaders
}
