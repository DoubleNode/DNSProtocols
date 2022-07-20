//
//  WKRPTCLCenters.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCoreThreading
import DNSDataObjects
import DNSError
import Foundation

public extension DNSError {
    typealias Centers = WKRPTCLCentersError
}
public enum WKRPTCLCentersError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case notFound(centerId: String, _ codeLocation: DNSCodeLocation)

    public static let domain = "WKRCENTERS"
    public enum Code: Int {
        case unknown = 1001
        case notImplemented = 1002
        case notFound = 1003
    }

    public var nsError: NSError! {
        switch self {
        case .unknown(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        case .notImplemented(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notImplemented.rawValue,
                                userInfo: userInfo)
        case .notFound(let centerId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["centerId"] = centerId
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notImplemented.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return String(format: NSLocalizedString("WKRCENTERS-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRCENTERS-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .notFound(let centerId, _):
            return String(format: NSLocalizedString("WKRCENTERS-Not Found%@%@", comment: ""),
                          "\(centerId)",
                          "(\(Self.domain):\(Self.Code.notFound.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation),
             .notFound(_, let codeLocation):
            return codeLocation.failureReason
        }
    }
}

// Protocol Return Types
public typealias WKRPTCLCentersRtnAlertEventStatus = ([DAOAlert], [DAOCenterEvent], [DAOCenterStatus])
public typealias WKRPTCLCentersRtnBool = Bool
public typealias WKRPTCLCentersRtnACenter = [DAOCenter]
public typealias WKRPTCLCentersRtnCenter = DAOCenter?
public typealias WKRPTCLCentersRtnACenterHoliday = [DAOCenterHoliday]
public typealias WKRPTCLCentersRtnCenterHours = DAOCenterHours?
public typealias WKRPTCLCentersRtnACenterState = ([DAOAlert], [DAOCenterEvent], [DAOCenterStatus])

// Protocol Publisher Types
public typealias WKRPTCLCentersPubAlertEventStatus = AnyPublisher<WKRPTCLCentersRtnAlertEventStatus, Error>

// Protocol Result Types
public typealias WKRPTCLCentersResBool = Result<WKRPTCLCentersRtnBool, Error>
public typealias WKRPTCLCentersResACenter = Result<WKRPTCLCentersRtnACenter, Error>
public typealias WKRPTCLCentersResCenter = Result<WKRPTCLCentersRtnCenter, Error>
public typealias WKRPTCLCentersResACenterHoliday = Result<WKRPTCLCentersRtnACenterHoliday, Error>
public typealias WKRPTCLCentersResCenterHours = Result<WKRPTCLCentersRtnCenterHours, Error>
public typealias WKRPTCLCentersResACenterState = Result<WKRPTCLCentersRtnACenterState, Error>

// Protocol Block Types
public typealias WKRPTCLCentersBlkACenter = (WKRPTCLCentersResACenter) -> Void
public typealias WKRPTCLCentersBlkACenterHoliday = (WKRPTCLCentersResACenterHoliday) -> Void
public typealias WKRPTCLCentersBlkACenterState = (WKRPTCLCentersResACenterState) -> Void
//
public typealias WKRPTCLCentersBlkBool = (WKRPTCLCentersResBool) -> Void
public typealias WKRPTCLCentersBlkCenter = (WKRPTCLCentersResCenter) -> Void
public typealias WKRPTCLCentersBlkCenterHours = (WKRPTCLCentersResCenterHours) -> Void

public protocol WKRPTCLCenters: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLCenters? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLCenters,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doFilterCenters(for activity: DAOActivity,
                         using centers: [DAOCenter],
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCentersBlkACenter?) throws
    func doLoadCenter(for centerCode: String,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLCentersBlkCenter?) throws
    func doLoadCenters(with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLCentersBlkACenter?) throws
    func doLoadHolidays(for center: DAOCenter,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLCentersBlkACenterHoliday?) throws
    func doLoadHours(for center: DAOCenter,
                     with progress: DNSPTCLProgressBlock?,
                     and block: WKRPTCLCentersBlkCenterHours?) throws
    func doLoadState(for center: DAOCenter,
                     with progress: DNSPTCLProgressBlock?) -> WKRPTCLCentersPubAlertEventStatus
    func doSearchCenter(for geohash: String,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLCentersBlkCenter?) throws
    func doUpdate(_ center: DAOCenter,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLCentersBlkBool?) throws
    func doUpdate(_ hours: DAOCenterHours,
                  for center: DAOCenter,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLCentersBlkBool?) throws

    // MARK: - Worker Logic (Shortcuts) -
    func doFilterCenters(for activity: DAOActivity,
                         using centers: [DAOCenter],
                         with block: WKRPTCLCentersBlkACenter?) throws
    func doLoadCenter(for centerCode: String,
                      with block: WKRPTCLCentersBlkCenter?) throws
    func doLoadCenters(with block: WKRPTCLCentersBlkACenter?) throws
    func doLoadHolidays(for center: DAOCenter,
                        with block: WKRPTCLCentersBlkACenterHoliday?) throws
    func doLoadHours(for center: DAOCenter,
                     with block: WKRPTCLCentersBlkCenterHours?) throws
    func doLoadState(for center: DAOCenter) -> WKRPTCLCentersPubAlertEventStatus
    func doSearchCenter(for geohash: String,
                        with block: WKRPTCLCentersBlkCenter?) throws
    func doUpdate(_ center: DAOCenter,
                  with block: WKRPTCLCentersBlkBool?) throws
    func doUpdate(_ hours: DAOCenterHours,
                  for center: DAOCenter,
                  with block: WKRPTCLCentersBlkBool?) throws
}
