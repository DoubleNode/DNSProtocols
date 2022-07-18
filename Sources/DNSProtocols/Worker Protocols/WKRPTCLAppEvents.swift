//
//  WKRPTCLAppEvents.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCoreThreading
import DNSDataObjects
import DNSError
import Foundation

public extension DNSError {
    typealias AppEvents = WKRPTCLAppEventsError
}
public enum WKRPTCLAppEventsError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

    public static let domain = "WKRAPPEVENTS"
    public enum Code: Int {
        case unknown = 1001
        case notImplemented = 1002
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
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return String(format: NSLocalizedString("WKRAPPEVENTS-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRAPPEVENTS-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation):
            return codeLocation.failureReason
        case .notImplemented(let codeLocation):
            return codeLocation.failureReason
        }
    }
}

// Protocol Result Types
public typealias WKRPTCLAppEventsResultArrayAppEvent = Result<[DAOAppEvent], Error>
//

// Protocol Block Types
public typealias WKRPTCLAppEventsBlockArrayAppEvent = (WKRPTCLAppEventsResultArrayAppEvent) -> Void
//

public protocol WKRPTCLAppEvents: WKRPTCLWorkerBase {
    var callNextWhen: WKRPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLAppEvents? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLAppEvents,
                  for callNextWhen: WKRPTCLWorker.Call.NextWhen)

    // MARK: - Business Logic / Single Item CRUD
    func doLoadAppEvents(with progress: WKRPTCLProgressBlock?,
                         and block: WKRPTCLAppEventsBlockArrayAppEvent?) throws
}
