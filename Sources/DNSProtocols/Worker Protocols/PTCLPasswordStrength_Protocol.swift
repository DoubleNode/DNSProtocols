//
//  PTCLPasswordStrength_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import DNSDataObjects
import DNSError
import Foundation

public enum PTCLPasswordStrengthError: Error
{
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
}
extension PTCLPasswordStrengthError: DNSError {
    public static let domain = "PWDSTR"
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
            return String(format: NSLocalizedString("PWDSTR-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("PWDSTR-Not Implemented%@", comment: ""),
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

public enum PTCLPasswordStrengthType: Int8
{
    case weak = 0
    case moderate = 50
    case strong = 100
}

public protocol PTCLPasswordStrength_Protocol: PTCLBase_Protocol {
    var callNextWhen: PTCLCallNextWhen { get }
    var nextWorker: PTCLPasswordStrength_Protocol? { get }

    var minimumLength: Int32 { get set }

    init()
    func register(nextWorker: PTCLPasswordStrength_Protocol,
                  for callNextWhen: PTCLCallNextWhen)

    // MARK: - Business Logic / Single Item CRUD

    func doCheckPasswordStrength(for password: String) throws -> PTCLPasswordStrengthType
}
