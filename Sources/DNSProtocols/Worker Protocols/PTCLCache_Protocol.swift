//
//  PTCLCache_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import Foundation

// (error: Error?)
public typealias PTCLCacheBlockVoidDNSError = (DNSError?) -> Void
// (object: Any?, error: Error?)
public typealias PTCLCacheBlockVoidAnyDNSError = (Any?, DNSError?) -> Void

public protocol PTCLCache_Protocol: PTCLBase_Protocol
{
    var nextWorker: PTCLCache_Protocol? { get }

    init()
    init(nextWorker: PTCLCache_Protocol)

    // MARK: - Business Logic / Single Item CRUD
    func doDeleteObject(for id: String,
                        with progress: PTCLProgressBlock?,
                        and block: PTCLCacheBlockVoidDNSError?) throws
    func doReadObject(for id: String,
                      with progress: PTCLProgressBlock?,
                      and block: PTCLCacheBlockVoidAnyDNSError?) throws
    func doLoadImage(from url: NSURL,
                     for id: String,
                     with progress: PTCLProgressBlock?,
                     and block: PTCLCacheBlockVoidAnyDNSError?) throws
    func doUpdate(object: Any,
                  for id: String,
                  with progress: PTCLProgressBlock?,
                  and block: PTCLCacheBlockVoidAnyDNSError?) throws
}
