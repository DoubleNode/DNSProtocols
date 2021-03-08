//
//  PTCLPassports_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import DNSCoreThreading
import DNSError
import DNSProtocols
import Foundation

public enum PTCLPassportsError: Error
{
    case unknown(_ codeLocation: CodeLocation)
    case notImplemented(_ codeLocation: CodeLocation)
}
extension PTCLPassportsError: DNSError {
    public static let domain = "PASSPORTS"
    public enum Code: Int
    {
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
            return NSLocalizedString("PASSPORTS-Unknown Error", comment: "")
                + " (\(Self.domain):\(Self.Code.unknown.rawValue))"
        case .notImplemented:
            return NSLocalizedString("PASSPORTS-Not Implemented", comment: "")
                + " (\(Self.domain):\(Self.Code.notImplemented.rawValue))"
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation):
            return codeLocation.failureReason
        case .notImplemented(let codeLocation):
            return codeLocation.failureReason
        }
    }
}

// (data: Data?, error: Error?)
public typealias PTCLPassportsBlockVoidDataError = (Data?, DNSError?) -> Void

public enum PTCLPassportsProtocolPassportTypes: String {
    case personalBarcode
}

public protocol PTCLPassports_Protocol: PTCLBase_Protocol {
    var nextWorker: PTCLPassports_Protocol? { get }

    init()
    init(nextWorker: PTCLPassports_Protocol)

    // MARK: - Business Logic / Single Item CRUD

    func doLoadPassport(of passportType: PTCLPassportsProtocolPassportTypes,
                        for account: MEEAccount,
                        with progress: PTCLProgressBlock?) -> AnyPublisher<Data, Error>
}
