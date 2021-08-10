//
//  PTCLPassports_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import DNSDataObjects
import DNSError
import Foundation

public enum PTCLPassportsError: Error
{
    case unknown(_ codeLocation: CodeLocation)
    case notImplemented(_ codeLocation: CodeLocation)
    case unknownType(passportType: String, _ codeLocation: CodeLocation)
}
extension PTCLPassportsError: DNSError {
    public static let domain = "PASSPORTS"
    public enum Code: Int
    {
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
            return String(format: NSLocalizedString("PASSPORTS-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("PASSPORTS-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .unknownType(let passportType, _):
            return String(format: NSLocalizedString("PASSPORTS-Unknown Type: %@%@", comment: ""),
                          passportType) + " (\(Self.domain):\(Self.Code.unknownType.rawValue))"
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

public protocol PTCLPassports_Protocol: PTCLBase_Protocol {
    var callNextWhen: PTCLCallNextWhen { get }
    var nextWorker: PTCLPassports_Protocol? { get }

    init()
    func register(nextWorker: PTCLPassports_Protocol,
                  for callNextWhen: PTCLCallNextWhen)

    // MARK: - Business Logic / Single Item CRUD

    func doBuildPassport(type passportType: String,
                         using data: [String: String],
                         for account: DAOAccount,
                         with progress: PTCLProgressBlock?) -> AnyPublisher<Data, Error>
}
