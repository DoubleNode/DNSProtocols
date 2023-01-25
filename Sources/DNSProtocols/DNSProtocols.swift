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
public enum DNSPTCLDeletedStates: String {
    case queued
    case ready
    case done
}
public struct DNSPTCLDeletedStatus {
    public struct Counts {
        public var total: Int = 0
        public var last24hrs: Int = 0
        public var last3days: Int = 0
        public var last7days: Int = 0
        public var last14days: Int = 0
        public var last21days: Int = 0
    }
    
    public var done: Counts = Counts()
    public var queued: Counts = Counts()
    public var ready: Counts = Counts()
}
