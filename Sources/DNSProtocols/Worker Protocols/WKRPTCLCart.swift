//
//  WKRPTCLCart.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLCartRtnBasket = DAOBasket
public typealias WKRPTCLCartRtnAOrder = [DAOOrder]
public typealias WKRPTCLCartRtnOrder = DAOOrder
public typealias WKRPTCLCartRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLCartResBasket = Result<WKRPTCLCartRtnBasket, Error>
public typealias WKRPTCLCartResAOrder = Result<WKRPTCLCartRtnAOrder, Error>
public typealias WKRPTCLCartResOrder = Result<WKRPTCLCartRtnOrder, Error>
public typealias WKRPTCLCartResVoid = Result<WKRPTCLCartRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLCartBlkBasket = (WKRPTCLCartResBasket) -> Void
public typealias WKRPTCLCartBlkAOrder = (WKRPTCLCartResAOrder) -> Void
public typealias WKRPTCLCartBlkOrder = (WKRPTCLCartResOrder) -> Void
public typealias WKRPTCLCartBlkVoid = (WKRPTCLCartResVoid) -> Void

public protocol WKRPTCLCart: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLCart? { get }

    init()
    func register(nextWorker: WKRPTCLCart,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doAdd(_ basketItem: DAOBasketItem,
               to basket: DAOBasket,
               with progress: DNSPTCLProgressBlock?,
               and block: WKRPTCLCartBlkBasket?)
    func doCheckout(for basket: DAOBasket,
                    using card: DAOCard,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLCartBlkOrder?)
    func doCreate(with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLCartBlkBasket?)
    func doCreate(and add: DAOBasketItem,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLCartBlkBasket?)
    func doLoadOrder(for id: String,
                     with progress: DNSPTCLProgressBlock?,
                     and block: WKRPTCLCartBlkOrder?)
    func doLoadOrders(for account: DAOAccount,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLCartBlkAOrder?)
    func doLoadOrders(for account: DAOAccount,
                      and state: DNSOrderState,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLCartBlkAOrder?)
    func doRemove(_ basket: DAOBasket,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLCartBlkVoid?)
    func doRemove(_ basketItem: DAOBasketItem,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLCartBlkVoid?)
    func doUpdate(_ basket: DAOBasket,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLCartBlkVoid?)
    func doUpdate(_ basketItem: DAOBasketItem,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLCartBlkVoid?)

    // MARK: - Worker Logic (Shortcuts) -
    func doAdd(_ basketItem: DAOBasketItem,
               to basket: DAOBasket,
               with block: WKRPTCLCartBlkBasket?)
    func doCheckout(for basket: DAOBasket,
                    using card: DAOCard,
                    with block: WKRPTCLCartBlkOrder?)
    func doCreate(with block: WKRPTCLCartBlkBasket?)
    func doCreate(and add: DAOBasketItem,
                  with block: WKRPTCLCartBlkBasket?)
    func doLoadOrder(for id: String,
                     with block: WKRPTCLCartBlkOrder?)
    func doLoadOrders(for account: DAOAccount,
                      with block: WKRPTCLCartBlkAOrder?)
    func doLoadOrders(for account: DAOAccount,
                      and state: DNSOrderState,
                      with block: WKRPTCLCartBlkAOrder?)
    func doRemove(_ basket: DAOBasket,
                  with block: WKRPTCLCartBlkVoid?)
    func doRemove(_ basketItem: DAOBasketItem,
                  with block: WKRPTCLCartBlkVoid?)
    func doUpdate(_ basket: DAOBasket,
                  with block: WKRPTCLCartBlkVoid?)
    func doUpdate(_ basketItem: DAOBasketItem,
                  with block: WKRPTCLCartBlkVoid?)
}
