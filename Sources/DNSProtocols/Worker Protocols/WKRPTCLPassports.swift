//
//  WKRPTCLPassports.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLPassportsRtnData = Data

// Protocol Publisher Types
public typealias WKRPTCLPassportsPubData = AnyPublisher<WKRPTCLPassportsRtnData, Error>

// Protocol Future Types
public typealias WKRPTCLPassportsFutData = Future<WKRPTCLPassportsRtnData, Error>

public protocol WKRPTCLPassports: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLPassports? { get }
    var wkrSystems: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLPassports,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doBuildPassport(ofType passportType: String,
                         using data: [String: String],
                         for account: DAOAccount,
                         with progress: DNSPTCLProgressBlock?) -> WKRPTCLPassportsPubData

    // MARK: - Worker Logic (Shortcuts) -
    func doBuildPassport(ofType passportType: String,
                         using data: [String: String],
                         for account: DAOAccount) -> WKRPTCLPassportsPubData
}
