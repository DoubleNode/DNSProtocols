//
//  WKRPTCLAccount.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLAccountRtnAAccount = [DAOAccount]
public typealias WKRPTCLAccountRtnAccount = DAOAccount
public typealias WKRPTCLAccountRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLAccountResAAccount = Result<WKRPTCLAccountRtnAAccount, Error>
public typealias WKRPTCLAccountResAccount = Result<WKRPTCLAccountRtnAccount, Error>
public typealias WKRPTCLAccountResVoid = Result<WKRPTCLAccountRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLAccountBlkAAccount = (WKRPTCLAccountResAAccount) -> Void
public typealias WKRPTCLAccountBlkAccount = (WKRPTCLAccountResAccount) -> Void
public typealias WKRPTCLAccountBlkVoid = (WKRPTCLAccountResVoid) -> Void

public protocol WKRPTCLAccount: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLAccount? { get }
    var wkrSystems: WKRPTCLSystems? { get }
    
    init()
    func register(nextWorker: WKRPTCLAccount,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)
    
    // MARK: - Worker Logic (Public) -
    func doLoadAccounts(for user: DAOUser,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLAccountBlkAAccount?)
    func doLoadCurrentAccount(with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLAccountBlkAccount?)
    func doUpdate(account: DAOAccount,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLAccountBlkVoid?)
    
    // MARK: - Worker Logic (Shortcuts) -
    func doLoadAccounts(for user: DAOUser,
                        with block: WKRPTCLAccountBlkAAccount?)
    func doLoadCurrentAccount(with block: WKRPTCLAccountBlkAccount?)
    func doUpdate(account: DAOAccount,
                  with block: WKRPTCLAccountBlkVoid?)
}
