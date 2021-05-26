//
//  PTCLCache_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCoreThreading
import DNSError
import UIKit

public enum PTCLCacheError: Error
{
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case createError(error: Error, _ codeLocation: DNSCodeLocation)
    case deleteError(error: Error, _ codeLocation: DNSCodeLocation)
    case readError(error: Error, _ codeLocation: DNSCodeLocation)
    case writeError(error: Error, _ codeLocation: DNSCodeLocation)
}
extension PTCLCacheError: DNSError {
    public static let domain = "CACHE"
    public enum Code: Int
    {
        case unknown = 1001
        case notImplemented = 1002
        case createError = 1003
        case deleteError = 1004
        case readError = 1005
        case writeError = 1006
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
        case .unknown:
            return String(format: NSLocalizedString("CACHE-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("CACHE-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .createError(let error, _):
            return String(format: NSLocalizedString("CACHE-Object Create Error: %@%@", comment: ""),
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.createError.rawValue))")
        case .deleteError(let error, _):
            return String(format: NSLocalizedString("CACHE-Object Delete Error: %@%@", comment: ""),
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.deleteError.rawValue))")
        case .readError(let error, _):
            return String(format: NSLocalizedString("CACHE-Object Read Error: %@%@", comment: ""),
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.readError.rawValue))")
        case .writeError(let error, _):
            return String(format: NSLocalizedString("CACHE-Object Write Error: %@%@", comment: ""),
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.writeError.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation),
             .createError(_, let codeLocation),
             .deleteError(_, let codeLocation),
             .readError(_, let codeLocation),
             .writeError(_, let codeLocation):
            return codeLocation.failureReason
        }
    }
}

public protocol PTCLCache_Protocol: PTCLBase_Protocol
{
    var callNextWhen: PTCLCallNextWhen { get }
    var nextWorker: PTCLCache_Protocol? { get }

    init()
    func register(nextWorker: PTCLCache_Protocol,
                  for callNextWhen: PTCLCallNextWhen)

    // MARK: - Business Logic / Single Item CRUD
    func doDeleteObject(for id: String,
                        with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error>
    func doLoadImage(from url: NSURL,
                     for id: String,
                     with progress: PTCLProgressBlock?) -> AnyPublisher<UIImage, Error>
    func doReadObject(for id: String,
                      with progress: PTCLProgressBlock?) -> AnyPublisher<Any, Error>
    func doReadObject(for id: String,
                      with progress: PTCLProgressBlock?) -> AnyPublisher<String, Error>
    func doUpdate(object: Any,
                  for id: String,
                  with progress: PTCLProgressBlock?) -> AnyPublisher<Any, Error>
}
