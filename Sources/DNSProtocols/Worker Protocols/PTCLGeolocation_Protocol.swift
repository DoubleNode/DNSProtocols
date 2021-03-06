//
//  PTCLGeolocation_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import DNSDataObjects
import DNSError
import Foundation

public enum PTCLGeolocationError: Error
{
    case unknown(_ codeLocation: DNSCodeLocation)
    case denied(_ codeLocation: DNSCodeLocation)
    case failure(error: Error, _ codeLocation: DNSCodeLocation)
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
        case .unknown(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        case .denied(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.denied.rawValue,
                                userInfo: userInfo)
        case .failure(let error, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Error"] = error
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.failure.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return NSLocalizedString("GEO-Unknown Error", comment: "")
                + " (\(Self.domain):\(Self.Code.unknown.rawValue))"
        case .denied:
            return String(format: NSLocalizedString("GEO-Denied", comment: ""))
                + " (\(Self.domain):\(Self.Code.denied.rawValue))"
        case .failure(let error, _):
            return String(format: NSLocalizedString("GEO-Failure: %@", comment: ""), error.localizedDescription)
                + " (\(Self.domain):\(Self.Code.failure.rawValue))"
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .denied(let codeLocation),
             .failure(_, let codeLocation):
            return codeLocation.failureReason
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
    func doStopTrackLocation(for processKey: String) throws
    func doTrackLocation(for processKey: String,
                         with progress: PTCLProgressBlock?,
                         and block: PTCLGeolocationBlockVoidStringDNSError?) throws
}
