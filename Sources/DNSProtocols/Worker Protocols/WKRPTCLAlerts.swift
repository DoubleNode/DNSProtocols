//
//  WKRPTCLAlerts.swift
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
    typealias Alerts = WKRPTCLAlertsError
}
public enum WKRPTCLAlertsError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

    public static let domain = "WKRALERTS"
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
            return String(format: NSLocalizedString("WKRALERTS-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRALERTS-Not Implemented%@", comment: ""),
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

public protocol WKRPTCLAlerts: WKRPTCLWorkerBase {
    var callNextWhen: WKRPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLAlerts? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLAlerts,
                  for callNextWhen: WKRPTCLWorker.Call.NextWhen)

    // MARK: - Business Logic / Single Item CRUD
    func doLoadAlerts(for center: DAOCenter,
                      with progress: WKRPTCLProgressBlock?) -> AnyPublisher<[DAOAlert], Error>
    func doLoadAlerts(for district: DAODistrict,
                      with progress: WKRPTCLProgressBlock?) -> AnyPublisher<[DAOAlert], Error>
    func doLoadAlerts(for region: DAORegion,
                      with progress: WKRPTCLProgressBlock?) -> AnyPublisher<[DAOAlert], Error>
    func doLoadAlerts(with progress: WKRPTCLProgressBlock?) -> AnyPublisher<[DAOAlert], Error>
}
