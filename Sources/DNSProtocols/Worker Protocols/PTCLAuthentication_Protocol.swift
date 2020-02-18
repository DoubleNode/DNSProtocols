//
//  PTCLAuthentication_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import UIKit

public enum PTCLAuthenticationError: Error
{
    case failure(domain: String, file: String, line: String, method: String)
}

extension PTCLAuthenticationError: DNSError {
    public var nsError: NSError! {
        switch self {
        case .failure(let domain, let file, let line, let method):
            let userInfo: [String : Any] = ["DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                                            NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"]
            return NSError.init(domain: domain, code: -9999, userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        switch self {
        case .failure(let domain, let file, let line, let method):
            return NSLocalizedString("SignIn Failure (\(domain):\(file):\(line):\(method))", comment: "")
        }
    }
}

public protocol PTCLAuthentication_AccessData {
}

public typealias PTCLAuthenticationBlockVoidBoolDNSError = (Bool, DNSError?) -> Void
public typealias PTCLAuthenticationBlockVoidBoolAccessDataDNSError = (Bool, PTCLAuthentication_AccessData, DNSError?) -> Void

public protocol PTCLAuthentication_Protocol: PTCLBase_Protocol {
    var nextWorker: PTCLAuthentication_Protocol? { get }

    init()
    init(nextWorker: PTCLAuthentication_Protocol)

    // MARK: - Business Logic / Single Item CRUD
    func doCheckAuthentication(using parameters: [String: Any],
                               with progress: PTCLProgressBlock?,
                               and block: PTCLAuthenticationBlockVoidBoolAccessDataDNSError) throws
    func doSignIn(from username: String?,
                  and password: String?,
                  using parameters: [String: Any],
                  with progress: PTCLProgressBlock?,
                  and block: @escaping PTCLAuthenticationBlockVoidBoolAccessDataDNSError) throws
    func doSignOut(using parameters: [String: Any],
                   with progress: PTCLProgressBlock?,
                   and block: @escaping PTCLAuthenticationBlockVoidBoolDNSError) throws
}
