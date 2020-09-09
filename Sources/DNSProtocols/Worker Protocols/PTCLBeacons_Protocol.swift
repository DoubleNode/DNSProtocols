//
//  PTCLBeacons_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
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

    func doLoadBeacons(in center: DAOCenter,
                       with progress: PTCLProgressBlock?,
                       and block: PTCLBeaconsBlockVoidArrayDAOBeaconError?) throws
    func doLoadBeacons(in center: DAOCenter,
                       for activity: DAOActivity,
                       with progress: PTCLProgressBlock?,
                       and block: PTCLBeaconsBlockVoidArrayDAOBeaconError?) throws
    func doRangeBeacons(named uuids: [UUID],
                        for processKey: String,
                        with progress: PTCLProgressBlock?,
                        and block: PTCLBeaconsBlockVoidArrayDAOBeaconError?) throws
    func doStopRangeBeacons(for processKey: String) throws
}
