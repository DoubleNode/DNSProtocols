//
//  PTCLCache_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public enum PTCLCacheError: Error
{
    case unknown(domain: String, file: String, line: String, method: String)
    case createError(error: Error, domain: String, file: String, line: String, method: String)
    case deleteError(error: Error, domain: String, file: String, line: String, method: String)
    case readError(error: Error, domain: String, file: String, line: String, method: String)
    case writeError(error: Error, domain: String, file: String, line: String, method: String)
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
        case .unknown(let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        case .createError(let error, let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "Error": error, "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.createError.rawValue,
                                userInfo: userInfo)
        case .deleteError(let error, let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "Error": error, "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.deleteError.rawValue,
                                userInfo: userInfo)
        case .readError(let error, let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "Error": error, "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.readError.rawValue,
                                userInfo: userInfo)
        case .writeError(let error, let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "Error": error, "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.writeError.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("Unknown Error", comment: "")
                + " (\(Self.domain):\(Self.Code.unknown.rawValue))"
        case .createError(let error, _, _, _, _):
            return String(format: NSLocalizedString("Object Create Error: %@", comment: ""), error.localizedDescription)
                + " (\(Self.domain):\(Self.Code.createError.rawValue))"
        case .deleteError(let error, _, _, _, _):
            return String(format: NSLocalizedString("Object Delete Error: %@", comment: ""), error.localizedDescription)
                + " (\(Self.domain):\(Self.Code.deleteError.rawValue))"
        case .readError(let error, _, _, _, _):
            return String(format: NSLocalizedString("Object Read Error: %@", comment: ""), error.localizedDescription)
                + " (\(Self.domain):\(Self.Code.readError.rawValue))"
        case .writeError(let error, _, _, _, _):
            return String(format: NSLocalizedString("Object Write Error: %@", comment: ""), error.localizedDescription)
                + " (\(Self.domain):\(Self.Code.writeError.rawValue))"
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        case .createError(_, let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        case .deleteError(_, let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        case .readError(_, let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        case .writeError(_, let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
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
