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

// Protocol Result Types
public typealias WKRPTCLSystemsResultArraySystem = Result<[DAOSystem], Error>
public typealias WKRPTCLSystemsResultArraySystemEndPoint = Result<[DAOSystemEndPoint], Error>
public typealias WKRPTCLSystemsResultArraySystemState = Result<[DAOSystemState], Error>
//
public typealias WKRPTCLSystemsResultSystem = Result<DAOSystem?, Error>

// Protocol Block Types
public typealias WKRPTCLSystemsBlockArraySystem = (WKRPTCLSystemsResultArraySystem) -> Void
public typealias WKRPTCLSystemsBlockArraySystemEndPoint = (WKRPTCLSystemsResultArraySystemEndPoint) -> Void
public typealias WKRPTCLSystemsBlockArraySystemState = (WKRPTCLSystemsResultArraySystemState) -> Void
//
public typealias WKRPTCLSystemsBlockSystem = (WKRPTCLSystemsResultSystem) -> Void

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
                      and block: WKRPTCLSystemsBlockSystem?) throws
    func doLoadEndPoints(for system: DAOSystem,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLSystemsBlockArraySystemEndPoint?) throws
    func doLoadHistory(for system: DAOSystem,
                       since time: Date,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLSystemsBlockArraySystemState?) throws
    func doLoadHistory(for endPoint: DAOSystemEndPoint,
                       since time: Date,
                       include failureCodes: Bool,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLSystemsBlockArraySystemState?) throws
    func doLoadSystems(with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLSystemsBlockArraySystem?) throws
    func doOverride(system: DAOSystem,
                    with state: DNSSystemState,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLSystemsBlockSystem?) throws
    func doReport(result: WKRPTCLSystemsData.Result,
                  for systemId: String,
                  and endPointId: String,
                  with progress: DNSPTCLProgressBlock?) -> AnyPublisher<Bool, Error>
    func doReport(result: WKRPTCLSystemsData.Result,
                  and failureCode: String,
                  for systemId: String,
                  and endPointId: String,
                  with progress: DNSPTCLProgressBlock?) -> AnyPublisher<Bool, Error>
    func doReport(result: WKRPTCLSystemsData.Result,
                  and failureCode: String,
                  and debugString: String,
                  for systemId: String,
                  and endPointId: String,
                  with progress: DNSPTCLProgressBlock?) -> AnyPublisher<Bool, Error>
    
    // MARK: - Worker Logic (Shortcuts) -
    func doLoadSystem(for id: String,
                      with block: WKRPTCLSystemsBlockSystem?) throws
    func doLoadEndPoints(for system: DAOSystem,
                         with block: WKRPTCLSystemsBlockArraySystemEndPoint?) throws
    func doLoadHistory(for system: DAOSystem,
                       since time: Date,
                       with block: WKRPTCLSystemsBlockArraySystemState?) throws
    func doLoadHistory(for endPoint: DAOSystemEndPoint,
                       since time: Date,
                       include failureCodes: Bool,
                       with block: WKRPTCLSystemsBlockArraySystemState?) throws
    func doLoadSystems(with block: WKRPTCLSystemsBlockArraySystem?) throws
    func doOverride(system: DAOSystem,
                    with state: DNSSystemState,
                    with block: WKRPTCLSystemsBlockSystem?) throws
    func doReport(result: WKRPTCLSystemsData.Result,
                  for systemId: String,
                  and endPointId: String) -> AnyPublisher<Bool, Error>
    func doReport(result: WKRPTCLSystemsData.Result,
                  and failureCode: String,
                  for systemId: String,
                  and endPointId: String) -> AnyPublisher<Bool, Error>
    func doReport(result: WKRPTCLSystemsData.Result,
                  and failureCode: String,
                  and debugString: String,
                  for systemId: String,
                  and endPointId: String) -> AnyPublisher<Bool, Error>
}
