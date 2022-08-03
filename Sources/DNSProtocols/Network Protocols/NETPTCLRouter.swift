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
public typealias NETPTCLRouterRtnURLRequest = URLRequest

public protocol NETPTCLRouter: URLRequestConvertible, NETPTCLNetworkBase {
    init()
    init(with netConfig: NETPTCLConfig)

    // MARK: - Network Router Logic (Public) -
    func asURLRequest() -> NETPTCLRouterRtnURLRequest
    func asURLRequest(for code: String) -> NETPTCLRouterRtnURLRequest
}
