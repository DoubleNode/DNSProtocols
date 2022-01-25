//
//  PTCLPasswordStrength.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import DNSDataObjects
import DNSError
import Foundation

public extension DNSError {
    typealias PasswordStrength = PTCLPasswordStrengthError
}
public enum PTCLPasswordStrengthError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

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

public enum PTCLPasswordStrengthLevel: Int8
{
    case weak = 0
    case moderate = 50
    case strong = 100
}

public protocol PTCLPasswordStrength: PTCLProtocolBase {
    typealias Level = PTCLPasswordStrengthLevel
    
    var callNextWhen: PTCLProtocol.Call.NextWhen { get }
    var nextWorker: PTCLPasswordStrength? { get }
    var systemsWorker: PTCLSystems? { get }

    var minimumLength: Int32 { get set }

    init()
    func register(nextWorker: PTCLPasswordStrength,
                  for callNextWhen: PTCLProtocol.Call.NextWhen)

    // MARK: - Business Logic / Single Item CRUD

    func doCheckPasswordStrength(for password: String) throws -> PTCLPasswordStrength.Level
}
