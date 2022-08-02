//
//  WKRPTCLCart.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import DNSDataObjects
import DNSError
import Foundation

public extension DNSError {
    typealias Cart = WKRPTCLCartError
}
public enum WKRPTCLCartError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case emptyBasket(_ codeLocation: DNSCodeLocation)

    public static let domain = "WKRCART"
    public enum Code: Int {
        case unknown = 1001
        case notImplemented = 1002
        case emptyBasket = 1003
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
        case .emptyBasket(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.emptyBasket.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return String(format: NSLocalizedString("WKRCART-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRCART-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .emptyBasket:
            return String(format: NSLocalizedString("WKRCART-Empty Basket%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.emptyBasket.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation),
             .emptyBasket(let codeLocation):
                return codeLocation.failureReason
       }
    }
}

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
               and block: WKRPTCLCartBlkBasket?) throws
    func doCheckout(for basket: DAOBasket,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLCartBlkOrder?) throws
    func doCreate(with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLCartBlkBasket?) throws
    func doCreate(and add: DAOBasketItem,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLCartBlkBasket?) throws
    func doLoadOrder(for id: String,
                     with progress: DNSPTCLProgressBlock?,
                     and block: WKRPTCLCartBlkOrder?) throws
    func doLoadOrders(for account: DAOAccount,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLCartBlkAOrder?) throws
    func doLoadOrders(for account: DAOAccount,
                      and state: DNSOrderState,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLCartBlkAOrder?) throws
    func doRemove(_ basket: DAOBasket,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLCartBlkVoid?) throws
    func doRemove(_ basketItem: DAOBasketItem,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLCartBlkVoid?) throws
    func doUpdate(_ basket: DAOBasket,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLCartBlkVoid?) throws
    func doUpdate(_ basketItem: DAOBasketItem,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLCartBlkVoid?) throws

    // MARK: - Worker Logic (Shortcuts) -
    func doAdd(_ basketItem: DAOBasketItem,
               to basket: DAOBasket,
               with block: WKRPTCLCartBlkBasket?) throws
    func doCheckout(for basket: DAOBasket,
                    with block: WKRPTCLCartBlkOrder?) throws
    func doCreate(with block: WKRPTCLCartBlkBasket?) throws
    func doCreate(and add: DAOBasketItem,
                  with block: WKRPTCLCartBlkBasket?) throws
    func doLoadOrder(for id: String,
                     with block: WKRPTCLCartBlkOrder?) throws
    func doLoadOrders(for account: DAOAccount,
                      with block: WKRPTCLCartBlkAOrder?) throws
    func doLoadOrders(for account: DAOAccount,
                      and state: DNSOrderState,
                      with block: WKRPTCLCartBlkAOrder?) throws
    func doRemove(_ basket: DAOBasket,
                  with block: WKRPTCLCartBlkVoid?) throws
    func doRemove(_ basketItem: DAOBasketItem,
                  with block: WKRPTCLCartBlkVoid?) throws
    func doUpdate(_ basket: DAOBasket,
                  with block: WKRPTCLCartBlkVoid?) throws
    func doUpdate(_ basketItem: DAOBasketItem,
                  with block: WKRPTCLCartBlkVoid?) throws
}
