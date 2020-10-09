//
//  PTCLBase_NetworkConfigurator.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Alamofire
import Foundation

public protocol PTCLBase_NetworkConfigurator: class
{
    func defaultHeaders() -> HTTPHeaders
}
