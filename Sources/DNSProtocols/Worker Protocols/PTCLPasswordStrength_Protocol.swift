//
//  PTCLPasswordStrength_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import DNSDataObjects
import Foundation

public enum PTCLPasswordStrengthType
{
    case weak
    case moderate
    case strong
}

public protocol PTCLPasswordStrength_Protocol: PTCLBase_Protocol {
    var nextWorker: PTCLPasswordStrength_Protocol? { get }

    init()
    init(nextWorker: PTCLPasswordStrength_Protocol)

    // MARK: - Business Logic / Single Item CRUD

    func doCheckPasswordStrength(for password: String) throws -> PTCLPasswordStrengthType
}
