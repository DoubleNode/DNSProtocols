//
//  WKRPTCLAdmin.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLAdminRtnAAccount = [DAOAccount]
public typealias WKRPTCLAdminRtnAString = [String]
public typealias WKRPTCLAdminRtnBool = Bool
public typealias WKRPTCLAdminRtnDeletedStatus = DNSPTCLDeletedStatus
public typealias WKRPTCLAdminRtnUserChangeRequest = (DAOUserChangeRequest?, [DAOUserChangeRequest])
public typealias WKRPTCLAdminRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLAdminResAAccount = Result<WKRPTCLAdminRtnAAccount, Error>
public typealias WKRPTCLAdminResDeletedStatus = Result<WKRPTCLAdminRtnDeletedStatus, Error>

// Protocol Block Types
public typealias WKRPTCLAdminBlkAAccount = (WKRPTCLAdminResAAccount) -> Void
public typealias WKRPTCLAdminBlkDeletedStatus = (WKRPTCLAdminResDeletedStatus) -> Void

// Protocol Publisher Types
public typealias WKRPTCLAdminPubAString = AnyPublisher<WKRPTCLAdminRtnAString, Error>
public typealias WKRPTCLAdminPubBool = AnyPublisher<WKRPTCLAdminRtnBool, Error>
public typealias WKRPTCLAdminPubUserChangeRequest = AnyPublisher<WKRPTCLAdminRtnUserChangeRequest, Error>
public typealias WKRPTCLAdminPubVoid = AnyPublisher<WKRPTCLAdminRtnVoid, Error>

// Protocol Future Types
public typealias WKRPTCLAdminFutAString = Future<WKRPTCLAdminRtnAString, Error>
public typealias WKRPTCLAdminFutBool = Future<WKRPTCLAdminRtnBool, Error>
public typealias WKRPTCLAdminFutUserChangeRequest = Future<WKRPTCLAdminRtnUserChangeRequest, Error>
public typealias WKRPTCLAdminFutVoid = Future<WKRPTCLAdminRtnVoid, Error>

public protocol WKRPTCLAdmin: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLAdmin? { get }
    var wkrSystems: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLAdmin,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doChange(_ user: DAOUser,
                  to role: DNSUserRole,
                  with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubVoid
    func doCheckAdmin(with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubBool
    func doCompleteDeleted(account: DAOAccount,
                           with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubVoid
    func doDenyChangeRequest(for user: DAOUser,
                             with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubVoid
    func doLoadChangeRequests(with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubUserChangeRequest
    func doLoadDeletedAccounts(thatAre state: DNSPTCLDeletedStates,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLAdminBlkAAccount?)
    func doLoadDeletedStatus(with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLAdminBlkDeletedStatus?)
    func doLoadTabs(with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubAString
    func doRequestChange(to role: DNSUserRole,
                         with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubVoid

    // MARK: - Worker Logic (Shortcuts) -
    func doChange(_ user: DAOUser,
                  to role: DNSUserRole) -> WKRPTCLAdminPubVoid
    func doCheckAdmin() -> WKRPTCLAdminPubBool
    func doCompleteDeleted(account: DAOAccount) -> WKRPTCLAdminPubVoid
    func doDenyChangeRequest(for user: DAOUser) -> WKRPTCLAdminPubVoid
    func doLoadChangeRequests() -> WKRPTCLAdminPubUserChangeRequest
    func doLoadDeletedAccounts(thatAre state: DNSPTCLDeletedStates,
                               with block: WKRPTCLAdminBlkDeletedStatus?)
    func doLoadDeletedStatus(with block: WKRPTCLAdminBlkAAccount?)
    func doLoadTabs() -> WKRPTCLAdminPubAString
    func doRequestChange(to role: DNSUserRole) -> WKRPTCLAdminPubVoid
}
