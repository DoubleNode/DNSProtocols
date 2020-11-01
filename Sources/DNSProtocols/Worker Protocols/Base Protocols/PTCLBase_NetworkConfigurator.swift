//
//  PTCLBase_NetworkConfigurator.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Alamofire
import DNSCore
import Foundation

public enum PTCLBaseNetworkError: Error
{
    case unknown(domain: String, file: String, line: String, method: String)
    case dataError(domain: String, file: String, line: String, method: String)
    case invalidUrl(domain: String, file: String, line: String, method: String)
    case networkError(error: Error, domain: String, file: String, line: String, method: String)
    case serverError(statusCode: Int, domain: String, file: String, line: String, method: String)
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
        case .unknown(let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        case .dataError(let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.dataError.rawValue,
                                userInfo: userInfo)
        case .invalidUrl(let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.invalidUrl.rawValue,
                                userInfo: userInfo)
        case .networkError(let error, let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "Error": error, "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.networkError.rawValue,
                                userInfo: userInfo)
        case .serverError(let statusCode, let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "StatusCode": statusCode, "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.serverError.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("Unknown Error", comment: "")
                + " (\(Self.domain):\(Self.Code.unknown.rawValue))"
        case .dataError:
            return NSLocalizedString("Data Error", comment: "")
                + " (\(Self.domain):\(Self.Code.dataError.rawValue))"
        case .invalidUrl:
            return NSLocalizedString("Invalid URL", comment: "")
                + " (\(Self.domain):\(Self.Code.invalidUrl.rawValue))"
        case .networkError(let error, _, _, _, _):
            return String(format: NSLocalizedString("Network Error: %@", comment: ""), error.localizedDescription)
                + " (\(Self.domain):\(Self.Code.networkError.rawValue))"
        case .serverError(let statusCode, _, _, _, _):
            return String(format: NSLocalizedString("Server Error: %@", comment: ""), "\(statusCode)")
                + " (\(Self.domain):\(Self.Code.serverError.rawValue))"
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let domain, let file, let line, let method),
             .dataError(let domain, let file, let line, let method),
             .invalidUrl(let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        case .networkError(_, let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        case .serverError(_, let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        }
    }
}

public protocol PTCLBase_NetworkConfigurator: class
{
    func defaultHeaders() -> HTTPHeaders
}
