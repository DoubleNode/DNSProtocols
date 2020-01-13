//
//  PTCLBeacons_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import DNSDataObjects
import Foundation

// (beacons: [DAOBeacon], error: Error?)
public typealias PTCLBeaconsBlockVoidArrayDAOBeaconError = ([DAOBeacon], DNSError?) -> Void

public protocol PTCLBeacons_Protocol: PTCLBase_Protocol {
    var nextWorker: PTCLBeacons_Protocol? { get }

    init()
    init(nextWorker: PTCLBeacons_Protocol)

    // MARK: - Business Logic / Single Item CRUD

    func doRangeBeacons(named uuids: [UUID],
                        for processKey: String,
                        with progress: PTCLProgressBlock?,
                        and block: PTCLBeaconsBlockVoidArrayDAOBeaconError?) throws

    func doStopRangeBeacons(for processKey: String) throws
}
