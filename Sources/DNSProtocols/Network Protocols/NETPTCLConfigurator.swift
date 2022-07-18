//
//  NETPTCLConfigurator.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Alamofire
import DNSCoreThreading
import DNSError
import Foundation

public protocol NETPTCLConfigurator: NETPTCLNetworkBase {
    func restHeaders() -> HTTPHeaders

    init()
}
