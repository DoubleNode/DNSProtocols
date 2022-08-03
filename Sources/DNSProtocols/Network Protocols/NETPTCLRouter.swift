//
//  NETPTCLRouter.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Alamofire
import DNSError
import Foundation

// Protocol Return Types
public typealias NETPTCLRouterRtnDataRequest = DataRequest
public typealias NETPTCLRouterRtnURLRequest = URLRequest

// Protocol Result Types
public typealias NETPTCLRouterResDataRequest = Result<NETPTCLRouterRtnDataRequest, Error>
public typealias NETPTCLRouterResURLRequest = Result<NETPTCLRouterRtnURLRequest, Error>

public protocol NETPTCLRouter: URLRequestConvertible, NETPTCLNetworkBase {
    init()
    init(with netConfig: NETPTCLConfig)

    // MARK: - Network Router Logic (Public) -
    func dataRequest(for code: String) -> NETPTCLRouterResDataRequest
    func asURLRequest() throws -> NETPTCLRouterRtnURLRequest
    func asURLRequest(for code: String) -> NETPTCLRouterResURLRequest
}