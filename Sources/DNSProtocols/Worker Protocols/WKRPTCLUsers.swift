//
//  WKRPTCLUsers.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLUsersRtnAUser = [DAOUser]
public typealias WKRPTCLUsersRtnUser = DAOUser?
public typealias WKRPTCLUsersRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLUsersResAUser = Result<WKRPTCLUsersRtnAUser, Error>
public typealias WKRPTCLUsersResUser = Result<WKRPTCLUsersRtnUser, Error>
public typealias WKRPTCLUsersResVoid = Result<WKRPTCLUsersRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLUsersBlkAUser = (WKRPTCLUsersResAUser) -> Void
public typealias WKRPTCLUsersBlkUser = (WKRPTCLUsersResUser) -> Void
public typealias WKRPTCLUsersBlkVoid = (WKRPTCLUsersResVoid) -> Void

public protocol WKRPTCLUsers: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLUsers? { get }

    init()
    func register(nextWorker: WKRPTCLUsers,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doLoadCurrentUser(with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLUsersBlkUser?)
    func doLoadUser(for id: String,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLUsersBlkUser?)
    func doLoadUsers(for account: DAOAccount,
                     with progress: DNSPTCLProgressBlock?,
                     and block: WKRPTCLUsersBlkAUser?)
    func doRemoveCurrentUser(with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLUsersBlkVoid?)
    func doRemove(_ user: DAOUser,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLUsersBlkVoid?)
    func doUpdate(_ user: DAOUser,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLUsersBlkVoid?)

    // MARK: - Worker Logic (Shortcuts) -
    func doLoadCurrentUser(with block: WKRPTCLUsersBlkUser?)
    func doLoadUser(for id: String,
                    with progress: WKRPTCLUsersBlkUser?)
    func doLoadUsers(for account: DAOAccount,
                     with block: WKRPTCLUsersBlkAUser?)
    func doRemoveCurrentUser(with block: WKRPTCLUsersBlkVoid?)
    func doRemove(_ user: DAOUser,
                  with block: WKRPTCLUsersBlkVoid?)
    func doUpdate(_ user: DAOUser,
                  with block: WKRPTCLUsersBlkVoid?)
}
