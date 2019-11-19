//
//  PTCLCache_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import Foundation

// (error: Error?)
public typealias PTCLCacheBlockVoidError = (Error?) -> Void
// (object: Any?, error: Error?)
public typealias PTCLCacheBlockVoidAnyError = (Any?, Error?) -> Void

public protocol PTCLCache_Protocol: PTCLBase_Protocol
{
    var nextWorker: PTCLCache_Protocol? { get }
    
    init()
    init(nextWorker: PTCLCache_Protocol)

    // MARK: - Business Logic / Single Item CRUD
    func doDeleteObject(for id: String,
                        with progress: PTCLProgressBlock?,
                        and block: PTCLCacheBlockVoidAnyError?) throws
    func doReadObject(for id: String,
                      with progress: PTCLProgressBlock?,
                      and block: PTCLCacheBlockVoidAnyError?) throws
    func doLoadImage(for url: NSURL,
                     with progress: PTCLProgressBlock?,
                     and block: PTCLCacheBlockVoidAnyError?) throws
    func doUpdateObject(for id: String,
                        with progress: PTCLProgressBlock?,
                        and block: PTCLCacheBlockVoidAnyError?) throws
}
