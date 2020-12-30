//
//  PTCLAuthentication_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import DNSDataObjects
import UIKit

public enum PTCLAuthenticationError: Error
{
    case unknown(domain: String, file: String, line: String, method: String)
    case failure(error: Error, domain: String, file: String, line: String, method: String)
    case lockedOut(domain: String, file: String, line: String, method: String)
    case passwordExpired(domain: String, file: String, line: String, method: String)
}
extension PTCLAuthenticationError: DNSError {
    public static let domain = "AUTH"
    public enum Code: Int
    {
        case unknown = 1001
        case failure = 1002
        case lockedOut = 1003
        case passwordExpired = 1004
    }

    public var nsError: NSError! {
        switch self {
        case .unknown(let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        case .failure(let error, let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "Error": error, "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.failure.rawValue,
                                userInfo: userInfo)
        case .lockedOut(let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.lockedOut.rawValue,
                                userInfo: userInfo)
        case .passwordExpired(let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.passwordExpired.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("AUTH-Unknown Error", comment: "")
                + " (\(Self.domain):\(Self.Code.unknown.rawValue))"
        case .failure(let error, _, _, _, _):
            return String(format: NSLocalizedString("AUTH-SignIn Failure: %@", comment: ""),
                          error.localizedDescription)
                + " (\(Self.domain):\(Self.Code.failure.rawValue))"
        case .lockedOut:
            return NSLocalizedString("AUTH-Locked Out", comment: "")
                + " (\(Self.domain):\(Self.Code.lockedOut.rawValue))"
        case .passwordExpired:
            return NSLocalizedString("AUTH-Password Expired", comment: "")
                + " (\(Self.domain):\(Self.Code.passwordExpired.rawValue))"
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        case .failure(_, let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        case .lockedOut(let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        case .passwordExpired(let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        }
    }
}

public protocol PTCLAuthentication_AccessData {
}

// (success: Bool, error: DNSError?)
public typealias PTCLAuthenticationBlockVoidBoolDNSError = (Bool, DNSError?) -> Void
// (authenticated: Bool, error: DNSError?)
public typealias PTCLAuthenticationBlockVoidBoolAccessDataDNSError = (Bool, PTCLAuthentication_AccessData, DNSError?) -> Void
// (authenticated: Bool, expiredAuthentication: Bool, error: DNSError?)
public typealias PTCLAuthenticationBlockVoidBoolBoolAccessDataDNSError = (Bool, Bool, PTCLAuthentication_AccessData, DNSError?) -> Void

public protocol PTCLAuthentication_Protocol: PTCLBase_Protocol {
    var nextWorker: PTCLAuthentication_Protocol? { get }

    init()
    init(nextWorker: PTCLAuthentication_Protocol)

    // MARK: - Business Logic / Single Item CRUD
    func doCheckAuthentication(using parameters: [String: Any],
                               with progress: PTCLProgressBlock?,
                               and block: @escaping PTCLAuthenticationBlockVoidBoolBoolAccessDataDNSError) throws
    func doSignIn(from username: String?,
                  and password: String?,
                  using parameters: [String: Any],
                  with progress: PTCLProgressBlock?,
                  and block: @escaping PTCLAuthenticationBlockVoidBoolAccessDataDNSError) throws
    func doSignOut(using parameters: [String: Any],
                   with progress: PTCLProgressBlock?,
                   and block: @escaping PTCLAuthenticationBlockVoidBoolDNSError) throws
    func doSignUp(from user: DAOUser?,
                  and password: String?,
                  using parameters: [String: Any],
                  with progress: PTCLProgressBlock?,
                  and block: @escaping PTCLAuthenticationBlockVoidBoolAccessDataDNSError) throws
}
