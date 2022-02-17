//
//  PTCLSystemsState.swift
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
    typealias Systems = PTCLSystemsError
}
public enum PTCLSystemsError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

    public static let domain = "SYSTEMS"
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
            return String(format: NSLocalizedString("SYSTEMS-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("SYSTEMS-Not Implemented%@", comment: ""),
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

public typealias PTCLSystemsResultArraySystem = Result<[DAOSystem], Error>
public typealias PTCLSystemsResultArraySystemEndPoint = Result<[DAOSystemEndPoint], Error>
public typealias PTCLSystemsResultArraySystemState = Result<[DAOSystemState], Error>
public typealias PTCLSystemsResultSystem = Result<DAOSystem?, Error>

public typealias PTCLSystemsBlockVoidArraySystem = (PTCLSystemsResultArraySystem) -> Void
public typealias PTCLSystemsBlockVoidArraySystemEndPoint = (PTCLSystemsResultArraySystemEndPoint) -> Void
public typealias PTCLSystemsBlockVoidArraySystemState = (PTCLSystemsResultArraySystemState) -> Void
public typealias PTCLSystemsBlockVoidSystem = (PTCLSystemsResultSystem) -> Void

public protocol PTCLSystems: PTCLProtocolBase {
    var callNextWhen: PTCLProtocol.Call.NextWhen { get }
    var nextWorker: PTCLSystems? { get }
    
    init()
    func register(nextWorker: PTCLSystems,
                  for callNextWhen: PTCLProtocol.Call.NextWhen)
    
    // MARK: - Business Logic / Single Item CRUD
    func doLoadSystem(for id: String,
                      with progress: PTCLProgressBlock?,
                      and block: PTCLSystemsBlockVoidSystem?) throws
    func doLoadEndPoints(for system: DAOSystem,
                         with progress: PTCLProgressBlock?,
                         and block: PTCLSystemsBlockVoidArraySystemEndPoint?) throws
    func doLoadHistory(for system: DAOSystem,
                       with progress: PTCLProgressBlock?,
                       and block: PTCLSystemsBlockVoidArraySystemState?) throws
    func doLoadSystems(with progress: PTCLProgressBlock?,
                       and block: PTCLSystemsBlockVoidArraySystem?) throws
    func doReport(state: String,
                  for systemId: String,
                  and endPointId: String,
                  with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error>
}
