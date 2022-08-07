//
//  WKRPTCLPermissions.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import DNSError
import Foundation

public struct WKRPTCLPermissionAction : Codable {
    public var permission: WKRPTCLPermissions.Data.System
    public var action: WKRPTCLPermissions.Data.Action

    public init(_ permission: WKRPTCLPermissions.Data.System,
                _ action: WKRPTCLPermissions.Data.Action) {
        self.permission = permission
        self.action = action
    }
}

// Protocol Return Types
public typealias WKRPTCLPermissionsRtnAAction = [WKRPTCLPermissionAction]
public typealias WKRPTCLPermissionsRtnAction = WKRPTCLPermissionAction

// Protocol Result Types
public typealias WKRPTCLPermissionsResAAction = Result<WKRPTCLPermissionsRtnAAction, Error>
public typealias WKRPTCLPermissionsResAction = Result<WKRPTCLPermissionsRtnAction, Error>

// Protocol Block Types
public typealias WKRPTCLPermissionsBlkAAction = (WKRPTCLPermissionsResAAction) -> Void
public typealias WKRPTCLPermissionsBlkAction = (WKRPTCLPermissionsResAction) -> Void

public protocol WKRPTCLPermissions: WKRPTCLWorkerBase {
    typealias Data = WKRPTCLPermissionsData
    typealias Action = WKRPTCLPermissionAction
    
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLPermissions? { get }
    var wkrSystems: WKRPTCLSystems { get }

    init()
    func register(nextWorker: WKRPTCLPermissions,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                   _ permission: WKRPTCLPermissions.Data.System,
                   with progress: DNSPTCLProgressBlock?,
                   and block: WKRPTCLPermissionsBlkAction?)
    func doRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                   _ permissions: [WKRPTCLPermissions.Data.System],
                   with progress: DNSPTCLProgressBlock?,
                   and block: WKRPTCLPermissionsBlkAAction?)
    func doStatus(of permissions: [WKRPTCLPermissions.Data.System],
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLPermissionsBlkAAction?)
    func doWait(for permission: WKRPTCLPermissions.Data.System,
                with progress: DNSPTCLProgressBlock?,
                and block: WKRPTCLPermissionsBlkAction?)

    // MARK: - Worker Logic (Shortcuts) -
    func doRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                   _ permission: WKRPTCLPermissions.Data.System,
                   with block: WKRPTCLPermissionsBlkAction?)
    func doRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                   _ permissions: [WKRPTCLPermissions.Data.System],
                   with block: WKRPTCLPermissionsBlkAAction?)
    func doStatus(of permissions: [WKRPTCLPermissions.Data.System],
                  with block: WKRPTCLPermissionsBlkAAction?)
    func doWait(for permission: WKRPTCLPermissions.Data.System,
                with block: WKRPTCLPermissionsBlkAction?)
}
