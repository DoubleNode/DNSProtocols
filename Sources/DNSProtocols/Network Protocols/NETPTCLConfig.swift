//
//  NETPTCLConfig.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Alamofire
import DNSError
import Foundation

// Protocol Return Types
public typealias NETPTCLConfigRtnDataRequest = DataRequest
public typealias NETPTCLConfigRtnHeaders = HTTPHeaders
public typealias NETPTCLConfigRtnURLComponents = URLComponents
public typealias NETPTCLConfigRtnURLRequest = URLRequest
public typealias NETPTCLConfigRtnVoid = Void

// Protocol Result Types
public typealias NETPTCLConfigResDataRequest = Result<NETPTCLConfigRtnDataRequest, Error>
public typealias NETPTCLConfigResHeaders = Result<NETPTCLConfigRtnHeaders, Error>
public typealias NETPTCLConfigResURLComponents = Result<NETPTCLConfigRtnURLComponents, Error>
public typealias NETPTCLConfigResURLRequest = Result<NETPTCLConfigRtnURLRequest, Error>
public typealias NETPTCLConfigResVoid = Result<NETPTCLConfigRtnVoid, Error>

public protocol NETPTCLConfig: NETPTCLNetworkBase {
    init()

    // MARK: - Network Config Logic (Public) -
    func urlComponents() -> NETPTCLConfigResURLComponents
    func urlComponents(for code: String) -> NETPTCLConfigResURLComponents
    func urlComponents(set components: URLComponents, for code: String) -> NETPTCLConfigResVoid
    func restHeaders() -> NETPTCLConfigResHeaders
    func restHeaders(for code: String) -> NETPTCLConfigResHeaders
    func urlRequest(using url: URL) -> NETPTCLConfigResURLRequest
    func urlRequest(for code: String, using url: URL) -> NETPTCLConfigResURLRequest
}
