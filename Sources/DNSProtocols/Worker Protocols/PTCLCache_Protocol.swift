//
//  PTCLCrash_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import Foundation

// (Error? error)
public typealias PTCLCacheBlockVoidError = (Error?) -> Void
// (Any? object, Error? error)
public typealias PTCLCacheBlockVoidAnyError = (Any?, Error?) -> Void

public protocol PTCLCrash_Protocol: PTCLBase_Protocol
{
    init()
    init(nextCrashWorker: PTCLCrash_Protocol)

    func nextCrashWorker() -> PTCLCrash_Protocol?

    // MARK: - Business Logic / Single Item CRUD
    func doReadObject(for id: String,
                      with progress: PTCLProgressBlock?,
                      and block: PTCLCacheBlockVoidAnyError?) throws
    func doDeleteObject(for id: String,
                        with progress: PTCLProgressBlock?,
                        and block: PTCLCacheBlockVoidAnyError?) throws
    func doLoadImage(for url: NSURL,
                     with progress: PTCLProgressBlock?,
                     and block: PTCLCacheBlockVoidAnyError?) throws
    func doUpdateObject(for id: String,
                        with progress: PTCLProgressBlock?,
                        and block: PTCLCacheBlockVoidAnyError?) throws

}
