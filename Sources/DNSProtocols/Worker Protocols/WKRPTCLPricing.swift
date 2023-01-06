//
//  WKRPTCLPricing.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLPricingRtnAPricingItem = [DAOPricingItem]
public typealias WKRPTCLPricingRtnAPricingSeason = [DAOPricingSeason]
public typealias WKRPTCLPricingRtnAPricingTier = [DAOPricingTier]
public typealias WKRPTCLPricingRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLPricingResAPricingItem = Result<WKRPTCLPricingRtnAPricingItem, Error>
public typealias WKRPTCLPricingResAPricingSeason = Result<WKRPTCLPricingRtnAPricingSeason, Error>
public typealias WKRPTCLPricingResAPricingTier = Result<WKRPTCLPricingRtnAPricingTier, Error>
public typealias WKRPTCLPricingResVoid = Result<WKRPTCLPricingRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLPricingBlkAPricingItem = (WKRPTCLPricingResAPricingItem) -> Void
public typealias WKRPTCLPricingBlkAPricingSeason = (WKRPTCLPricingResAPricingSeason) -> Void
public typealias WKRPTCLPricingBlkAPricingTier = (WKRPTCLPricingResAPricingTier) -> Void
public typealias WKRPTCLPricingBlkVoid = (WKRPTCLPricingResVoid) -> Void

public protocol WKRPTCLPricing: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLPricing? { get }

    init()
    func register(nextWorker: WKRPTCLPricing,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doLoadPricingItems(for pricingTier: DAOPricingTier,
                            and pricingSeason: DAOPricingSeason,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLPricingBlkAPricingItem?)
    func doLoadPricingSeasons(for pricingTier: DAOPricingTier,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLPricingBlkAPricingSeason?)
    func doLoadPricingTiers(with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLPricingBlkAPricingTier?)
    func doRemove(_ pricingTier: DAOPricingTier,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLPricingBlkVoid?)
    func doRemove(_ pricingSeason: DAOPricingSeason,
                  for pricingTier: DAOPricingTier,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLPricingBlkVoid?)
    func doRemove(_ pricingItem: DAOPricingItem,
                  for pricingTier: DAOPricingTier,
                  and pricingSeason: DAOPricingSeason,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLPricingBlkVoid?)
    func doUpdate(_ pricingTier: DAOPricingTier,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLPricingBlkVoid?)
    func doUpdate(_ pricingSeason: DAOPricingSeason,
                  for pricingTier: DAOPricingTier,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLPricingBlkVoid?)
    func doUpdate(_ pricingItem: DAOPricingItem,
                  for pricingTier: DAOPricingTier,
                  and pricingSeason: DAOPricingSeason,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLPricingBlkVoid?)

    // MARK: - Worker Logic (Shortcuts) -
    func doLoadPricingItems(for pricingTier: DAOPricingTier,
                            and pricingSeason: DAOPricingSeason,
                            with block: WKRPTCLPricingBlkAPricingItem?)
    func doLoadPricingSeasons(for pricingTier: DAOPricingTier,
                              with block: WKRPTCLPricingBlkAPricingSeason?)
    func doLoadPricingTiers(with block: WKRPTCLPricingBlkAPricingTier?)
    func doRemove(_ pricingTier: DAOPricingTier,
                  with block: WKRPTCLPricingBlkVoid?)
    func doRemove(_ pricingSeason: DAOPricingSeason,
                  for pricingTier: DAOPricingTier,
                  with block: WKRPTCLPricingBlkVoid?)
    func doRemove(_ pricingItem: DAOPricingItem,
                  for pricingTier: DAOPricingTier,
                  and pricingSeason: DAOPricingSeason,
                  with block: WKRPTCLPricingBlkVoid?)
    func doUpdate(_ pricingTier: DAOPricingTier,
                  with block: WKRPTCLPricingBlkVoid?)
    func doUpdate(_ pricingSeason: DAOPricingSeason,
                  for pricingTier: DAOPricingTier,
                  with block: WKRPTCLPricingBlkVoid?)
    func doUpdate(_ pricingItem: DAOPricingItem,
                  for pricingTier: DAOPricingTier,
                  and pricingSeason: DAOPricingSeason,
                  with block: WKRPTCLPricingBlkVoid?)
}
