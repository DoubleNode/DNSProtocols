//
//  WKRPTCLProducts.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLProductsRtnMeta = DNSMetadata
public typealias WKRPTCLProductsRtnAProduct = [DAOProduct]
public typealias WKRPTCLProductsRtnPricing = DAOPricing
public typealias WKRPTCLProductsRtnProduct = DAOProduct
public typealias WKRPTCLProductsRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLProductsResMeta = Result<WKRPTCLProductsRtnMeta, Error>
public typealias WKRPTCLProductsResAProduct = Result<WKRPTCLProductsRtnAProduct, Error>
public typealias WKRPTCLProductsResPricing = Result<WKRPTCLProductsRtnPricing, Error>
public typealias WKRPTCLProductsResProduct = Result<WKRPTCLProductsRtnProduct, Error>
public typealias WKRPTCLProductsResVoid = Result<WKRPTCLProductsRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLProductsBlkMeta = (WKRPTCLProductsResMeta) -> Void
public typealias WKRPTCLProductsBlkAProduct = (WKRPTCLProductsResAProduct) -> Void
public typealias WKRPTCLProductsBlkPricing = (WKRPTCLProductsResPricing) -> Void
public typealias WKRPTCLProductsBlkProduct = (WKRPTCLProductsResProduct) -> Void
public typealias WKRPTCLProductsBlkVoid = (WKRPTCLProductsResVoid) -> Void

public protocol WKRPTCLProducts: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLProducts? { get }

    init()
    func register(nextWorker: WKRPTCLProducts,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doLoadPricing(for product: DAOProduct,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLProductsBlkPricing?)
    func doLoadProduct(for id: String,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLProductsBlkProduct?)
    func doLoadProduct(for id: String,
                       and place: DAOPlace,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLProductsBlkProduct?)
    func doLoadProducts(with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLProductsBlkAProduct?)
    func doLoadProducts(for place: DAOPlace,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLProductsBlkAProduct?)
    func doReact(with reaction: DNSReactionType,
                 to product: DAOProduct,
                 with progress: DNSPTCLProgressBlock?,
                 and block: WKRPTCLProductsBlkMeta?)
    func doRemove(_ product: DAOProduct,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLProductsBlkVoid?)
    func doUnreact(with reaction: DNSReactionType,
                   to product: DAOProduct,
                   with progress: DNSPTCLProgressBlock?,
                   and block: WKRPTCLProductsBlkMeta?)
    func doUpdate(_ pricing: DAOPricing,
                  for product: DAOProduct,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLProductsBlkVoid?)
    func doUpdate(_ product: DAOProduct,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLProductsBlkVoid?)

    // MARK: - Worker Logic (Shortcuts) -
    func doLoadPricing(for product: DAOProduct,
                       with block: WKRPTCLProductsBlkPricing?)
    func doLoadProduct(for id: String,
                       with block: WKRPTCLProductsBlkProduct?)
    func doLoadProduct(for id: String,
                       and place: DAOPlace,
                       with block: WKRPTCLProductsBlkProduct?)
    func doLoadProducts(with block: WKRPTCLProductsBlkAProduct?)
    func doLoadProducts(for place: DAOPlace,
                        with block: WKRPTCLProductsBlkAProduct?)
    func doReact(with reaction: DNSReactionType,
                 to product: DAOProduct,
                 with block: WKRPTCLProductsBlkMeta?)
    func doRemove(_ product: DAOProduct,
                  with block: WKRPTCLProductsBlkVoid?)
    func doUnreact(with reaction: DNSReactionType,
                   to product: DAOProduct,
                   with block: WKRPTCLProductsBlkMeta?)
    func doUpdate(_ pricing: DAOPricing,
                  for product: DAOProduct,
                  with block: WKRPTCLProductsBlkVoid?)
    func doUpdate(_ product: DAOProduct,
                  with block: WKRPTCLProductsBlkVoid?)
}
