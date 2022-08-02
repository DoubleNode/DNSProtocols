//
//  WKRPTCLPassports.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import DNSDataObjects
import DNSError
import Foundation

public extension DNSError {
    typealias Passports = WKRPTCLPassportsError
}
public enum WKRPTCLPassportsError: DNSError {
    case unknown(_ codeLocation: CodeLocation)
    case notImplemented(_ codeLocation: CodeLocation)
    case unknownType(passportType: String, _ codeLocation: CodeLocation)

    public static let domain = "WKRPASSPORTS"
    public enum Code: Int {
        case unknown = 1001
        case notImplemented = 1002
        case unknownType = 1003
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
        case .unknownType(let passportType, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["passportType"] = passportType
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknownType.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return String(format: NSLocalizedString("WKRPASSPORTS-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRPASSPORTS-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .unknownType(let passportType, _):
            return String(format: NSLocalizedString("WKRPASSPORTS-Unknown Type%@%@", comment: ""),
                          "\(passportType)",
                          " (\(Self.domain):\(Self.Code.unknownType.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation),
             .unknownType(_, let codeLocation):
            return codeLocation.failureReason
        }
    }
}

// Protocol Return Types
public typealias WKRPTCLPassportsRtnData = Data

// Protocol Publisher Types
public typealias WKRPTCLPassportsPubData = AnyPublisher<WKRPTCLPassportsRtnData, Error>

// Protocol Future Types
public typealias WKRPTCLPassportsFutData = Future<WKRPTCLPassportsRtnData, Error>

public protocol WKRPTCLPassports: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLPassports? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLPassports,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doBuildPassport(ofType passportType: String,
                         using data: [String: String],
                         for account: DAOAccount,
                         with progress: DNSPTCLProgressBlock?) -> WKRPTCLPassportsPubData

    // MARK: - Worker Logic (Shortcuts) -
    func doBuildPassport(ofType passportType: String,
                         using data: [String: String],
                         for account: DAOAccount) -> WKRPTCLPassportsPubData
}
