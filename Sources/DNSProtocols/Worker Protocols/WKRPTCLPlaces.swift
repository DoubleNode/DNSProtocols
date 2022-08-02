//
//  WKRPTCLPlaces.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCoreThreading
import DNSDataObjects
import DNSError
import Foundation

public extension DNSError {
    typealias Places = WKRPTCLPlacesError
}
public enum WKRPTCLPlacesError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case notFound(placeId: String, _ codeLocation: DNSCodeLocation)

    public static let domain = "WKRPLACES"
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
        case .notFound(let placeId, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["placeId"] = placeId
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
            return String(format: NSLocalizedString("WKRPLACES-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRPLACES-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .notFound(let placeId, _):
            return String(format: NSLocalizedString("WKRPLACES-Not Found%@%@", comment: ""),
                          "\(placeId)",
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
public typealias WKRPTCLPlacesRtnAlertEventStatus = ([DAOAlert], [DAOPlaceEvent], [DAOPlaceStatus])
public typealias WKRPTCLPlacesRtnAPlace = [DAOPlace]
public typealias WKRPTCLPlacesRtnPlace = DAOPlace
public typealias WKRPTCLPlacesRtnAPlaceHoliday = [DAOPlaceHoliday]
public typealias WKRPTCLPlacesRtnPlaceHours = DAOPlaceHours
public typealias WKRPTCLPlacesRtnAPlaceState = ([DAOAlert], [DAOPlaceEvent], [DAOPlaceStatus])
public typealias WKRPTCLPlacesRtnVoid = Void

// Protocol Publisher Types
public typealias WKRPTCLPlacesPubAlertEventStatus = AnyPublisher<WKRPTCLPlacesRtnAlertEventStatus, Error>

// Protocol Result Types
public typealias WKRPTCLPlacesResAPlace = Result<WKRPTCLPlacesRtnAPlace, Error>
public typealias WKRPTCLPlacesResPlace = Result<WKRPTCLPlacesRtnPlace, Error>
public typealias WKRPTCLPlacesResAPlaceHoliday = Result<WKRPTCLPlacesRtnAPlaceHoliday, Error>
public typealias WKRPTCLPlacesResPlaceHours = Result<WKRPTCLPlacesRtnPlaceHours, Error>
public typealias WKRPTCLPlacesResAPlaceState = Result<WKRPTCLPlacesRtnAPlaceState, Error>
public typealias WKRPTCLPlacesResVoid = Result<WKRPTCLPlacesRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLPlacesBlkAPlace = (WKRPTCLPlacesResAPlace) -> Void
public typealias WKRPTCLPlacesBlkPlace = (WKRPTCLPlacesResPlace) -> Void
public typealias WKRPTCLPlacesBlkAPlaceHoliday = (WKRPTCLPlacesResAPlaceHoliday) -> Void
public typealias WKRPTCLPlacesBlkPlaceHours = (WKRPTCLPlacesResPlaceHours) -> Void
public typealias WKRPTCLPlacesBlkAPlaceState = (WKRPTCLPlacesResAPlaceState) -> Void
public typealias WKRPTCLPlacesBlkVoid = (WKRPTCLPlacesResVoid) -> Void

public protocol WKRPTCLPlaces: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLPlaces? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLPlaces,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doFilterPlaces(for activity: DAOActivity,
                         using places: [DAOPlace],
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLPlacesBlkAPlace?) throws
    func doLoadPlace(for placeCode: String,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLPlacesBlkPlace?) throws
    func doLoadPlaces(with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLPlacesBlkAPlace?) throws
    func doLoadHolidays(for place: DAOPlace,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLPlacesBlkAPlaceHoliday?) throws
    func doLoadHours(for place: DAOPlace,
                     with progress: DNSPTCLProgressBlock?,
                     and block: WKRPTCLPlacesBlkPlaceHours?) throws
    func doLoadState(for place: DAOPlace,
                     with progress: DNSPTCLProgressBlock?) -> WKRPTCLPlacesPubAlertEventStatus
    func doSearchPlace(for geohash: String,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLPlacesBlkPlace?) throws
    func doUpdate(_ place: DAOPlace,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLPlacesBlkVoid?) throws
    func doUpdate(_ hours: DAOPlaceHours,
                  for place: DAOPlace,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLPlacesBlkVoid?) throws

    // MARK: - Worker Logic (Shortcuts) -
    func doFilterPlaces(for activity: DAOActivity,
                         using places: [DAOPlace],
                         with block: WKRPTCLPlacesBlkAPlace?) throws
    func doLoadPlace(for placeCode: String,
                      with block: WKRPTCLPlacesBlkPlace?) throws
    func doLoadPlaces(with block: WKRPTCLPlacesBlkAPlace?) throws
    func doLoadHolidays(for place: DAOPlace,
                        with block: WKRPTCLPlacesBlkAPlaceHoliday?) throws
    func doLoadHours(for place: DAOPlace,
                     with block: WKRPTCLPlacesBlkPlaceHours?) throws
    func doLoadState(for place: DAOPlace) -> WKRPTCLPlacesPubAlertEventStatus
    func doSearchPlace(for geohash: String,
                        with block: WKRPTCLPlacesBlkPlace?) throws
    func doUpdate(_ place: DAOPlace,
                  with block: WKRPTCLPlacesBlkVoid?) throws
    func doUpdate(_ hours: DAOPlaceHours,
                  for place: DAOPlace,
                  with block: WKRPTCLPlacesBlkVoid?) throws
}
