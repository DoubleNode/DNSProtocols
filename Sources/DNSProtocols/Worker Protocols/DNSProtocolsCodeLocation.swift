//
//  DNSProtocolsCodeLocation.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError

public extension DNSCodeLocation {
    typealias protocols = DNSProtocolsCodeLocation
}
open class DNSProtocolsCodeLocation: DNSCodeLocation {
    override open class var domainPreface: String { "com.doublenode.protocols." }
}
