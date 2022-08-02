//
//  WKRPTCLProducts.swift
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
    typealias Products = WKRPTCLProductsError
}
public enum WKRPTCLProductsError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

    public static let domain = "WKRPRODUCTS"
    public enum Code: Int {
        case unknown = 1001
        case notImplemented = 1002
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
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return String(format: NSLocalizedString("WKRPRODUCTS-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRPRODUCTS-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation):
                return codeLocation.failureReason
       }
    }
}

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
                       and block: WKRPTCLProductsBlkProduct?) throws
    func doLoadProducts(with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLProductsBlkAProduct?) throws
    func doRemove(_ product: DAOProduct,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLProductsBlkVoid?) throws
    func doUpdate(_ product: DAOProduct,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLProductsBlkVoid?) throws

    // MARK: - Worker Logic (Shortcuts) -
    func doLoadProduct(for id: String,
                       with block: WKRPTCLProductsBlkProduct?) throws
    func doLoadProducts(with block: WKRPTCLProductsBlkAProduct?) throws
    func doRemove(_ product: DAOProduct,
                  with block: WKRPTCLProductsBlkVoid?) throws
    func doUpdate(_ product: DAOProduct,
                  with block: WKRPTCLProductsBlkVoid?) throws
}
