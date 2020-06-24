//
//  PTCLPasswordStrength_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import Foundation

public enum PTCLPasswordStrengthType: Int8
{
    case weak = 0
    case moderate = 50
    case strong = 100
}

public protocol PTCLPasswordStrength_Protocol: PTCLBase_Protocol {
    var nextWorker: PTCLPasswordStrength_Protocol? { get }

    var minimumLength: Int32 { get set }

    init()
    init(nextWorker: PTCLPasswordStrength_Protocol)

    // MARK: - Business Logic / Single Item CRUD

    func doCheckPasswordStrength(for password: String) throws -> PTCLPasswordStrengthType
}
