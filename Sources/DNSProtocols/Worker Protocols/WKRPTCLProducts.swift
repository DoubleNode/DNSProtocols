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
public typealias WKRPTCLProductsRtnAProduct = [DAOProduct]
public typealias WKRPTCLProductsRtnProduct = DAOProduct
public typealias WKRPTCLProductsRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLProductsResAProduct = Result<WKRPTCLProductsRtnAProduct, Error>
public typealias WKRPTCLProductsResProduct = Result<WKRPTCLProductsRtnProduct, Error>
public typealias WKRPTCLProductsResVoid = Result<WKRPTCLProductsRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLProductsBlkAProduct = (WKRPTCLProductsResAProduct) -> Void
public typealias WKRPTCLProductsBlkProduct = (WKRPTCLProductsResProduct) -> Void
public typealias WKRPTCLProductsBlkVoid = (WKRPTCLProductsResVoid) -> Void

public protocol WKRPTCLProducts: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLProducts? { get }

    init()
    func register(nextWorker: WKRPTCLProducts,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doLoadProduct(for id: String,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLProductsBlkProduct?)
    func doLoadProducts(with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLProductsBlkAProduct?)
    func doRemove(_ product: DAOProduct,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLProductsBlkVoid?)
    func doUpdate(_ product: DAOProduct,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLProductsBlkVoid?)

    // MARK: - Worker Logic (Shortcuts) -
    func doLoadProduct(for id: String,
                       with block: WKRPTCLProductsBlkProduct?)
    func doLoadProducts(with block: WKRPTCLProductsBlkAProduct?)
    func doRemove(_ product: DAOProduct,
                  with block: WKRPTCLProductsBlkVoid?)
    func doUpdate(_ product: DAOProduct,
                  with block: WKRPTCLProductsBlkVoid?)
}
