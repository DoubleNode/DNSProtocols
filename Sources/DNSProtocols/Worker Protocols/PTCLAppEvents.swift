//
//  PTCLAppEvents.swift
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
    typealias AppEvents = PTCLAppEventsError
}
public enum PTCLAppEventsError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

    public static let domain = "APPEVENTS"
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
            return String(format: NSLocalizedString("APPEVENTS-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("APPEVENTS-Not Implemented%@", comment: ""),
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

public typealias PTCLAppEventsResultArrayAppEvent = Result<[DAOAppEvent], Error>

public typealias PTCLAppEventsBlockVoidArrayAppEvent = (PTCLAppEventsResultArrayAppEvent) -> Void

public protocol PTCLAppEvents: PTCLProtocolBase {
    var callNextWhen: PTCLProtocol.Call.NextWhen { get }
    var nextWorker: PTCLAppEvents? { get }
    var systemsWorker: PTCLSystems? { get }

    init()
    func register(nextWorker: PTCLAppEvents,
                  for callNextWhen: PTCLProtocol.Call.NextWhen)

    // MARK: - Business Logic / Single Item CRUD
    func doLoadAppEvents(with progress: PTCLProgressBlock?,
                         and block: PTCLAppEventsBlockVoidArrayAppEvent?) throws
}
