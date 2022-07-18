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

public struct PTCLSystemsData {
    public enum Result: String {
        case failure
        case success
    }
}

public protocol WKRPTCLSystems: WKRPTCLWorkerBase {
    var callNextWhen: WKRPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLSystems,
                  for callNextWhen: WKRPTCLWorker.Call.NextWhen)
    
    // MARK: - Business Logic / Single Item CRUD
    func doLoadSystem(for id: String,
                      with progress: WKRPTCLProgressBlock?,
                      and block: WKRPTCLSystemsBlockSystem?) throws
    func doLoadEndPoints(for system: DAOSystem,
                         with progress: WKRPTCLProgressBlock?,
                         and block: WKRPTCLSystemsBlockArraySystemEndPoint?) throws
    func doLoadHistory(for system: DAOSystem,
                       since time: Date,
                       with progress: WKRPTCLProgressBlock?,
                       and block: WKRPTCLSystemsBlockArraySystemState?) throws
    func doLoadHistory(for endPoint: DAOSystemEndPoint,
                       since time: Date,
                       include failureCodes: Bool,
                       with progress: WKRPTCLProgressBlock?,
                       and block: WKRPTCLSystemsBlockArraySystemState?) throws
    func doLoadSystems(with progress: WKRPTCLProgressBlock?,
                       and block: WKRPTCLSystemsBlockArraySystem?) throws
    func doOverride(system: DAOSystem,
                    with state: DNSSystemState,
                    with progress: WKRPTCLProgressBlock?,
                    and block: WKRPTCLSystemsBlockSystem?) throws
    func doReport(result: PTCLSystemsData.Result,
                  for systemId: String,
                  and endPointId: String,
                  with progress: WKRPTCLProgressBlock?) -> AnyPublisher<Bool, Error>
    func doReport(result: PTCLSystemsData.Result,
                  and failureCode: String,
                  for systemId: String,
                  and endPointId: String,
                  with progress: WKRPTCLProgressBlock?) -> AnyPublisher<Bool, Error>
    func doReport(result: PTCLSystemsData.Result,
                  and failureCode: String,
                  and debugString: String,
                  for systemId: String,
                  and endPointId: String,
                  with progress: WKRPTCLProgressBlock?) -> AnyPublisher<Bool, Error>
}
