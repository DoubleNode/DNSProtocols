//
//  WKRPTCLPlaces.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSDataObjects
import Foundation

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

// Protocol Future Types
public typealias WKRPTCLPlacesFutAlertEventStatus = Future<WKRPTCLPlacesRtnAlertEventStatus, Error>

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
    var wkrSystems: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLPlaces,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doFilterPlaces(for activity: DAOActivity,
                         using places: [DAOPlace],
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLPlacesBlkAPlace?)
    func doLoadPlace(for placeCode: String,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLPlacesBlkPlace?)
    func doLoadPlaces(with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLPlacesBlkAPlace?)
    func doLoadHolidays(for place: DAOPlace,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLPlacesBlkAPlaceHoliday?)
    func doLoadHours(for place: DAOPlace,
                     with progress: DNSPTCLProgressBlock?,
                     and block: WKRPTCLPlacesBlkPlaceHours?)
    func doLoadState(for place: DAOPlace,
                     with progress: DNSPTCLProgressBlock?) -> WKRPTCLPlacesPubAlertEventStatus
    func doSearchPlace(for geohash: String,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLPlacesBlkPlace?)
    func doUpdate(_ place: DAOPlace,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLPlacesBlkVoid?)
    func doUpdate(_ hours: DAOPlaceHours,
                  for place: DAOPlace,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLPlacesBlkVoid?)

    // MARK: - Worker Logic (Shortcuts) -
    func doFilterPlaces(for activity: DAOActivity,
                         using places: [DAOPlace],
                         with block: WKRPTCLPlacesBlkAPlace?)
    func doLoadPlace(for placeCode: String,
                      with block: WKRPTCLPlacesBlkPlace?)
    func doLoadPlaces(with block: WKRPTCLPlacesBlkAPlace?)
    func doLoadHolidays(for place: DAOPlace,
                        with block: WKRPTCLPlacesBlkAPlaceHoliday?)
    func doLoadHours(for place: DAOPlace,
                     with block: WKRPTCLPlacesBlkPlaceHours?)
    func doLoadState(for place: DAOPlace) -> WKRPTCLPlacesPubAlertEventStatus
    func doSearchPlace(for geohash: String,
                        with block: WKRPTCLPlacesBlkPlace?)
    func doUpdate(_ place: DAOPlace,
                  with block: WKRPTCLPlacesBlkVoid?)
    func doUpdate(_ hours: DAOPlaceHours,
                  for place: DAOPlace,
                  with block: WKRPTCLPlacesBlkVoid?)
}
