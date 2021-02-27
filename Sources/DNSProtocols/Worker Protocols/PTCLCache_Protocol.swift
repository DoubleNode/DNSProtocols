//
//  PTCLCache_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import DNSError
import Foundation

public enum PTCLCacheError: Error
{
    case unknown(_ codeLocation: DNSCodeLocation)
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
        case createError = 1002
        case deleteError = 1003
        case readError = 1004
        case writeError = 1005
    }
    
    public var nsError: NSError! {
        switch self {
        case .unknown(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
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
            return NSLocalizedString("CACHE-Unknown Error", comment: "")
                + " (\(Self.domain):\(Self.Code.unknown.rawValue))"
        case .createError(let error, _):
            return String(format: NSLocalizedString("CACHE-Object Create Error: %@", comment: ""), error.localizedDescription)
                + " (\(Self.domain):\(Self.Code.createError.rawValue))"
        case .deleteError(let error, _):
            return String(format: NSLocalizedString("CACHE-Object Delete Error: %@", comment: ""), error.localizedDescription)
                + " (\(Self.domain):\(Self.Code.deleteError.rawValue))"
        case .readError(let error, _):
            return String(format: NSLocalizedString("CACHE-Object Read Error: %@", comment: ""), error.localizedDescription)
                + " (\(Self.domain):\(Self.Code.readError.rawValue))"
        case .writeError(let error, _):
            return String(format: NSLocalizedString("CACHE-Object Write Error: %@", comment: ""), error.localizedDescription)
                + " (\(Self.domain):\(Self.Code.writeError.rawValue))"
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .createError(_, let codeLocation),
             .deleteError(_, let codeLocation),
             .readError(_, let codeLocation),
             .writeError(_, let codeLocation):
            return codeLocation.failureReason
        }
    }
}
// (error: Error?)
public typealias PTCLCacheBlockVoidDNSError = (DNSError?) -> Void
// (object: Any?, error: Error?)
public typealias PTCLCacheBlockVoidAnyDNSError = (Any?, DNSError?) -> Void
public typealias PTCLCacheBlockVoidStringDNSError = (String?, DNSError?) -> Void

public protocol PTCLCache_Protocol: PTCLBase_Protocol
{
    var nextWorker: PTCLCache_Protocol? { get }

    init()
    init(nextWorker: PTCLCache_Protocol)

    // MARK: - Business Logic / Single Item CRUD
    func doDeleteObject(for id: String,
                        with progress: PTCLProgressBlock?,
                        and block: PTCLCacheBlockVoidDNSError?) throws
    func doReadObject(for id: String,
                      with progress: PTCLProgressBlock?,
                      and block: PTCLCacheBlockVoidAnyDNSError?) throws
    func doReadObject(for id: String,
                      with progress: PTCLProgressBlock?,
                      and block: PTCLCacheBlockVoidStringDNSError?) throws
    func doLoadImage(from url: NSURL,
                     for id: String,
                     with progress: PTCLProgressBlock?,
                     and block: PTCLCacheBlockVoidAnyDNSError?) throws
    func doUpdate(object: Any,
                  for id: String,
                  with progress: PTCLProgressBlock?,
                  and block: PTCLCacheBlockVoidAnyDNSError?) throws
}
