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
        case failure(error: Error)
        case notFound
        case unhandled
    }
}

// (currentStep: Int, totalSteps: Int, precentCompleted: Float, statusText: String)
public typealias DNSPTCLProgressBlock = (Int, Int, Float, String) -> Void
