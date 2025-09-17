//
//  WKRPTCLActivityTypes.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import DNSDataTypes
import Foundation

// Protocol Return Types
public typealias WKRPTCLActivityTypesRtnActivityType = DAOActivityType
public typealias WKRPTCLActivityTypesRtnAActivityType = [DAOActivityType]
public typealias WKRPTCLActivityTypesRtnBool = Bool
public typealias WKRPTCLActivityTypesRtnMeta = DNSMetadata
public typealias WKRPTCLActivityTypesRtnPricing = DAOPricing
public typealias WKRPTCLActivityTypesRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLActivityTypesResActivityType = Result<WKRPTCLActivityTypesRtnActivityType, Error>
public typealias WKRPTCLActivityTypesResAActivityType = Result<WKRPTCLActivityTypesRtnAActivityType, Error>
public typealias WKRPTCLActivityTypesResBool = Result<WKRPTCLActivityTypesRtnBool, Error>
public typealias WKRPTCLActivityTypesResMeta = Result<WKRPTCLActivityTypesRtnMeta, Error>
public typealias WKRPTCLActivityTypesResPricing = Result<WKRPTCLActivityTypesRtnPricing, Error>
public typealias WKRPTCLActivityTypesResVoid = Result<WKRPTCLActivityTypesRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLActivityTypesBlkActivityType = (WKRPTCLActivityTypesResActivityType) -> Void
public typealias WKRPTCLActivityTypesBlkAActivityType = (WKRPTCLActivityTypesResAActivityType) -> Void
public typealias WKRPTCLActivityTypesBlkBool = (WKRPTCLActivityTypesResBool) -> Void
public typealias WKRPTCLActivityTypesBlkMeta = (WKRPTCLActivityTypesResMeta) -> Void
public typealias WKRPTCLActivityTypesBlkPricing = (WKRPTCLActivityTypesResPricing) -> Void
public typealias WKRPTCLActivityTypesBlkVoid = (WKRPTCLActivityTypesResVoid) -> Void

public protocol WKRPTCLActivityTypes: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var wkrSystems: WKRPTCLSystems? { get }
    
    init()
    func register(nextWorker: WKRPTCLActivityTypes,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)
    
    // MARK: - Worker Logic (Public) -
    func doLoadActivityType(for code: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLActivityTypesBlkActivityType?)
    func doLoadActivityType(for tag: DNSString,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLActivityTypesBlkActivityType?)
    func doLoadActivityTypes(with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLActivityTypesBlkAActivityType?)
    func doLoadPricing(for activityType: DAOActivityType,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLActivityTypesBlkPricing?)
    func doReact(with reaction: DNSReactionType,
                 to activityType: DAOActivityType,
                 with progress: DNSPTCLProgressBlock?,
                 and block: WKRPTCLActivityTypesBlkMeta?)
    func doUnreact(with reaction: DNSReactionType,
                   to activityType: DAOActivityType,
                   with progress: DNSPTCLProgressBlock?,
                   and block: WKRPTCLActivityTypesBlkMeta?)
    func doUpdate(_ activityType: DAOActivityType,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLActivityTypesBlkVoid?)
    func doUpdate(_ pricing: DAOPricing,
                  for activityType: DAOActivityType,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLActivityTypesBlkVoid?)

    // MARK: - Worker Logic (Shortcuts) -
    func doLoadActivityType(for code: String,
                            with block: WKRPTCLActivityTypesBlkActivityType?)
    func doLoadActivityType(for tag: DNSString,
                            with block: WKRPTCLActivityTypesBlkActivityType?)
    func doLoadActivityTypes(with block: WKRPTCLActivityTypesBlkAActivityType?)
    func doLoadPricing(for activityType: DAOActivityType,
                       with block: WKRPTCLActivityTypesBlkPricing?)
    func doReact(with reaction: DNSReactionType,
                 to activityType: DAOActivityType,
                 with block: WKRPTCLActivityTypesBlkMeta?)
    func doUnreact(with reaction: DNSReactionType,
                   to activityType: DAOActivityType,
                   with block: WKRPTCLActivityTypesBlkMeta?)
    func doUpdate(_ activityType: DAOActivityType,
                  with block: WKRPTCLActivityTypesBlkVoid?)
    func doUpdate(_ pricing: DAOPricing,
                  for activityType: DAOActivityType,
                  with block: WKRPTCLActivityTypesBlkVoid?)
}
