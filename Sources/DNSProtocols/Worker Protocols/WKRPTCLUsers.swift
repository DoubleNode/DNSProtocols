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
public typealias WKRPTCLUsersRtnAAccountLinkRequest = [DAOAccountLinkRequest]
public typealias WKRPTCLUsersRtnAAccount = [DAOAccount]
public typealias WKRPTCLUsersRtnBool = Bool
public typealias WKRPTCLUsersRtnAUser = [DAOUser]
public typealias WKRPTCLUsersRtnUser = DAOUser
public typealias WKRPTCLUsersRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLUsersResAAccountLinkRequest = Result<WKRPTCLUsersRtnAAccountLinkRequest, Error>
public typealias WKRPTCLUsersResAAccount = Result<WKRPTCLUsersRtnAAccount, Error>
public typealias WKRPTCLUsersResBool = Result<WKRPTCLUsersRtnBool, Error>
public typealias WKRPTCLUsersResAUser = Result<WKRPTCLUsersRtnAUser, Error>
public typealias WKRPTCLUsersResUser = Result<WKRPTCLUsersRtnUser, Error>
public typealias WKRPTCLUsersResVoid = Result<WKRPTCLUsersRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLUsersBlkAAccountLinkRequest = (WKRPTCLUsersResAAccountLinkRequest) -> Void
public typealias WKRPTCLUsersBlkAAccount = (WKRPTCLUsersResAAccount) -> Void
public typealias WKRPTCLUsersBlkBool = (WKRPTCLUsersResBool) -> Void
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
    func doActivate(_ user: DAOUser,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLUsersBlkBool?)
    func doConfirm(pendingUser: DAOUser,
                   with progress: DNSPTCLProgressBlock?,
                   and block: WKRPTCLUsersBlkVoid?)
    func doConsent(childUser: DAOUser,
                   with progress: DNSPTCLProgressBlock?,
                   and block: WKRPTCLUsersBlkVoid?)
    func doLoadCurrentUser(with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLUsersBlkUser?)
    func doLoadChildUsers(for user: DAOUser,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLUsersBlkAUser?)
    func doLoadLinkRequests(for user: DAOUser,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLUsersBlkAAccountLinkRequest?)
    func doLoadPendingUsers(for user: DAOUser,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLUsersBlkAUser?)
    func doLoadUnverifiedAccounts(for user: DAOUser,
                                  with progress: DNSPTCLProgressBlock?,
                                  and block: WKRPTCLUsersBlkAAccount?)
    func doLoadUser(for id: String,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLUsersBlkUser?)
    func doLoadUsers(for account: DAOAccount,
                     with progress: DNSPTCLProgressBlock?,
                     and block: WKRPTCLUsersBlkAUser?)
    func doRemove(_ user: DAOUser,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLUsersBlkVoid?)
    func doUpdate(_ user: DAOUser,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLUsersBlkVoid?)

    // MARK: - Worker Logic (Shortcuts) -
    func doActivate(_ user: DAOUser,
                    with block: WKRPTCLUsersBlkBool?)
    func doConfirm(pendingUser: DAOUser,
                   with block: WKRPTCLUsersBlkVoid?)
    func doConsent(childUser: DAOUser,
                   with block: WKRPTCLUsersBlkVoid?)
    func doLoadCurrentUser(with block: WKRPTCLUsersBlkUser?)
    func doLoadChildUsers(for user: DAOUser,
                          with block: WKRPTCLUsersBlkAUser?)
    func doLoadUser(for id: String,
                    with progress: WKRPTCLUsersBlkUser?)
    func doLoadLinkRequests(for user: DAOUser,
                            with block: WKRPTCLUsersBlkAAccountLinkRequest?)
    func doLoadPendingUsers(for user: DAOUser,
                            with block: WKRPTCLUsersBlkAUser?)
    func doLoadUnverifiedAccounts(for user: DAOUser,
                                  with block: WKRPTCLUsersBlkAAccount?)
    func doLoadUsers(for account: DAOAccount,
                     with block: WKRPTCLUsersBlkAUser?)
    func doRemove(_ user: DAOUser,
                  with block: WKRPTCLUsersBlkVoid?)
    func doUpdate(_ user: DAOUser,
                  with block: WKRPTCLUsersBlkVoid?)
}
