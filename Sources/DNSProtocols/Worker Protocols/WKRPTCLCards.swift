//
//  WKRPTCLCards.swift
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
    typealias Cards = WKRPTCLCardsError
}
public enum WKRPTCLCardsError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

    public static let domain = "WKRCARDS"
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
            return String(format: NSLocalizedString("WKRCARDS-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRCARDS-Not Implemented%@", comment: ""),
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
public typealias WKRPTCLCardsRtnACard = [DAOCard]
public typealias WKRPTCLCardsRtnCard = DAOCard
public typealias WKRPTCLCardsRtnATransaction = [DAOTransaction]
public typealias WKRPTCLCardsRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLCardsResACard = Result<WKRPTCLCardsRtnACard, Error>
public typealias WKRPTCLCardsResCard = Result<WKRPTCLCardsRtnCard, Error>
public typealias WKRPTCLCardsResATransaction = Result<WKRPTCLCardsRtnATransaction, Error>
public typealias WKRPTCLCardsResVoid = Result<WKRPTCLCardsRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLCardsBlkACard = (WKRPTCLCardsResACard) -> Void
public typealias WKRPTCLCardsBlkCard = (WKRPTCLCardsResCard) -> Void
public typealias WKRPTCLCardsBlkATransaction = (WKRPTCLCardsResATransaction) -> Void
public typealias WKRPTCLCardsBlkVoid = (WKRPTCLCardsResVoid) -> Void

public protocol WKRPTCLCards: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLCards? { get }

    init()
    func register(nextWorker: WKRPTCLCards,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doAdd(_ card: DAOCard,
               to user: DAOUser,
               with progress: DNSPTCLProgressBlock?,
               and block: WKRPTCLCardsBlkVoid?) throws
    func doLoadCard(for id: String,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLCardsBlkCard?) throws
    func doLoadCard(for transaction: DAOTransaction,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLCardsBlkCard?) throws
    func doLoadCards(for user: DAOUser,
                     with progress: DNSPTCLProgressBlock?,
                     and block: WKRPTCLCardsBlkACard?) throws
    func doLoadTransactions(for card: DAOCard,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLCardsBlkATransaction?) throws
    func doRemove(_ card: DAOCard,
                  from user: DAOUser,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLCardsBlkVoid?) throws
    func doUpdate(_ card: DAOCard,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLCardsBlkVoid?) throws

    // MARK: - Worker Logic (Shortcuts) -
    func doAdd(_ card: DAOCard,
               to user: DAOUser,
               with block: WKRPTCLCardsBlkVoid?) throws
    func doLoadCard(for id: String,
                    with block: WKRPTCLCardsBlkCard?) throws
    func doLoadCard(for transaction: DAOTransaction,
                    with block: WKRPTCLCardsBlkCard?) throws
    func doLoadCards(for user: DAOUser,
                     with block: WKRPTCLCardsBlkACard?) throws
    func doLoadTransactions(for card: DAOCard,
                            with block: WKRPTCLCardsBlkATransaction?) throws
    func doRemove(_ card: DAOCard,
                  from user: DAOUser,
                  with block: WKRPTCLCardsBlkVoid?) throws
    func doUpdate(_ card: DAOCard,
                  with block: WKRPTCLCardsBlkVoid?) throws
}
