//
//  PTCLCenters.swift
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
    typealias Centers = PTCLCentersError
}
public enum PTCLCentersError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case notFound(centerId: String, _ codeLocation: DNSCodeLocation)

    public static let domain = "CENTERS"
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
            return String(format: NSLocalizedString("CENTERS-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("CENTERS-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .notFound(let centerId, _):
            return String(format: NSLocalizedString("CENTERS-Not Found%@%@", comment: ""),
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

public typealias PTCLCentersResultArrayCenter = Result<[DAOCenter], Error>
public typealias PTCLCentersResultArrayCenterState = Result<([DAOAlert], [DAOCenterEvent], [DAOCenterStatus]), Error>
public typealias PTCLCentersResultBool = Result<Bool, Error>
public typealias PTCLCentersResultCenter = Result<DAOCenter?, Error>
public typealias PTCLCentersResultArrayCenterHoliday = Result<([DAOCenterHoliday]), Error>
public typealias PTCLCentersResultCenterHours = Result<DAOCenterHours?, Error>

public typealias PTCLCentersBlockVoidArrayCenter = (PTCLCentersResultArrayCenter) -> Void
public typealias PTCLCentersBlockVoidArrayCenterState = (PTCLCentersResultArrayCenterState) -> Void
public typealias PTCLCentersBlockVoidBool = (PTCLCentersResultBool) -> Void
public typealias PTCLCentersBlockVoidCenter = (PTCLCentersResultCenter) -> Void
public typealias PTCLCentersBlockVoidCenterHours = (PTCLCentersResultCenterHours) -> Void
public typealias PTCLCentersBlockVoidArrayCenterHoliday = (PTCLCentersResultArrayCenterHoliday) -> Void

public protocol PTCLCenters: PTCLProtocolBase {
    var callNextWhen: PTCLProtocol.Call.NextWhen { get }
    var nextWorker: PTCLCenters? { get }
    var systemsWorker: PTCLSystems? { get }

    init()
    func register(nextWorker: PTCLCenters,
                  for callNextWhen: PTCLProtocol.Call.NextWhen)

    // MARK: - Business Logic / Single Item CRUD
    func doFilterCenters(for activity: DAOActivity,
                         using centers: [DAOCenter],
                         with progress: PTCLProgressBlock?,
                         and block: PTCLCentersBlockVoidArrayCenter?) throws
    func doLoadCenter(for centerCode: String,
                      with progress: PTCLProgressBlock?,
                      and block: PTCLCentersBlockVoidCenter?) throws
    func doLoadCenters(with progress: PTCLProgressBlock?,
                       and block: PTCLCentersBlockVoidArrayCenter?) throws
    func doLoadHolidays(for center: DAOCenter,
                        with progress: PTCLProgressBlock?,
                        and block: PTCLCentersBlockVoidArrayCenterHoliday?) throws
    func doLoadHours(for center: DAOCenter,
                     with progress: PTCLProgressBlock?,
                     and block: PTCLCentersBlockVoidCenterHours?) throws
    func doLoadState(for center: DAOCenter,
                     with progress: PTCLProgressBlock?) -> AnyPublisher<([DAOAlert], [DAOCenterEvent], [DAOCenterStatus]), Error>
    func doSearchCenter(for geohash: String,
                        with progress: PTCLProgressBlock?,
                        and block: PTCLCentersBlockVoidCenter?) throws
    func doUpdate(_ center: DAOCenter,
                  with progress: PTCLProgressBlock?,
                  and block: PTCLCentersBlockVoidBool?) throws
    func doUpdate(_ hours: DAOCenterHours,
                  for center: DAOCenter,
                  with progress: PTCLProgressBlock?,
                  and block: PTCLCentersBlockVoidBool?) throws
}
