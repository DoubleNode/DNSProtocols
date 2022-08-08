//
//  WKRPTCLAuth.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import UIKit

public protocol WKRPTCLAuthAccessData { }

// Protocol Return Types
public typealias WKRPTCLAuthRtnBoolAccessData = (Bool, WKRPTCLAuthAccessData)
public typealias WKRPTCLAuthRtnBoolBoolAccessData = (Bool, Bool, WKRPTCLAuthAccessData)
public typealias WKRPTCLAuthRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLAuthResBoolAccessData = Result<WKRPTCLAuthRtnBoolAccessData, Error>
public typealias WKRPTCLAuthResBoolBoolAccessData = Result<WKRPTCLAuthRtnBoolBoolAccessData, Error>
public typealias WKRPTCLAuthResVoid = Result<WKRPTCLAuthRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLAuthBlkBoolAccessData = (WKRPTCLAuthResBoolAccessData) -> Void
public typealias WKRPTCLAuthBlkBoolBoolAccessData = (WKRPTCLAuthResBoolBoolAccessData) -> Void
public typealias WKRPTCLAuthBlkVoid = (WKRPTCLAuthResVoid) -> Void

public protocol WKRPTCLAuth: WKRPTCLWorkerBase {
    typealias AccessData = WKRPTCLAuthAccessData
    
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLAuth? { get }
    var wkrSystems: WKRPTCLSystems? { get }


    init()
    func register(nextWorker: WKRPTCLAuth,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doCheckAuth(using parameters: DNSDataDictionary,
                     with progress: DNSPTCLProgressBlock?,
                     and block: WKRPTCLAuthBlkBoolBoolAccessData?)
    func doSignIn(from username: String?,
                  and password: String?,
                  using parameters: DNSDataDictionary,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLAuthBlkBoolAccessData?)
    func doSignOut(using parameters: DNSDataDictionary,
                   with progress: DNSPTCLProgressBlock?,
                   and block: WKRPTCLAuthBlkVoid?)
    func doSignUp(from user: DAOUser?,
                  and password: String?,
                  using parameters: DNSDataDictionary,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLAuthBlkBoolAccessData?)

    // MARK: - Worker Logic (Shortcuts) -
    func doCheckAuth(using parameters: DNSDataDictionary,
                               with block: WKRPTCLAuthBlkBoolBoolAccessData?)
    func doSignIn(from username: String?,
                  and password: String?,
                  using parameters: DNSDataDictionary,
                  with block: WKRPTCLAuthBlkBoolAccessData?)
    func doSignOut(using parameters: DNSDataDictionary,
                   with block: WKRPTCLAuthBlkVoid?)
    func doSignUp(from user: DAOUser?,
                  and password: String?,
                  using parameters: DNSDataDictionary,
                  with block: WKRPTCLAuthBlkBoolAccessData?)
}
