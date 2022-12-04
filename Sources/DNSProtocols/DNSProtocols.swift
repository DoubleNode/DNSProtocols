//
//  DNSProtocols.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError

public typealias DNSPTCLCallBlock = () -> Any?
public typealias DNSPTCLCallResultBlock = (DNSPTCLResultBlock?) -> Any?
// ProgressBlock: (currentStep: Int64, totalSteps: Int64, precentCompleted: Double, statusText: String)
public typealias DNSPTCLProgressBlock = (Int64, Int64, Double, String) -> Void
public typealias DNSPTCLResultBlock = (DNSPTCLWorker.Call.Result) -> Any?

public protocol DNSPTCLWorker {
    typealias Call = DNSPTCLCall
}
public enum DNSPTCLCall {
    public enum NextWhen {
        case always
        case whenError
        case whenNotFound
        case whenUnhandled
    }
    public enum Result {
        case completed
        case error
        case failure(_ error: Error)
        case notFound
        case unhandled
    }
}
