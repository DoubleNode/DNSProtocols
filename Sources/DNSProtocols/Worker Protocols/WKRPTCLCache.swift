//
//  WKRPTCLCache.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCoreThreading
import DNSError
import UIKit

public extension DNSError {
    typealias Cache = WKRPTCLCacheError
}
public enum WKRPTCLCacheError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case createError(error: Error, _ codeLocation: DNSCodeLocation)
    case deleteError(error: Error, _ codeLocation: DNSCodeLocation)
    case readError(error: Error, _ codeLocation: DNSCodeLocation)
    case writeError(error: Error, _ codeLocation: DNSCodeLocation)

    public static let domain = "WKRCACHE"
    public enum Code: Int {
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
            return String(format: NSLocalizedString("WKRCACHE-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRCACHE-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
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

// Protocol Return Types
public typealias WKRPTCLCacheRtnAny = Any
public typealias WKRPTCLCacheRtnImage = UIImage
public typealias WKRPTCLCacheRtnString = String
public typealias WKRPTCLCacheRtnVoid = Void

// Protocol Publisher Types
public typealias WKRPTCLCachePubAny = AnyPublisher<WKRPTCLCacheRtnAny, Error>
public typealias WKRPTCLCachePubImage = AnyPublisher<WKRPTCLCacheRtnImage, Error>
public typealias WKRPTCLCachePubString = AnyPublisher<WKRPTCLCacheRtnString, Error>
public typealias WKRPTCLCachePubVoid = AnyPublisher<WKRPTCLCacheRtnVoid, Error>

// Protocol Future Types
public typealias WKRPTCLCacheFutAny = Future<WKRPTCLCacheRtnAny, Error>
public typealias WKRPTCLCacheFutImage = Future<WKRPTCLCacheRtnImage, Error>
public typealias WKRPTCLCacheFutString = Future<WKRPTCLCacheRtnString, Error>
public typealias WKRPTCLCacheFutVoid = Future<WKRPTCLCacheRtnVoid, Error>

public protocol WKRPTCLCache: WKRPTCLWorkerBase
{
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLCache? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLCache,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doDeleteObject(for id: String,
                        with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubVoid
    func doLoadImage(from url: NSURL,
                     for id: String,
                     with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubImage
    func doReadObject(for id: String,
                      with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubAny
    func doReadObject(for id: String,
                      with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubString
    func doUpdate(object: Any,
                  for id: String,
                  with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubAny

    // MARK: - Worker Logic (Shortcuts) -
    func doDeleteObject(for id: String) -> WKRPTCLCachePubVoid
    func doLoadImage(from url: NSURL,
                     for id: String) -> WKRPTCLCachePubImage
    func doReadObject(for id: String) -> WKRPTCLCachePubAny
    func doReadObject(for id: String) -> WKRPTCLCachePubString
    func doUpdate(object: Any,
                  for id: String) -> WKRPTCLCachePubAny
}
