//
//  WKRPTCLGeo.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import DNSDataObjects
import DNSError
import Foundation

public extension DNSError {
    typealias Geo = WKRPTCLGeoError
}
public enum WKRPTCLGeoError: DNSError {
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

// Protocol Return Types
public typealias WKRPTCLGeoRtnString = String

// Protocol Result Types
public typealias WKRPTCLGeoResString = Result<WKRPTCLGeoRtnString, Error>

// Protocol Block Types
public typealias WKRPTCLGeoBlkString = (WKRPTCLGeoResString) -> Void

public protocol WKRPTCLGeo: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLGeo? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLGeo,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doLocate(with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLGeoBlkString?) throws
    func doStopTrackLocation(for processKey: String) throws
    func doTrackLocation(for processKey: String,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLGeoBlkString?) throws

    // MARK: - Worker Logic (Shortcuts) -
    func doLocate(with block: WKRPTCLGeoBlkString?) throws
    func doTrackLocation(for processKey: String,
                         with block: WKRPTCLGeoBlkString?) throws
}
