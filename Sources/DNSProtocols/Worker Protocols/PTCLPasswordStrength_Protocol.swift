//
//  PTCLPasswordStrength_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import Foundation

public enum PTCLPasswordStrengthError: Error
{
    case unknown(domain: String, file: String, line: String, method: String)
}
extension PTCLPasswordStrengthError: DNSError {
    public static let domain = "PWDSTR"
    public enum Code: Int
    {
        case unknown = 1001
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
        }
    }
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("PWDSTR-Unknown Error", comment: "")
                + " (\(Self.domain):\(Self.Code.unknown.rawValue))"
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
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
    var nextWorker: PTCLPasswordStrength_Protocol? { get }

    var minimumLength: Int32 { get set }

    init()
    init(nextWorker: PTCLPasswordStrength_Protocol)

    // MARK: - Business Logic / Single Item CRUD

    func doCheckPasswordStrength(for password: String) throws -> PTCLPasswordStrengthType
}
