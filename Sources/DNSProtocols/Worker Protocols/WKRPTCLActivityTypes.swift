//
//  WKRPTCLActivityTypes.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLActivityTypesRtnActivityType = DAOActivityType
public typealias WKRPTCLActivityTypesRtnAActivityType = [DAOActivityType]
public typealias WKRPTCLActivityTypesRtnBool = Bool
public typealias WKRPTCLActivityTypesRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLActivityTypesResActivityType = Result<WKRPTCLActivityTypesRtnActivityType, Error>
public typealias WKRPTCLActivityTypesResAActivityType = Result<WKRPTCLActivityTypesRtnAActivityType, Error>
public typealias WKRPTCLActivityTypesResBool = Result<WKRPTCLActivityTypesRtnBool, Error>
public typealias WKRPTCLActivityTypesResVoid = Result<WKRPTCLActivityTypesRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLActivityTypesBlkActivityType = (WKRPTCLActivityTypesResActivityType) -> Void
public typealias WKRPTCLActivityTypesBlkAActivityType = (WKRPTCLActivityTypesResAActivityType) -> Void
public typealias WKRPTCLActivityTypesBlkBool = (WKRPTCLActivityTypesResBool) -> Void
public typealias WKRPTCLActivityTypesBlkVoid = (WKRPTCLActivityTypesResVoid) -> Void

public protocol WKRPTCLActivityTypes: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLActivityTypes? { get }
    var systemsWorker: WKRPTCLSystems { get }
    
    init()
    func register(nextWorker: WKRPTCLActivityTypes,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)
    
    // MARK: - Worker Logic (Public) -
    func doFavorite(_ activityType: DAOActivityType,
                    for user: DAOUser,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLActivityTypesBlkVoid?)
    func doIsFavorited(_ activityType: DAOActivityType,
                       for user: DAOUser,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLActivityTypesBlkBool?)
    func doLoadActivityType(for code: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLActivityTypesBlkActivityType?)
    func doLoadActivityTypes(with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLActivityTypesBlkAActivityType?)
    func doUnfavorite(_ activityType: DAOActivityType,
                      for user: DAOUser,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLActivityTypesBlkVoid?)
    func doUpdate(_ activityType: DAOActivityType,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLActivityTypesBlkVoid?)
    
    // MARK: - Worker Logic (Shortcuts) -
    func doFavorite(_ activityType: DAOActivityType,
                    for user: DAOUser,
                    with block: WKRPTCLActivityTypesBlkVoid?)
    func doIsFavorited(_ activityType: DAOActivityType,
                       for user: DAOUser,
                       with block: WKRPTCLActivityTypesBlkBool?)
    func doLoadActivityType(for code: String,
                            with block: WKRPTCLActivityTypesBlkActivityType?)
    func doLoadActivityTypes(with block: WKRPTCLActivityTypesBlkAActivityType?)
    func doUnfavorite(_ activityType: DAOActivityType,
                      for user: DAOUser,
                      with block: WKRPTCLActivityTypesBlkVoid?)
    func doUpdate(_ activityType: DAOActivityType,
                  with block: WKRPTCLActivityTypesBlkVoid?)
}
