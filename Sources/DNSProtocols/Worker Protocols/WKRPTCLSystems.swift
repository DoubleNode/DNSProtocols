//
//  WKRPTCLSystems.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLSystemsRtnMeta = DNSMetadata
public typealias WKRPTCLSystemsRtnASystem = [DAOSystem]
public typealias WKRPTCLSystemsRtnSystem = DAOSystem
public typealias WKRPTCLSystemsRtnASystemEndPoint = [DAOSystemEndPoint]
public typealias WKRPTCLSystemsRtnASystemState = [DAOSystemState]
public typealias WKRPTCLSystemsRtnVoid = Void

// Protocol Publisher Types
public typealias WKRPTCLSystemsPubVoid = AnyPublisher<WKRPTCLSystemsRtnVoid, Error>

// Protocol Future Types
public typealias WKRPTCLSystemsFutVoid = Future<WKRPTCLSystemsRtnVoid, Error>

// Protocol Result Types
public typealias WKRPTCLSystemsResMeta = Result<WKRPTCLSystemsRtnMeta, Error>
public typealias WKRPTCLSystemsResASystem = Result<WKRPTCLSystemsRtnASystem, Error>
public typealias WKRPTCLSystemsResSystem = Result<WKRPTCLSystemsRtnSystem, Error>
public typealias WKRPTCLSystemsResASystemEndPoint = Result<WKRPTCLSystemsRtnASystemEndPoint, Error>
public typealias WKRPTCLSystemsResASystemState = Result<WKRPTCLSystemsRtnASystemState, Error>

// Protocol Block Types
public typealias WKRPTCLSystemsBlkMeta = (WKRPTCLSystemsResMeta) -> Void
public typealias WKRPTCLSystemsBlkASystem = (WKRPTCLSystemsResASystem) -> Void
public typealias WKRPTCLSystemsBlkSystem = (WKRPTCLSystemsResSystem) -> Void
public typealias WKRPTCLSystemsBlkASystemEndPoint = (WKRPTCLSystemsResASystemEndPoint) -> Void
public typealias WKRPTCLSystemsBlkASystemState = (WKRPTCLSystemsResASystemState) -> Void

public struct WKRPTCLSystemsData {
    public enum Result: String {
        case failure
        case success
    }
}
public struct WKRPTCLSystemsStateData {
    public static var empty = WKRPTCLSystemsStateData(system: "", endPoint: "", sendDebug: false)

    public var system: String
    public var endPoint: String
    public var sendDebug: Bool
    
    public init(system: String, endPoint: String, sendDebug: Bool) {
        self.system = system
        self.endPoint = endPoint
        self.sendDebug = sendDebug
    }
}

public protocol WKRPTCLSystems: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLSystems,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)
    
    // MARK: - Worker Logic (Public) -
    func doLoadSystem(for id: String,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLSystemsBlkSystem?)
    func doLoadEndPoints(for system: DAOSystem,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLSystemsBlkASystemEndPoint?)
    func doLoadHistory(for system: DAOSystem,
                       since time: Date,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLSystemsBlkASystemState?)
    func doLoadHistory(for endPoint: DAOSystemEndPoint,
                       since time: Date,
                       include failureCodes: Bool,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLSystemsBlkASystemState?)
    func doLoadSystems(with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLSystemsBlkASystem?)
    func doOverride(system: DAOSystem,
                    with state: DNSSystemState,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLSystemsBlkSystem?)
    func doReact(with reaction: DNSReactionType,
                 to system: DAOSystem,
                 with progress: DNSPTCLProgressBlock?,
                 and block: WKRPTCLSystemsBlkMeta?)
    func doReport(result: WKRPTCLSystemsData.Result,
                  for systemId: String,
                  and endPointId: String,
                  with progress: DNSPTCLProgressBlock?) -> WKRPTCLSystemsPubVoid
    func doReport(result: WKRPTCLSystemsData.Result,
                  and failureCode: String,
                  for systemId: String,
                  and endPointId: String,
                  with progress: DNSPTCLProgressBlock?) -> WKRPTCLSystemsPubVoid
    func doReport(result: WKRPTCLSystemsData.Result,
                  and failureCode: String,
                  and debugString: String,
                  for systemId: String,
                  and endPointId: String,
                  with progress: DNSPTCLProgressBlock?) -> WKRPTCLSystemsPubVoid
    
    // MARK: - Worker Logic (Shortcuts) -
    func doLoadSystem(for id: String,
                      with block: WKRPTCLSystemsBlkSystem?)
    func doLoadEndPoints(for system: DAOSystem,
                         with block: WKRPTCLSystemsBlkASystemEndPoint?)
    func doLoadHistory(for system: DAOSystem,
                       since time: Date,
                       with block: WKRPTCLSystemsBlkASystemState?)
    func doLoadHistory(for endPoint: DAOSystemEndPoint,
                       since time: Date,
                       include failureCodes: Bool,
                       with block: WKRPTCLSystemsBlkASystemState?)
    func doLoadSystems(with block: WKRPTCLSystemsBlkASystem?)
    func doOverride(system: DAOSystem,
                    with state: DNSSystemState,
                    with block: WKRPTCLSystemsBlkSystem?)// Protocol Return Types
    func doReact(with reaction: DNSReactionType,
                 to system: DAOSystem,
                 with block: WKRPTCLSystemsBlkMeta?)
    func doReport(result: WKRPTCLSystemsData.Result,
                  for systemId: String,
                  and endPointId: String) -> WKRPTCLSystemsPubVoid
    func doReport(result: WKRPTCLSystemsData.Result,
                  and failureCode: String,
                  for systemId: String,
                  and endPointId: String) -> WKRPTCLSystemsPubVoid
    func doReport(result: WKRPTCLSystemsData.Result,
                  and failureCode: String,
                  and debugString: String,
                  for systemId: String,
                  and endPointId: String) -> WKRPTCLSystemsPubVoid
}
