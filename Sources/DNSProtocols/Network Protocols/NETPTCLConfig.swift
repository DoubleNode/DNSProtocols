//
//  NETPTCLConfig.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Alamofire
import DNSError
import Foundation

// Protocol Return Types
public typealias NETPTCLConfigRtnHeaders = HTTPHeaders

// Protocol Result Types
public typealias NETPTCLConfigResHeaders = Result<NETPTCLConfigRtnHeaders, Error>

public protocol NETPTCLConfig: NETPTCLNetworkBase {
    init()

    // MARK: - Worker Logic (Public) -
    func restHeaders() -> NETPTCLConfigResHeaders
}
