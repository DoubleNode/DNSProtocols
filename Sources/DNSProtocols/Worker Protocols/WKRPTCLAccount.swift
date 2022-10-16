//
//  WKRPTCLAccount.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLAccountRtnAAccount = [DAOAccount]
public typealias WKRPTCLAccountRtnAccount = DAOAccount
public typealias WKRPTCLAccountRtnBool = Bool
public typealias WKRPTCLAccountRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLAccountResAAccount = Result<WKRPTCLAccountRtnAAccount, Error>
public typealias WKRPTCLAccountResAccount = Result<WKRPTCLAccountRtnAccount, Error>
public typealias WKRPTCLAccountResBool = Result<WKRPTCLAccountRtnBool, Error>
public typealias WKRPTCLAccountResVoid = Result<WKRPTCLAccountRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLAccountBlkAAccount = (WKRPTCLAccountResAAccount) -> Void
public typealias WKRPTCLAccountBlkAccount = (WKRPTCLAccountResAccount) -> Void
public typealias WKRPTCLAccountBlkBool = (WKRPTCLAccountResBool) -> Void
public typealias WKRPTCLAccountBlkVoid = (WKRPTCLAccountResVoid) -> Void

public protocol WKRPTCLAccount: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLAccount? { get }
    var wkrSystems: WKRPTCLSystems? { get }
    
    init()
    func register(nextWorker: WKRPTCLAccount,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)
    
    // MARK: - Worker Logic (Public) -
    func doActivate(account: DAOAccount,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLAccountBlkBool?)
    func doDeactivate(account: DAOAccount,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLAccountBlkVoid?)
    func doDelete(account: DAOAccount,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLAccountBlkVoid?)
    func doLoadAccount(for id: String,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLAccountBlkAccount?)
    func doLoadAccounts(for user: DAOUser,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLAccountBlkAAccount?)
    func doLoadCurrentAccounts(with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLAccountBlkAAccount?)
    func doSearchAccounts(using parameters: DNSDataDictionary,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAccountBlkAAccount?)
    func doUpdate(account: DAOAccount,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLAccountBlkVoid?)
    
    // MARK: - Worker Logic (Shortcuts) -
    func doActivate(account: DAOAccount,
                    and block: WKRPTCLAccountBlkBool?)
    func doDeactivate(account: DAOAccount,
                      and block: WKRPTCLAccountBlkVoid?)
    func doDelete(account: DAOAccount,
                  and block: WKRPTCLAccountBlkVoid?)
    func doLoadAccount(for id: String,
                       with block: WKRPTCLAccountBlkAccount?)
    func doLoadAccounts(for user: DAOUser,
                        with block: WKRPTCLAccountBlkAAccount?)
    func doLoadCurrentAccounts(with block: WKRPTCLAccountBlkAAccount?)
    func doSearchAccounts(using parameters: DNSDataDictionary,
                          with block: WKRPTCLAccountBlkAAccount?)
    func doUpdate(account: DAOAccount,
                  with block: WKRPTCLAccountBlkVoid?)
}
