//
//  WKRPTCLSystems.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCoreThreading
import DNSDataObjects
import DNSError
import UIKit

public extension DNSError {
    typealias Systems = WKRPTCLSystemsError
}
public enum WKRPTCLSystemsError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

    public static let domain = "WKRSYSTEMS"
    public enum Code: Int {
        case unknown = 1001
        case notImplemented = 1002
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
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return String(format: NSLocalizedString("WKRSYSTEMS-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRSYSTEMS-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
            .notImplemented(let codeLocation):
            return codeLocation.failureReason
        }
    }
}

// Protocol Return Types
public typealias WKRPTCLSystemsRtnBool = Bool
public typealias WKRPTCLSystemsRtnASystem = [DAOSystem]
public typealias WKRPTCLSystemsRtnSystem = DAOSystem?
public typealias WKRPTCLSystemsRtnASystemEndPoint = [DAOSystemEndPoint]
public typealias WKRPTCLSystemsRtnASystemState = [DAOSystemState]

// Protocol Publisher Types
public typealias WKRPTCLSystemsPubBool = AnyPublisher<WKRPTCLSystemsRtnBool, Error>

// Protocol Result Types
public typealias WKRPTCLSystemsResASystem = Result<WKRPTCLSystemsRtnASystem, Error>
public typealias WKRPTCLSystemsResSystem = Result<WKRPTCLSystemsRtnSystem, Error>
public typealias WKRPTCLSystemsResASystemEndPoint = Result<WKRPTCLSystemsRtnASystemEndPoint, Error>
public typealias WKRPTCLSystemsResASystemState = Result<WKRPTCLSystemsRtnASystemState, Error>

// Protocol Block Types
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

public protocol WKRPTCLSystems: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLSystems,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)
    
    // MARK: - Worker Logic (Public) -
    func doLoadSystem(for id: String,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLSystemsBlkSystem?) throws
    func doLoadEndPoints(for system: DAOSystem,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLSystemsBlkASystemEndPoint?) throws
    func doLoadHistory(for system: DAOSystem,
                       since time: Date,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLSystemsBlkASystemState?) throws
    func doLoadHistory(for endPoint: DAOSystemEndPoint,
                       since time: Date,
                       include failureCodes: Bool,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLSystemsBlkASystemState?) throws
    func doLoadSystems(with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLSystemsBlkASystem?) throws
    func doOverride(system: DAOSystem,
                    with state: DNSSystemState,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLSystemsBlkSystem?) throws
    func doReport(result: WKRPTCLSystemsData.Result,
                  for systemId: String,
                  and endPointId: String,
                  with progress: DNSPTCLProgressBlock?) -> WKRPTCLSystemsPubBool
    func doReport(result: WKRPTCLSystemsData.Result,
                  and failureCode: String,
                  for systemId: String,
                  and endPointId: String,
                  with progress: DNSPTCLProgressBlock?) -> WKRPTCLSystemsPubBool
    func doReport(result: WKRPTCLSystemsData.Result,
                  and failureCode: String,
                  and debugString: String,
                  for systemId: String,
                  and endPointId: String,
                  with progress: DNSPTCLProgressBlock?) -> WKRPTCLSystemsPubBool
    
    // MARK: - Worker Logic (Shortcuts) -
    func doLoadSystem(for id: String,
                      with block: WKRPTCLSystemsBlkSystem?) throws
    func doLoadEndPoints(for system: DAOSystem,
                         with block: WKRPTCLSystemsBlkASystemEndPoint?) throws
    func doLoadHistory(for system: DAOSystem,
                       since time: Date,
                       with block: WKRPTCLSystemsBlkASystemState?) throws
    func doLoadHistory(for endPoint: DAOSystemEndPoint,
                       since time: Date,
                       include failureCodes: Bool,
                       with block: WKRPTCLSystemsBlkASystemState?) throws
    func doLoadSystems(with block: WKRPTCLSystemsBlkASystem?) throws
    func doOverride(system: DAOSystem,
                    with state: DNSSystemState,
                    with block: WKRPTCLSystemsBlkSystem?) throws
    func doReport(result: WKRPTCLSystemsData.Result,
                  for systemId: String,
                  and endPointId: String) -> WKRPTCLSystemsPubBool
    func doReport(result: WKRPTCLSystemsData.Result,
                  and failureCode: String,
                  for systemId: String,
                  and endPointId: String) -> WKRPTCLSystemsPubBool
    func doReport(result: WKRPTCLSystemsData.Result,
                  and failureCode: String,
                  and debugString: String,
                  for systemId: String,
                  and endPointId: String) -> WKRPTCLSystemsPubBool
}
