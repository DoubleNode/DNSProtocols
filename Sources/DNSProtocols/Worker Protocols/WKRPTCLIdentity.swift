//
//  WKRPTCLIdentity.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import Foundation

// Protocol Return Types
public typealias WKRPTCLIdentityRtnVoid = Void

// Protocol Publisher Types
public typealias WKRPTCLIdentityPubVoid = AnyPublisher<WKRPTCLIdentityRtnVoid, Error>

// Protocol Future Types
public typealias WKRPTCLIdentityFutVoid = Future<WKRPTCLIdentityRtnVoid, Error>

public protocol WKRPTCLIdentity: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLIdentity? { get }
    var wkrSystems: WKRPTCLSystems { get }

    init()
    func register(nextWorker: WKRPTCLIdentity,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doClearIdentity(with progress: DNSPTCLProgressBlock?) -> WKRPTCLIdentityPubVoid
    func doJoin(group: String,
                with progress: DNSPTCLProgressBlock?) -> WKRPTCLIdentityPubVoid
    func doLeave(group: String,
                 with progress: DNSPTCLProgressBlock?) -> WKRPTCLIdentityPubVoid
    func doSetIdentity(using data: DNSDataDictionary,
                       with progress: DNSPTCLProgressBlock?) -> WKRPTCLIdentityPubVoid

    // MARK: - Worker Logic (Shortcuts) -
    func doClearIdentity() -> WKRPTCLIdentityPubVoid
    func doJoin(group: String) -> WKRPTCLIdentityPubVoid
    func doLeave(group: String) -> WKRPTCLIdentityPubVoid
    func doSetIdentity(using data: DNSDataDictionary) -> WKRPTCLIdentityPubVoid
}
