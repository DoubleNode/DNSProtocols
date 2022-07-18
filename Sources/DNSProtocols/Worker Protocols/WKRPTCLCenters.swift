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

// Protocol Result Types
public typealias WKRPTCLCentersResultArrayCenter = Result<[DAOCenter], Error>
public typealias WKRPTCLCentersResultArrayCenterHoliday = Result<([DAOCenterHoliday]), Error>
public typealias WKRPTCLCentersResultArrayCenterState = Result<([DAOAlert], [DAOCenterEvent], [DAOCenterStatus]), Error>
//
public typealias WKRPTCLCentersResultBool = Result<Bool, Error>
public typealias WKRPTCLCentersResultCenter = Result<DAOCenter?, Error>
public typealias WKRPTCLCentersResultCenterHours = Result<DAOCenterHours?, Error>

// Protocol Block Types
public typealias WKRPTCLCentersBlockArrayCenter = (WKRPTCLCentersResultArrayCenter) -> Void
public typealias WKRPTCLCentersBlockArrayCenterHoliday = (WKRPTCLCentersResultArrayCenterHoliday) -> Void
public typealias WKRPTCLCentersBlockArrayCenterState = (WKRPTCLCentersResultArrayCenterState) -> Void
//
public typealias WKRPTCLCentersBlockBool = (WKRPTCLCentersResultBool) -> Void
public typealias WKRPTCLCentersBlockCenter = (WKRPTCLCentersResultCenter) -> Void
public typealias WKRPTCLCentersBlockCenterHours = (WKRPTCLCentersResultCenterHours) -> Void

public protocol WKRPTCLCenters: WKRPTCLWorkerBase {
    var callNextWhen: WKRPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLCenters? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLCenters,
                  for callNextWhen: WKRPTCLWorker.Call.NextWhen)

    // MARK: - Business Logic / Single Item CRUD
    func doFilterCenters(for activity: DAOActivity,
                         using centers: [DAOCenter],
                         with progress: WKRPTCLProgressBlock?,
                         and block: WKRPTCLCentersBlockArrayCenter?) throws
    func doLoadCenter(for centerCode: String,
                      with progress: WKRPTCLProgressBlock?,
                      and block: WKRPTCLCentersBlockCenter?) throws
    func doLoadCenters(with progress: WKRPTCLProgressBlock?,
                       and block: WKRPTCLCentersBlockArrayCenter?) throws
    func doLoadHolidays(for center: DAOCenter,
                        with progress: WKRPTCLProgressBlock?,
                        and block: WKRPTCLCentersBlockArrayCenterHoliday?) throws
    func doLoadHours(for center: DAOCenter,
                     with progress: WKRPTCLProgressBlock?,
                     and block: WKRPTCLCentersBlockCenterHours?) throws
    func doLoadState(for center: DAOCenter,
                     with progress: WKRPTCLProgressBlock?) -> AnyPublisher<([DAOAlert], [DAOCenterEvent], [DAOCenterStatus]), Error>
    func doSearchCenter(for geohash: String,
                        with progress: WKRPTCLProgressBlock?,
                        and block: WKRPTCLCentersBlockCenter?) throws
    func doUpdate(_ center: DAOCenter,
                  with progress: WKRPTCLProgressBlock?,
                  and block: WKRPTCLCentersBlockBool?) throws
    func doUpdate(_ hours: DAOCenterHours,
                  for center: DAOCenter,
                  with progress: WKRPTCLProgressBlock?,
                  and block: WKRPTCLCentersBlockBool?) throws
}
