//
//  PTCLGeolocation_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import DNSDataObjects
import Foundation

public enum PTCLGeolocationError: Error
{
    case unknown(domain: String, file: String, line: String, method: String)
    case denied(domain: String, file: String, line: String, method: String)
    case failure(error: Error, domain: String, file: String, line: String, method: String)
}
extension PTCLGeolocationError: DNSError {
    public static let domain = "GEO"
    public enum Code: Int
    {
        case unknown = 1001
        case denied = 1002
        case failure = 1003
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
        case .denied(let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.failure.rawValue,
                                userInfo: userInfo)
        case .failure(let error, let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "Error:": error, "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.failure.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("GEO-Unknown Error", comment: "")
                + " (\(Self.domain):\(Self.Code.unknown.rawValue))"
        case .denied:
            return String(format: NSLocalizedString("GEO-Denied", comment: ""))
                + " (\(Self.domain):\(Self.Code.failure.rawValue))"
        case .failure(let error, _, _, _, _):
            return String(format: NSLocalizedString("GEO-Failure: %@", comment: ""), error.localizedDescription)
                + " (\(Self.domain):\(Self.Code.failure.rawValue))"
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        case .denied(let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        case .failure(_, let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        }
    }
}

// (geohash: String, error: Error?)
public typealias PTCLGeolocationBlockVoidStringDNSError = (String, DNSError?) -> Void

public protocol PTCLGeolocation_Protocol: PTCLBase_Protocol {
    var nextWorker: PTCLGeolocation_Protocol? { get }

    init()
    init(nextWorker: PTCLGeolocation_Protocol)

    // MARK: - Business Logic / Single Item CRUD

    func doLocate(with progress: PTCLProgressBlock?,
                  and block: PTCLGeolocationBlockVoidStringDNSError?) throws

    func doTrackLocation(for processKey: String,
                         with progress: PTCLProgressBlock?,
                         and block: PTCLGeolocationBlockVoidStringDNSError?) throws

    func doStopTrackLocation(for processKey: String) throws
}
