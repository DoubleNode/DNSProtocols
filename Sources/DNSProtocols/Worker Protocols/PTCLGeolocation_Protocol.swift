//
//  PTCLGeolocation_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import Foundation

// (geohash: String, error: Error?)
public typealias PTCLGeolocationBlockVoidStringDNSError = (String, DNSError?) -> Void

public protocol PTCLGeolocation_Protocol: PTCLBase_Protocol {
    var nextWorker: PTCLGeolocation_Protocol? { get }

    init()
    init(nextWorker: PTCLGeolocation_Protocol)

    // MARK: - Business Logic / Single Item CRUD

    func doLocate(with progress: PTCLProgressBlock?,
                  and block: PTCLGeolocationBlockVoidStringDNSError?) throws

    func doTrackLocation(for processKey: String,
                         with progress: PTCLProgressBlock?,
                         and block: PTCLGeolocationBlockVoidStringDNSError?) throws

    func doStopTrackLocation(for processKey: String) throws
}
