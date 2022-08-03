//
//  WKRPTCLWorkerBase+Error.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError
import Foundation

public extension DNSError {
    typealias WorkerBase = WKRPTCLWorkerBaseError
}
public enum WKRPTCLWorkerBaseError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case invalidParameter(parameter: String, _ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case systemError(error: Error, _ codeLocation: DNSCodeLocation)
    
    public static let domain = "WKRBASE"
    public enum Code: Int {
        case unknown = 1001
        case invalidParameter = 1002
        case notImplemented = 1003
        case systemError = 1004
    }
    
    public var nsError: NSError! {
        switch self {
        case .unknown(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        case .invalidParameter(let parameter, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Parameter"] = parameter
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.invalidParameter.rawValue,
                                userInfo: userInfo)
        case .notImplemented(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notImplemented.rawValue,
                                userInfo: userInfo)
        case .systemError(let error, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Error"] = error
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.systemError.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return String(format: NSLocalizedString("WKRBASE-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .invalidParameter(let parameter, _):
            return String(format: NSLocalizedString("WKRBASE-Invalid Parameter%@%@", comment: ""),
                          "\(parameter)",
                          " (\(Self.domain):\(Self.Code.invalidParameter.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRBASE-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .systemError(let error, _):
            return String(format: NSLocalizedString("WKRBASE-System Error%@%@", comment: ""),
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.systemError.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
            .notImplemented(let codeLocation),
            .systemError(_, let codeLocation),
            .invalidParameter(_, let codeLocation):
            return codeLocation.failureReason
        }
    }
}