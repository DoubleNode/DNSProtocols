//
//  WKRPTCLAlerts.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLAlertsRtnAAlert = [DAOAlert]

// Protocol Publisher Types
public typealias WKRPTCLAlertsPubAAlert = AnyPublisher<WKRPTCLAlertsRtnAAlert, Error>

// Protocol Future Types
public typealias WKRPTCLAlertsFutAAlert = Future<WKRPTCLAlertsRtnAAlert, Error>

public protocol WKRPTCLAlerts: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var wkrSystems: WKRPTCLSystems? { get }
    
    init()
    func register(nextWorker: WKRPTCLAlerts,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)
    
    // MARK: - Worker Logic (Public) -
    func doLoadAlerts(for place: DAOPlace,
                      with progress: DNSPTCLProgressBlock?) -> WKRPTCLAlertsPubAAlert
    func doLoadAlerts(for section: DAOSection,
                      with progress: DNSPTCLProgressBlock?) -> WKRPTCLAlertsPubAAlert
    func doLoadAlerts(with progress: DNSPTCLProgressBlock?) -> WKRPTCLAlertsPubAAlert
    
    // MARK: - Worker Logic (Shortcuts) -
    func doLoadAlerts(for place: DAOPlace) -> WKRPTCLAlertsPubAAlert
    func doLoadAlerts(for section: DAOSection) -> WKRPTCLAlertsPubAAlert
    func doLoadAlerts() -> WKRPTCLAlertsPubAAlert
}
