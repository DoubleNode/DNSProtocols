//
//  WKRPTCLCards.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import Foundation

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
               and block: WKRPTCLCardsBlkVoid?)
    func doLoadCard(for id: String,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLCardsBlkCard?)
    func doLoadCard(for transaction: DAOTransaction,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLCardsBlkCard?)
    func doLoadCards(for user: DAOUser,
                     with progress: DNSPTCLProgressBlock?,
                     and block: WKRPTCLCardsBlkACard?)
    func doLoadTransactions(for card: DAOCard,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLCardsBlkATransaction?)
    func doRemove(_ card: DAOCard,
                  from user: DAOUser,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLCardsBlkVoid?)
    func doUpdate(_ card: DAOCard,
                  for user: DAOUser,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLCardsBlkVoid?)

    // MARK: - Worker Logic (Shortcuts) -
    func doAdd(_ card: DAOCard,
               to user: DAOUser,
               with block: WKRPTCLCardsBlkVoid?)
    func doLoadCard(for id: String,
                    with block: WKRPTCLCardsBlkCard?)
    func doLoadCard(for transaction: DAOTransaction,
                    with block: WKRPTCLCardsBlkCard?)
    func doLoadCards(for user: DAOUser,
                     with block: WKRPTCLCardsBlkACard?)
    func doLoadTransactions(for card: DAOCard,
                            with block: WKRPTCLCardsBlkATransaction?)
    func doRemove(_ card: DAOCard,
                  from user: DAOUser,
                  with block: WKRPTCLCardsBlkVoid?)
    func doUpdate(_ card: DAOCard,
                  with block: WKRPTCLCardsBlkVoid?)
}
