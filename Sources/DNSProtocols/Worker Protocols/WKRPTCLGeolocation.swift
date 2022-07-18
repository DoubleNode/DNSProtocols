//
//  WKRPTCLGeolocation.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import DNSDataObjects
import DNSError
import Foundation

public extension DNSError {
    typealias Geolocation = WKRPTCLGeolocationError
}
public enum WKRPTCLGeolocationError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case denied(_ codeLocation: DNSCodeLocation)
    case failure(error: Error, _ codeLocation: DNSCodeLocation)

    public static let domain = "WKRGEO"
    public enum Code: Int {
        case unknown = 1001
        case notImplemented = 1002
        case denied = 1003
        case failure = 1004
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
            return String(format: NSLocalizedString("WKRGEO-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRGEO-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .denied:
            return String(format: NSLocalizedString("WKRGEO-Denied%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.denied.rawValue))")
        case .failure(let error, _):
            return String(format: NSLocalizedString("WKRGEO-Failure%@%@", comment: ""),
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.failure.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation),
             .denied(let codeLocation),
             .failure(_, let codeLocation):
            return codeLocation.failureReason
        }
    }
}

// Protocol Result Types
//
public typealias WKRPTCLGeolocationResultString = Result<String, Error>

// Protocol Block Types
//
public typealias WKRPTCLGeolocationBlockString = (WKRPTCLGeolocationResultString) -> Void

public protocol WKRPTCLGeolocation: WKRPTCLWorkerBase {
    var callNextWhen: WKRPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLGeolocation? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLGeolocation,
                  for callNextWhen: WKRPTCLWorker.Call.NextWhen)

    // MARK: - Business Logic / Single Item CRUD
    func doLocate(with progress: WKRPTCLProgressBlock?,
                  and block: WKRPTCLGeolocationBlockString?) throws
    func doStopTrackLocation(for processKey: String) throws
    func doTrackLocation(for processKey: String,
                         with progress: WKRPTCLProgressBlock?,
                         and block: WKRPTCLGeolocationBlockString?) throws
}
