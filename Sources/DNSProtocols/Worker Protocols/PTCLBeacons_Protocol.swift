//
//  PTCLBeacons_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import DNSDataObjects
import Foundation

public enum PTCLBeaconsError: Error
{
    case unknown(domain: String, file: String, line: String, method: String)
}
extension PTCLBeaconsError: DNSError {
    public static let domain = "BEACONS"
    public enum Code: Int
    {
        case unknown = 1001
    }
    
    public var nsError: NSError! {
        switch self {
        case .unknown(let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("BEACONS-Unknown Error", comment: "")
                + " (\(Self.domain):\(Self.Code.unknown.rawValue))"
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        }
    }
}

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
