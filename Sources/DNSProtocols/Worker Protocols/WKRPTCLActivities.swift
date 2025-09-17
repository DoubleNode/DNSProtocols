//
//  WKRPTCLActivities.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLActivitiesRtnActivity = DAOActivity
public typealias WKRPTCLActivitiesRtnAActivity = [DAOActivity]
public typealias WKRPTCLActivitiesRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLActivitiesResActivity = Result<WKRPTCLActivitiesRtnActivity, Error>
public typealias WKRPTCLActivitiesResAActivity = Result<WKRPTCLActivitiesRtnAActivity, Error>
public typealias WKRPTCLActivitiesResVoid = Result<WKRPTCLActivitiesRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLActivitiesBlkActivity = (WKRPTCLActivitiesResActivity) -> Void
public typealias WKRPTCLActivitiesBlkAActivity = (WKRPTCLActivitiesResAActivity) -> Void
public typealias WKRPTCLActivitiesBlkVoid = (WKRPTCLActivitiesResVoid) -> Void

public protocol WKRPTCLActivities: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var wkrSystems: WKRPTCLSystems? { get }
    
    init()
    func register(nextWorker: WKRPTCLActivities,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)
    
    // MARK: - Worker Logic (Public) -
    func doLoadActivities(for place: DAOPlace,
                          using activityTypes: [DAOActivityType],
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLActivitiesBlkAActivity?)
    func doUpdate(_ activities: [DAOActivity],
                  for place: DAOPlace,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLActivitiesBlkVoid?)
    
    // MARK: - Worker Logic (Shortcuts) -
    func doLoadActivities(for place: DAOPlace,
                          using activityTypes: [DAOActivityType],
                          with block: WKRPTCLActivitiesBlkAActivity?)
    func doUpdate(_ activities: [DAOActivity],
                  for place: DAOPlace,
                  with block: WKRPTCLActivitiesBlkVoid?)
}
