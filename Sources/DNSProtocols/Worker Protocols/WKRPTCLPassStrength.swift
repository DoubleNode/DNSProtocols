//
//  WKRPTCLPassStrength.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

// Protocol Return Types
public typealias WKRPTCLPassStrengthRtnVoid = WKRPTCLPassStrength.Level

// Protocol Result Types
public typealias WKRPTCLPassStrengthResVoid = Result<WKRPTCLPassStrengthRtnVoid, Error>

public enum WKRPTCLPassStrengthLevel: Int8 {
    case weak = 0
    case moderate = 50
    case strong = 100
}

public protocol WKRPTCLPassStrength: WKRPTCLWorkerBase {
    typealias Level = WKRPTCLPassStrengthLevel
    
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var wkrSystems: WKRPTCLSystems? { get }

    var minimumLength: Int32 { get set }

    init()
    func register(nextWorker: WKRPTCLPassStrength,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doCheckPassStrength(for password: String) -> WKRPTCLPassStrengthResVoid
}
