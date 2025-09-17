//
//  WKRPTCLPromotions.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSDataTypes
import DNSDataUIObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLPromotionsRtnMeta = DNSMetadata
public typealias WKRPTCLPromotionsRtnAPromotion = [DAOPromotion]
public typealias WKRPTCLPromotionsRtnPromotion = DAOPromotion
public typealias WKRPTCLPromotionsRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLPromotionsResMeta = Result<WKRPTCLPromotionsRtnMeta, Error>
public typealias WKRPTCLPromotionsResAPromotion = Result<WKRPTCLPromotionsRtnAPromotion, Error>
public typealias WKRPTCLPromotionsResPromotion = Result<WKRPTCLPromotionsRtnPromotion, Error>
public typealias WKRPTCLPromotionsResVoid = Result<WKRPTCLPromotionsRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLPromotionsBlkMeta = (WKRPTCLPromotionsResMeta) -> Void
public typealias WKRPTCLPromotionsBlkAPromotion = (WKRPTCLPromotionsResAPromotion) -> Void
public typealias WKRPTCLPromotionsBlkPromotion = (WKRPTCLPromotionsResPromotion) -> Void
public typealias WKRPTCLPromotionsBlkVoid = (WKRPTCLPromotionsResVoid) -> Void

public protocol WKRPTCLPromotions: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }

    init()
    func register(nextWorker: WKRPTCLPromotions,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    @available(iOS 15.0.0, *)
    func doActivate(_ id: String,
                    with progress: DNSPTCLProgressBlock?) async -> WKRPTCLPromotionsResVoid
    func doActivate(_ id: String,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLPromotionsBlkVoid?)
    @available(iOS 15.0.0, *)
    func doDelete(_ promotion: DAOPromotion,
                  with progress: DNSPTCLProgressBlock?) async -> WKRPTCLPromotionsResVoid
    func doDelete(_ promotion: DAOPromotion,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLPromotionsBlkVoid?)
    @available(iOS 15.0.0, *)
    func doDispense(_ id: String,
                    with progress: DNSPTCLProgressBlock?) async -> WKRPTCLPromotionsResVoid
    func doDispense(_ id: String,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLPromotionsBlkVoid?)
    func doLoadPromotion(for id: String,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLPromotionsBlkPromotion?)
    func doLoadPromotions(for account: DAOAccount?,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPromotionsBlkAPromotion?)
    func doLoadPromotions(for path: String,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPromotionsBlkAPromotion?)
    func doReact(with reaction: DNSReactionType,
                 to promotion: DAOPromotion,
                 with progress: DNSPTCLProgressBlock?,
                 and block: WKRPTCLPromotionsBlkMeta?)
    func doUnreact(with reaction: DNSReactionType,
                   to promotion: DAOPromotion,
                   with progress: DNSPTCLProgressBlock?,
                   and block: WKRPTCLPromotionsBlkMeta?)
    func doUpdate(_ promotion: DAOPromotion,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLPromotionsBlkPromotion?)

    // MARK: - Worker Logic (Shortcuts) -
    @available(iOS 15.0.0, *)
    func doActivate(_ id: String) async -> WKRPTCLPromotionsResVoid
    func doActivate(_ id: String,
                    and block: WKRPTCLPromotionsBlkVoid?)
    @available(iOS 15.0.0, *)
    func doDelete(_ promotion: DAOPromotion) async -> WKRPTCLPromotionsResVoid
    func doDelete(_ promotion: DAOPromotion,
                  and block: WKRPTCLPromotionsBlkVoid?)
    @available(iOS 15.0.0, *)
    func doDispense(_ id: String) async -> WKRPTCLPromotionsResVoid
    func doDispense(_ id: String,
                    and block: WKRPTCLPromotionsBlkVoid?)
    func doLoadPromotion(for id: String,
                         and block: WKRPTCLPromotionsBlkPromotion?)
    func doLoadPromotions(for account: DAOAccount?,
                          and block: WKRPTCLPromotionsBlkAPromotion?)
    func doLoadPromotions(for path: String,
                          and block: WKRPTCLPromotionsBlkAPromotion?)
    func doReact(with reaction: DNSReactionType,
                 to promotion: DAOPromotion,
                 with block: WKRPTCLPromotionsBlkMeta?)
    func doUnreact(with reaction: DNSReactionType,
                   to promotion: DAOPromotion,
                   with block: WKRPTCLPromotionsBlkMeta?)
    func doUpdate(_ promotion: DAOPromotion,
                  and block: WKRPTCLPromotionsBlkPromotion?)
}
