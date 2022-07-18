//
//  WKRPTCLCms.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCoreThreading
import DNSError
import Foundation

public extension DNSError {
    typealias Cms = WKRPTCLCmsError
}
public enum WKRPTCLCmsError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

    public static let domain = "WKRCMS"
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
            return String(format: NSLocalizedString("WKRCMS-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRCMS-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation):
            return codeLocation.failureReason
        }
    }
}

// Protocol Result Types
public typealias WKRPTCLCmsResultArrayAny = Result<[Any], Error>
//

// Protocol Block Types
public typealias WKRPTCLCmsBlockArrayAny = (WKRPTCLCmsResultArrayAny) -> Void
//

public protocol WKRPTCLCms: WKRPTCLWorkerBase {
    var callNextWhen: WKRPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLCms? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLCms,
                  for callNextWhen: WKRPTCLWorker.Call.NextWhen)

    // MARK: - Business Logic / Single Item CRUD
    func doLoad(for group: String,
                with progress: WKRPTCLProgressBlock?,
                and block: WKRPTCLCmsBlockArrayAny?) throws
}