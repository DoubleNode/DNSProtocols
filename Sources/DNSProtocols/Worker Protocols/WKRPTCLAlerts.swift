//
//  WKRPTCLAlerts.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
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

// Protocol Return Types
public typealias WKRPTCLAlertsRtnAAlert = [DAOAlert]

// Protocol Publisher Types
public typealias WKRPTCLAlertsPubAAlert = AnyPublisher<WKRPTCLAlertsRtnAAlert, Error>

public protocol WKRPTCLAlerts: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLAlerts? { get }
    var systemsWorker: WKRPTCLSystems? { get }
    
    init()
    func register(nextWorker: WKRPTCLAlerts,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)
    
    // MARK: - Worker Logic (Public) -
    func doLoadAlerts(for place: DAOPlace,
                      with progress: DNSPTCLProgressBlock?) -> WKRPTCLAlertsPubAAlert
    func doLoadAlerts(for district: DAODistrict,
                      with progress: DNSPTCLProgressBlock?) -> WKRPTCLAlertsPubAAlert
    func doLoadAlerts(for region: DAORegion,
                      with progress: DNSPTCLProgressBlock?) -> WKRPTCLAlertsPubAAlert
    func doLoadAlerts(with progress: DNSPTCLProgressBlock?) -> WKRPTCLAlertsPubAAlert
    
    // MARK: - Worker Logic (Shortcuts) -
    func doLoadAlerts(for place: DAOPlace) -> WKRPTCLAlertsPubAAlert
    func doLoadAlerts(for district: DAODistrict) -> WKRPTCLAlertsPubAAlert
    func doLoadAlerts(for region: DAORegion) -> WKRPTCLAlertsPubAAlert
    func doLoadAlerts() -> WKRPTCLAlertsPubAAlert
}
